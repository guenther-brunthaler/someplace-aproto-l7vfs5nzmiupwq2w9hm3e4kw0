#! /bin/sh
set -e
trap 'test $? = 0 || echo "$0 failed!" >& 2' 0
o=${0%.sh}.txt
echo "Generating $o..."
exec awk -f - << EOF > "$o"
	function add_head(item) {
		r[start++]= item
	}

	function add_tail(item) {
		r[--end]= item
	}
	
	function x(d) {
		return sprintf("0x%02X", d)
	}
	
	function p7(pfx,    p) {
		for (p= 1; p <= 64; p+= p) {
			add_head(pfx " " p " octet" (p == 1 ? "" : "s"))
		}
	}

	BEGIN{
		start=0; beyond= end=256
		add_tail("reserved for future extension," \
			" illegal to use in current design")
		add_tail("explicit end-of-message indicator" \
			" (normally not required)")
		s23= int((s= end - start) / 3)
		for (s= s23 + s % 3; s--; ) {
			add_head("data field payload with the" \
				" implied value " x(start))
		}
		s23-= 7
		for (s= 0; s < s23; ++s) {
			add_head("data field payload follows, with length" \
				" (<opcode> - 0x56 == " x(s) ") bytes")
		}
		p7("length-prefixed data field follows, prefix is")
		for (s= 0; s < s23; ++s) {
			add_head("tag increment with the implied" \
				" value (<opcode> - 0xA8 == " x(s + 2) ")")
		}
		p7("tag increment value follows as ")
		if (start != end) exit 1
		for (start= 0; start < beyond; ++start) {
			print x(start) " " r[start]
		}
	}
EOF
