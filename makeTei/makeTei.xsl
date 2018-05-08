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

<xsl:param name="baseURL"/>




<xsl:template match="matthias">
<TEI xmlns="http://www.tei-c.org/ns/1.0">
<xsl:copy-of select="document($baseURL)//teiHeader"/>
<body>
<xsl:for-each select="collection('file:///C:/Users/matth/Documents/GitHub/tei2mets/gt_sample/tif/?select=*.tif')" >
<xsl:element name='file'>
<xsl:value-of select="document-uri(.), '/'[last()]"/>
</xsl:element>
</xsl:for-each>

</body>
</TEI>
</xsl:template>


</xsl:stylesheet>