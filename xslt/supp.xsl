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

    <xsl:for-each select="SupplementalRecordSet/SupplementalRecord">
      <xsl:variable name='supprec_uri'>
        <uri prefix='&mesh;'>
          <xsl:value-of select="SupplementalRecordUI"/>
        </uri>
      </xsl:variable>

      <!--
        Transformation rule: meshv:identifier
      -->
      <xsl:call-template name='triple'>
        <xsl:with-param name="doc">
          <desc>Every supplemental record has a unique identifier.</desc>
        </xsl:with-param>
        <xsl:with-param name='spec'>
          <xsl:copy-of select="$supprec_uri"/>
          <uri prefix='&meshv;'>identifier</uri>
          <literal>
            <xsl:value-of select="SupplementalRecordUI"/>
          </literal>
        </xsl:with-param>
      </xsl:call-template>

      <!--
       Transformation rule: SCRClass
      -->
      <xsl:call-template name='triple'>
        <xsl:with-param name="doc">
        </xsl:with-param>
        <xsl:with-param name='spec'>
          <xsl:copy-of select="$supprec_uri"/>
          <uri prefix='&rdf;'>type</uri>
          <xsl:choose>
            <xsl:when test='@SCRClass = "1"'>
              <uri prefix='&meshv;'>SCR_Chemical</uri>
            </xsl:when>
            <xsl:when test='@SCRClass = "2"'>
              <uri prefix='&meshv;'>SCR_Protocol</uri>
            </xsl:when>
            <xsl:when test='@SCRClass = "3"'>
              <uri prefix='&meshv;'>SCR_Disease</uri>
            </xsl:when>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>

      <!--
        Transformation rule: rdfs:label
      -->
      <xsl:call-template name='triple'>
        <xsl:with-param name="doc">
          <desc>Every supplemental record has a name.</desc>
        </xsl:with-param>
        <xsl:with-param name='spec'>
          <xsl:copy-of select="$supprec_uri"/>
          <uri prefix='&rdfs;'>label</uri>
          <literal>
            <xsl:value-of select="SupplementalRecordName/String"/>
          </literal>
        </xsl:with-param>
      </xsl:call-template>

      <!--
        Transformation rule: note
      -->
      <xsl:if test="Note">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>A supplemental record can have a note that provides information about the substance.</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$supprec_uri"/>
            <uri prefix='&meshv;'>note</uri>
            <literal>
              <xsl:value-of select="Note"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>

      <!--
        Transformation rule: frequency
      -->
      <xsl:if test="Frequency">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>A supplemental record can have a frequency associated with it. This number represents the number of citations
              indexed with the supplemental record in PubMed.</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$supprec_uri"/>
            <uri prefix='&meshv;'>frequency</uri>
            <literal type='&xs;#int'>
              <xsl:value-of select="Frequency"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>

      <!--
        Transformation rule: mappedData.  This will use either the predicate mappedTo or preferredMappedTo,
        depending on whether either (or both) of the descriptors or qualifiers starts with an asterisk.
        See issue #17.
      -->
      <xsl:for-each select="HeadingMappedToList/HeadingMappedTo">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>Mapped data</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$supprec_uri"/>
            <uri prefix='&meshv;'>
              <xsl:choose>
                <xsl:when test='starts-with(DescriptorReferredTo/DescriptorUI, "*") or 
                  starts-with(QualifierReferredTo/QualifierUI, "*")'>
                  <xsl:value-of select="'preferredMappedTo'"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="'mappedTo'"/>
                </xsl:otherwise>
              </xsl:choose>
            </uri>
            <uri prefix='&mesh;'>
              <xsl:choose>
                <xsl:when test='QualifierReferredTo'>
                  <xsl:value-of select="concat(f:no-asterisk(DescriptorReferredTo/DescriptorUI),
                    f:no-asterisk(QualifierReferredTo/QualifierUI))"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="f:no-asterisk(DescriptorReferredTo/DescriptorUI)"/>
                </xsl:otherwise>
              </xsl:choose>
            </uri>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>
      
      <xsl:for-each select="IndexingInformationList/IndexingInformation">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>See GitHub issue #16.</desc>
          </xsl:with-param>
          <xsl:with-param name="spec">
            <xsl:copy-of select="$supprec_uri"/>
            <uri prefix='&meshv;'>indexerConsiderAlso</uri>
            <uri prefix='&mesh;'>
              <xsl:value-of select="DescriptorReferredTo/DescriptorUI"/>
              <xsl:if test="QualifierReferredTo">
                <xsl:value-of select="QualifierReferredTo/QualifierUI"/>
              </xsl:if>
            </uri>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>        

      <!--
        Transformation rule: source
      -->
      <xsl:for-each select="SourceList/Source">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>A supplemental record can have one or more sources. A source is a 
              citation reference in which the indexing concept was first found.</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$supprec_uri"/>
            <uri prefix='&meshv;'>source</uri>
            <literal>
              <xsl:value-of select="."/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>

      <xsl:call-template name='CommonKids'>
        <xsl:with-param name="parent" select="$supprec_uri"/>
      </xsl:call-template>

    </xsl:for-each>
  </xsl:template>

  <!--
    Helper function to strip out a leading asterisk from an identifier, if there is one
  -->
  <xsl:function name='f:no-asterisk' as="text()">
    <xsl:param name='orig'/>
    <xsl:choose>
      <xsl:when test='starts-with($orig, "*")'>
        <xsl:value-of select="substring($orig, 2)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$orig"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  


</xsl:stylesheet>
