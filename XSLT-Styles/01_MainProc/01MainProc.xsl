<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:saxon="http://saxon.sf.net/" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:d2t="http://www.data2type/software/xslt-check" xmlns:axsl="http://www.w3.org/1999/XSL/TransformAlias" exclude-result-prefixes="xs xd" version="2.0">

    <xsl:namespace-alias stylesheet-prefix="axsl" result-prefix="xsl"/>
    <!--
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"   saxon:next-in-chain="02PreProc.xsl"/>-->
    <xsl:output name="resultDoc" method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <xsl:include href="../00_FunctionLib/00FunctionLib.xsl"/>

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jul 5, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> Manuel Montero Pineda</xd:p>
            <xd:p><xd:b>E-Mail:</xd:b> montero@data2type.de</xd:p>
            <xd:p><xd:b>Company:</xd:b> data2type GmbH</xd:p>
            <xd:p><xd:b>Copyright:</xd:b> data2type GmbH</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    <xsl:param name="filename" select="document-uri(/)"/>
    

    <xsl:variable name="styleFolder" select="resolve-uri(/config/styleFolder, base-uri(/))"/>
    <xsl:variable name="extension" select="/config/styleExtensions"/>
    <xsl:variable name="xslts" select="d2t:getDocuments(/config/styleFolder)"/>
    <xsl:variable name="startingStyle" select="resolve-uri(/config/startingStyle, concat($styleFolder, '/'))"/>
    
    <xsl:variable name="defaultCheckedElements">
        <checkedElements>
            <template>
                <name>true</name>
                <match>true</match>
            </template>
            <if>true</if>
            <choose>
                <when>true</when>
                <otherwise>true</otherwise>
            </choose>
            <for-each>true</for-each>
            <for-each-group>true</for-each-group>
            <function>true</function>
        </checkedElements>
    </xsl:variable>
    
    <xsl:variable name="checkedElements" select="/config/(checkedElements, $defaultCheckedElements/checkedElements)[1]"/>
    <xsl:variable name="checkedElementNames" select="$checkedElements//(* except template/*)[. = 'true']/local-name()"/>
    <xsl:variable name="checkedTemplates" select="$checkedElements/template/(
        if (name = 'true') then ('name') else (),
        if (match = 'true') then ('match') else ()
        )"/>

    <xsl:template match="*" mode="#default d2t:xsl">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="/config/styleFolder|/config/dataFolder">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:value-of select="resolve-uri(., base-uri())"/>
        </xsl:copy>
    </xsl:template>
    
    <xd:doc scope="component">
        <xd:desc>
            <xd:p>This template defines all commands that should be monitored.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="xsl:*[local-name() = $checkedElementNames] | xsl:template[@*/local-name() = $checkedTemplates]" mode="d2t:xsl">

        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates mode="#current"/>
            <xsl:call-template name="count"/>
        </xsl:copy>
    </xsl:template>
    <xd:doc scope="component">
        <xd:desc>
            <xd:p>This named template will be copied to the end of the command that will be observed.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="count">
        <xsl:variable name="elementname" select="name()"/>
        <xsl:variable name="position" select="count(preceding::*[name() = $elementname] | ancestor::*[name() = $elementname]) + 1"/>
        <xsl:variable name="filename" select="tokenize(base-uri(), '/')[last()]"/>
        <axsl:call-template name="d2t:resolve" d2t:id="{string-join((string($position), $filename, $elementname), '#')}">
            <axsl:with-param name="name" select="'{$elementname}'"/>
            <axsl:with-param name="filename" select="'{$filename}'"/>
            <axsl:with-param name="position" select="{$position}"/>
        </axsl:call-template>
    </xsl:template>
    <xd:doc scope="component">
        <xd:desc>
            <xd:p>This template generates a named template in the second transformation.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="/">
        <xsl:if test="not($xslts)">
            <xsl:message terminate="yes">No stylesheets found in <xsl:value-of select="$styleFolder"/></xsl:message>
        </xsl:if>
        <xsl:for-each select="$xslts">
            <xsl:variable name="filename" select="tokenize(document-uri(/), '/')[last()]"/>
            <xsl:message select="$filename"/>
            <xsl:result-document href="../03Commands/{replace($filename, '\.xsl$', '.tmp')}" format="resultDoc">

                <d2t:commands>
                    <d2t:filename>
                        <xsl:value-of select="tokenize(document-uri(/), '/')[last()]"/>
                    </d2t:filename>

                    <xsl:apply-templates mode="C"/>
                </d2t:commands>
            </xsl:result-document>
            <xsl:result-document href="../01OutStyle/{$filename}">
                <xsl:apply-templates select="/node()" mode="d2t:xsl"/>
            </xsl:result-document>
        </xsl:for-each>
        <xsl:result-document href="../01OutStyle/d2t.main.xsl">
            <axsl:stylesheet version="2.0">
                <axsl:include href="{tokenize($startingStyle, '/')[last()]}"/>

                <axsl:template match="/" mode="d2t:start">
                    <root>
                        <axsl:for-each select="d2t:getDocuments(/config/dataFolder)">
                            <result>
                                <axsl:apply-templates select="/"/>
                            </result>
                        </axsl:for-each>
                    </root>
                </axsl:template>
                
                <axsl:template name="d2t:resolve">
                    <axsl:param name="name"/>
                    <axsl:param name="position"/>
                    <axsl:param name="filename"/>
                    <axsl:message>
                        <axsl:value-of select="'#pos#', $position, '#filename#', $filename, '#name#', $name, '#endCom'" separator=""/>
                    </axsl:message>
                </axsl:template>

                <xsl:copy-of select="doc('../00_FunctionLib/00FunctionLib.xsl')/*/xsl:function"/>
            </axsl:stylesheet>
        </xsl:result-document>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="xsl:stylesheet | xsl:transform" mode="d2t:xsl">
        <xsl:message>startingStyle: <xsl:value-of select="$startingStyle"/> $filename=<xsl:value-of select="document-uri(/)"/></xsl:message>
        <xsl:copy>
            <xsl:copy-of select="@*"/>


            <xsl:apply-templates mode="#current"/>
        </xsl:copy>
    </xsl:template>





    <xsl:template match="*" mode="C">
        <xsl:apply-templates mode="C"/>
    </xsl:template>

    <xsl:template match="text()" mode="C"/>

    <xsl:template match="xsl:*[local-name() = $checkedElementNames] | xsl:template[@*/local-name() = $checkedTemplates]" mode="C">
        <xsl:variable name="elementname" select="name()"/>
        <xsl:apply-templates mode="C"/>

        <d2t:command>
            <d2t:name>
                <xsl:value-of select="name()"/>
            </d2t:name>
            <d2t:position>
                <xsl:value-of select="count(preceding::*[name() = $elementname] | ancestor::*[name() = $elementname]) + 1"/>
            </d2t:position>
            <d2t:line>
                <xsl:value-of select="saxon:line-number()"/>
            </d2t:line>
        </d2t:command>
    </xsl:template>



</xsl:stylesheet>
