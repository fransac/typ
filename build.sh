#!/bin/sh
set -eu

size=$(cat "src/size")

echo 'STARTFONT 2.1'
echo "FONT $NAME"
echo "SIZE $size 75 75"
echo "FONTBOUNDINGBOX $size $size 0 0"

echo "CHARS $(grep '[^[:space:]]' "src/mapping" | wc -l)"

rowtohex()
{
	value=0

	for n in $(seq $size)
	do
		if [ $(echo "$1" | cut -c $n) = '#' ]
		then
			add=$(echo "2 ^ (($size - $n + 1) + 7 - $size)" | bc)
			value=$((value + add))
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
	encoding=$(echo "$char" | LC_ALL=C od -A n -t uC \
	                        | sed 's/^ *//' \
	                        | cut -d ' ' -f 1)

	echo "STARTCHAR $bdfchar"
	echo "ENCODING $encoding"
	echo "SWIDTH 1000 0"
	echo "DWIDTH $size 0"
	echo "BBX $size $size 0 0"
	echo 'BITMAP'

	for n in $(seq $size)
	do
		row=$(sed -n "${n}p" "$file")

		if [ "${#row}" -ne $size ]
		then
			echo "ERROR: src/$relfile:$n has bad length." >&2
			exit 1
		fi

		case "$row" in
			*[!.#]*)
				echo "ERROR: src/$relfile:$n has bad char." >&2
				exit 1
				;;
		esac

		rowtohex "$row"
	done

	echo 'ENDCHAR'
done < "src/mapping"

echo 'ENDFONT'
