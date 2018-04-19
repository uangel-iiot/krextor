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

 <!--자식 정보를 추가-->
<xsl:variable name="krextor:resources">
	<CAEXFile type="&aml;CAEXFile"/>
	<AdditionalInformation type="&aml;AdditionalInformation" related-via-properties="&aml;hasAdditionalInfomation" related-via-inverse-properties="&aml;isAdditionalInformationOf"/>
	
	<ExternalReference type="&aml;ExternalReference" related-via-properties="&aml;hasExternalReference" related-via-inverse-properties="&aml;isExternalReferenceOf"/>
	
	<InstanceHierarchy type="&aml;InstanceHierarchy" related-via-properties="&aml;hasInstanceHierarchy" related-via-inverse-properties="&aml;isInstanceHierarchyOf"/>
	
	<InterfaceClassLib type="&aml;InterfaceClassLib" related-via-properties="&aml;hasInterfaceClassLib" related-via-inverse-properties="&aml;isInterfaceClassLibOf"/>
	
	<RoleClassLib type="&aml;RoleClassLib" related-via-properties="&aml;hasRoleClassLib" related-via-inverse-properties="&aml;isRoleClassLibOf"/>
	
	<SystemUnitClassLib type="&aml;SystemUnitClassLib" related-via-properties="&aml;hasSystemUnitClassLib" related-via-inverse-properties="&aml;isSystemUnitClassLibOf"/>
	
	<InternalElement type="&aml;InternalElement" related-via-properties="&aml;hasInternalElement" related-via-inverse-properties="&aml;isInternalElementOf"/>
	<Attribute type="&aml;Attribute" related-via-properties="&aml;hasAttribute" related-via-inverse-properties="&aml;isAttributeOf"/>
	<RefSemantic type="&aml;RefSemantic" related-via-properties="&aml;hasRefSemantic" related-via-inverse-properties="&aml;isRefSemanticOf"/>
	<ExternalInterface type="&aml;ExternalInterface" related-via-properties="&aml;hasExternalInterface" related-via-inverse-properties="&aml;isExternalInterfaceOf"/>
	<SupportedRoleClass type="&aml;SupportedRoleClass" related-via-properties="&aml;hasSupportedRoleClass" related-via-inverse-properties="&aml;isSupportedRoleClassOf"/>
	<RoleRequirements type="&aml;RoleRequirements" related-via-properties="&aml;hasRoleRequirements" related-via-inverse-properties="&aml;isRoleRequirementsOf"/> 
	<InterfaceClass type="&aml;InterfaceClass" related-via-properties="&aml;hasInterfaceClass" related-via-inverse-properties="&aml;isInterfaceClassOf"/>
	<SystemUnitClass type="&aml;SystemUnitClass" related-via-properties="&aml;hasSystemUnitClass" related-via-inverse-properties="&aml;isSystemUnitClassOf"/>
	<InternalLink type="&aml;InternalLink" related-via-properties="&aml;hasInternalLink" related-via-inverse-properties="&aml;isInternalLinkOf"/>
	<RoleClass type="&aml;RoleClass" related-via-properties="&aml;hasRoleClass" related-via-inverse-properties="&aml;isRoleClassOf"/>
</xsl:variable>

<!--
<xsl:template match="CAEXFile
					|CAEXFile/AdditionalInformation
					|CAEXFile/ExternalReference
					|CAEXFile/InstanceHierarchy
					|CAEXFile/RoleClassLib
					|CAEXFile/SystemUnitClassLib
					|Attribute
					|RefSemantic
					|ExternalInterface
					|SupportedRoleClass
					|RoleRequirements
					|InterfaceClassLib
					|InterfaceClass
					|RoleClass
					|InternalElement
					|SystemUnitClass" mode="krextor:main">
	   <xsl:apply-templates select="." mode="krextor:create-resource"/>
</xsl:template>
-->

<xsl:template match="CAEXFile
					|AdditionalInformation
					|ExternalReference
					|InstanceHierarchy
					|RoleClassLib
					|SystemUnitClassLib
					|Attribute
					|RefSemantic
					|ExternalInterface
					|SupportedRoleClass
					|RoleRequirements
					|InterfaceClassLib
					|InterfaceClass
					|RoleClass
					|InternalElement
					|SystemUnitClass
					|InternalLink" mode="krextor:main">
	<xsl:apply-templates select="." mode="krextor:create-resource"/>
</xsl:template>

<xsl:variable name="krextor:literal-properties">
	    <FileName property="&aml;name" krextor:attribute="yes" datatype="&xsd;string"/>
	    <!--<SchemaVersion property="&aml;hasSchemaVersion" krextor:attribute="yes"/>-->
	    <SchemaVersion property="&aml;schemaVersion" datatype="&xsd;string" krextor:attribute="yes"/>
<!-- AdditionalInformation -->
	    <WriterName property="&aml;hasWriterName"/>
	    <WriterID property="&aml;hasWriterID" datatype="&xsd;string" />
	    <WriterVendor property="&aml;hasWriterVendor" datatype="&xsd;string" />
	    <WriterVendorURL property="&aml;hasWriterVendorURL" datatype="&xsd;string" />
	    <WriterVersion property="&aml;hasWriterVersion" datatype="&xsd;string" />
	    <WriterRelease property="&aml;hasWriterRelease" datatype="&xsd;string" />
	    <LastWritingDateTime property="&aml;hasLastWritingDateTime" datatype="&xsd;dateTime" />
	    <WriterProjectTitle property="&aml;hasWriterProjectTitle" datatype="&xsd;string" />
	    <WriterProjectID property="&aml;hasWriterProjectID" datatype="&xsd;string" />
<!-- ExternalReference -->
	    <Path property="&aml;refBaseClassPath" krextor:attribute="yes" datatype="&xsd;string"/>
	    <Alias property="&aml;externalReferenceAlias" krextor:attribute="yes" datatype="&xsd;string"/>	
<!-- InstanceHierarchy  -->
<!--		<Name property="&schema;name" krextor:attribute="yes" datatype="&xsd;string"/>-->
		
<!-- Attribute  -->
		<AttributeDataType property="&aml;hasDataType" krextor:attribute="yes" datatype="&xsd;string"/>
		<Description property="&aml;hasDescription" krextor:attribute="yes" datatype="&xsd;string"/>
		<Unit property="&aml;unit" krextor:attribute="yes" datatype="&xsd;string"/>
		<Value property="&aml;Value" krextor:attribute="yes" datatype="&xsd;string"/>
		<Name property="&aml;name" krextor:attribute="yes" datatype="&xsd;string"/>

<!-- InternalElement -->
		<ID property="&dc;identifier" krextor:attribute="yes" datatype="&xsd;string"/>
		<RefBaseSystemUnitPath property="&aml;RefBaseSystemUnitPath" krextor:attribute="yes" datatype="&xsd;string"/>
<!-- ExternalInterface -->
		<RefBaseClassPath property="&aml;refBaseClassPath" krextor:attribute="yes" datatype="&xsd;string"/>
<!-- SupportedRoleClass -->
		<RefRoleClassPath property="&aml;refRoleClassPath" krextor:attribute="yes" datatype="&xsd;string"/>
<!-- RoleRequirements -->
		<RefBaseRoleClassPath property="&aml;refBaseRoleClassPath" krextor:attribute="yes" datatype="&xsd;string"/>
<!-- InterfaceClassLib -->
		<Version property="&aml;hasVersion" datatype="&xsd;string" />
<!-- <InterfaceClass property="&aml;hasInterfaceClass" object-is-list="true" /> -->

<!-- the following mapping rules will be simplified in the second example, this version can be treated as standard test case -->
</xsl:variable>
<!--
<xsl:template match="CAEXFile/@FileName
                      |CAEXFile/@SchemaVersion
                      |CAEXFile/AdditionalInformation/WriterHeader/WriterName
	                  |CAEXFile/AdditionalInformation/WriterHeader/WriterID
                      |CAEXFile/AdditionalInformation/WriterHeader/WriterVendor
	                  |CAEXFile/AdditionalInformation/WriterHeader/WriterVendorURL
	                  |CAEXFile/AdditionalInformation/WriterHeader/WriterVersion
	                  |CAEXFile/AdditionalInformation/WriterHeader/WriterRelease
	                  |CAEXFile/AdditionalInformation/WriterHeader/LastWritingDateTime
	                  |CAEXFile/AdditionalInformation/WriterHeader/WriterProjectTitle
	                  |CAEXFile/AdditionalInformation/WriterHeader/WriterProjectID
	                  |CAEXFile/ExternalReference/@Path
	                  |CAEXFile/ExternalReference/@Alias
	                  |CAEXFile/InstanceHierarchy/@Name
	                  |CAEXFile/InstanceHierarchy//InternalElement/@Name
	                  |CAEXFile/InstanceHierarchy//InternalElement/@ID
	                  |CAEXFile/InstanceHierarchy//InternalElement/@RefBaseSystemUnitPath
	                  |CAEXFile/InstanceHierarchy//InternalElement/Attribute/@Name
	                  |CAEXFile/InstanceHierarchy//InternalElement/ExternalInterface/@Name
	                  |CAEXFile/InstanceHierarchy//InternalElement/ExternalInterface/Attribute/@Name
	                  |CAEXFile/InstanceHierarchy//InternalElement/ExternalInterface/@ID
	                  |CAEXFile/InstanceHierarchy//InternalElement/ExternalInterface/@RefBaseClassPath
	                  |CAEXFile/InstanceHierarchy//InternalElement/SupportedRoleClass/@RefRoleClassPath
	                  |CAEXFile/InstanceHierarchy//InternalElement/RoleRequirements/@RefBaseRoleClassPath
	                  |CAEXFile/InterfaceClassLib/@Name
	                  |CAEXFile/InterfaceClassLib//InterfaceClass/@Name
	                  |CAEXFile/InterfaceClassLib//InterfaceClass/@RefBaseClassPath
	                  |CAEXFile/InterfaceClassLib//InterfaceClass/Attribute/@Name
	                  |CAEXFile/InterfaceClassLib//InterfaceClass/Attribute/Value 
	                  |CAEXFile/RoleClassLib/@Name
	                  |CAEXFile/RoleClassLib/Version
	                  |CAEXFile/RoleClassLib//RoleClass/@Name
		          |CAEXFile/RoleClassLib//RoleClass/Attribute/@Name
			  |CAEXFile/RoleClassLib//RoleClass/Attribute/Value
	                  |CAEXFile/RoleClassLib//RoleClass/@RefBaseClassPath
	                  |CAEXFile/RoleClassLib//RoleClass/ExternalInterface/@Name
	                  |CAEXFile/RoleClassLib//RoleClass/ExternalInterface/Attribute/@Name
	                  |CAEXFile/RoleClassLib//RoleClass/ExternalInterface/@ID
	                  |CAEXFile/RoleClassLib//RoleClass/ExternalInterface/@RefBaseClassPath
	                  |CAEXFile/SystemUnitClassLib/@Name
	                  |CAEXFile/SystemUnitClassLib/Version
	                  |CAEXFile/SystemUnitClassLib//SystemUnitClass/InternalElement/@Name
	                  |CAEXFile/SystemUnitClassLib//SystemUnitClass/InternalElement/@ID
	                  |CAEXFile/SystemUnitClassLib//SystemUnitClass/InternalElement/@RefBaseSystemUnitPath
	                  |CAEXFile/SystemUnitClassLib//SystemUnitClass/InternalElement/Attribute/@Name
	                  |CAEXFile/SystemUnitClassLib//SystemUnitClass/InternalElement/ExternalInterface/@Name
	                  |CAEXFile/SystemUnitClassLib//SystemUnitClass/InternalElement/ExternalInterface/@ID
	                  |CAEXFile/SystemUnitClassLib//SystemUnitClass/InternalElement/ExternalInterface/@RefBaseClassPath
	                  |CAEXFile/SystemUnitClassLib//SystemUnitClass/InternalElement/SupportedRoleClass/@RefRoleClassPath
	                  |CAEXFile/SystemUnitClassLib//SystemUnitClass/InternalElement/RoleRequirements/@RefBaseRoleClassPath
	                  |CAEXFile/SystemUnitClassLib//SystemUnitClass/@Name
			  |CAEXFile/SystemUnitClassLib//SystemUnitClass/Attribute/@Name
			  |CAEXFile/SystemUnitClassLib//SystemUnitClass/Attribute/Value
	                  |CAEXFile/SystemUnitClassLib//SystemUnitClass/ExternalInterface/@Name
	                  |CAEXFile/SystemUnitClassLib//SystemUnitClass/ExternalInterface/@ID
	                  |CAEXFile/SystemUnitClassLib//SystemUnitClass/ExternalInterface/@RefBaseClassPath
	                  |CAEXFile/SystemUnitClassLib//SystemUnitClass/SupportedRoleClass/@RefRoleClassPath" 
	                  mode="krextor:main">
 <xsl:apply-templates select="." mode="krextor:add-literal-property"/>
</xsl:template>
-->

<xsl:template match="CAEXFile/@SchemaVersion
                      |CAEXFile/AdditionalInformation/WriterHeader/WriterName
	                  |CAEXFile/AdditionalInformation/WriterHeader/WriterID
                      |CAEXFile/AdditionalInformation/WriterHeader/WriterVendor
	                  |CAEXFile/AdditionalInformation/WriterHeader/WriterVendorURL
	                  |CAEXFile/AdditionalInformation/WriterHeader/WriterVersion
	                  |CAEXFile/AdditionalInformation/WriterHeader/WriterRelease
	                  |CAEXFile/AdditionalInformation/WriterHeader/LastWritingDateTime
	                  |CAEXFile/AdditionalInformation/WriterHeader/WriterProjectTitle
	                  |CAEXFile/AdditionalInformation/WriterHeader/WriterProjectID
	                  |CAEXFile/ExternalReference/@Path
	                  |CAEXFile/ExternalReference/@Alias
	                  |CAEXFile/InstanceHierarchy//InternalElement/@ID
	                  |CAEXFile/InstanceHierarchy//InternalElement/ExternalInterface/@ID
	                  |CAEXFile/RoleClassLib/Version
	                  |CAEXFile/RoleClassLib//RoleClass/ExternalInterface/@ID
	                  |CAEXFile/SystemUnitClassLib/Version
	                  |CAEXFile/SystemUnitClassLib//SystemUnitClass/InternalElement/@ID
	                  |CAEXFile/SystemUnitClassLib//SystemUnitClass/InternalElement/ExternalInterface/@ID
	                  |CAEXFile/SystemUnitClassLib//SystemUnitClass/ExternalInterface/@ID" 
	                  mode="krextor:main">
 	<xsl:apply-templates select="." mode="krextor:add-literal-property"/>
</xsl:template>

<xsl:template match="CAEXFile/AdditionalInformation/@AutomationMLVersion" mode="krextor:main">
  <xsl:call-template name="krextor:add-literal-property">
    <xsl:with-param name="property" select="'&aml;hasAutomationMLVersion'"/>
    <xsl:with-param name="datatype " select="'&xsd;string'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="//RefSemantic/@CorrespondingAttributePath" mode="krextor:main">
  <xsl:call-template name="krextor:add-literal-property">
    <xsl:with-param name="property" select="'&aml;hasCorrespondingAttributePath'"/>
    <xsl:with-param name="datatype" select="'&xsd;string'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="//Attribute/@Unit" mode="krextor:main">
  <xsl:call-template name="krextor:add-literal-property">
    <xsl:with-param name="property" select="'&aml;unit'"/>
    <xsl:with-param name="datatype" select="'&xsd;string'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="//*/@FileName | //*/@Name" mode="krextor:main">
	<xsl:call-template name="krextor:add-literal-property">
		<xsl:with-param name="property" select="'&rdfs;label'"/>
	</xsl:call-template>

	<xsl:call-template name="krextor:add-literal-property">
		<xsl:with-param name="property" select="'&aml;name'"/>
		<xsl:with-param name="datatype" select="'&xsd;string'"/>
	</xsl:call-template>

	<xsl:call-template name="krextor:add-uri-property">
		<xsl:with-param name="property" select="'&aml;root'"/>
		<xsl:with-param name="object" select="resolve-uri(krextor:global-element-index(/CAEXFile), concat('http://iiot.skt.com/aml/', /CAEXFile/@FileName, '/'))"/>
	</xsl:call-template>

	<xsl:if test="../RefSemantic/@CorrespondingAttributePath eq 'aml-dataSourceType:OPCUA'">
		<xsl:variable name="iriOfLastInternalElement">
			<xsl:call-template name="krextor:find-last-internal-element-iri">
				<xsl:with-param name="node" select="."/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:call-template name="krextor:add-uri-property">
			<xsl:with-param name="property" select="'&aml;isDataVariableOf'"/>
			<xsl:with-param name="object" select="$iriOfLastInternalElement"/>
		</xsl:call-template>
	</xsl:if>
</xsl:template>

<!--받은 node의 상위 InternalElement 중에 가장 가까운 InternalElement를 찾아 반환-->
<xsl:template name="krextor:find-last-internal-element-iri">
	<xsl:param name="node"/>
	<xsl:choose>
		<xsl:when test="local-name($node) ne 'InternalElement' and local-name($node) ne 'SystemUnitClass'">
			<xsl:call-template name="krextor:find-last-internal-element-iri">
				<xsl:with-param name="node" select="$node/.."/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="resolve-uri(krextor:global-element-index($node), concat('http://iiot.skt.com/aml/', /CAEXFile/@FileName, '/'))"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="//Attribute/Value" mode="krextor:main">
	<xsl:choose>
		<xsl:when test="../@Name='RefDataSource'">
			<xsl:variable name="refId">
				<xsl:value-of select="."/>
			</xsl:variable>
			<xsl:variable name="dataSource-iri">
				<xsl:for-each select="/CAEXFile/InstanceHierarchy//*[@ID = $refId] | /CAEXFile/SystemUnitClassLib//*[@ID = $refId]">
					<xsl:value-of select="resolve-uri(krextor:global-element-index(.), concat('http://iiot.skt.com/aml/', /CAEXFile/@FileName, '/'))"/>
				</xsl:for-each>
			</xsl:variable>
			<xsl:call-template name="krextor:add-uri-property">
				<xsl:with-param name="property" select="'&aml;Value'"/>
				<xsl:with-param name="object" select="$dataSource-iri"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="krextor:add-literal-property">
				<xsl:with-param name="property" select="'&aml;Value'"/>
				<xsl:with-param name="datatype" select="'&xsd;string'"/>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!--RefBaseSystemUnitPath인 경우-->
<xsl:template match="//InternalElement/@RefBaseSystemUnitPath" mode="krextor:main">
	
	<xsl:call-template name="krextor:add-literal-property">
		<xsl:with-param name="property" select="'&aml;refBaseSystemUnitPath'"/>
		<xsl:with-param name="datatype" select="'&xsd;string'"/>
	</xsl:call-template>

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
		<xsl:with-param name="property" select="'&rdf;type'"/>
		<xsl:with-param name="object" select="$class-iri"/>
	</xsl:call-template>

	<xsl:call-template name="krextor:add-uri-property">
		<xsl:with-param name="property" select="'&aml;refBaseSystemUnitClass'"/>
		<xsl:with-param name="object" select="$class-iri"/>
	</xsl:call-template>

</xsl:template>

<!--SystemUnitClass의 RefBaseClassPath인 경우-->
<xsl:template match="//SystemUnitClass/@RefBaseClassPath | //ExternalInterface/@RefBaseClassPath | //InterfaceClass/@RefBaseClassPath | //RoleClass/@RefBaseClassPath" mode="krextor:main">

	<xsl:call-template name="krextor:add-literal-property">
		<xsl:with-param name="property" select="'&aml;refBaseClassPath'"/>
		<xsl:with-param name="datatype" select="'&xsd;string'"/>
	</xsl:call-template>

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
		<xsl:with-param name="property" select="'&rdf;type'"/>
		<xsl:with-param name="object" select="$class-iri"/>
	</xsl:call-template>

	<xsl:call-template name="krextor:add-uri-property">
		<xsl:with-param name="property" select="'&aml;refBaseClass'"/>
		<xsl:with-param name="object" select="$class-iri"/>
	</xsl:call-template>

</xsl:template>

<!--
RefBaseRoleClassPath - RoleRequirements
RefRoleClassPath - SupportedRoleClassPath
RefBaseClassPath - RoleClass
-->
<xsl:template match="//RoleRequirements/@RefBaseRoleClassPath" mode="krextor:main">

	<xsl:call-template name="krextor:add-literal-property">
	<xsl:with-param name="property" select="'&aml;refBaseRoleClassPath'"/>
	<xsl:with-param name="datatype" select="'&xsd;string'"/>
	</xsl:call-template>

	<xsl:call-template name="krextor:add-uri-property">
		<xsl:with-param name="property" select="'&aml;root'"/>
		<xsl:with-param name="object" select="resolve-uri(krextor:global-element-index(/CAEXFile), concat('http://iiot.skt.com/aml/', /CAEXFile/@FileName, '/'))"/>
	</xsl:call-template>

	<xsl:variable name="path">
		<xsl:value-of select="."/>
	</xsl:variable>

	<xsl:call-template name="krextor:add-literal-property">
		<xsl:with-param name="property" select="'&rdfs;label'"/>
		<xsl:with-param name="object" select="$path"/>
	</xsl:call-template>
	
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
		<xsl:with-param name="property" select="'&rdf;type'"/>
		<xsl:with-param name="object" select="$class-iri"/>
	</xsl:call-template>

		<xsl:call-template name="krextor:add-uri-property">
		<xsl:with-param name="property" select="'&aml;refBaseRoleClass'"/>
		<xsl:with-param name="object" select="$class-iri"/>
	</xsl:call-template>

</xsl:template>

<xsl:template match="//SupportedRoleClass/@RefRoleClassPath" mode="krextor:main">

	<xsl:call-template name="krextor:add-literal-property">
		<xsl:with-param name="property" select="'&aml;refRoleClassPath'"/>
		<xsl:with-param name="datatype" select="'&xsd;string'"/>
	</xsl:call-template>

	<xsl:call-template name="krextor:add-uri-property">
		<xsl:with-param name="property" select="'&aml;root'"/>
		<xsl:with-param name="object" select="resolve-uri(krextor:global-element-index(/CAEXFile), concat('http://iiot.skt.com/aml/', /CAEXFile/@FileName, '/'))"/>
	</xsl:call-template>

	<xsl:variable name="path">
		<xsl:value-of select="."/>
	</xsl:variable>

	<xsl:call-template name="krextor:add-literal-property">
		<xsl:with-param name="property" select="'&rdfs;label'"/>
		<xsl:with-param name="object" select="$path"/>
	</xsl:call-template>
	
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
		<xsl:with-param name="property" select="'&rdf;type'"/>
		<xsl:with-param name="object" select="$class-iri"/>
	</xsl:call-template>

	<xsl:call-template name="krextor:add-uri-property">
		<xsl:with-param name="property" select="'&aml;refBaseRoleClass'"/>
		<!--<xsl:with-param name="property" select="'&aml;refRoleClass'"/>-->
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

<!--RefSideA-->
<xsl:template match="//InternalElement/InternalLink/@RefPartnerSideA" mode="krextor:main">
	<xsl:call-template name="krextor:add-literal-property">
		<xsl:with-param name="property" select="'&aml;refPartnerSideA'"/>
		<xsl:with-param name="datatype" select="'&xsd;string'"/>
	</xsl:call-template>

	<xsl:variable name="refSide">
		<xsl:value-of select="."/>
	</xsl:variable>

	<xsl:for-each select="/CAEXFile/InstanceHierarchy//InternalElement[@ID = substring-before(substring-after($refSide, '{'), '}')]">
		<xsl:variable name="ie-iri">
			<xsl:value-of select="resolve-uri(krextor:global-element-index(.), concat('http://iiot.skt.com/aml/', /CAEXFile/@FileName, '/'))"/>
		</xsl:variable>
		<xsl:call-template name="krextor:add-uri-property">
			<xsl:with-param name="property" select="'&aml;refPartnerSideAIE'"/>
			<xsl:with-param name="object" select="$ie-iri"/>
		</xsl:call-template>

		<xsl:variable name="if-iri">
			<xsl:value-of select="resolve-uri(krextor:global-element-index(./ExternalInterface[@Name = substring-after($refSide, ':')]), concat('http://iiot.skt.com/aml/', /CAEXFile/@FileName, '/'))"/>
		</xsl:variable>
		<xsl:call-template name="krextor:add-uri-property">
			<xsl:with-param name="property" select="'&aml;refPartnerSideAIF'"/>
			<xsl:with-param name="object" select="$if-iri"/>
		</xsl:call-template>
	</xsl:for-each>

</xsl:template>

<!--RefSideB-->
<xsl:template match="//InternalElement/InternalLink/@RefPartnerSideB" mode="krextor:main">

	<xsl:call-template name="krextor:add-literal-property">
		<xsl:with-param name="property" select="'&aml;refPartnerSideB'"/>
		<xsl:with-param name="datatype" select="'&xsd;string'"/>
	</xsl:call-template>

	<xsl:variable name="refSide">
		<xsl:value-of select="."/>
	</xsl:variable>

	<xsl:for-each select="/CAEXFile/InstanceHierarchy//InternalElement[@ID = substring-before(substring-after($refSide, '{'), '}')]">
		<xsl:variable name="ie-iri">
			<xsl:value-of select="resolve-uri(krextor:global-element-index(.), concat('http://iiot.skt.com/aml/', /CAEXFile/@FileName, '/'))"/>
		</xsl:variable>
		<xsl:call-template name="krextor:add-uri-property">
			<xsl:with-param name="property" select="'&aml;refPartnerSideBIE'"/>
			<xsl:with-param name="object" select="$ie-iri"/>
		</xsl:call-template>

		<xsl:variable name="if-iri">
			<xsl:value-of select="resolve-uri(krextor:global-element-index(./ExternalInterface[@Name = substring-after($refSide, ':')]), concat('http://iiot.skt.com/aml/', /CAEXFile/@FileName, '/'))"/>
		</xsl:variable>
		<xsl:call-template name="krextor:add-uri-property">
			<xsl:with-param name="property" select="'&aml;refPartnerSideBIF'"/>
			<xsl:with-param name="object" select="$if-iri"/>
		</xsl:call-template>
	</xsl:for-each>
</xsl:template>

</xsl:transform>
