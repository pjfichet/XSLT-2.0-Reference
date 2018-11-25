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
		<p>...</p>
	</elem>
	<type name="">
		<p>...</p>
	</type>
<docset>
-->

<!--
Load the hand written documentation. The file name is
a parameter, to define it from the command line.
-->
<xsl:param name="docfile" select="'docxslt-2.0.xml'"/>
<xsl:variable name="doc" select="document($docfile)"/>

<!--
The root element, which selects elements and types.
-->

<xsl:template match="/">
	<docset>
		<xsl:apply-templates select="/xs:schema/xs:element[not(@abstract)]" mode="element"/>
		<xsl:apply-templates select="/xs:schema/xs:simpleType" mode="type"/>
	</docset>
</xsl:template>

<!--
Here, we are selecting each elements, and we walk through
their hierarchy to search for the <xs:element> and
<xs:attribute> we want to display.
-->

<xsl:template match="xs:element[@name]" mode="element">
	<xsl:variable name="name" select="@name"/>
	<elem name="{@name}">
		<xsl:apply-templates mode="element"/>
		<xsl:apply-templates select="$doc/doc/elem[@name=$name]/p" mode="doc"/>
	</elem>
</xsl:template>

<xsl:template match="xs:extension" mode="element">
	<xsl:apply-templates mode="element"/>
	<xsl:variable name="base" select="substring-after(@base, ':')"/>
	<xsl:apply-templates select="/xs:schema/xs:complexType[@name=$base]" mode="element"/>
</xsl:template>

<xsl:template match="xs:restriction" mode="element">
	<!--
		TODO: xs:restriction > xs:element should override base ones.
		Check xsl:tranform @version for example.
	-->
	<xsl:apply-templates mode="element"/>
	<xsl:variable name="base" select="substring-after(@base, ':')"/>
	<restricted name="{$base}">
		<xsl:apply-templates select="/xs:schema/xs:complexType[@name=$base]" mode="element"/>
	</restricted>
</xsl:template>

<xsl:template match="xs:group[@ref]" mode="element">
	<xsl:variable name="ref" select="substring-after(@ref, ':')"/>
	<xsl:apply-templates select="/xs:schema/xs:group[@name=$ref]" mode="element"/>
</xsl:template>

<xsl:template match="xs:group[@name]" mode="element">
	<xsl:apply-templates mode="element"/>
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

<xsl:template match="*" mode="element">
	<xsl:apply-templates mode="element"/>
</xsl:template>

<!--
Finally, we transform the referenced sub-elements. Those with
abstract=true are themselves references to a list of elements.
-->

<xsl:template match="xs:element[@ref]" mode="element">
	<xsl:variable name="ref" select="substring-after(@ref, ':')"/>
	<xsl:apply-templates select="/xs:schema/xs:element[@name=$ref]" mode="referenced"/>
</xsl:template>

<xsl:template match="xs:element[@abstract='true']" mode="referenced">
	<xsl:variable name="name" select="concat('xsl:', @name)"/>
	<xsl:apply-templates select="/xs:schema/xs:element[@substitutionGroup=$name]" mode="referenced"/>
</xsl:template>

<xsl:template match="xs:element" mode="referenced">
	<subelem ref="{@name}"/>
</xsl:template>

<!--
Here we copy the handwritten documentation
-->

<xsl:template match="p" mode="doc">
	<xsl:copy>
		<xsl:apply-templates mode="doc"/>
	</xsl:copy>
</xsl:template>

<xsl:template match="*" mode="doc">
	<xsl:copy>
		<xsl:apply-templates mode="doc"/>
	</xsl:copy>
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
