#! /bin/sh
set -e
trap 'test $? = 0 || echo "$0 failed!" >& 2' 0
o=${0%.sh}.txt
echo "Generating $o..."
exec awk -f - << EOF > "$o"
	function front(item) {
		r[start++]= item
	}

	function tail(item) {
		r[--end]= item
	}
	
	function x(d) {
		return sprintf("%02X", d)
	}
	
	function psz(pfx,    p, n) {
		n= sizes
		for (p= 1; n--; p+= p) {
			front(pfx " " x(p) " octet" (p == 1 ? "" : "s"))
		}
	}

	BEGIN{
		start= 0; beyond= end= 256; sizes= 7
		tail("reserved for future extension," \
			" illegal to use in current design")
		tail("explicit end-of-message indicator" \
			" (normally not required)")
		reserved= beyond - end
		s1= s23= int((s= end - start) / 3)
		for (s= s1+= s % 3; s--; ) {
			front("single-octet data field payload with" \
				" implied value " x(start))
		}
		implied= s23 - sizes
		for (s= 0; s < implied; ++s) {
			front("data field payload follows, with length" \
				" (<opcode> - " x(s1) " == " x(s) ") bytes")
		}
		psz("length-prefixed data field payload follows, prefix is")
		for (s= 0; s < implied; ++s) {
			front("tag increment with implied" \
				" value (<opcode> - " x(s1 + s23 - reserved) \
				" == " x(s + reserved) ")")
		}
		psz("tag increment value follows as")
		if (start != end) exit 1
		print "Opcodes (all values are hexadecimal):"
		for (start= 0; start < beyond; ++start) {
			print x(start) " " r[start]
		}
	}
EOF
