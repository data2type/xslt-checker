<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:d2t="http://www.data2type/software/xslt-check">
    <xsl:variable name="comTxt" select="unparsed-text(resolve-uri('../04LOG/command.log', document-uri(/)))"/>
    <xsl:variable name="comLines" select="tokenize($comTxt, '#endCom')"/>
    <xsl:variable name="comXml" as="xs:string*">
        <xsl:for-each select="$comLines">
            <xsl:sequence select="normalize-space(.)"/>
        </xsl:for-each>
    </xsl:variable>

    <xsl:template match="/">
        <d2t:commandfiles>
            <xsl:perform-sort>
                <xsl:sort select="d2t:position" data-type="number"/>
                <xsl:for-each-group select="$comXml" group-by=".">
                    <d2t:command>
                        <xsl:analyze-string select="." regex="#([^#]+)#([^#]+)">
                            <xsl:matching-substring>
                                <xsl:variable name="name" select="regex-group(1)"/>
                                <xsl:variable name="name" select="
                                        if ($name = 'pos') then
                                            ('position')
                                        else
                                            ($name)"/>
                                <xsl:element name="d2t:{$name}">
                                    <xsl:value-of select="regex-group(2)"/>
                                </xsl:element>
                            </xsl:matching-substring>
                        </xsl:analyze-string>
                    </d2t:command>
                </xsl:for-each-group>

            </xsl:perform-sort>



        </d2t:commandfiles>
    </xsl:template>
    
</xsl:stylesheet>
