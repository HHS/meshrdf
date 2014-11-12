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
    <xsl:for-each select="DescriptorRecordSet/DescriptorRecord">

      <xsl:variable name='descriptor_id' select='DescriptorUI'/>
      
      <!--
        Transformation rule: meshv:identifier
      -->
      <xsl:variable name='descriptor_uri'>
        <uri prefix='&mesh;'>
          <xsl:value-of select="$descriptor_id"/>
        </uri>
      </xsl:variable>
      
      <xsl:call-template name='triple'>
        <xsl:with-param name="doc">
          <desc>This relation states that a descriptor record has a unique identifier.</desc>
        </xsl:with-param>
        <xsl:with-param name='spec'>
          <xsl:copy-of select="$descriptor_uri"/>
          <uri prefix='&meshv;'>identifier</uri>
          <literal>
            <xsl:value-of select="DescriptorUI"/>
          </literal>
        </xsl:with-param>
      </xsl:call-template>

      <!-- 
        Transformation rule: descriptorClass
      -->
      <xsl:call-template name="triple">
        <xsl:with-param name="doc">
          <desc>This relation states that a descriptor record has a descriptor class to which 
            it belongs.</desc>
        </xsl:with-param>
        <xsl:with-param name="spec">
          <xsl:copy-of select="$descriptor_uri"/>
          <uri prefix="&rdf;">type</uri>
          <uri prefix='&meshv;'>
            <xsl:choose>
              <xsl:when test="@DescriptorClass = '1'">
                <xsl:text>TopicalDescriptor</xsl:text>
              </xsl:when>
              <xsl:when test="@DescriptorClass = '2'">
                <xsl:text>PublicationType</xsl:text>
              </xsl:when>
              <xsl:when test="@DescriptorClass = '3'">
                <xsl:text>CheckTag</xsl:text>
              </xsl:when>
              <xsl:when test="@DescriptorClass = '4'">
                <xsl:text>GeographicalDescriptor</xsl:text>
              </xsl:when>
            </xsl:choose>
          </uri>
        </xsl:with-param>
      </xsl:call-template>

      <!--
        Transformation rule: rdfs:label
      -->      
      <xsl:call-template name="triple">
        <xsl:with-param name="doc">
          <desc>This relation states that a descriptor record has a name.</desc>
        </xsl:with-param>
        <xsl:with-param name="spec">
          <xsl:copy-of select="$descriptor_uri"/>
          <uri prefix='&rdfs;'>label</uri>
          <literal>
            <xsl:value-of select="DescriptorName/String"/>
          </literal>
        </xsl:with-param>
      </xsl:call-template>
      
      <xsl:for-each select="AllowableQualifiersList/AllowableQualifier">
        <xsl:variable name='qualifier_id' select='QualifierReferredTo/QualifierUI'/>
        <xsl:variable name='qualifier_uri'>
          <uri prefix='&mesh;'>
            <xsl:value-of select="$qualifier_id"/>
          </uri>
        </xsl:variable>
        
        <!--
          Transformation rule: allowableQualifier
        -->
        <xsl:call-template name="triple">
          <xsl:with-param name="doc">
            <desc>This relation states that a descriptor record has an allowable qualifier.</desc>
          </xsl:with-param>
          <xsl:with-param name="spec">
            <xsl:copy-of select='$descriptor_uri'/>
            <uri prefix='&meshv;'>allowableQualifier</uri>
            <xsl:copy-of select='$qualifier_uri'/>
          </xsl:with-param>
        </xsl:call-template>
        
        <!-- 
          Create a DescriptorQualifierPair resource
        -->
        <xsl:variable name='dqpair_uri'>
          <uri prefix='&mesh;'>
            <xsl:value-of select="concat($descriptor_id, $qualifier_id)"/>
          </uri>
        </xsl:variable>
        
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>Define a DescriptorQualifierPair resource for this valid pair</desc>
          </xsl:with-param>
          <xsl:with-param name="spec">
            <xsl:copy-of select='$dqpair_uri'/>
            <uri prefix='&rdf;'>type</uri>
            <uri prefix='&meshv;'>AllowedDescriptorQualifierPair</uri>
          </xsl:with-param>
        </xsl:call-template>

        <!-- 
          Link it back to the descriptor
        -->
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>Link the DescriptorQualifierPair to its descriptor</desc>
          </xsl:with-param>
          <xsl:with-param name="spec">
            <xsl:copy-of select='$dqpair_uri'/>
            <uri prefix='&meshv;'>hasDescriptor</uri>
            <xsl:copy-of select='$descriptor_uri'/>
          </xsl:with-param>
        </xsl:call-template>
        
        <!-- 
          Link it back to the qualifier
        -->
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>Link the DescriptorQualifierPair to its qualifier</desc>
          </xsl:with-param>
          <xsl:with-param name="spec">
            <xsl:copy-of select='$dqpair_uri'/>
            <uri prefix='&meshv;'>hasQualifier</uri>
            <xsl:copy-of select='$qualifier_uri'/>
          </xsl:with-param>
        </xsl:call-template>        
      </xsl:for-each>
      
      <!--
        Transformation rule: publicMeSHNote
      -->
      <xsl:if test="PublicMeSHNote">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>This relation states that a descriptor has a public MeSH note.</desc>
            <fixme report='klortho' issue='27'>Should have (leading and) trailing whitespace removed</fixme>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$descriptor_uri"/>
            <uri prefix='&meshv;'>publicMeSHNote</uri>
            <literal>
              <xsl:value-of select="PublicMeSHNote"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>
      
      <xsl:for-each select="EntryCombinationList/EntryCombination">

        <xsl:variable name='ecin_uri'>
          <uri prefix='&mesh;'>
            <xsl:value-of select="concat(ECIN/DescriptorReferredTo/DescriptorUI,
                                         ECIN/QualifierReferredTo/QualifierUI)"/>
          </uri>
        </xsl:variable>

        <!-- 
          ECIN is a DescriptorQualifierPair
        -->
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>The ECIN is a DisallowedDescriptorQualifierPair.</desc>
          </xsl:with-param>
          <xsl:with-param name="spec">
            <xsl:copy-of select='$ecin_uri'/>
            <uri prefix='&rdf;'>type</uri>
            <uri prefix='&meshv;'>DisallowedDescriptorQualifierPair</uri>
          </xsl:with-param>
        </xsl:call-template>
        
        <!-- 
          Link it back to the descriptor
        -->
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>Link the ECIN to its descriptor</desc>
          </xsl:with-param>
          <xsl:with-param name="spec">
            <xsl:copy-of select='$ecin_uri'/>
            <uri prefix='&meshv;'>hasDescriptor</uri>
            <uri prefix='&mesh;'>
              <xsl:value-of select="ECIN/DescriptorReferredTo/DescriptorUI"/>
            </uri>
          </xsl:with-param>
        </xsl:call-template>
        
        <!-- 
          Link it back to the qualifier
        -->
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>Link the ECIN to its qualifier</desc>
          </xsl:with-param>
          <xsl:with-param name="spec">
            <xsl:copy-of select='$ecin_uri'/>
            <uri prefix='&meshv;'>hasQualifier</uri>
            <uri prefix='&mesh;'>
              <xsl:value-of select="ECIN/QualifierReferredTo/QualifierUI"/>
            </uri>
          </xsl:with-param>
        </xsl:call-template>        
        
        <!--
          Relation to ECOUT
        -->
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>Link the ECIN to the ECOUT</desc>
          </xsl:with-param>
          <xsl:with-param name="spec">
            <xsl:copy-of select='$ecin_uri'/>
            <uri prefix='&meshv;'>useInstead</uri>
            <uri prefix='&mesh;'>
              <xsl:value-of select="ECOUT/DescriptorReferredTo/DescriptorUI"/>
              <xsl:if test='ECOUT/QualifierReferredTo'>
                <xsl:value-of select="ECOUT/QualifierReferredTo/QualifierUI"/>
              </xsl:if>
            </uri>
          </xsl:with-param>
        </xsl:call-template>        
      </xsl:for-each>

      <!--
        Transformation rules: seeAlso, hasRelatedDescriptor
      -->
      <xsl:for-each select="SeeRelatedList/SeeRelatedDescriptor">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>This descriptor gets a seeAlso relation to another descriptor.</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$descriptor_uri"/>
            <uri prefix='&meshv;'>seeAlso</uri>
            <uri prefix='&mesh;'>
              <xsl:value-of select="DescriptorReferredTo/DescriptorUI"/>
            </uri>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>

      <!--
        Transformation rule: considerAlso
      -->
      <xsl:if test="ConsiderAlso">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <fixme>Maybe we can break this up into several considerTermsAt.</fixme>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$descriptor_uri"/>
            <uri prefix='&meshv;'>considerAlso</uri>
            <literal>
              <xsl:value-of select="ConsiderAlso"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>

      <!--
        Transformation rule: runningHead
      -->
      <xsl:if test="RunningHead">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>This relation says that a descriptor has a running head.</desc>
            <fixme>Whether or not there would be any value to breaking up the text of the 
              running head.</fixme>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$descriptor_uri"/>
            <uri prefix='&meshv;'>runningHead</uri>
            <literal>
              <xsl:value-of select="RunningHead"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>

      <xsl:call-template name='CommonKids'>
        <xsl:with-param name="parent" select="$descriptor_uri"/>
      </xsl:call-template>

    </xsl:for-each>
    
  </xsl:template>
</xsl:stylesheet>
