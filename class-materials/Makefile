templates:
	# Remove previous templates
	rm -rf assignments-template
	mkdir assignments-template
	# Clean up any files that might contain hints
	for dir in assignments-complete/*/; do make --directory=$$dir clean; done
	# Copy over files
	cp -r assignments-complete/* assignments-template/
	# Remove code in TODO sections
	# This command uses sed -i '', may only work on BSD sed, 
	# delete the empty single quotes to run with GNU sed
	files=$$(grep -rl "BEGIN DELETE BLOCK" assignments-template); \
	for file in $$files; do sed -i '' -r '/(\/\/|#|\/\*) BEGIN DELETE BLOCK/,/(\/\/|#|\/\*) END DELETE BLOCK/d' $$file; done