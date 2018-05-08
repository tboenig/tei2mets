<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:xs="http://www.w3.org/2001/XMLSchema"
xsi:schemaLocation="http://schema.primaresearch.org/PAGE/gts/pagecontent/2017-07-15 
http://schema.primaresearch.org/PAGE/gts/pagecontent/2017-07-15/pagecontent.xsd"
xmlns="http://schema.primaresearch.org/PAGE/gts/pagecontent/2017-07-15"
exclude-result-prefixes="#all" version="3.0">
<xsl:namespace-alias stylesheet-prefix="" result-prefix=""/>
<xsl:strip-space elements="*"/>
<xsl:output indent="no" encoding="UTF-8"/>

<!-- Param -->

<xsl:param name="INPUT_DIR"/>

<xsl:variable name="anzahl" select="count(//clip)"/>

<!-- Document -->
<xsl:template match="/">

<!-- date -->
<xsl:variable name="current_date">
<xsl:value-of select="current-dateTime()"/>
</xsl:variable>


<!-- document -->
<xsl:variable name="input-dir-uri"
select="'file:///' || replace($INPUT_DIR, '\\', '/') || '?select=*.xml;recurse=no'" as="xs:string"/>

<xsl:variable name="documents" select="collection($input-dir-uri)" as="document-node()*"/>


<!-- number of clips -->



<xsl:for-each select="$documents">

<xsl:variable name="numberClips">
<xsl:for-each select="//clipping">
<xsl:value-of select="count(//clip)"/>
</xsl:for-each>
</xsl:variable>



<xsl:variable name="cur-doc" select="." as="document-node()"/>
<xsl:variable name="basename" as="xs:string" select="string(base-uri($cur-doc))"/>

<!-- Output URI -->
<xsl:variable name="output-uri" select="replace($basename, 'gt', 'gt/page')"/>
<xsl:variable name="exif-uri_part01" select="replace($basename, 'gt/clip_', 'gt/exif/')"/>


<!--URI Filename Variablen -->
<xsl:variable name="filename" select="(tokenize($exif-uri_part01, '/'))[last()]"/>
<xsl:variable name="without_extension" select="replace($filename, '.xml', '')"/>


<!-- exif file -->
<xsl:variable name="exif_file" select="$exif-uri_part01"/>
<xsl:variable name="exif" select="document($exif_file)"/>


<xsl:message select="$exif_file"></xsl:message>





<xsl:result-document href="{$output-uri}">
<xsl:choose>
<xsl:when test="$numberClips = 1"/>
<xsl:otherwise>
<TEI>
<xsl:copy-of select="document('')/*/@xsi:schemaLocation"/>
<Metadata>
<Creator>Deutsches Textarchiv</Creator>
<Created>
<xsl:value-of select="substring-before($current_date, '+')"/>
</Created>
<LastChange>
<!--year--><xsl:value-of select="substring(clipping/@datetime, 7, 4)"/>-<!--month--><xsl:value-of
select="substring(clipping/@datetime, 4, 2)"/>-<!--day--><xsl:value-of
select="substring-before(clipping/@datetime, '.')"/><!--lastTime-->T<xsl:value-of
select="substring(clipping/@datetime, 12, 8)"/></LastChange>
</Metadata>
<Page>
<xsl:attribute name="imageFilename">../jpg/<xsl:value-of select="$without_extension"
/></xsl:attribute>
<xsl:attribute name="imageWidth">
<xsl:value-of
select="$exif//*[namespace-uri() = 'http://ns.exiftool.ca/File/1.0/' and local-name() = 'ImageWidth'][1]"/>
</xsl:attribute>
<xsl:attribute name="imageHeight">
<xsl:value-of
select="$exif//*[namespace-uri() = 'http://ns.exiftool.ca/File/1.0/' and local-name() = 'ImageHeight'][1]"/>
</xsl:attribute>
<xsl:choose>
<xsl:when test="clip/@type = '34'">
<xsl:attribute name="type" select="'table-of-contents'"/>
</xsl:when>
<xsl:when test="clip/@type = '35'">
<xsl:attribute name="type" select="'title'"/>
</xsl:when>
<xsl:otherwise>
<xsl:attribute name="type" select="'content'"/>
</xsl:otherwise>
</xsl:choose>
<ReadingOrder>
<OrderedGroup id="{generate-id(.)}" caption="Regions reading order">
<xsl:for-each select="//clip">
<RegionRefIndexed index="{position()}" regionRef="region_{position()}"/>
</xsl:for-each>
</OrderedGroup>
</ReadingOrder>
<xsl:apply-templates select="$cur-doc/node()"/>
</Page>
</TEI>
</xsl:otherwise>
</xsl:choose>
</xsl:result-document>
</xsl:for-each>
</xsl:template>





<xsl:template match="clip" name="textregion">
<xsl:variable name="custom">
<xsl:choose>
<xsl:when test="./@type = '11'">
<xsl:text>#poem</xsl:text>
</xsl:when>
<xsl:when test="@type = '20'">
<xsl:text>#heading_level1</xsl:text>
</xsl:when>
<xsl:when test="@type = '21'">
<xsl:text>#heading_level2</xsl:text>
</xsl:when>
<xsl:when test="@type = '22'">
<xsl:text>#heading_level3</xsl:text>
</xsl:when>
<xsl:when test="@type = '23'">
<xsl:text>#heading_level4</xsl:text>
</xsl:when>
<xsl:when test="@type = '24'">
<xsl:text>#heading_level5</xsl:text>
</xsl:when>
<xsl:when test="@type = '25'">
<xsl:text>#heading_level6</xsl:text>
</xsl:when>
<xsl:when test="@type = '26'">
<xsl:text>#heading_level7</xsl:text>
</xsl:when>
<xsl:when test="@type = '30'">
<xsl:text>#column</xsl:text>
</xsl:when>
<xsl:when test="@type = '32'">
<xsl:text>#stage</xsl:text>
</xsl:when>
<xsl:when test="@type = '33'">
<xsl:text>#list_item</xsl:text>
</xsl:when>
<xsl:when test="@type = '36'">
<xsl:text>#back_paragraph</xsl:text>
</xsl:when>
<xsl:when test="@type = '41'">
<xsl:text>#castlist</xsl:text>
</xsl:when>
<xsl:when test="@type = '42'">
<xsl:text>#closer</xsl:text>
</xsl:when>
<xsl:when test="@type = '44'">
<xsl:text>#poem_lg</xsl:text>
</xsl:when>
<xsl:when test="@type = '45'">
<xsl:text>#salute</xsl:text>
</xsl:when>
<xsl:when test="@type = '46'">
<xsl:text>#speaker</xsl:text>
</xsl:when>
<xsl:when test="@type = '47'">
<xsl:text>#cit</xsl:text>
</xsl:when>
<xsl:when test="@type = '61'">
<xsl:text>#ded</xsl:text>
</xsl:when>
<xsl:when test="@type = '63'">
<xsl:text>#arg</xsl:text>
</xsl:when>
<xsl:when test="@type = '43'">
<xsl:text>#poem_heading</xsl:text>
</xsl:when>
<xsl:when test="@type = '91'">
<xsl:text>#margi_left</xsl:text>
</xsl:when>
<xsl:when test="@type = '92'">
<xsl:text>#margi_right</xsl:text>
</xsl:when>
<xsl:when test="./@type = '130'">
<xsl:text>#list</xsl:text>
</xsl:when>
<xsl:when test="@type = '140'">
<xsl:text>#formel</xsl:text>
</xsl:when>

</xsl:choose>
</xsl:variable>

<xsl:variable name="zone">
<xsl:choose>
<xsl:when test="@type = '10'">
<xsl:text>paragraph</xsl:text>
</xsl:when>
<xsl:when test="@type = '11'">
<xsl:text>paragraph</xsl:text>
</xsl:when>
<xsl:when test="@type = '20'">
<xsl:text>heading</xsl:text>
</xsl:when>
<xsl:when test="@type = '21'">
<xsl:text>heading</xsl:text>
</xsl:when>
<xsl:when test="@type = '22'">
<xsl:text>heading</xsl:text>
</xsl:when>
<xsl:when test="@type = '23'">
<xsl:text>heading</xsl:text>
</xsl:when>
<xsl:when test="@type = '24'">
<xsl:text>heading</xsl:text>
</xsl:when>
<xsl:when test="@type = '25'">
<xsl:text>heading</xsl:text>
</xsl:when>
<xsl:when test="@type = '26'">
<xsl:text>heading</xsl:text>
</xsl:when>
<xsl:when test="@type = '30'">
<xsl:text>paragraph</xsl:text>
</xsl:when>
<xsl:when test="@type = '31'">
<xsl:text>caption</xsl:text>
</xsl:when>
<xsl:when test="@type = '32'">
<xsl:text>paragraph</xsl:text>
</xsl:when>
<xsl:when test="@type = '33'">
<xsl:text>paragraph</xsl:text>
</xsl:when>
<xsl:when test="@type = '34'">
<xsl:text>paragraph</xsl:text>
</xsl:when>
<xsl:when test="@type = '35'">
<xsl:text>other</xsl:text>
</xsl:when>
<xsl:when test="@type = '36'">
<xsl:text>other</xsl:text>
</xsl:when>
<xsl:when test="@type = '40'">
<xsl:text>page-number</xsl:text>
</xsl:when>
<xsl:when test="@type = '41'">
<xsl:text>paragraph</xsl:text>
</xsl:when>
<xsl:when test="@type = '42'">
<xsl:text>other</xsl:text>
</xsl:when>
<xsl:when test="@type = '43'">
<xsl:text>paragraph</xsl:text>
</xsl:when>
<xsl:when test="@type = '44'">
<xsl:text>paragraph</xsl:text>
</xsl:when>
<xsl:when test="@type = '45'">
<xsl:text>other</xsl:text>
</xsl:when>
<xsl:when test="@type = '46'">
<xsl:text>other</xsl:text>
</xsl:when>
<xsl:when test="@type = '47'">
<xsl:text>paragraph</xsl:text>
</xsl:when>
<xsl:when test="@type = '50'">
<xsl:text>signature-mark</xsl:text>
</xsl:when>
<xsl:when test="@type = '60'">
<xsl:text>header</xsl:text>
</xsl:when>
<xsl:when test="@type = '61'">
<xsl:text>paragraph</xsl:text>
</xsl:when>
<xsl:when test="@type = '62'">
<xsl:text>heading</xsl:text>
</xsl:when>
<xsl:when test="@type = '63'">
<xsl:text>paragraph</xsl:text>
</xsl:when>
<xsl:when test="@type = '64'">
<xsl:text>paragraph</xsl:text>
</xsl:when>
<xsl:when test="@type = '70'">
<xsl:text>footnote</xsl:text>
</xsl:when>
<xsl:when test="@type = '71'">
<xsl:text>footnote-continued</xsl:text>
</xsl:when>
<xsl:when test="@type = '80'">
<xsl:text>endnote</xsl:text>
</xsl:when>
<xsl:when test="@type = '90'">
<xsl:text>catch-word</xsl:text>
</xsl:when>
<xsl:when test="@type = '91'">
<xsl:text>marginalia</xsl:text>
</xsl:when>
<xsl:when test="@type = '92'">
<xsl:text>marginalia</xsl:text>
</xsl:when>
<xsl:when test="@type = '130'">
<xsl:text>paragraph</xsl:text>
</xsl:when>
<xsl:when test="@type = '333'">
<xsl:text>paragraph</xsl:text>
</xsl:when>
<xsl:otherwise> </xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:choose>
<xsl:when test="@type = '150'">
<SeparatorRegion>
<xsl:attribute name="id">region_<xsl:value-of select="position()"/></xsl:attribute>
<Coords points="{@left},{@top} {@right},{@top} {@right},{@bottom} {@left},{@bottom}"/>
</SeparatorRegion>
</xsl:when>
<xsl:when test="@type = '444'">
<GraphicRegion>
<xsl:attribute name="id">region_<xsl:value-of select="position()"/></xsl:attribute>
<Coords points="{@left},{@top} {@right},{@top} {@right},{@bottom} {@left},{@bottom}"/>
</GraphicRegion>
</xsl:when>
<xsl:when test="@type = '110'">
<GraphicRegion>
<xsl:attribute name="id">region_<xsl:value-of select="position()"/></xsl:attribute>
<Coords points="{@left},{@top} {@right},{@top} {@right},{@bottom} {@left},{@bottom}"/>
</GraphicRegion>
</xsl:when>
<xsl:when test="@type = '120'">
<TableRegion>
<xsl:attribute name="id">region_<xsl:value-of select="position()"/></xsl:attribute>
<Coords points="{@left},{@top} {@right},{@top} {@right},{@bottom} {@left},{@bottom}"/>
</TableRegion>
</xsl:when>
<xsl:when test="@type = '140'">
<MathsRegion>
<xsl:attribute name="id">region_<xsl:value-of select="position()"/></xsl:attribute>
<Coords points="{@left},{@top} {@right},{@top} {@right},{@bottom} {@left},{@bottom}"/>
</MathsRegion>
</xsl:when>
<xsl:otherwise>
<TextRegion>
<xsl:attribute name="type">
<xsl:value-of select="$zone"/>
</xsl:attribute>
<xsl:choose>
<xsl:when test="@type = '11'or '20' 
or '21' or '22' 
or '23' or '24' 
or '25' or '26' 
or '30' or '32' 
or '33' or '36' 
or '41'
or '42' or '43' 
or '44' or '45' 
or '46' or '47' 
or '61' or '63' 
or '91' or '92' 
or '130' or '140'">
<xsl:attribute name="custom"><xsl:value-of select="$custom"/></xsl:attribute>
</xsl:when>
</xsl:choose>

<xsl:attribute name="id">region_<xsl:value-of select="position()"/></xsl:attribute>
<Coords points="{@left},{@top} {@right},{@top} {@right},{@bottom} {@left},{@bottom}"/>
</TextRegion>
</xsl:otherwise>
</xsl:choose>
</xsl:template>



</xsl:stylesheet>
