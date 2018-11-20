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
			<a href="#xslt-attributes">Attributes types</a>
			<a href="https://github.com/pjfichet/XSLT-2.0-Reference">Github</a>
		</nav>

		<section id="xslt-elements">
			<h2>XSLT elements</h2>
			<xsl:apply-templates select="xs:schema/xs:element[not(@abstract)]" mode="list">
				<xsl:sort select="@name" data-type="text" order="ascending"/>
			</xsl:apply-templates>
		</section>

		<section id="xslt-attributes">
			<h2>XSLT attributes types</h2>
			<xsl:apply-templates select="xs:schema/xs:simpleType">
				<xsl:sort select="@name" data-type="text" order="ascending"/>
			</xsl:apply-templates>
		</section>

	</body>
</html>
</xsl:template>


<xsl:template match="xs:element" mode="list">
	<section class="element" id="{@name}">
		<xsl:apply-templates select="@name"/>
		<xsl:if test="descendant::xs:attribute">
			<ul class="content">
				<xsl:apply-templates select="descendant::xs:attribute" mode="content" />
			</ul>
		</xsl:if>
		<xsl:if test="descendant::xs:element">
			<ul class="content">
				<xsl:apply-templates select="descendant::xs:element" mode="content"/>
			</ul>
		</xsl:if>
	</section>
</xsl:template>

<xsl:template match="xs:element/@name">
	<h3><a href="#{.}">
		<xsl:value-of select="$prefix"/>
		<xsl:value-of select="."/>
		<xsl:value-of select="$suffix"/>
	</a></h3>
	<ul class="content"><li><a href="{$standart}#element-{.}">ref</a></li></ul>
</xsl:template>
		   	

<xsl:template match="xs:attribute" mode="content">
	<li class="attr-ref">
		<xsl:if test="@use='required'">
			<xsl:attribute name="class">attr-ref required</xsl:attribute>
		</xsl:if>
		<xsl:value-of select="@name"/>
		<span class="general">
			<xsl:text> </xsl:text>
			<a href="#{substring-after(@type, ':')}">
				<xsl:value-of select="substring-after(@type, ':')"/>
			</a>
		</span>
		<!-- <attribute name="{@name}" type="{@type}" use="{@use}" default="{@default}"/> -->
	</li>
</xsl:template>

<xsl:template match="xs:element" mode="content">
	<li class="elem-ref">
		<a href="#{substring-after(@ref, ':')}">&lt;<xsl:value-of select="@ref"/>&gt;</a>
	</li>
</xsl:template>

<xsl:template match="xs:schema/xs:simpleType">
	<section class="attribute" id="{@name}">
		<h3><a href="#{@name}"><xsl:value-of select="@name"/></a></h3>
		<ul class="content"><li><a href="{$standart}#glossary">ref</a></li></ul>
		<xsl:apply-templates select="descendant::xs:documentation"/>
	</section>
</xsl:template>

<xsl:template match="xs:documentation">
	<div class="content">
		<p class="desc"><xsl:apply-templates select="text()"/></p>
	</div>
</xsl:template>

</xsl:stylesheet>
