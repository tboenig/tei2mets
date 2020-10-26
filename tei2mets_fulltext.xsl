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
  xmlns:TEI="http://www.tei-c.org/ns/1.0" xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:DC="http://purl.org/dc/elements/1.1/" xmlns:mods="http://www.loc.gov/mods/v3"
  xmlns:mets="http://www.loc.gov/METS/" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:DV="http://dfg-viewer.de/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xs" version="2.0">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p>
        <xd:p>
          <xd:b>Created on:</xd:b> Apr 17, 2011 </xd:p>
        <xd:p>
          <xd:b>Author:</xd:b> cmahnke </xd:p>
      </xd:p>
      <xd:p/>
      <xd:p>
        <xd:p>
          <xd:b>Revised on:</xd:b> Juni 28, 2017 </xd:p>
        <xd:p>
          <xd:b>Author:</xd:b> tboenig </xd:p>
      </xd:p>
      <xd:p/>
    </xd:desc>
  </xd:doc>

  <xsl:output encoding="UTF-8" exclude-result-prefixes="#all" indent="yes"/>

  <xsl:param name="identifier">
    <xsl:choose>
      <xsl:when test="//TEI:fileDesc/TEI:publicationStmt/TEI:idno/TEI:idno[@type = 'DTADirName']">
        <xsl:value-of
          select="//TEI:fileDesc/TEI:publicationStmt/TEI:idno/TEI:idno[@type = 'DTADirName']"/>
      </xsl:when>
      <xsl:otherwise>DTADirName_nicht_vorhanden</xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <xsl:param name="locationPrefix">http://media.dwds.de/dta/images/</xsl:param>
  <xsl:param name="location_alto_Prefix"/>
  <xsl:param name="localPrefix">string('REPLACEME-LOCAL_PREFIX')</xsl:param>
  <xsl:param name="locationSuffix">.jpg</xsl:param>
  <xsl:param name="multipleHead" select="true()" as="xs:boolean"/>
  <xsl:variable name="physPrefix">phys</xsl:variable>
  <xsl:variable name="locPrefix">loc</xsl:variable>
  <xsl:variable name="filePrefix">file</xsl:variable>
  <xsl:variable name="useOrWidth">width</xsl:variable>
  <xsl:variable name="fileGroups">
    <group width="800" locationPrefix="" locationSuffix="">DEFAULT</group>
    <group width="400" locationPrefix="" locationSuffix="">MIN</group>
    <group width="160" locationPrefix="" locationSuffix="">THUMBS</group>
    <group width="1600" locationPrefix="" locationSuffix="">MAX</group>
    <group width="1600" locationPrefix="" locationSuffix="">DOWNLOAD</group>
  </xsl:variable>
  <xsl:variable name="alto">
    <group fileExt="xml" locationPrefix="" locationSuffix="">FULLTEXT</group>
  </xsl:variable>

  <xsl:template match="/">
    <mets:mets
      xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-3.xsd http://www.loc.gov/METS/ http://www.loc.gov/standards/mets/version17/mets.v1-7.xsd">
      <xsl:if test="$identifier = 'REPLACEME'">
        <xsl:comment>Replace the string 'REPLACEME' with the real dentifier using sed, if no param was given</xsl:comment>
      </xsl:if>
      <xsl:call-template name="metsHeader"/>
      <!-- the file section -->
      <mets:fileSec>
        <xsl:variable name="nodes" select="//TEI:pb"/>
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

        <xsl:for-each select="$alto/group">
          <xsl:call-template name="pbFileSect_alto">
            <xsl:with-param name="use">
              <xsl:value-of select="text()"/>
            </xsl:with-param>
            <xsl:with-param name="nodes" select="$nodes"/>
            <xsl:with-param name="prefix" select="@location_alto_Prefix"/>
            <!--<xsl:with-param name="suffix" select="@location_alto_Suffix"/>-->
            <xsl:with-param name="file" select="@fileExt"/>
          </xsl:call-template>
        </xsl:for-each>

      </mets:fileSec>
      <!-- The logical struct map -->
      <mets:structMap TYPE="LOGICAL">
        <xsl:choose>
          <xsl:when test="//TEI:fileDesc/TEI:titleStmt/TEI:title[@type = 'volume']">
            <mets:div TYPE="multivolume_work">
              <xsl:attribute name="ID">
                <xsl:value-of select="$locPrefix"/>
                <xsl:text>_</xsl:text>
                <xsl:number format="0001" value="1"/>
              </xsl:attribute>
              <xsl:choose>
                <xsl:when test="//TEI:fileDesc/TEI:titleStmt/TEI:title[@type = 'sub']">
                  <xsl:attribute name="LABEL"><xsl:value-of
                      select="//TEI:fileDesc/TEI:titleStmt/TEI:title[@type = 'main']"/>,
                      <xsl:value-of select="//TEI:fileDesc/TEI:titleStmt/TEI:title[@type = 'sub']"
                    /></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="LABEL">
                    <xsl:value-of select="//TEI:fileDesc/TEI:titleStmt/TEI:title[@type = 'main']"/>
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
                  <xsl:value-of select="//TEI:fileDesc/TEI:titleStmt/TEI:title[@type = 'volume']"/>
                </xsl:attribute>
                <xsl:apply-templates select="/TEI:TEI/TEI:text"/>
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
              <xsl:apply-templates select="/TEI:TEI/TEI:text"/>
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
        <xsl:for-each select="//TEI:head | //TEI:titlePage[@type = 'main']">
          <xsl:if test="not(preceding-sibling::TEI:head)">
            <xsl:variable name="childPbs" select="ancestor::TEI:div[1]/descendant::TEI:pb"/>
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
                    <xsl:number format="0001" value="count(preceding::TEI:pb)"/>
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
                      <xsl:number format="0001" value="count(preceding::TEI:pb)"/>
                    </xsl:attribute>
                  </mets:smLink>
                </xsl:for-each>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </xsl:for-each>
      </mets:structLink>
    </mets:mets>
  </xsl:template>

  <!-- Creates the physical struct map -->
  <xsl:template name="pbPhysMap">
    <xsl:for-each select="//TEI:pb">
      <mets:div TYPE="page">
        <xsl:variable name="pageNr">
          <xsl:number level="any" count="//TEI:pb"/>
        </xsl:variable>
        <xsl:variable name="pageId">
          <xsl:number format="0001" level="any" count="//TEI:pb"/>
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
              <xsl:value-of select="$filePrefix"/>
              <xsl:text>_</xsl:text>
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
        <mets:file MIMETYPE="image/jpeg">
          <xsl:attribute name="ID">
            <xsl:value-of select="$filePrefix"/>
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$use"/>
            <xsl:text>_</xsl:text>
            <xsl:number format="0001" level="any" count="//TEI:pb"/>
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
              <xsl:if test="$id = ''">
                <xsl:message terminate="yes">No identifier given!</xsl:message>
              </xsl:if>
              <xsl:value-of select="$id"/>

              <xsl:choose>
                <xsl:when test="$useOrWidth = 'use'">
                  <xsl:text>/</xsl:text>
                  <xsl:value-of select="$use"/>
                  <xsl:text>/</xsl:text>
                  <xsl:value-of select="$identifier"/>
                  <xsl:text>_</xsl:text>
                  <xsl:number format="0001" level="any" count="//TEI:pb"/>
                </xsl:when>

                <xsl:when test="$useOrWidth = 'width'">
                  <xsl:if test="$width = ''">
                    <xsl:message terminate="yes">No width given!</xsl:message>
                  </xsl:if>
                  <xsl:text>/</xsl:text>
                  <xsl:value-of select="$identifier"/>
                  <xsl:text>_</xsl:text>
                  <xsl:number format="0001" level="any" count="//TEI:pb"/>
                  <xsl:text>_</xsl:text>
                  <xsl:value-of select="$width"/>
                  <xsl:text>px</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:message terminate="yes">Wrong URL type, valid is 'use' and 'width'
                  </xsl:message>
                </xsl:otherwise>
              </xsl:choose>


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


  <xsl:template name="pbFileSect_alto">
    <xsl:param name="nodes"/>
    <xsl:param name="id" select="$identifier"/>
    <xsl:param name="use"/>
    <xsl:param name="prefix" select="$location_alto_Prefix"/>
    <xsl:param name="file"/>
    <mets:fileGrp>
      <xsl:attribute name="USE">
        <xsl:value-of select="$use"/>
      </xsl:attribute>
      <xsl:for-each select="$nodes">
        <mets:file MIMETYPE="text/xml">
          <xsl:attribute name="ID">
            <xsl:value-of select="$filePrefix"/>
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$use"/>
            <xsl:text>_</xsl:text>
            <xsl:number format="0001" level="any" count="//TEI:pb"/>
          </xsl:attribute>
          <mets:FLocat LOCTYPE="URL">
            <xsl:attribute name="xlink:href">
              <xsl:choose>
                <xsl:when test="$prefix = ''">
                  <xsl:value-of select="$prefix"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$location_alto_Prefix"/>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:if test="$id = ''">
                <xsl:message terminate="yes">No identifier given!</xsl:message>
              </xsl:if>
              <xsl:value-of select="$id"/>

              <xsl:choose>
                 <xsl:when test="$useOrWidth = 'width'">
                  <xsl:if test="$file = ''">
                    <xsl:message terminate="yes">No width given!</xsl:message>
                  </xsl:if>
                  <xsl:text>/</xsl:text>
                  <xsl:value-of select="$identifier"/>
                  <xsl:text>_</xsl:text>
                  <xsl:number format="0001" level="any" count="//TEI:pb"/>
                  <xsl:text>.</xsl:text>
                  <xsl:value-of select="$file"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:message terminate="yes">Wrong URL type, valid is 'use' and 'width'
                  </xsl:message>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
          </mets:FLocat>
        </mets:file>
      </xsl:for-each>
    </mets:fileGrp>
  </xsl:template>



  <xsl:template match="TEI:front">
    <mets:div>
      <xsl:apply-templates select="TEI:titlePage"/>
    </mets:div>
  </xsl:template>


  <xsl:template match="TEI:back">
    <mets:div>
      <xsl:apply-templates select="TEI:titlePage"/>
    </mets:div>
  </xsl:template>


  <xsl:template match="TEI:titlePage">
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

  <xsl:template match="TEI:div">
    <xsl:choose>
      <!-- Get rid of empty div tags -->
      <xsl:when test="TEI:head">
        <mets:div>
          <xsl:apply-templates select="TEI:div | TEI:head"/>
        </mets:div>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="TEI:div | TEI:head"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



  <xsl:template match="TEI:head">
    <xsl:variable name="text_head">
      <xsl:value-of select="text() | TEI:hi"/>
    </xsl:variable>
    <xsl:variable name="LabelType">
      <xsl:choose>
        <xsl:when test="parent::TEI:div/@type">
          <xsl:value-of select="parent::TEI:div/@type"/>
        </xsl:when>
        <xsl:otherwise>chapter</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!--<xsl:if test="parent::TEI:div/count(child::TEI:head) > 1">
<xsl:message>Div element contains more then one head, only using the first one!</xsl:message>-->
    <!--</xsl:if>-->
    <xsl:if test="parent::TEI:div/count(child::TEI:head) &gt;= 1">
      <xsl:attribute name="ID">
        <xsl:call-template name="createId">
          <xsl:with-param name="prefix">
            <xsl:value-of select="$locPrefix"/>
            <xsl:text>_</xsl:text>
          </xsl:with-param>
          <xsl:with-param name="node" select="."/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:if test="$multipleHead and following-sibling::TEI:head">
        <xsl:attribute name="DMDID">
          <xsl:call-template name="createId">
            <xsl:with-param name="prefix" select="'dmdSec_'"/>
            <xsl:with-param name="node" select="parent::TEI:div"/>
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
      <mets:mdWrap MDTYPE="MODS">
        <mets:xmlData>
          <mods:mods>

            <!--neu-->
            <mods:location>
              <mods:physicalLocation>
                <xsl:value-of select="//TEI:msIdentifier/TEI:repository"/>
              </mods:physicalLocation>
              <mods:shelfLocator>
                <xsl:value-of select="//TEI:idno/TEI:idno[@type = 'shelfmark']"/>
              </mods:shelfLocator>
              <mods:url>
                <xsl:value-of select="//TEI:idno/TEI:idno[@type = 'URLCatalogue']"/>
              </mods:url>
            </mods:location>
            <mods:originInfo>
              <mods:place>
                <mods:placeTerm type="text">
                  <xsl:value-of
                    select="//TEI:sourceDesc/TEI:biblFull/TEI:publicationStmt/TEI:pubPlace"/>
                </mods:placeTerm>
              </mods:place>
              <mods:dateIssued encoding="w3cdtf" keyDate="yes">
                <xsl:value-of select="//TEI:sourceDesc/TEI:biblFull/TEI:publicationStmt/TEI:date"/>
              </mods:dateIssued>
              <mods:publisher>
                <xsl:value-of
                  select="//TEI:sourceDesc/TEI:biblFull/TEI:publicationStmt/TEI:publisher"/>
              </mods:publisher>
            </mods:originInfo>
            <mods:originInfo>
              <mods:dateCaptured encoding="w3cdtf">
                <xsl:value-of select="//TEI:fileDesc/TEI:publicationStmt/TEI:date"/>
              </mods:dateCaptured>
              <mods:edition>[Electronic ed.]</mods:edition>
            </mods:originInfo>
            <mods:classification authority="DTA">
              <xsl:value-of select="//TEI:profileDesc/TEI:textClass/TEI:classCode[1]"/>
            </mods:classification>
            <mods:classification authority="DTA">
              <xsl:value-of select="//TEI:profileDesc/TEI:textClass/TEI:classCode[2]"/>
            </mods:classification>
            <xsl:choose>
              <xsl:when test="//TEI:fileDesc/TEI:publicationStmt/TEI:idno/TEI:idno[@type = 'urn']">
                <mods:identifier type="urn">
                  <xsl:value-of
                    select="//TEI:fileDesc/TEI:publicationStmt/TEI:idno/TEI:idno[@type = 'URN']"/>
                </mods:identifier>
              </xsl:when>
            </xsl:choose>
            <xsl:choose>
              <xsl:when test="//TEI:fileDesc/TEI:publicationStmt/TEI:idno/TEI:idno[@type = 'DTAID']">
                <mods:identifier type="dtaid">
                  <xsl:value-of
                    select="//TEI:fileDesc/TEI:publicationStmt/TEI:idno/TEI:idno[@type = 'DTAID']"/>
                </mods:identifier>
              </xsl:when>
            </xsl:choose>
            <mods:titleInfo>
              <mods:title>
                <xsl:value-of
                  select="TEI:TEI/TEI:teiHeader/TEI:fileDesc/TEI:titleStmt/TEI:title[@type = 'main']"
                />
              </mods:title>
              <mods:subTitle>
                <xsl:value-of
                  select="TEI:TEI/TEI:teiHeader/TEI:fileDesc/TEI:titleStmt/TEI:title[@type = 'sub']"
                />
              </mods:subTitle>
            </mods:titleInfo>
            <mods:part>
              <xsl:attribute name="order">
                <xsl:choose>
                  <xsl:when
                    test="TEI:TEI/TEI:teiHeader/TEI:fileDesc/TEI:titleStmt/TEI:title[@type = 'volume'][matches(@n, ',')]">
                    <xsl:analyze-string
                      select="TEI:TEI/TEI:teiHeader/TEI:fileDesc/TEI:titleStmt/TEI:title[@type = 'volume']/@n"
                      regex="(\d+),*(\d*)">
                      <xsl:matching-substring>
                        <xsl:value-of select="regex-group(2)"/>
                      </xsl:matching-substring>
                    </xsl:analyze-string>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of
                      select="TEI:TEI/TEI:teiHeader/TEI:fileDesc/TEI:titleStmt/TEI:title[@type = 'volume']/@n"
                    />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <mods:detail>
                <xsl:attribute name="type">volume</xsl:attribute>
                <mods:number>
                  <xsl:value-of
                    select="TEI:TEI/TEI:teiHeader/TEI:fileDesc/TEI:titleStmt/TEI:title[@type = 'volume']"
                  />
                </mods:number>
              </mods:detail>
            </mods:part>
            <mods:language>
              <mods:languageTerm authority="iso639-2b" type="code">
                <xsl:value-of select="//TEI:langUsage/TEI:language/@ident"/>
              </mods:languageTerm>
            </mods:language>
            <mods:relatedItem type="series">
              <mods:titleInfo>
                <mods:title>
                  <xsl:value-of
                    select="//TEI:fileDesc/TEI:titleStmt/TEI:respStmt[@corresp = '#availability-textsource-1']/orgName"
                  />
                </mods:title>
              </mods:titleInfo>
            </mods:relatedItem>
            <mods:name type="personal">
              <mods:role>
                <mods:roleTerm authority="marcrelator" type="code">aut</mods:roleTerm>
              </mods:role>
              <mods:namePart type="family">
                <xsl:value-of
                  select="//TEI:fileDesc/TEI:titleStmt/TEI:author/TEI:persName/TEI:surname"/>
              </mods:namePart>
              <mods:namePart type="given">
                <xsl:value-of
                  select="//TEI:fileDesc/TEI:titleStmt/TEI:author/TEI:persName/TEI:forename"/>
              </mods:namePart>
              <mods:displayForm>
                <xsl:value-of
                  select="//TEI:fileDesc/TEI:titleStmt/TEI:author/TEI:persName/TEI:forename"/>
                <xsl:text> </xsl:text>
                <xsl:value-of
                  select="//TEI:fileDesc/TEI:titleStmt/TEI:author/TEI:persName/TEI:surname"/>
              </mods:displayForm>
            </mods:name>
            <xsl:choose>
              <xsl:when
                test="//TEI:fileDesc/TEI:titleStmt/TEI:respStmt[@corresp = '#availability-textsource-1']">
                <xsl:for-each
                  select="//TEI:fileDesc/TEI:titleStmt/TEI:respStmt[@corresp = '#availability-textsource-1']/TEI:persName">
                  <mods:name type="personal">
                    <mods:role>
                      <mods:roleTerm authority="marcrelator" type="code">edt</mods:roleTerm>
                    </mods:role>
                    <mods:namePart type="family">
                      <xsl:value-of select="TEI:surname"/>
                    </mods:namePart>
                    <mods:namePart type="given">
                      <xsl:value-of select="TEI:forename"/>
                    </mods:namePart>
                  </mods:name>
                </xsl:for-each>
              </xsl:when>
            </xsl:choose>
            <mods:physicalDescription>
              <mods:extent>
                <xsl:value-of
                  select="//TEI:fileDesc/TEI:sourceDesc/TEI:biblFull/TEI:extent/TEI:measure"/>
              </mods:extent>
            </mods:physicalDescription>
            <mods:extension>
              <zvdd:zvddWrap xmlns:zvdd="http://zvdd.gdz-cms.de/">
                <zvdd:titleWord>
                  <xsl:value-of select="TEI:TEI/TEI:teiHeader/TEI:fileDesc/TEI:titleStmt/TEI:title"
                  />
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
      <xsl:for-each select="//TEI:div[count(child::TEI:head) > 1]">
        <mets:dmdSec>
          <xsl:attribute name="ID">
            <xsl:call-template name="createId">
              <xsl:with-param name="prefix" select="'dmdSec_'"/>
              <xsl:with-param name="node" select="."/>
            </xsl:call-template>
          </xsl:attribute>
          <mets:mdWrap MDTYPE="MODS">
            <mets:xmlData>
              <mods:mods>
                <xsl:for-each select="./TEI:head">
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
              <DV:owner>Berlin-Brandenburgische Akademie der Wissenschaften Deutsches
                Textarchiv</DV:owner>
              <DV:ownerLogo>http://www.deutschestextarchiv.de/static/images/dta.svg</DV:ownerLogo>
              <DV:ownerSiteURL>http://deutschestextarchiv.de</DV:ownerSiteURL>
              <DV:ownerContact>mailto:redaktion@deutschestextarchiv.de</DV:ownerContact>
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
                  <xsl:when test="//TEI:idno[@type = 'URLWeb']">
                    <xsl:value-of
                      select="//TEI:fileDesc/TEI:publicationStmt/TEI:idno/TEI:idno[@type = 'URLWeb']"
                    />
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
