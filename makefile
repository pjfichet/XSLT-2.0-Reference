
all: doc/index.html doc/style.css

doc/style.css: css
	cat $</reset.css $</mini.css $</blue.css > $@

doc/index.html: index.xslt xslt-2.0.xsd
	xsltproc -o $@ $< xslt-2.0.xsd

xslt-2.0.xsd:
	wget -q -O $@ https://www.w3.org/2007/schema-for-xslt20.xsd

xslt-2.0.html:
	wget -q -O $@ https://www.w3.org/TR/xslt20

clean:
	rm -f xslt-2.0.xsd