# Generate files in build/, build/44x44, build/16x16 for each
# file in vector/
# based on https://github.com/jnylen/nonametv-logos/blob/master/Makefile

CONVERT  := convert
INKSCAPE := inkscape

FILES256 := $(patsubst vector/%.svg,build/%.png,$(wildcard vector/*.svg))
FILES100 := $(patsubst vector/%.svg,build/100x100/%.png,$(wildcard vector/*.svg))
FILES44  := $(patsubst vector/%.svg,build/44x44/%.png,$(wildcard vector/*.svg))
FILES16  := $(patsubst vector/%.svg,build/16x16/%.png,$(wildcard vector/*.svg))

all: dobuild

# do not clean upload, we use it to quickly perform checksums locally before uploading
clean:
	rm -rf build

dobuild: build buildfiles

build:
	mkdir -p build build/44x44 build/100x100 build/16x16

buildfiles: $(FILES256) $(FILES100) $(FILES44) $(FILES16)

build/%.png: vector/%.svg
	${CONVERT} -density 300 -background none $< -resize 256x256 -gravity center -extent 256x256 $@

build/100x100/%.png: vector/%.svg
	${CONVERT} -density 300 -background none $< -resize 100x100 -gravity center -extent 100x100 $@

build/44x44/%.png: vector/%.svg
	${CONVERT} -density 300 -background none $< -resize 44x44 -gravity center -extent 44x44 $@

build/16x16/%.png: vector/%.svg
	${CONVERT} -density 300 -background none $< -resize 16x16 -gravity center -extent 16x16 $@

doupload:
	mkdir -p upload
	rsync --checksum --delete -r build/ upload/
#	rsync -rsh=ssh -av --delete upload/ /server/www/xmltv/chanlogos/
#	rsync -rsh=ssh -av --delete upload/ taiga:/server/www/xmltv/chanlogos/
