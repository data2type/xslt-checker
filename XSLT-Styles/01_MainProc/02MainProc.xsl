<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:d2t="http://www.data2type/software/xslt-check" exclude-result-prefixes="xs xd" version="2.0">
    <xsl:output name="resultDoc" method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jul 7, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> MMP-D2T</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>

    <xsl:template match="/">
        <d2t:commandfiles>
            <xsl:variable name="url" select="resolve-uri('../03Commands?select=*.tmp', base-uri())"/>
            <xsl:copy-of select="collection($url)/*"/>
        </d2t:commandfiles>
    </xsl:template>

</xsl:stylesheet>
