import fontforge
import io
import json
import os
import tempfile

fontname = "Typ"
charsdir = "chars"
charwidth, charheight = 4, 5
pxbetween = 1
fontem = 400

font = fontforge.font()

font.familyname = fontname
font.fontname = fontname
font.fullname = fontname
font.weight = "Regular"
font.em = fontem
font.ascent = fontem
font.descent = 0

mappingfile = open("chars/mapping.json", "r")
mapping = json.load(mappingfile)
mappingfile.close()

# It returns the SVG string based on the grid.
def gridtosvg(grid):
	pixels = []

	for y in range(charheight):
		for x in range(charwidth):
			if grid.replace("\n", "")[y * charwidth + x] == "#":
				pixels.append([x, y])

	svg = '<svg xmlns="http://www.w3.org/2000/svg" '
	svg += f'width="{charwidth + pxbetween}" height="{charheight}" '
	svg += f'viewBox="0 0 {charwidth + pxbetween} {charheight}" '
	svg += 'preserveAspectRatio="xMidYMid meet" rendering="crispEdges">'

	for p in pixels:
		svg += f'<rect x="{p[0] + pxbetween / 2}" y="{p[1]}" width="1" '
		svg += 'height="1" fill="#000000" shape-rendering="crispEdges">'
		svg += '</rect>'

	if not pixels:
		svg += '<rect x="0" y="0" width="0" height="0" fill="none">'
		svg += '</rect>'

	svg += '</svg>'

	return svg

for filename, chars in mapping.items():
	filepath = os.path.join("chars", filename)

	if not os.path.exists(filepath):
		print(f"{filepath} does not exist.")
		continue

	print(f'Making character "{filename}".')

	file = open(filepath, "r")
	svg = gridtosvg(file.read())
	file.close()

	tmp = tempfile.NamedTemporaryFile(delete=True, mode="w+",
	                                  suffix=".svg")
	tmp.write(svg)
	tmp.seek(0)

	for c in chars:
		glyph = font.createMappedChar(ord(c))
		glyph.width = fontem
		glyph.vwidth = fontem
		glyph.importOutlines(tmp.name)

	tmp.close()

font.generate(f"{fontname}.ttf")
