<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- 
  This external subset defines all of the entities that we'll use for URI prefixes from other
  various ontologies.
-->
<!DOCTYPE xsl:stylesheet SYSTEM "mesh-rdf-prefixes.ent" >

<xsl:stylesheet version="2.0" 
                xmlns:f="http://nlm.nih.gov/ns/f"
                xmlns:xs="http://www.w3.org/2001/XMLSchema" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="common.xsl"/>
  <xsl:output method="text"/>


  <xsl:template match="/">

    <!-- triples for Qualifier Records -->

    <xsl:for-each select="QualifierRecordSet/QualifierRecord">
      <xsl:variable name='qualifier_uri'>
        <uri prefix='&mesh;'>
          <xsl:value-of select="QualifierUI"/>
        </uri>
      </xsl:variable>

      <!--
        Transformation rule: rdf:type
      -->
      <xsl:call-template name='triple'>
        <xsl:with-param name="doc">
          <desc>This relation states that a Subject node used to identify a Qualifier is of type "Qualifier".</desc>
        </xsl:with-param>
        <xsl:with-param name='spec'>
          <xsl:copy-of select="$qualifier_uri"/>
          <uri prefix='&rdf;'>type</uri>
          <uri prefix='&meshv;'>Qualifier</uri>
        </xsl:with-param>
      </xsl:call-template>
      
      <!--
        Transformation rule: meshv:identifier
      -->
      <xsl:call-template name='triple'>
        <xsl:with-param name="doc">
          <desc>This relation states that a qualifier has a qualifier identifier.</desc>
        </xsl:with-param>
        <xsl:with-param name='spec'>
          <xsl:copy-of select="$qualifier_uri"/>
          <uri prefix='&meshv;'>identifier</uri>
          <literal>
            <xsl:value-of select="QualifierUI"/>
          </literal>
        </xsl:with-param>
      </xsl:call-template>

      <!--
        Transformation rule: isQualifierType
        This only ever has a value of one, so we will drop it
      <xsl:call-template name='triple'>
        <xsl:with-param name="doc">
          <desc>This relation states that a qualifier has a qualifier type.</desc>
          <fixme report='klortho'>Rather than a predicate with a literal value, couldn't we use an rdf:type relation for
            this, and assign a class to each qualifier type?  Currently (see http://www.nlm.nih.gov/mesh/xml_data_elements.html)
            the only defined type is "1".</fixme>
        </xsl:with-param>
        <xsl:with-param name='spec'>
          <xsl:copy-of select="$qualifier_uri"/>
          <uri prefix='&meshv;'>isQualifierType</uri>
          <literal>
            <xsl:value-of select="@QualifierType"/>
          </literal>
        </xsl:with-param>
      </xsl:call-template>
      -->

      <!--
        Transformation rule: rdfs:label
      -->
      <xsl:call-template name='triple'>
        <xsl:with-param name="doc">
          <desc>Every qualifier has a qualifier name.</desc>
        </xsl:with-param>
        <xsl:with-param name='spec'>
          <xsl:copy-of select="$qualifier_uri"/>
          <uri prefix='&rdfs;'>label</uri>
          <literal>
            <xsl:value-of select="QualifierName/String"/>
          </literal>
        </xsl:with-param>
      </xsl:call-template>

      <!--
        Transformation rule: allowedTreeNode
      -->
      <xsl:for-each select="TreeNodeAllowedList/TreeNodeAllowed">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>A qualifier can have at least one allowed tree node.</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$qualifier_uri"/>
            <uri prefix='&meshv;'>allowedTreeNode</uri>
            <uri prefix='&mesh;'>
              <xsl:value-of select="."/>
            </uri>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>

      <xsl:call-template name='CommonKids'>
        <xsl:with-param name="parent" select="$qualifier_uri"/>
      </xsl:call-template>

    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
