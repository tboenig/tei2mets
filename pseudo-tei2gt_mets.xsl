<?xml version="1.0" encoding="UTF-8"?>
<!--
  This file is part of the METS Merger, Copyright 2011, 2012 SUB Göttingen

  This program is free software; you can redistribute it and/or modify it under
  the terms of the GNU Affero General Public License version 3 as published by
  the Free Software Foundation.
  
  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
  details.
 
  You should have received a copy of the GNU Affero General Public License
  along with this program; if not, see http://www.gnu.org/licenses or write to
  the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
  MA 02110-1301 USA.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xlink="http://www.w3.org/1999/xlink"
xmlns:DC="http://purl.org/dc/elements/1.1/" xmlns:mods="http://www.loc.gov/mods/v3"
xmlns:mets="http://www.loc.gov/METS/" xmlns:xs="http://www.w3.org/2001/XMLSchema"
xmlns:DV="http://dfg-viewer.de/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xs" version="2.0">
<xd:doc scope="stylesheet">
<xd:desc>
<xd:p>
<xd:p> <xd:b>Created on:</xd:b> Apr 17, 2011 </xd:p>
<xd:p> <xd:b>Author:</xd:b> cmahnke </xd:p>
</xd:p>
<xd:p/>
<xd:p>
<xd:p> <xd:b>Revised on:</xd:b> Juni 28, 2017 </xd:p>
<xd:p> <xd:b>Author:</xd:b> tboenig </xd:p>
</xd:p>
<xd:p/>
</xd:desc>
</xd:doc>

<xsl:output encoding="UTF-8" exclude-result-prefixes="#all" indent="yes"/>
<xsl:param name="baseURL1"/>
<xsl:param name="output-uri">file:///P:/OCR-Koordination/OCR-D_Produktion/ground_truth_04_vorbereitung/OCR-D_gt/data_text_structur/<xsl:value-of select="$baseURL1"/>/mets/<xsl:value-of select="$baseURL1"/>_mets.xml</xsl:param>
<xsl:param name="identifier">
<xsl:choose>
<xsl:when test="//fileDesc/publicationStmt/idno/idno[@type = 'DTADirName']">
<xsl:value-of select="//fileDesc/publicationStmt/idno/idno[@type = 'DTADirName']"/>
</xsl:when>
<xsl:otherwise>DTADirName_nicht_vorhanden</xsl:otherwise>
</xsl:choose>
</xsl:param>
<xsl:param name="locationPrefix"></xsl:param>
<xsl:param name="locationSuffix">.tif</xsl:param>
<xsl:param name="multipleHead" select="true()" as="xs:boolean"/>
<xsl:variable name="physPrefix">phys</xsl:variable>
<xsl:variable name="locPrefix">loc</xsl:variable>
<xsl:variable name="filePrefix">file</xsl:variable>
<xsl:variable name="useOrWidth">width</xsl:variable>

<!-- Image Files -->
<xsl:param name="IMG"/>     	<!--The unmanipulated source images-->
<xsl:param name="IMG-BIN"/>  	<!--Black-and-White images-->
<xsl:param name="IMG-CROP"/>	<!--Cropped images-->
<xsl:param name="IMG-DESKEW"/>	<!--Deskewed images-->
<xsl:param name="IMG-DESPECK"/>	<!--Despeckled images-->
<xsl:param name="IMG-DEWARP"/>	<!--Dewarped images-->


<!-- pageXML-->
<xsl:param name="PAGE"/>		<!--Page segmentation ground truth  -->
<xsl:param name="BLOCK"/>		<!--Block segmentation ground truth  -->
<xsl:param name="LINE"/>		<!--Line segmentation ground truth  -->
<xsl:param name="WORD"/>		<!--Word segmentation ground truth  -->
<xsl:param name="GLYPH"/>		<!--Glyph segmentation ground truth  -->

<xsl:variable name="fileGroups">
<xsl:if test="$PAGE = '1'"><group locationPrefix="file://page/" locationSuffix=".xml">OCR-D-GT-SEG-PAGE</group></xsl:if>
<xsl:if test="$BLOCK = '1'"><group locationPrefix="file://page/" locationSuffix=".xml">OCR-D-GT-SEG-BLOCK</group></xsl:if>
<xsl:if test="$LINE = '1'"><group locationPrefix="file://page/" locationSuffix=".xml">OCR-D-GT-SEG-LINE</group></xsl:if>
<xsl:if test="$WORD = '1'"><group locationPrefix="file://page/" locationSuffix=".xml">OCR-D-GT-SEG-WORD</group></xsl:if>
<xsl:if test="$GLYPH = '1'"><group locationPrefix="file://page/" locationSuffix=".xml">OCR-D-GT-SEG-GLYPH</group></xsl:if>

<xsl:if test="$IMG = '1'"><group locationPrefix="file://tif/" locationSuffix="">OCR-D-IMG</group></xsl:if>
<xsl:if test="$IMG-BIN = '1'"><group locationPrefix="" locationSuffix="">OCR-D-IMG-BIN</group></xsl:if>
<xsl:if test="$IMG-BIN = '1'"><group locationPrefix="" locationSuffix="">OCR-D-IMG-BIN</group></xsl:if>
<xsl:if test="$IMG-CROP = '1'"><group locationPrefix="" locationSuffix="">OCR-D-IMG-CROP</group></xsl:if>
<xsl:if test="$IMG-DESKEW = '1'"><group locationPrefix="" locationSuffix="">OCR-D-IMG-DESKEW</group></xsl:if>
<xsl:if test="$IMG-DESPECK = '1'"><group locationPrefix="" locationSuffix="">OCR-D-IMG-DESPECK</group></xsl:if>
<xsl:if test="$IMG-DEWARP = '1'"><group locationPrefix="" locationSuffix="">OCR-D-IMG-DEWARP</group></xsl:if>
</xsl:variable>

<xsl:template match="/">
<xsl:result-document href="{$output-uri}">
<mets:mets
xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-3.xsd http://www.loc.gov/mets/ http://www.loc.gov/standards/mets/version17/mets.v1-7.xsd">
<xsl:if test="$identifier = 'REPLACEME'">
<xsl:comment>Replace the string 'REPLACEME' with the real dentifier using sed, if no param was given</xsl:comment>
</xsl:if>
<xsl:call-template name="metsHeader"/>
<!-- the file section -->
<mets:fileSec>
<xsl:variable name="nodes" select="//pb"/>
<xsl:for-each select="$fileGroups/group">
<xsl:call-template name="pbFileSect">
<xsl:with-param name="use">
<xsl:value-of select="text()"/>
</xsl:with-param>
<xsl:with-param name="nodes" select="$nodes"/>
<xsl:with-param name="prefix" select="@locationPrefix"/>
<xsl:with-param name="suffix" select="@locationSuffix"/>
<xsl:with-param name="width" select="@width"/>
</xsl:call-template>
</xsl:for-each>
</mets:fileSec>
<!-- The logical struct map -->
<mets:structMap TYPE="LOGICAL">
<xsl:choose>
<xsl:when test="//fileDesc/titleStmt/title[@type = 'volume']">
<mets:div TYPE="multivolume_work">
<xsl:attribute name="ID">
<xsl:value-of select="$locPrefix"/>
<xsl:text>_</xsl:text>
<xsl:number format="0001" value="1"/>
</xsl:attribute>
<xsl:choose>
<xsl:when test="//fileDesc/titleStmt/title[@type = 'sub']">
<xsl:attribute name="LABEL"><xsl:value-of
select="//fileDesc/titleStmt/title[@type = 'main']"/>, <xsl:value-of
select="//fileDesc/titleStmt/title[@type = 'sub']"/></xsl:attribute>
</xsl:when>
<xsl:otherwise>
<xsl:attribute name="LABEL">
<xsl:value-of select="//fileDesc/titleStmt/title[@type = 'main']"/>
</xsl:attribute>
</xsl:otherwise>
</xsl:choose>
<mets:div TYPE="volume">
<xsl:attribute name="DMDID">
<xsl:text>dmdSec_</xsl:text>
<xsl:number format="0001" value="1"/>
</xsl:attribute>
<xsl:attribute name="ADMID">
<xsl:text>amdSec_</xsl:text>
<xsl:number format="0001" value="1"/>
</xsl:attribute>
<xsl:attribute name="LABEL">
<xsl:value-of select="//fileDesc/titleStmt/title[@type = 'volume']"/>
</xsl:attribute>
<xsl:apply-templates select="/TEI/text"/>
</mets:div>
</mets:div>
</xsl:when>
<xsl:otherwise>
<mets:div TYPE="Monograph" DMDID="dmdSec_0001" ADMID="amdSec_0001">
<xsl:attribute name="ID">
<xsl:value-of select="$locPrefix"/>
<xsl:text>_</xsl:text>
<xsl:number format="0001" value="1"/>
</xsl:attribute>
<xsl:apply-templates select="/TEI/text"/>
</mets:div>
</xsl:otherwise>
</xsl:choose>

</mets:structMap>
<!-- The physical struct map -->
<mets:structMap TYPE="PHYSICAL">
<mets:div TYPE="physSequence">
<xsl:attribute name="ID">
<xsl:value-of select="$physPrefix"/>
<xsl:text>_</xsl:text>
<xsl:number format="0001" value="0"/>
</xsl:attribute>
<xsl:call-template name="pbPhysMap"/>
</mets:div>
</mets:structMap>
<mets:structLink>
<mets:smLink>
<xsl:attribute name="xlink:from">
<xsl:value-of select="$locPrefix"/>
<xsl:text>_</xsl:text>
<xsl:number format="0001" value="1"/>
</xsl:attribute>
<xsl:attribute name="xlink:to">
<xsl:value-of select="$physPrefix"/>
<xsl:text>_</xsl:text>
<xsl:number format="0001" value="0"/>
</xsl:attribute>
</mets:smLink>
<xsl:for-each select="//head | //titlePage[@type = 'main']">
<xsl:if test="not(preceding-sibling::head)">
<xsl:variable name="childPbs" select="ancestor::div[1]/descendant::pb"/>
<xsl:variable name="from">
<xsl:call-template name="createId">
<xsl:with-param name="prefix">
<xsl:value-of select="$locPrefix"/>
<xsl:text>_</xsl:text>
</xsl:with-param>
<xsl:with-param name="node" select="."/>
</xsl:call-template>
</xsl:variable>
<xsl:choose>
<xsl:when test="count($childPbs) = 0">
<mets:smLink>
<xsl:attribute name="xlink:from">
<xsl:value-of select="$from"/>
</xsl:attribute>
<xsl:attribute name="xlink:to">
<xsl:value-of select="$physPrefix"/>
<xsl:text>_</xsl:text>
<xsl:number format="0001" value="count(preceding::pb)"/>
</xsl:attribute>
</mets:smLink>
</xsl:when>
<xsl:otherwise>
<xsl:for-each select="$childPbs">
<mets:smLink>
<xsl:attribute name="xlink:from">
<xsl:value-of select="$from"/>
</xsl:attribute>
<xsl:attribute name="xlink:to">
<xsl:value-of select="$physPrefix"/>
<xsl:text>_</xsl:text>
<xsl:number format="0001" value="count(preceding::pb)"/>
</xsl:attribute>
</mets:smLink>
</xsl:for-each>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:for-each>
</mets:structLink>
</mets:mets>
</xsl:result-document>
</xsl:template>



















<!-- Creates the physical struct map -->
<xsl:template name="pbPhysMap">
<xsl:for-each select="//pb">
<mets:div TYPE="page">
<xsl:variable name="pageNr">
<xsl:number level="any" count="//pb"/>
</xsl:variable>
<xsl:variable name="pageId">
<xsl:number format="0001" level="any" count="//pb"/>
</xsl:variable>
<xsl:attribute name="ORDER">
<xsl:value-of select="$pageNr"/>
</xsl:attribute>
<xsl:attribute name="ID">
<xsl:value-of select="$physPrefix"/>
<xsl:text>_</xsl:text>
<xsl:value-of select="$pageId"/>
</xsl:attribute>
<xsl:for-each select="$fileGroups/group">
<mets:fptr>
<xsl:attribute name="FILEID">
<xsl:value-of select="."/>
<xsl:text>_</xsl:text>
<xsl:value-of select="$pageId"/>
</xsl:attribute>
</mets:fptr>
</xsl:for-each>
</mets:div>
</xsl:for-each>
</xsl:template>

<!-- Creates a file group -->
<xsl:template name="pbFileSect">
<xsl:param name="nodes"/>
<xsl:param name="id" select="$identifier"/>
<xsl:param name="use"/>
<xsl:param name="prefix" select="$locationPrefix"/>
<xsl:param name="suffix" select="$locationSuffix"/>
<xsl:param name="width"/>
<mets:fileGrp>
<xsl:attribute name="USE">
<xsl:value-of select="$use"/>
</xsl:attribute>
<xsl:for-each select="$nodes">

<mets:file>
<xsl:choose>
<xsl:when test="$use = 'OCR-D-IMG'"><xsl:attribute name="MIMETYPE">image/tif</xsl:attribute></xsl:when>
<xsl:when test="$PAGE or $BLOCK or $LINE or $GLYPH or $WORD = '1'"><xsl:attribute name="MIMETYPE">application/vnd.prima.page+xml</xsl:attribute></xsl:when>
<xsl:otherwise><xsl:attribute name="MIMETYPE">image/jpeg</xsl:attribute></xsl:otherwise>
</xsl:choose>

<xsl:attribute name="ID">
<xsl:value-of select="$use"/>
<xsl:text>_</xsl:text>
<xsl:number format="0001" level="any" count="//pb"/>
</xsl:attribute>
<mets:FLocat LOCTYPE="URL">
<xsl:attribute name="xlink:href">
<xsl:choose>
<xsl:when test="$prefix = ''">
<xsl:value-of select="$locationPrefix"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$prefix"/>
</xsl:otherwise>
</xsl:choose>
<xsl:value-of select="substring-before(./@facs, '.')"/>
<xsl:choose>
<xsl:when test="$suffix = ''">
<xsl:value-of select="$locationSuffix"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$suffix"/>
</xsl:otherwise>
</xsl:choose>
</xsl:attribute>
</mets:FLocat>
</mets:file>
</xsl:for-each>
</mets:fileGrp>
</xsl:template>


<xsl:template match="front">
<mets:div>
<xsl:apply-templates select="titlePage"/>
</mets:div>
</xsl:template>


<xsl:template match="back">
<mets:div>
<xsl:apply-templates select="titlePage"/>
</mets:div>
</xsl:template>


<xsl:template match="titlePage">
<xsl:variable name="LabelType">
<xsl:choose>
<xsl:when test=".[@type = 'main']">title_page</xsl:when>
<xsl:otherwise>
<xsl:value-of select="@type"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:attribute name="ID">
<xsl:call-template name="createId">
<xsl:with-param name="prefix">
<xsl:value-of select="$locPrefix"/>
<xsl:text>_</xsl:text>
</xsl:with-param>
<xsl:with-param name="node" select="."/>
</xsl:call-template>
</xsl:attribute>
<xsl:attribute name="TYPE">
<xsl:value-of select="$LabelType"/>
</xsl:attribute>
<xsl:attribute name="LABEL"/>
</xsl:template>

<xsl:template match="div">
<xsl:choose>
<!-- Get rid of empty div tags -->
<xsl:when test="head">
<mets:div>
<xsl:apply-templates select="div | head"/>
</mets:div>
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="div | head"/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>



<xsl:template match="head">
<xsl:variable name="text_head">
<xsl:value-of select="text() | hi"/>
</xsl:variable>
<xsl:variable name="LabelType">
<xsl:choose>
<xsl:when test="parent::div/@type">
<xsl:value-of select="parent::div/@type"/>
</xsl:when>
<xsl:otherwise>Chapter</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<!--<xsl:if test="parent::div/count(child::head) > 1">
<xsl:message>Div element contains more then one head, only using the first one!</xsl:message>-->
<!--</xsl:if>-->
<xsl:if test="parent::div/count(child::head) &gt;= 1">
<xsl:attribute name="ID">
<xsl:call-template name="createId">
<xsl:with-param name="prefix">
<xsl:value-of select="$locPrefix"/>
<xsl:text>_</xsl:text>
</xsl:with-param>
<xsl:with-param name="node" select="."/>
</xsl:call-template>
</xsl:attribute>
<xsl:if test="$multipleHead and following-sibling::head">
<xsl:attribute name="DMDID">
<xsl:call-template name="createId">
<xsl:with-param name="prefix" select="'dmdSec_'"/>
<xsl:with-param name="node" select="parent::div"/>
</xsl:call-template>
</xsl:attribute>
</xsl:if>
<xsl:attribute name="TYPE">
<xsl:value-of select="$LabelType"/>
</xsl:attribute>
<xsl:attribute name="LABEL">
<xsl:call-template name="cleanLabel">
<xsl:with-param name="str" select="$text_head"/>
</xsl:call-template>
</xsl:attribute>
</xsl:if>
</xsl:template>






<xsl:template match="text()"/>
<xsl:template name="metsHeader">
<mets:dmdSec ID="dmdSec_0001">
<mets:mdWrap MDTYPE="mods">
<mets:xmlData>
<mods:mods>

<!--neu-->
<mods:location>
<mods:physicalLocation>
<xsl:value-of select="//msIdentifier/repository"/>
</mods:physicalLocation>
<mods:shelfLocator>
<xsl:value-of select="//idno/idno[@type = 'shelfmark']"/>
</mods:shelfLocator>
<mods:url>
<xsl:value-of select="//idno/idno[@type = 'URLCatalogue']"/>
</mods:url>
</mods:location>
<mods:originInfo>
<mods:place>
<mods:placeTerm type="text">
<xsl:value-of select="//sourceDesc/biblFull/publicationStmt/pubPlace"/>
</mods:placeTerm>
</mods:place>
<mods:dateIssued encoding="w3cdtf" keyDate="yes">
<xsl:value-of select="//sourceDesc/biblFull/publicationStmt/date"/>
</mods:dateIssued>
<mods:publisher>
<xsl:value-of select="//sourceDesc/biblFull/publicationStmt/publisher"/>
</mods:publisher>
</mods:originInfo>
<mods:originInfo>
<mods:dateCaptured encoding="w3cdtf">
<xsl:value-of select="//fileDesc/publicationStmt/date"/>
</mods:dateCaptured>
<mods:edition>[Electronic ed.]</mods:edition>
</mods:originInfo>
<mods:classification authority="DTA">
<xsl:value-of select="//profileDesc/textClass/classCode[1]"/>
</mods:classification>
<mods:classification authority="DTA">
<xsl:value-of select="//profileDesc/textClass/classCode[2]"/>
</mods:classification>
<xsl:choose>
<xsl:when test="//fileDesc/publicationStmt/idno/idno[@type = 'urn']">
<mods:identifier type="urn">
<xsl:value-of select="//fileDesc/publicationStmt/idno/idno[@type = 'URN']"/>
</mods:identifier>
</xsl:when>
</xsl:choose>
<xsl:choose>
<xsl:when test="//fileDesc/publicationStmt/idno/idno[@type = 'DTAID']">
<mods:identifier type="dtaid">
<xsl:value-of select="//fileDesc/publicationStmt/idno/idno[@type = 'DTAID']"/>
</mods:identifier>
</xsl:when>
</xsl:choose>
<mods:titleInfo>
<mods:title>
<xsl:value-of select="TEI/teiHeader/fileDesc/titleStmt/title[@type = 'main']"/>
</mods:title>
<mods:subTitle>
<xsl:value-of select="TEI/teiHeader/fileDesc/titleStmt/title[@type = 'sub']"/>
</mods:subTitle>
</mods:titleInfo>
<xsl:choose>
<xsl:when test="TEI/teiHeader/fileDesc/titleStmt/title[@type = 'volume']">
<mods:part>
<xsl:attribute name="order">
<xsl:choose>
<xsl:when
test="TEI/teiHeader/fileDesc/titleStmt/title[@type = 'volume'][matches(@n, ',')]">
<xsl:analyze-string
select="TEI/teiHeader/fileDesc/titleStmt/title[@type = 'volume']/@n"
regex="(\d+),*(\d*)">
<xsl:matching-substring>
<xsl:value-of select="regex-group(2)"/>
</xsl:matching-substring>
</xsl:analyze-string>
</xsl:when>
<xsl:otherwise>
<xsl:value-of
select="TEI/teiHeader/fileDesc/titleStmt/title[@type = 'volume']/@n"/>
</xsl:otherwise>
</xsl:choose>
</xsl:attribute>
<mods:detail>
<xsl:attribute name="type">volume</xsl:attribute>
<mods:number>
<xsl:value-of select="TEI/teiHeader/fileDesc/titleStmt/title[@type = 'volume']"/>
</mods:number>
</mods:detail>
</mods:part>
</xsl:when>
</xsl:choose>
<mods:language>
<mods:languageTerm authority="iso639-2b" type="code">
<xsl:value-of select="//langUsage/language/@ident"/>
</mods:languageTerm>
</mods:language>
<mods:relatedItem type="series">
<mods:titleInfo>
<mods:title>
<xsl:value-of
select="//fileDesc/titleStmt/respStmt[@corresp = '#availability-textsource-1']/orgName"
/>
</mods:title>
</mods:titleInfo>
</mods:relatedItem>
<mods:name type="personal">
<mods:role>
<mods:roleTerm authority="marcrelator" type="code">aut</mods:roleTerm>
</mods:role>
<mods:namePart type="family">
<xsl:value-of select="//fileDesc/titleStmt/author/persName/surname"/>
</mods:namePart>
<mods:namePart type="given">
<xsl:value-of select="//fileDesc/titleStmt/author/persName/forename"/>
</mods:namePart>
<mods:displayForm>
<xsl:value-of select="//fileDesc/titleStmt/author/persName/forename"/>
<xsl:text> </xsl:text>
<xsl:value-of select="//fileDesc/titleStmt/author/persName/surname"/>
</mods:displayForm>
</mods:name>
<xsl:choose>
<xsl:when test="//fileDesc/titleStmt/respStmt[@corresp = '#availability-textsource-1']">
<xsl:for-each
select="//fileDesc/titleStmt/respStmt[@corresp = '#availability-textsource-1']/persName">
<mods:name type="personal">
<mods:role>
<mods:roleTerm authority="marcrelator" type="code">edt</mods:roleTerm>
</mods:role>
<mods:namePart type="family">
<xsl:value-of select="surname"/>
</mods:namePart>
<mods:namePart type="given">
<xsl:value-of select="forename"/>
</mods:namePart>
</mods:name>
</xsl:for-each>
</xsl:when>
</xsl:choose>
<mods:physicalDescription>
<mods:extent>
<xsl:value-of select="//fileDesc/sourceDesc/biblFull/extent/measure"/>
</mods:extent>
</mods:physicalDescription>
<mods:extension>
<zvdd:zvddWrap xmlns:zvdd="http://zvdd.gdz-cms.de/">
<zvdd:titleWord>
<xsl:value-of select="TEI/teiHeader/fileDesc/titleStmt/title"/>
</zvdd:titleWord>
</zvdd:zvddWrap>
</mods:extension>
<!--neu ende-->
</mods:mods>
</mets:xmlData>
</mets:mdWrap>
</mets:dmdSec>
<!-- Create DMD Sects for divs with multiple headings -->
<xsl:if test="$multipleHead">
<xsl:for-each select="//div[count(child::head) > 1]">
<mets:dmdSec>
<xsl:attribute name="ID">
<xsl:call-template name="createId">
<xsl:with-param name="prefix" select="'dmdSec_'"/>
<xsl:with-param name="node" select="."/>
</xsl:call-template>
</xsl:attribute>
<mets:mdWrap MDTYPE="mods">
<mets:xmlData>
<mods:mods>
<xsl:for-each select="./head">
<mods:titleInfo>
<mods:title>
<xsl:value-of select="."/>
</mods:title>
</mods:titleInfo>
</xsl:for-each>
</mods:mods>
</mets:xmlData>
</mets:mdWrap>
</mets:dmdSec>
</xsl:for-each>
</xsl:if>
<mets:amdSec ID="amdSec_0001">
<mets:rightsMD ID="rights_0001">
<mets:mdWrap MDTYPE="OTHER" OTHERMDTYPE="DVRIGHTS" MIMETYPE="text/xml">
<mets:xmlData>
<DV:rights>
<DV:owner>Koordinierte Förderinitiative zur Weiterentwicklung von Verfahren für die Optical-Character-Recognition OCR-D</DV:owner>
<DV:ownerLogo>http://ocr-d.de/sites/default/files/ocr-d.svg</DV:ownerLogo>
<DV:ownerSiteURL>http://ocr-d.de/</DV:ownerSiteURL>
<DV:ownerContact>mailto:ocrd@bbaw.de</DV:ownerContact>
</DV:rights>
</mets:xmlData>
</mets:mdWrap>
</mets:rightsMD>
<mets:digiprovMD ID="digiprovMD_0001">
<mets:mdWrap MIMETYPE="text/xml" MDTYPE="OTHER" OTHERMDTYPE="DVLINKS">
<mets:xmlData>
<DV:links>
<DV:reference/>
<DV:presentation>
<xsl:choose>
<xsl:when test="//idno[@type = 'URLWeb']">
<xsl:value-of select="//fileDesc/publicationStmt/idno/idno[@type = 'URLWeb']"/>
</xsl:when>
</xsl:choose>
</DV:presentation>
</DV:links>
</mets:xmlData>
</mets:mdWrap>
</mets:digiprovMD>
</mets:amdSec>
</xsl:template>
<xsl:template name="createId">
<xsl:param name="prefix"/>
<xsl:param name="node" select="."/>
<xsl:value-of select="concat($prefix, generate-id($node))"/>
</xsl:template>

<xsl:template name="cleanLabel">
<xsl:param name="str"/>
<xsl:variable name="labelString" select="string($str)"/>
<xsl:variable name="labelWithoutHyphen" select="replace($labelString, '-\s?&#xA;\s*', '')"/>
<xsl:variable name="labelClean" select="replace($labelWithoutHyphen, '&#xA;\s*', ' ')"/>
<xsl:value-of select="normalize-space($labelClean)"/>
</xsl:template>




</xsl:stylesheet>
