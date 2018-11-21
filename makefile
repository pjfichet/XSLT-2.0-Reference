
all: docs/index.html docs/style.css

docs/style.css: css
	cat $</reset.css $</mini.css $</blue.css > $@

docs/index.html: xslt-2.0.xml xmltohtml.xslt
	xsltproc -o $@ xmltohtml.xslt $<

xslt-2.0.xml: xslt-2.0.xsd xsdtoxml.xslt
	xsltproc -o $@ xsdtoxml.xslt $<

xslt-2.0.xsd:
	wget -q -O $@ https://www.w3.org/2007/schema-for-xslt20.xsd

xslt-2.0.html:
	wget -q -O $@ https://www.w3.org/TR/xslt20

clean:
	rm -f xslt-2.0.xsd
