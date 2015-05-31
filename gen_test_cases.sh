#! /bin/sh
maxbits=${1:-64}
export POSIXLY_CORRECT=1 LC_ALL=C
unset BC_ENV_ARGS BC_LINE_LENGTH
{
	echo 'scale= 0'
	echo 'for (b= 0; b < '$maxbits'; ++b) {'
	for x in \
		"2 ^ b / 3" \
		"2 ^ b - 1" \
		"2 ^ b" \
		"2 ^ b + 1"
	do
		echo "   $x"
	done
	echo '}'
} | bc | while read LINE
do
	s=`printf %s "$LINE" | tr -d '\\\'`
	if test x"$s" != x"$LINE"
	then
		printf %s "$s"
	else
		printf '%s\n' "$LINE"
	fi
done | {
	cat
	for x in 12 17 99 2382837823782793 100000
	do
		echo $x
	done
} | sort -nu
