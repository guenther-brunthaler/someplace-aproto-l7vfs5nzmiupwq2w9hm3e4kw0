#! /bin/sh
maxbits=64
{
	echo 'scale= 0'
	echo 'for (b= 0; b < '$maxbits'; ++b) {'
	for x in \
		"2 ^ b / 3" \
		"2 ^ b - 1" \
		"2 ^ b" \
		"2 ^ b + 1"
	do
		echo '   print '"$x"', "\n"'
	done
	echo '}'
} | bc | {
	cat
	for x in 12 17 99 2382837823782793 100000
	do
		echo $x
	done
} | sort -nu
