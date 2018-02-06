<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:d2t="http://www.data2type/software/xslt-check" version="2.0" exclude-result-prefixes="#all">
    
    <xsl:param name="used_commands" as="document-node()"/>
    
    <xsl:key name="command-pos-file-comName" match="d2t:command" use="string-join((d2t:position, d2t:filename, d2t:name), '#')"/>
    <xsl:key name="xslCallTemplate-comId" match="xsl:call-template" use="@d2t:id"/>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>

    </xsl:template>
    
    <xsl:template match="d2t:commands">
        <xsl:variable name="xslDir" select="resolve-uri('../01OutStyle/', base-uri())"/>
        <xsl:variable name="xslFile" select="resolve-uri(d2t:filename, $xslDir)"/>
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <!-- <xsl:apply-templates  select="document($xsl_file,.)"/>-->
            <xsl:apply-templates select="d2t:filename"/>
            <xsl:for-each select="d2t:command">

                
                <xsl:variable name="comId" select="string-join((d2t:position, ../d2t:filename, d2t:name), '#')"/>

                <xsl:choose>
                    <xsl:when test="key('command-pos-file-comName', $comId, $used_commands)"/>


                    <xsl:otherwise>

                        <xsl:copy>
                            <xsl:copy-of select="@*"/>
                            <xsl:apply-templates/>
                            <d2t:xsl>
                                <xsl:variable name="xslElement" select="key('xslCallTemplate-comId', $comId, doc($xslFile))"/>
                                <xsl:for-each select="$xslElement/parent::*">
                                    <xsl:copy copy-namespaces="no">
                                        <xsl:copy-of select="@*"/>
                                    </xsl:copy>
                                </xsl:for-each>
                            </d2t:xsl>
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
