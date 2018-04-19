<?xml version="1.0" encoding="UTF-8"?>

<!DOCTYPE stylesheet [
    <!ENTITY rdf "http://www.w3.org/1999/02/22-rdf-syntax-ns#">
]>

<stylesheet xmlns="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xd="http://www.pnp-software.com/XSLTdoc"
    xmlns:rxr="http://ilrt.org/discovery/2004/03/rxr/"
    xmlns:krextor="http://kwarc.info/projects/krextor"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="2.0">
    <import href="../generic/generic.xsl"/>
    <import href="rxr.xsl"/>
    <import href="util/turtle.xsl"/>

    <xd:doc type="stylesheet">
	<xd:short>Output module for Turtle</xd:short>
	<xd:detail>This stylesheet provides low-level triple-creation functions
	    and templates for a Turtle extraction from XML languages.
	    <ul>
		<li><a href="http://www.w3.org/TeamSubmission/turtle/">Specification of Turtle</a></li>
	    </ul>
	</xd:detail>
	<xd:author>Christoph Lange</xd:author>
	<xd:copyright>Christoph Lange, 2008</xd:copyright>
	<xd:svnId>$Id$</xd:svnId>
    </xd:doc>

    <output method="text" encoding="UTF-8"/>

    <xd:doc>Generates a pretty-printed predicate (currently only supports displaying <code>rdf:type</code> as “a”).</xd:doc>
    <function name="krextor:pretty-predicate">
	<param name="predicate"/>
	<value-of select="if ($predicate eq '&rdf;type') then 'a'
	    else concat('&lt;', $predicate, '&gt;')"/>
    </function>

    <xd:doc>TODO</xd:doc>
    <function name="krextor:rxr-node-to-turtle" as="xs:string">
	<param name="element"/>
	<value-of select="krextor:node-id-to-turtle(
		if ($element/@uri) then $element/@uri
		else if ($element/@blank) then $element/@blank
		else '',
		if ($element/@uri) then 'uri'
		else if ($element/@blank) then 'blank'
		else ''
	    )"/>
    </function>

    <xd:doc>We obtain the RDF graph as RXR and then regroup the triples
	by subject and predicate</xd:doc>
    <template match="/" mode="krextor:main">
	<!-- TODO Consider outputting some @prefixes -->
	<variable name="rxr">
	    <apply-imports/>
	</variable>
	<for-each-group select="$rxr/rxr:graph/rxr:triple"
	    group-by="krextor:rxr-node-to-turtle(rxr:subject)">
	    <!-- output the subject -->
	    <value-of select="current-grouping-key()"/>
	    <text>&#xa;</text>
	    <for-each-group select="current-group()" group-by="rxr:predicate/@uri">
		<text>&#x9;</text>
		<!-- output the predicate -->
		<value-of select="krextor:pretty-predicate(current-grouping-key())"/>
		<text>&#x9;</text>
		<for-each select="current-group()/rxr:object">
		    <!-- output the object(s) -->
		    <value-of select="if (@uri|@blank) then
			    krextor:rxr-node-to-turtle(.)
			else
			    krextor:literal-to-turtle(., @xml:lang, @datatype)"/>
		    <value-of select="if (position() ne last()) then ', ' else ' '"/>
		</for-each>
		<value-of select="if (position() ne last()) then ';' else '.'"/>
		<text>&#xa;</text>
	    </for-each-group>
	</for-each-group>
    </template>
</stylesheet>
