<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:template match="/cocktails/cocktail">
        <h3>
            <xsl:value-of select="name"/>
            <xsl:text> (alc: </xsl:text>
            <xsl:value-of select="alc"/>
            <xsl:text>%)</xsl:text>
        </h3>
        <xsl:apply-templates select="ingredients"/>
    </xsl:template>
    
    <xsl:template match="ingredients">
        <table>
            <xsl:for-each select="ingredient">
                <tr>
                    <td>
                        <xsl:value-of select="name"/>
                    </td>
                    <td>
                        <xsl:value-of select="portion"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="portion/@unit"/>
                    </td>
                </tr>
            </xsl:for-each>
        </table>
    </xsl:template>
    
    <xsl:template match="alc">
        <xsl:text> (alc: </xsl:text>
        <xsl:value-of select="alc"/>
        <xsl:text>%)</xsl:text>
    </xsl:template>
    
    <xsl:template match="name">
        <xsl:value-of select="name"/>
    </xsl:template>
</xsl:stylesheet>