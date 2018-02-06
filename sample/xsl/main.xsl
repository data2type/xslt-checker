<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:output method="xhtml"/>

    <xsl:template match="/">

        <html>
            <head>
                <title>Cocktails</title>
            </head>
            <body>
                <h1>Cocktails</h1>
                <xsl:if test="/cocktails/cocktail[@cat = 'sour']">
                    <h2>Sour</h2>
                    <xsl:for-each select="/cocktails/cocktail[@cat = 'sour']">
                        <xsl:apply-templates select="."/>
                    </xsl:for-each>
                </xsl:if>

                <xsl:if test="/cocktails/cocktail[@cat = 'fruity']">
                    <h2>Fruity</h2>
                    <xsl:for-each select="/cocktails/cocktail[@cat = 'fruity']">
                        <xsl:apply-templates select="."/>
                    </xsl:for-each>
                </xsl:if>
                
                <xsl:if test="/cocktails/cocktail[@cat = 'sweet']">
                    <h2>Sweet</h2>
                    <xsl:for-each select="/cocktails/cocktail[@cat = 'sweet']">
                        <xsl:apply-templates select="."/>
                    </xsl:for-each>
                </xsl:if>

                <xsl:if test="/cocktails/cocktail[@cat = 'creamy']">
                    <h2>Creamy</h2>
                    <xsl:for-each select="/cocktails/cocktail[@cat = 'creamy']">
                        <xsl:apply-templates select="."/>
                    </xsl:for-each>
                </xsl:if>

            </body>
        </html>
    </xsl:template>

    <xsl:include href="components.xsl"/>
    
</xsl:stylesheet>
