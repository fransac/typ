#!/bin/sh
set -eu

size=$(cat "src/size")

printf '%s\n' 'STARTFONT 2.1'
printf '%s\n' "FONT $NAME"
printf '%s\n' "SIZE $size 75 75"
printf '%s\n' "FONTBOUNDINGBOX $size $size 0 0"

printf '%s\n' "CHARS $(grep '[^[:space:]]' "src/mapping" | wc -l)"

rowtohex()
{
	value=0

	for n in $(seq $size)
	do
		if [ $(printf '%s\n' "$1" | cut -c $n) = '#' ]
		then
			value=$((value + (1 << (8 - n))))
		fi
	done

	printf '%02X\n' "$value"
}

while IFS=$(printf '\t') read -r char relfile
do
	[ -n "$char" ] || continue
	[ -n "$relfile" ] || continue

	case "$char" in
		' ')
			bdfchar="space"
			;;
		*)
			bdfchar="$char"
			;;
	esac

	file="src/$relfile"
	encoding=$(printf '%s\n' "$char" | LC_ALL=C od -A n -t uC \
	                               | sed 's/^ *//' \
	                               | cut -d ' ' -f 1)

	printf '%s\n' "STARTCHAR $bdfchar"
	printf '%s\n' "ENCODING $encoding"
	printf '%s\n' "SWIDTH 1000 0"
	printf '%s\n' "DWIDTH $size 0"
	printf '%s\n' "BBX $size $size 0 0"
	printf '%s\n' 'BITMAP'

	for n in $(seq $size)
	do
		row=$(sed -n "${n}p" "$file")

		if [ "${#row}" -ne $size ]
		then
			printf '%s\n' "ERROR: src/$relfile:$n has bad length." >&2
			exit 1
		fi

		case "$row" in
			*[!.#]*)
				printf '%s\n' \
				       "ERROR: src/$relfile:$n has bad char." >&2
				exit 1
				;;
		esac

		rowtohex "$row"
	done

	printf '%s\n' 'ENDCHAR'
done < "src/mapping"

printf '%s\n' 'ENDFONT'
