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
        Transformation rule: dcterms:identifier
      -->
      <xsl:call-template name='triple'>
        <xsl:with-param name="doc">
          <desc>Every supplemental record has a unique identifier.</desc>
        </xsl:with-param>
        <xsl:with-param name='spec'>
          <xsl:copy-of select="$supprec_uri"/>
          <uri prefix='&dcterms;'>identifier</uri>
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
              <uri prefix='&meshv;'>RegularSubstance</uri>
            </xsl:when>
            <xsl:when test='@SCRClass = "2"'>
              <uri prefix='&meshv;'>Protocol</uri>
            </xsl:when>
            <xsl:when test='@SCRClass = "3"'>
              <uri prefix='&meshv;'>RareDisease</uri>
            </xsl:when>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>

      <!--
        Transformation rule: rdf:type
      <xsl:call-template name='triple'>
        <xsl:with-param name="doc">
          <desc>This relation states that a Subject node used to identify a Supplementary Concept 
            Record (SCR) is of type "SupplementaryConcept".</desc>
          <fixme report='klortho'>
            How about naming this, simply, SupplementaryConcept?
          </fixme>
        </xsl:with-param>
        <xsl:with-param name='spec'>
          <xsl:copy-of select="$supprec_uri"/>
          <uri prefix='&rdf;'>type</uri>
          <uri prefix='&meshv;'>SupplementaryConcept</uri>
        </xsl:with-param>
      </xsl:call-template>
      -->

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
          <uri prefix='&meshv;'>frequencyyyyyy</uri>
          <literal type='&xs;#int'>
            <xsl:value-of select="xs:int(Frequency)"/>
          </literal>
        </xsl:with-param>
      </xsl:call-template>
      </xsl:if>

      <!--
        Transformation rule: mappedData
      -->
      <xsl:for-each select="HeadingMappedToList/HeadingMappedTo">
        <xsl:variable name='supp_rec_blank'>
          <named>
            <xsl:text>_:blank_set1_</xsl:text>
            <xsl:value-of select="../../SupplementalRecordUI"/>
            <xsl:text>_</xsl:text>
            <xsl:value-of select="position()"/>
          </named>
        </xsl:variable>

        <xsl:call-template name="triple">
          <xsl:with-param name="doc">
            <desc>To remain true to the structure of the supplemental records in XML format, we created the hasMappedData relation.
              A supplemental record can be mappled to at least one descriptor record or descriptor record/qualifier record combination. A
              blank node makes up the mapped data entity.</desc>
          </xsl:with-param>
          <xsl:with-param name="spec">
            <xsl:copy-of select="$supprec_uri"/>
            <uri prefix='&meshv;'>mappedData</uri>
            <xsl:copy-of select='$supp_rec_blank'/>
          </xsl:with-param>
        </xsl:call-template>

        <!--
          Transformation rule: rdf:type
        -->
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>This relation states that a Subject node used to identify mapped data is of type "MappedData".</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$supp_rec_blank"/>
            <uri prefix='&rdf;'>type</uri>
            <uri prefix='&meshv;'>MappedData</uri>
          </xsl:with-param>
        </xsl:call-template>

        <!--
          Transformation rule: isMappedToDescriptor
        -->
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>A supplemental record is mapped to a descriptor record. In our representation 
              the mapping is first to a blank node and then to the descriptor record.</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$supp_rec_blank"/>
            <uri prefix='&meshv;'>isMappedToDescriptor</uri>
            <uri prefix='&mesh;'>
              <xsl:value-of select="replace(DescriptorReferredTo/DescriptorUI,'\*','')"/>
            </uri>
          </xsl:with-param>
        </xsl:call-template>
        
        <!--
          Descriptor is starred
        -->
        <!--<xsl:variable name="descui" select="DescriptorReferredTo/DescriptorUI"/>-->
        <xsl:if test="starts-with(DescriptorReferredTo/DescriptorUI, '*')">
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <fixme reporter='klortho'>As with many other cases, I don't think a predicate with a literal value is the
                right way to handle this.  I'd rather see this as an `rdf:type` to some class that encapsulates the
                semantics.</fixme>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$supp_rec_blank"/>
              <uri prefix='&meshv;'>isDescriptorStarred</uri>
              <literal>Y</literal>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
        
        <!--
          Transformation rule: rdfs:label
        -->
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>A descriptor has a name.</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <uri prefix='&mesh;'>
              <xsl:value-of select="replace(DescriptorReferredTo/DescriptorUI, '\*', '')"/>
            </uri>
            <uri prefix='&rdfs;'>label</uri>
            <literal>
              <xsl:value-of select="DescriptorReferredTo/DescriptorName/String"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
        
        <xsl:if test="QualifierReferredTo">
          <xsl:variable name='qualifier_referred_to_uri'>
            <uri prefix='&mesh;'>
              <xsl:value-of select="replace(QualifierReferredTo/QualifierUI, '\*', '')"/>
            </uri>
          </xsl:variable>
          
          <!--
            Transformation rule: isMappedToQualifier
          -->
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>A supplemental record can be mapped to a qualifier record. In our representation
                the mapping is first to a blank node and then to
                the qualifier record.</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$supp_rec_blank"/>
              <uri prefix='&meshv;'>isMappedToQualifier</uri>
              <xsl:copy-of select="$qualifier_referred_to_uri"/>
            </xsl:with-param>
          </xsl:call-template>

          <!--
            Qualifier is starred
          -->
          <xsl:if test="starts-with(QualifierReferredTo/QualifierUI, '*')">
            <xsl:call-template name='triple'>
              <xsl:with-param name="doc">
                <fixme reporter='klortho'>As usual, I don't like this predicate with a literal "Y" value</fixme>
              </xsl:with-param>
              <xsl:with-param name='spec'>
                <xsl:copy-of select="$supp_rec_blank"/>
                <uri prefix='&meshv;'>isQualifierStarred</uri>
                <literal>Y</literal>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:if>

          <!-- 
            Transformation rule: rdfs:label
          -->
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>A qualifier has a name.</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$qualifier_referred_to_uri"/>
              <uri prefix='&rdfs;'>label</uri>
              <literal>
                <xsl:value-of select="QualifierReferredTo/QualifierName/String"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
      </xsl:for-each>

      <xsl:for-each select="IndexingInformationList/IndexingInformation">
        <xsl:variable name='indexing_data_blank'>
          <named>
            <xsl:text>_:blank_set2_</xsl:text>
            <xsl:value-of select="../../SupplementalRecordUI"/>
            <xsl:text>_</xsl:text>
            <xsl:value-of select="position()"/>
          </named>
        </xsl:variable>
        
        <!--
          Transformation rule: indexingData
        -->
        <xsl:call-template name="triple">
          <xsl:with-param name="doc">
            <desc>To remain true to the structure of the supplemental records in XML 
              format, we created the hasIndexingData relation.
              A supplemental record can have indexing information that consists of at least one 
              descriptor record or descriptor record/qualifier record combination. A
              blank node makes up the indexing data entity.</desc>
          </xsl:with-param>
          <xsl:with-param name="spec">
            <xsl:copy-of select="$supprec_uri"/>
            <uri prefix='&meshv;'>indexingData</uri>
            <xsl:copy-of select="$indexing_data_blank"/>
          </xsl:with-param>
        </xsl:call-template>
        
        <!--
          Transformation rule: rdf:type
        -->
        <xsl:call-template name="triple">
          <xsl:with-param name="doc">
            <desc>This relation states that a Subject node used to identify a Supplementary Concept Record (SCR) is of type "SupplementaryConcept".</desc>
          </xsl:with-param>
          <xsl:with-param name="spec">
            <xsl:copy-of select="$indexing_data_blank"/>
            <uri prefix='&rdf;'>type</uri>
            <uri prefix='&meshv;'>IndexingData</uri>
          </xsl:with-param>
        </xsl:call-template>
        
        <!--
          Transformation rule: indexingDescriptor
        -->
        <xsl:call-template name="triple">
          <xsl:with-param name="doc">
            <desc>A supplemental record can be indexed to more than one descriptor via a unique blank node.</desc>
          </xsl:with-param>
          <xsl:with-param name="spec">
            <xsl:copy-of select="$indexing_data_blank"/>
            <uri prefix='&meshv;'>indexingDescriptor</uri>
            <uri prefix='&mesh;'>
              <xsl:value-of select="DescriptorReferredTo/DescriptorUI"/>
            </uri>
          </xsl:with-param>
        </xsl:call-template>
        
        <!--
          Transformation rule: indexingQualifier
        -->
        <xsl:if test="QualifierReferredTo">
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>A supplemental record can be indexed to more than one qualifier via a unique blank node.</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$indexing_data_blank"/>
              <uri prefix='&meshv;'>indexingQualifier</uri>
              <uri prefix='&mesh;'>
                <xsl:value-of select="QualifierReferredTo/QualifierUI"/>
              </uri>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
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
</xsl:stylesheet>
