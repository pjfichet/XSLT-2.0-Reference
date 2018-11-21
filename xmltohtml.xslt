<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
>


<xsl:output
	method="html"
	indent="yes"
	omit-xml-declaration="yes"
	doctype-system="about:legacy-compat"
/>

<xsl:variable name="standart" select="'https://www.w3.org/TR/xslt20'"/>
<xsl:variable name="prefix" select="'&lt;xsl:'"/>
<xsl:variable name="suffix" select="'&gt;'"/>

<xsl:template match="/">
<html>
	<xsl:comment>This file is generated by XSLT from xslt-2.0.xsd.</xsl:comment>
	<head>
		<title>
			<xsl:text>XSLT-2.0 Quick Reference</xsl:text>
		</title>
		<link rel="stylesheet" href="style.css" />
		<meta name="viewport" content="width=device-width, initial-scale=1" />
	</head>
	<body id="toc" class="language-markup">
		<nav class="toc-link">
			<h1>XSLT-2.0  Reference</h1>
			<a href="#toc" title="Show a simplified table of contents">Summary</a>
			<a href="#xslt-elements">Elements</a>
			<a href="#xslt-types">Types</a>
			<a href="https://github.com/pjfichet/XSLT-2.0-Reference">Github</a>
		</nav>

		<section id="xslt-elements">
			<h2>Elements</h2>
			<xsl:apply-templates select="//docset/elem">
				<xsl:sort select="@name" data-type="text" order="ascending"/>
			</xsl:apply-templates>
		</section>

		<section id="xslt-types">
			<h2>Types</h2>
			<xsl:apply-templates select="//docset/type">
				<xsl:sort select="@name" data-type="text" order="ascending"/>
			</xsl:apply-templates>
		</section>

	</body>
</html>
</xsl:template>

<!--
List elements
-->

<xsl:template match="elem">
	<section class="element" id="{@name}">
		<h3><a href="#{@name}">
			<xsl:value-of select="$prefix"/>
			<xsl:value-of select="@name"/>
			<xsl:value-of select="$suffix"/>
		</a></h3>
		<p class="content"><a href="{$standart}#element-{@name}">ref</a></p>
		<xsl:if test="attribute">
			<ul class="content">
				<xsl:apply-templates select="attribute"/>
			</ul>
		</xsl:if>
		<xsl:if test="subelem">
			<ul class="content">
				<xsl:apply-templates select="subelem"/>
			</ul>
		</xsl:if>
	</section>
</xsl:template>

<xsl:template match="attribute">
	<li class="attr-ref">
		<xsl:if test="@use='required'">
			<xsl:attribute name="class">attr-ref required</xsl:attribute>
		</xsl:if>
		<xsl:value-of select="@ref"/>
		<span class="general">
			<xsl:text> </xsl:text>
			<a href="#{@type}">
				<xsl:value-of select="@type"/>
			</a>
		</span>
	</li>
</xsl:template>

<xsl:template match="subelem">
	<li class="elem-ref">
		<a href="#{@ref}">&lt;<xsl:value-of select="@ref"/>&gt;</a>
	</li>
</xsl:template>

<!--
List types.
-->

<xsl:template match="type">
	<section class="type" id="{@name}">
		<h3><a href="#{@name}"><xsl:value-of select="@name"/></a></h3>
		<p class="content"><a href="{$standart}#glossary">ref</a></p>
		<xsl:apply-templates select="p"/>
	</section>
</xsl:template>

<xsl:template match="p">
	<div class="content">
		<p class="desc"><xsl:apply-templates select="text()"/></p>
	</div>
</xsl:template>

</xsl:stylesheet>
