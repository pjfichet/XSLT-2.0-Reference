<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xsl:output method="html" indent="yes"/>
<xsl:strip-space elements="*"/>

<!--
Second phase of the transformation to deal with restrictions.
We copy everything as is, except descendant of <restricted>
which duplicate a descendant of <elem>.
-->

<xsl:template match="node()|@*">
	<xsl:copy>
		<xsl:apply-templates select="node()|@*"/>
	</xsl:copy>
</xsl:template>

<xsl:template match="restricted">
	<xsl:apply-templates mode="restricted"/>
</xsl:template>

<xsl:template match="attribute" mode="restricted">
	<xsl:variable name="ref" select="@ref"/>
	<xsl:if test="not(boolean(ancestor::elem/attribute[@ref=$ref]))">
		<xsl:copy-of select="."/>
	</xsl:if>
</xsl:template>

<xsl:template match="subelem" mode="restricted">
	<xsl:variable name="ref" select="@ref"/>
	<xsl:if test="not(boolean(ancestor::elem/subelem[@ref=$ref]))">
		<xsl:copy-of select="."/>
	</xsl:if>
</xsl:template>




</xsl:stylesheet>
