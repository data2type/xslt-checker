<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:d2t="http://www.data2type/software/xslt-check"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:function name="d2t:getDocuments" as="document-node()*">
        <xsl:param name="urlNode" as="element()"/>
        <xsl:variable name="folder" select="resolve-uri($urlNode, base-uri($urlNode))"/>
        <xsl:variable name="extensions" select="$urlNode/@extensions/tokenize(., ';')"/>
        <xsl:variable name="recurse" select="$urlNode/@recurse = 'true'"/>
        <xsl:sequence select="d2t:getDocuments($folder, $extensions, $recurse)"/>
    </xsl:function>
    <xsl:function name="d2t:getDocuments" as="document-node()*">
        <xsl:param name="folder"/>
        <xsl:param name="extensions" as="xs:string*"/>
        <xsl:param name="recurse" as="xs:boolean"/>
        <xsl:variable name="extensions" select="
            if (count($extensions) = 0) then
            ('*')
            else
            ($extensions)"/>
        <xsl:variable name="recurseQry" select="
            if ($recurse) then
            ('yes')
            else
            ('no')"/>
        <xsl:for-each select="$extensions">
            <xsl:variable name="ext" select="."/>
            
            <xsl:variable name="url" select="concat($folder, '?select=*.', $ext, ';recurse=', $recurse)"/>
            <xsl:sequence select="collection($url)"/>
        </xsl:for-each>
    </xsl:function>
</xsl:stylesheet>