<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:d2t="http://www.data2type/software/xslt-check" version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all">
    <xsl:output method="text"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:variable name="columnWidths" select="(8, 18, 8, -1)"/>
    
    <xsl:template match="/">
        <xsl:for-each select="//d2t:commands">
            <xsl:call-template name="emptyline"/>
            <xsl:text>
    
*******************************************************************************
**
** Unused commands in the stylesheet-file: </xsl:text>
            <xsl:value-of select="d2t:filename"/>
            <xsl:text>
**
*******************************************************************************
</xsl:text>
            <xsl:call-template name="emptyline"/>
            <xsl:value-of select="
                string-join((
                d2t:align('line', 'center', $columnWidths[1]),
                d2t:align('command', 'center', $columnWidths[2]),
                d2t:align('position', 'center', $columnWidths[3]),
                d2t:align('attributes', 'center', $columnWidths[4])
                ), ' '
                )"
            />
            <xsl:call-template name="break"/>
            
            <xsl:value-of select="
                string-join((
                d2t:align('', 'center', $columnWidths[1], '-'),
                d2t:align('', 'center', $columnWidths[2], '-'),
                d2t:align('', 'center', $columnWidths[3], '-'),
                d2t:align('----------------------------------------------', 'center', $columnWidths[4], '-')
                ), ' '
                )
                "
            />

            <xsl:call-template name="break"/>
            <xsl:for-each select="d2t:command">
                <xsl:sort data-type="number" select="d2t:line"/>
                <xsl:sort data-type="number" select="d2t:position"/>

                

                <xsl:variable name="attributes" select='concat(d2t:xsl/xsl:*/(@test | @select | @name | @match)/name(), "=""", d2t:xsl/xsl:*/@*[1], """")'/>
                
                <xsl:variable name="name" select="d2t:name"/>
                <xsl:value-of select="
                    string-join((
                    d2t:align(d2t:line, 'right', $columnWidths[1]),
                    d2t:align($name, 'left', $columnWidths[2]),
                    d2t:align(d2t:position, 'right', $columnWidths[3]),
                    d2t:align($attributes, 'left', $columnWidths[4])[$name != 'xsl:otherwise']
                    ), ' '
                    )"
                />
                <xsl:call-template name="break"/>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="emptyline">
        <xsl:call-template name="break">
            <xsl:with-param name="amount" select="2"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="break">
        <xsl:param name="amount" select="1"/>
        <xsl:for-each select="1 to $amount">
            <xsl:text>&#10;</xsl:text>
        </xsl:for-each>
    </xsl:template>

    <xsl:function name="d2t:align">
        <xsl:param name="value"/>
        <xsl:param name="alignment"/>
        <xsl:param name="columnWidth"/>
        <xsl:sequence select="d2t:align($value, $alignment, $columnWidth, ' ')"/>
    </xsl:function>
    <xsl:function name="d2t:align">
        <xsl:param name="value"/>
        <xsl:param name="alignment"/>
        <xsl:param name="columnWidth"/>
        <xsl:param name="spaceChar"/>
        
        <xsl:variable name="valueLength" select="string-length($value)"/>
        <xsl:variable name="spaceCount" select="$columnWidth - $valueLength"/>
        <xsl:variable name="space" select=" string-join(for $i in 1 to ($spaceCount) return ($spaceChar), '')"/>
        
        <xsl:choose>
            <xsl:when test="$spaceCount le 0">
                <xsl:value-of select="$value"/>
            </xsl:when>
            <xsl:when test="$alignment = 'right'">
                <xsl:value-of select="concat($space, $value)"/>
            </xsl:when>
            <xsl:when test="$alignment = 'center'">
                <xsl:variable name="half" select="xs:integer(floor($spaceCount div 2))"/>
                <xsl:variable name="spaceL" select="substring($space, 1, $half)"/>
                <xsl:variable name="spaceR" select="substring($space, 1, $spaceCount - $half)"/>
                <xsl:value-of select="concat($spaceL, $value, $spaceR)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($value, $space)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

</xsl:stylesheet>
