<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="display_csv_field">
		<xsl:param name="field" />
		<xsl:param name="separator" />
		<xsl:variable name="linefeed">
			<xsl:text>&#10;</xsl:text>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains( $field, '&quot;' )">
				<xsl:text>"</xsl:text>
				<xsl:call-template name="escape_quotes">
					<xsl:with-param name="string" select="$field" />
				</xsl:call-template>
				<xsl:text>"</xsl:text>
			</xsl:when>
			<xsl:when test="contains( $field, $separator ) or contains( $field, $linefeed )">
				<xsl:text>"</xsl:text>
				<xsl:value-of select="$field" />
				<xsl:text>"</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$field" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="escape_quotes">
		<xsl:param name="string" />
		<xsl:value-of select="substring-before( $string, '&quot;' )" />
		<xsl:text>""</xsl:text>
		<xsl:variable name="substring_after_first_quote" select="substring-after( $string, '&quot;' )" />
		<xsl:choose>
			<xsl:when test="not( contains( $substring_after_first_quote,'&quot;' ) )">
				<xsl:value-of select="$substring_after_first_quote" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="escape_quotes">
					<xsl:with-param name="string" select="$substring_after_first_quote" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>