# XSLT Checker #

The XSLT Checker is a small project to detect in a given XSLT stylesheet commands which are never used when it is processing a huge set of input data.

## Call the XSLT Checker ##

The XSLT Checker is called by:

```
start.bat [config-file]? [output-directory]?
```

## Configurtion file ##

The XSLT Checker is configured by a configiguration file, which should valid to the RelaxNG schema [schema/config.rnc](schema/config.rnc).

The default config will be found in config/config.xml

### Input Data Set ###

The `<dataFolder>` specifies the input data set. The containing path should point to a folder and can be relative to the config or absolute.

In the default config the `<dataFolder>` points to the folder [{$projectDir}/sample/xml](./sample/xml/).

The optional attribute `extensions` can be used to specify a file extensions. If the attribute is set only files with those extensions should be used as Input Data Set. Multiple extensions should be separated by a semicolon (`;`). If the attribute is omited any file in the given folder should be used.

In the default config this `extensions` attribute has the value `xml`.

### XSLT Stylesheet Set ###

The `<styleFolder>` specifies the XSLT Stylesheet Set. The containing path should point to a folder and can be relative to the config or absolute.

In the default config the `<styleFolder>` points to the folder [{$projectDir}/sample/xsl](./sample/xsl/).

The optional attribute `extensions` can be used to specify a file extensions. If the attribute is set only files with those extensions should be used as XSLT Stylesheet Set. Multiple extensions should be separated by a semicolon (`;`). If the attribute is omited any file in the given folder should be used.

In the default config this `extensions` attribute has the value `xsl`.

### Main Stylesheet ###

The `startingStyle` specifies one stylesheet in the XSLT Stylesheet Set which should be used as the Main Stylesheet. The containing path should point to the Main Stylesheet and should be relative to the folder `<styleFolder>`.

The Main Stylesheet should include or import all other stylesheets of the XSLT Stylesheet Set directly or indirectly.

### Command Configuration ###

By default the commands `xsl:template`, `xsl:if`, `xsl:choose/xsl:when`, `xsl:choose/xsl:otherwise`, `xsl:for-each`, `xsl:for-each-group` and `xsl:function` will be checked by the XSLT Checker.

The optional element `checkedElements` can be used to specify which commands should be ignored by the XSLT Checker. If this element is omited the XSLT Checker processes in the default behavior.

Example to ignore only the `xsl:template` with `match` attribute:

```
<checkedElements>
    <template>
        <name>true</name>
        <match>false</match>
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
```

## Output directory ##

The output directory will be used to store the result of the XSLT Checker. The result contains two versions of the same report. One in XML and one in plain text format.

Both report versions lists all respected commands which was never used when all files of the Input Data Set was processed by the Main Stylesheet.

The default output directory is [{$projectDir}/sample/result](sample/result)

## Restrictions ##

Currently the XSLT Checker has the following restrictions:

- It works on Windows systems only
- The Stylesheets should be processable with the Saxon version 8.9
- The XSLT Checker can not catch any error. The Input Data Set should not throw any error.
- Only one Stylesheet call is supported. A XSLT pipeline can not be checked by the XSLT Checker 





