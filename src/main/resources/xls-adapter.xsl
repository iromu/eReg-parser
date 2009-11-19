<?xml version="1.0" encoding="ISO-8859-1" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" encoding="ISO-8859-1" />
	<xsl:variable name="separator">
		<xsl:text>;</xsl:text>
	</xsl:variable>
	<xsl:import href="display_csv_field.xsl" />
	<xsl:template match="/">
		<xsl:for-each select="/xfdf/fields/field/value">
			<xsl:call-template name="display_csv_field">
				<xsl:with-param name="field" select="." />
				<xsl:with-param name="separator" select="$separator" />
			</xsl:call-template>
			<xsl:if test="position() != last()">
				<xsl:value-of select="$separator" />
			</xsl:if>
		</xsl:for-each>
		<xsl:text>&#10;</xsl:text>
	</xsl:template>
</xsl:stylesheet>
