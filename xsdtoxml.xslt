<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xsl:output method="html" indent="yes"/>
<xsl:strip-space elements="*"/>

<!--
<docset>
	<elem name="">
		<attribute name="" use="" type=""/>
		<subelem ref=""/>
	</elem>
	<type name="">
		<p>...</p>
	</type>
<docset>
-->

<!--
Here, we are selecting each elements, and we walk through
their hierarchy to search for the <xs:element> and
<xs:attribute> we want to display.
-->

<xsl:template match="/">
	<docset>
		<xsl:apply-templates select="/xs:schema/xs:element[not(@abstract)]" mode="element"/>
		<xsl:apply-templates select="/xs:schema/xs:simpleType" mode="type"/>
	</docset>
</xsl:template>

<xsl:template match="xs:element[@name]" mode="element">
	<elem name="{@name}">
		<xsl:apply-templates mode="element"/>
	</elem>
</xsl:template>

<xsl:template match="xs:extension" mode="element">
	<xsl:apply-templates mode="element"/>
	<xsl:variable name="base" select="substring-after(@base, ':')"/>
		<xsl:apply-templates select="/xs:schema/xs:complexType[@name=$base]" mode="referenced"/>
</xsl:template>

<xsl:template match="xs:group[@ref]" mode="element">
	<xsl:variable name="ref" select="substring-after(@ref, ':')"/>
	<xsl:apply-templates select="/xs:schema/xs:group[@name=$ref]" mode="referenced"/>
</xsl:template>

<xsl:template match="xs:element[@ref]" mode="element">
	<subelem ref="{@ref}"/>
</xsl:template>

<xsl:template match="xs:attribute" mode="element">
	<attribute ref="{@name}" type="{@type}" use="{@use}">
		<xsl:if test="substring-before(@type, ':')='xsl'">
			<xsl:attribute name="type">
				<xsl:value-of select="substring-after(@type, ':')"/>
			</xsl:attribute>
		</xsl:if>
	</attribute>
</xsl:template>

<xsl:template match="xs:restriction" mode="element">
	<restriction>
		<xsl:apply-templates mode="element"/>
	</restriction>
</xsl:template>

<xsl:template match="*" mode="element">
	<xsl:apply-templates mode="element"/>
</xsl:template>


<!--
From here, we are looking for elements only referenced as part
of xs:extension. We walk through their hierarchy in search of
the <xs:element> and <xs:attribute> (TODO) we want to display.
-->

<xsl:template match="xs:complexType" mode="referenced">
	<xsl:apply-templates mode="referenced"/>
</xsl:template>

<xsl:template match="xs:group[@ref]" mode="referenced">
	<xsl:variable name="ref" select="substring-after(@ref, ':')"/>
	<xsl:apply-templates select="/xs:schema/xs:group[@name=$ref]" mode="referenced"/>
</xsl:template>

<xsl:template match="xs:element[@ref]" mode="referenced">
	<xsl:variable name="ref" select="@ref"/>
	<xsl:apply-templates select="/xs:schema/xs:element[@substitutionGroup=$ref]" mode="referenced"/>
</xsl:template>

<xsl:template match="xs:element[@name]" mode="referenced">
	<subelem ref="{@name}"/>
</xsl:template>

<xsl:template match="*" mode="referenced">
	<xsl:apply-templates mode="referenced"/>
</xsl:template>

<!--
We are now looking for types. We walk through their hierarchy
to search for the <xs:documentation> we want to display.
TODO: implement patterns, restrictions, etc.
-->

<xsl:template match="xs:simpleType" mode="type">
	<type name="{@name}">
		<xsl:apply-templates mode="type"/>
	</type>
</xsl:template>

<xsl:template match="xs:documentation" mode="type">
	<p><xsl:value-of select="normalize-space(text())"/></p>
</xsl:template>

<xsl:template match="*" mode="type">
	<xsl:apply-templates mode="type"/>
</xsl:template>

</xsl:stylesheet>
