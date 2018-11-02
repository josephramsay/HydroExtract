<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
<xsl:output method="text" encoding="utf-8" />
<xsl:strip-space elements="*" />

<xsl:param name="delim" select="','"/>
<xsl:param name="nsep" select="'__'"/>
<xsl:param name="sep" select="':'"/>
<xsl:param name="quote" select="'&quot;'"/>
<xsl:param name="break" select="'&#xA;'"/>
<xsl:param name="din" select="'{'"/>
<xsl:param name="dout" select="'}'"/>

<xsl:template match="/">
	<xsl:value-of select="$din"/><xsl:apply-templates/><xsl:value-of select="$dout"/>
</xsl:template>

<xsl:template match="*[not(*)]">
	<xsl:value-of select="$quote"/><xsl:call-template name="path"/><xsl:value-of select="$quote"/>
 	<xsl:value-of select="$sep"/>
 	<xsl:value-of select="$quote"/>
 	<xsl:call-template name="replace">
        <xsl:with-param name="text" select="normalize-space()"/>
    </xsl:call-template>
 	<xsl:value-of select="concat($quote, $delim)"/>
</xsl:template>

<!-- Append XML paths to create unique key -->
<xsl:template name="path">
	<xsl:for-each select="parent::*">
  		<xsl:call-template name="path"/>
 	</xsl:for-each>
	<xsl:value-of select="local-name()"/>
	<xsl:if test="child::*">
		<xsl:value-of select="$nsep"/>
	</xsl:if>
</xsl:template>

<!-- Replace unescaped double quotes in text values -->
<xsl:template name="replace">
    <xsl:param name="text"/>
    <xsl:param name="searchString">"</xsl:param>
    <xsl:param name="replaceString">\"</xsl:param>
    <xsl:choose>
        <xsl:when test="contains($text,$searchString)">
            <xsl:value-of select="substring-before($text,$searchString)"/>
            <xsl:value-of select="$replaceString"/>
           <!--  recursive call -->
            <xsl:call-template name="replace">
                <xsl:with-param name="text" select="substring-after($text,$searchString)"/>
                <xsl:with-param name="searchString" select="$searchString"/>
                <xsl:with-param name="replaceString" select="$replaceString"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$text"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

</xsl:stylesheet>