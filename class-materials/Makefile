templates:
	# Remove previous templates
	rm -r assignments-template/
	mkdir assignments-template
	# Put the place holder gitignore back
	echo '*\n!.gitignore' > assignments-template/.gitignore
	# Clean up any files that might contain hints
	for dir in assignments-complete/*/; do make --directory=$$dir clean; done
	# Copy over files
	cp -r assignments-complete/* assignments-template/
	# Remove code in TODO sections
	find assignments-template -type f \( -name '*.c' -o -name '*.S' -o -name '*.ld' \) -exec sed -r -n '/(\/\/|#|\/\*) BEGIN DELETE BLOCK/,/(\/\/|#|\/\*) END DELETE BLOCK/d' {} \;
