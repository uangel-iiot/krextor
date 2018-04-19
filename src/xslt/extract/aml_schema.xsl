<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE stylesheet  [
<!ENTITY dc "http://purl.org/dc/elements/1.1/">
<!ENTITY owl "http://www.w3.org/2002/07/owl#">
<!ENTITY rdf "http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<!ENTITY rdfs "http://www.w3.org/2000/01/rdf-schema#">
<!ENTITY xsd "http://www.w3.org/2001/XMLSchema#">
<!ENTITY aml "http://iiot.skt.com/aml/">
<!ENTITY schema "http://schema.org/">
]>




<xsl:transform version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:vi="http://www.openlinksw.com/virtuoso/xslt/"
	xmlns:rdf="&rdf;"
	xmlns:rdfs="&rdfs;"
	xmlns:schema="&schema;"
	xmlns:dc="&dc;"
	xmlns:owl="&owl;"
	xmlns:aml="&aml;"
	xmlns:xd="http://www.pnp-software.com/XSLTdoc"
	xmlns:krextor="http://kwarc.info/projects/krextor"
	xmlns:krextor-genuri="http://kwarc.info/projects/krextor/genuri"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	exclude-result-prefixes="">
	<xsl:output method="xml" indent="yes" encoding="utf-8" />
	<xsl:param name="base" select="'http://iiot.skt.com/aml/'"/>
                      
<!--  CAEXFile -->

<!--<xsl:param name="autogenerate-fragment-uris" select="'generate-id'"/>-->

 <xsl:template match="/" mode="krextor:main">
      <xsl:apply-imports>
        <xsl:with-param
          name="krextor:base-uri"
          select="xs:anyURI(concat('http://iiot.skt.com/aml/', CAEXFile/@FileName, '/'))"
          as="xs:anyURI"
          tunnel="yes"/>
      </xsl:apply-imports>
 </xsl:template>

<xd:doc>uses ElementN as the fragment URI of the N-th occurrence of an element named
	<code>Element</code> in document order, starting from N=1.
</xd:doc>

<xsl:function name="krextor:global-element-index" as="xs:string?">
	<xsl:param name="node" as="node()"/>

	<xsl:choose>
		<xsl:when test="string-length($node/@Name) > 0">
			
			<xsl:choose>
				<xsl:when test="contains($node/RefSemantic/@CorrespondingAttributePath, 'aml-dataSourceType:') and $node/Attribute/@Name='RefDataSource'">

					<xsl:value-of select="concat('DataVariable', count(root($node)//*[local-name() eq local-name($node) and . &lt;&lt; $node]) + 1, '-', fn:encode-for-uri($node/@Name))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat(local-name($node), count(root($node)//*[local-name() eq local-name($node) and . &lt;&lt; $node]) + 1, '-', fn:encode-for-uri($node/@Name))"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--<xsl:value-of select="concat(local-name($node), count(root($node)//*[local-name() eq local-name($node) and . &lt;&lt; $node]) + 1, '/', fn:encode-for-uri($node/@Name))"/>-->
		</xsl:when>
		<xsl:when test="string-length($node/@FileName) > 0">
			<xsl:value-of select="concat(local-name($node), count(root($node)//*[local-name() eq local-name($node) and . &lt;&lt; $node]) + 1, '-', fn:encode-for-uri($node/@FileName))"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="concat(local-name($node), count(root($node)//*[local-name() eq local-name($node) and . &lt;&lt; $node]) + 1)"/>
		</xsl:otherwise>
	</xsl:choose>

</xsl:function>

<!-- copied and adapted from generic/uri.xsl -->
<xsl:template match="krextor-genuri:global-element-index" as="xs:string?">
	<xsl:param name="node" as="node()"/>
	<xsl:param name="base-uri" as="xs:anyURI"/>
	<xsl:sequence select="resolve-uri(krextor:global-element-index($node), $base-uri)"/>
</xsl:template>
    
<xsl:param name="autogenerate-fragment-uris" select="'global-element-index'" />
<!-- <xsl:param name="autogenerate-fragment-uris" select="'pseudo-xpath'" /> -->

<xsl:variable name="krextor:resources">
	<InterfaceClass type="&aml;InterfaceClass"/>
	<SystemUnitClass type="&aml;SystemUnitClass"/>
	<RoleClass type="&aml;RoleClass"/>
</xsl:variable>

<xsl:template match="InterfaceClass[@RefBaseClassPath]
					|RoleClass[@RefBaseClassPath]
					|SystemUnitClass[@RefBaseClassPath]" mode="krextor:main">
	   <xsl:apply-templates select="." mode="krextor:create-resource"/>
</xsl:template>


<xsl:variable name="krextor:literal-properties"> 
<!-- Attribute  -->
		<AttributeDataType property="&aml;hasDataType" krextor:attribute="yes" datatype="&xsd;string"/>
		<Description property="&aml;hasDescription" krextor:attribute="yes" datatype="&xsd;string"/>
<!-- SupportedRoleClass -->
		<RefRoleClassPath property="&aml;refRoleClassPath" krextor:attribute="yes" datatype="&xsd;string"/>
<!-- RoleRequirements -->
		<RefBaseRoleClassPath property="&aml;refBaseRoleClassPath" krextor:attribute="yes" datatype="&xsd;string"/>
<!-- InterfaceClassLib -->
<!-- <InterfaceClass property="&aml;hasInterfaceClass" object-is-list="true" /> -->

<!-- the following mapping rules will be simplified in the second example, this version can be treated as standard test case -->
</xsl:variable>
<xsl:template match="CAEXFile/SystemUnitClassLib//SystemUnitClass/InternalElement/@ID
	                  |CAEXFile/SystemUnitClassLib//SystemUnitClass/InternalElement/@RefBaseSystemUnitPath
	                  |CAEXFile/SystemUnitClassLib//SystemUnitClass/InternalElement/SupportedRoleClass/@RefRoleClassPath
	                  |CAEXFile/SystemUnitClassLib//SystemUnitClass/InternalElement/RoleRequirements/@RefBaseRoleClassPath
	                  |CAEXFile/SystemUnitClassLib//SystemUnitClass/SupportedRoleClass/@RefRoleClassPath" 
	                  mode="krextor:main">
 <xsl:apply-templates select="." mode="krextor:add-literal-property"/>
</xsl:template>

<!--SystemUnitClass의 RefBaseClassPath인 경우-->
<xsl:template match="//SystemUnitClass/@RefBaseClassPath 
                        | //ExternalInterface/@RefBaseClassPath 
                        | //InterfaceClass/@RefBaseClassPath 
                        | //RoleClass/@RefBaseClassPath" mode="krextor:main">

	<xsl:variable name="path">
		<xsl:value-of select="."/>
	</xsl:variable>
	
	<xsl:variable name="class-iri">
		<xsl:choose>
			<xsl:when test="contains($path, '/')">
				<xsl:call-template name="krextor:get-iri-from-path">
					<xsl:with-param name="path" select="$path"/>
					<xsl:with-param name="delim" select="'/'"/>
					<xsl:with-param name="node" select="/CAEXFile"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($path, '}')">
				<xsl:for-each select="/CAEXFile/InstanceHierarchy//InternalElement[@ID=substring-before(substring-after($path, '{'), '}')]">
					<xsl:value-of select="resolve-uri(krextor:global-element-index(.), concat('http://iiot.skt.com/aml/', /CAEXFile/@FileName, '/'))"/>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="resolve-uri(krextor:global-element-index(../..), concat('http://iiot.skt.com/aml/', /CAEXFile/@FileName, '/'))"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:call-template name="krextor:add-uri-property">
		<xsl:with-param name="property" select="'&rdfs;subClassOf'"/>
		<xsl:with-param name="object" select="$class-iri"/>
	</xsl:call-template>

</xsl:template>


<!--재귀적으로 path에 delimeter가 포함되지 않을때까지 분리하여 iiot:make-signature, iiot:make-iri를 호출-->
<xsl:template name="krextor:get-iri-from-path">
	<xsl:param name="path"/>
	<xsl:param name="delim" select="'/'"/>
	<xsl:param name="node"/>

	<xsl:choose>
		<xsl:when test="contains($path, $delim)">
			<xsl:call-template name="krextor:get-iri-from-path">
				<!--delimeter로 문자열을 분리하여 뒤의 결과를 취함-->
				<xsl:with-param name="node" select="$node/*[@Name = substring-before($path, $delim)]"/>
				<xsl:with-param name="path" select="substring-after($path, $delim)"/>
				<xsl:with-param name="delim" select="$delim"/>
			</xsl:call-template>
		</xsl:when>
		<!--얻은 정보로 node-signature를 만들고 node-signature로 iri 생성-->
		<xsl:otherwise>
			<xsl:for-each select="$node/*[@Name=$path]">
				<xsl:value-of select="resolve-uri(krextor:global-element-index(.), concat('http://iiot.skt.com/aml/', /CAEXFile/@FileName, '/'))"/>
			</xsl:for-each>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:transform>