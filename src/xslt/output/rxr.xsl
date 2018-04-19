<?xml version="1.0" encoding="UTF-8"?>

<!DOCTYPE stylesheet [
    <!ENTITY rdf "http://www.w3.org/1999/02/22-rdf-syntax-ns#">
]>

<stylesheet xmlns="http://www.w3.org/1999/XSL/Transform" 
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:xd="http://www.pnp-software.com/XSLTdoc"
    xmlns:rxr="http://ilrt.org/discovery/2004/03/rxr/"
    xmlns:krextor="http://kwarc.info/projects/krextor"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="krextor xd xs"
    version="2.0">
    <import href="../generic/generic.xsl"/>

    <xd:doc type="stylesheet">
	<xd:short>Output module for RDF/RXR</xd:short>
	<xd:detail>This is an output module for the RDF notation RXR (Regular XML RDF).  References:
	    <ul>
		<li><a href="http://www.idealliance.org/papers/dx_xmle04/papers/03-08-03/03-08-03.html">David Beckett: Modernising Semantic Web Markup</a></li>
		<li><a href="http://ilrt.org/discovery/2004/03/rxr/">XML schemas for RXR</a></li>
	    </ul>
	</xd:detail>
	<xd:author>Christoph Lange</xd:author>
	<xd:copyright>Christoph Lange, 2008</xd:copyright>
	<xd:svnId>$Id$</xd:svnId>
    </xd:doc>

    <output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>

    <xd:doc>
	<xd:short>Creates one RDF triple</xd:short>
	<xd:detail>Creates one RDF triple
        <xd:param name="subject">the identifier of the subject, either a URI or a blank node ID</xd:param>
        <xd:param name="subject-type">the type of the subject identifier, either <code>'uri'</code> or <code>'blank'</code></xd:param>
        <xd:param name="predicate">the identifier of the predicate, always a URI</xd:param>
        <xd:param name="object">the value of the object, either a URI or a blank node ID or a literal</xd:param>
        <xd:param name="object-type">the type of the object, either <code>'uri'</code> or <code>'blank'</code>, or nothing for literal objects.  A literal can be given as a string (or text node), or as any other XML</xd:param>
        <xd:param name="object-language">the language of a literal object.  Language annotation is only supported on the object,
	     but neither on triples nor on graphs, as in RXR</xd:param>
        <xd:param name="object-datatype">the datatype of a literal object</xd:param>
	</xd:detail>
    </xd:doc>
    <template name="krextor:output-triple">
	<param name="subject"/>
	<param name="subject-type"/>

	<param name="predicate"/>

	<param name="object"/>
	<param name="object-type"/>
	<param name="object-language"/>
	<param name="object-datatype"/>

	<param name="reference-of-object"/>
	<param name="empty-content"/>

	<rxr:triple>
	    <rxr:subject>
		<attribute name="{$subject-type}" select="$subject"/>
	    </rxr:subject>
	    <rxr:predicate uri="{$predicate}"/>
	    <rxr:object>
		<if test="$object-language">
		    <attribute name="xml:lang" select="$object-language"/>
		    </if>
		<if test="$reference-of-object">
			<attribute name="uri" select="$reference-of-object"/>
		</if>
		<choose>
		    <when test="$object-type">
			<attribute name="{$object-type}" select="$object"/>
		    </when>
		    <otherwise>
			<!-- literal object -->
			<if test="$object-datatype">
			    <attribute name="datatype" select="$object-datatype"/>
			</if>
			<if test="$empty-content=false()">
				<choose>
					<when test="$object-datatype eq '&rdf;XMLLiteral'">
						<copy-of select="$object"/>
					</when>
					<otherwise>
						<value-of select="$object"/>
					</otherwise>
				</choose>
			</if>
		    </otherwise>
		</choose>
	    </rxr:object>
	</rxr:triple>
    </template>

    <template match="/" mode="krextor:main">
	<rxr:graph>
	    <apply-imports/>
	</rxr:graph>
    </template>
</stylesheet>
