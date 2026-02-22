# In case your system doesn't have any of these tools:
# https://pypi.python.org/pypi/xml2rfc
# https://github.com/cabo/kramdown-rfc2629
# https://github.com/Juniper/libslax/tree/master/doc/oxtradoc
# https://tools.ietf.org/tools/idnits/

xml2rfc ?= xml2rfc
kramdown-rfc2629 ?= kramdown-rfc2629
oxtradoc ?= oxtradoc
idnits ?= idnits

DRAFTS := draft-yn-netmod-yang2

default:
	@for draft in $(DRAFTS); do \
		export draft _; \
	  make make_draft; \
		if [ "$$?" != "0" ]; then \
	    exit 1; \
  	fi; \
	done

make_draft:
	@echo "\nMaking $(draft)..."
	@current_ver=`git tag | grep '$(draft)-[0-9][0-9]' | tail -1 | sed -e"s/.*-//"`; \
	if [ -z "$$current_ver" ]; then \
	  next_ver=00; \
	else \
	  next_ver_num=`expr $${current_ver} + 1`; \
	  next_ver=`printf "%.2d" $${next_ver_num}`; \
	fi; \
	export next_ver; \
	make $(draft)-$${next_ver}

$(draft)-$(next_ver):
	make $@.xml
	make $@.txt
	make $@.html


$(draft)-$(next_ver).xml: $(draft).xml
	@echo "Making $@ from $<..."
	sed -e"s/$(basename $<)-latest/$(basename $@)/" -e"s/YYYY-MM-DD/$(shell date +%Y-%m-%d)/" $< > $@
	#cd refs && ./validate-all.sh && ./gen-trees.sh && cd ..
	#./.insert-figures.sh $@ > tmp && mv tmp $@
	#rm -f refs/*-tree*.txt refs/tree-*.txt

$(draft)-$(next_ver).txt: $(draft)-$(next_ver).xml
	@echo "Making $@ from $<..."
	$(xml2rfc) --v3 $< -o $@ --text --no-pagination

$(draft)-$(next_ver).html: $(draft)-$(next_ver).xml
	@echo "Making $@ from $<..."
	$(xml2rfc) --v3 $< -o $@ --html

.PHONY: clean

clean:
	@for draft in $(DRAFTS); do \
		export draft _; \
	  $(MAKE) clean_draft; \
	done

clean_draft:
	-rm -f $(draft)-[0-9][0-9].xml
	-rm -f $(draft)-[0-9][0-9].txt
	-rm -f $(draft)-[0-9][0-9].html

