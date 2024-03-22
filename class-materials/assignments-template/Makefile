templates:
	# Clean up any files that might contain hints
	for dir in ../assignments-complete/*/; do make --directory=$$dir clean; done
	# Copy over files
	cp -r ../assignments-complete .
	# Remove code in TODO sections
	find . -type f -name '*.c' -o '*.S' -o '*.ld' -exec sed -i /(\/\/|#|\/*) BEGIN DELETE BLOCK/,/(\/\/|#|\/*) END DELETE BLOCK/d {}