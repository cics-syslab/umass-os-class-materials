.PHONY: templates template-zips

templates-clean:
	# Remove previous templates
	rm -rf assignments-template

templates: templates-clean
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

clean: templates-clean template-zips-clean

template-zips: template-zips-clean templates
	mkdir template-zips
	for dir in assignments-template/*/; do cd $$dir; zip -r ../../template-zips/$$(basename $$dir).zip .; cd ../..; done

template-zips-clean:
	rm -rf template-zips