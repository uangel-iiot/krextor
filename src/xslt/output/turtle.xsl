<?xml version="1.0" encoding="UTF-8"?>

<!--
    *  Copyright (C) 2008
    *  Christoph Lange
    *  Jacobs University Bremen
    *
    *   Krextor is free software; you can redistribute it and/or
    * 	modify it under the terms of the GNU Lesser General Public
    * 	License as published by the Free Software Foundation; either
    * 	version 2 of the License, or (at your option) any later version.
    *
    * 	This program is distributed in the hope that it will be useful,
    * 	but WITHOUT ANY WARRANTY; without even the implied warranty of
    * 	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    * 	Lesser General Public License for more details.
    *
    * 	You should have received a copy of the GNU Lesser General Public
    * 	License along with this library; if not, write to the
    * 	Free Software Foundation, Inc., 59 Temple Place - Suite 330,
    * 	Boston, MA 02111-1307, USA.
    * 
-->

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

    <xd:doc type="stylesheet">
	<xd:short>Output module for Turtle</xd:short>
	<xd:detail>This stylesheet provides low-level triple-creation functions
	    and templates for a Turtle extraction from XML languages.
	    <ul>
		<li><a href="http://www.dajobe.org/2004/01/turtle/">Specification of Turtle</a></li>
	    </ul>
	</xd:detail>
	<xd:author>Christoph Lange</xd:author>
	<xd:copyright>Christoph Lange, 2008</xd:copyright>
	<xd:svnId>$Id$</xd:svnId>
    </xd:doc>

    <output method="text" encoding="UTF-8"/>

    <function name="krextor:node-id-to-turtle" as="xs:string">
	<param name="element"/>
	<choose>
	    <when test="$element/@uri">
		<value-of select="concat('&lt;', $element/@uri, '&gt;')"/>
	    </when>
	    <when test="$element/@blank">
		<value-of select="concat('_:', $element/@blank)"/>
	    </when>
	    <!-- TODO verify bnode syntax -->
	    <!-- TODO fail in 'else' case -->
	    <otherwise>
		<value-of select="''"/>
	    </otherwise>
	</choose>
    </function>

    <xd:doc>Generates a pretty-printed predicate (currently only supports displaying <code>rdf:type</code> as “a”).</xd:doc>
    <function name="krextor:pretty-predicate">
	<param name="predicate"/>
	<value-of select="if ($predicate eq '&rdf;type') then 'a'
	    else concat('&lt;', $predicate, '&gt;')"/>
    </function>

    <xd:doc>We obtain the RDF graph as RXR and then regroup the triples
	by subject and predicate</xd:doc>
    <template match="/">
	<!-- TODO Consider outputting some @prefixes -->
	<variable name="rxr">
	    <apply-imports/>
	</variable>
	<for-each-group select="$rxr/rxr:graph/rxr:triple"
	    group-by="krextor:node-id-to-turtle(rxr:subject)">
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
			    krextor:node-id-to-turtle(.)
			else if (contains(., '&#xa;')) then
			    concat('&quot;&quot;&quot;', ., '&quot;&quot;&quot;')
			else concat('&quot;', ., '&quot;')"/>
		    <choose>
			<when test="@xml:lang">
			    <value-of select="concat('@', @xml:lang)"/>
			</when>
			<when test="@datatype">
			    <value-of select="concat('^^&lt;', @datatype, '&gt;')"/>
			</when>
		    </choose>
		    <value-of select="if (position() ne last()) then ', ' else ' '"/>
		</for-each>
		<value-of select="if (position() ne last()) then ';' else '.'"/>
		<text>&#xa;</text>
	    </for-each-group>
	</for-each-group>
    </template>
</stylesheet>
