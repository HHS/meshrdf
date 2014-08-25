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
          <fixme reporter='klortho'>As usual, I don't like these predicates with literal values.
            I think this should be done with rdf:type relations to particular classes, each of
            which would be a subclass of SupplementaryConceptRecord.</fixme>
        </xsl:with-param>
        <xsl:with-param name='spec'>
          <xsl:copy-of select="$supprec_uri"/>
          <uri prefix='&meshv;'>SCRClass</uri>
          <literal>
            <xsl:value-of select="@SCRClass"/>
          </literal>
        </xsl:with-param>
      </xsl:call-template>

      <!--
        Transformation rule: rdf:type
      -->
      <xsl:call-template name='triple'>
        <xsl:with-param name="doc">
          <desc>This relation states that a Subject node used to identify a Supplementary Concept Record (SCR) is of type "SupplementaryConceptRecord".</desc>
        </xsl:with-param>
        <xsl:with-param name='spec'>
          <xsl:copy-of select="$supprec_uri"/>
          <uri prefix='&rdf;'>type</uri>
          <uri prefix='&meshv;'>SupplementaryConceptRecord</uri>
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
        Transformation rule: dateCreated
      -->
      <xsl:call-template name='triple'>
        <xsl:with-param name="doc">
          <desc>Every supplemental record has a date on which it was created.</desc>
        </xsl:with-param>
        <xsl:with-param name='spec'>
          <uri prefix='&mesh;'>
            <xsl:value-of select="SupplementalRecordUI"/>
          </uri>
          <uri prefix='&meshv;'>dateCreated</uri>
          <xsl:call-template name="DateLiteral">
            <xsl:with-param name="context" select="DateCreated"/>
          </xsl:call-template>
        </xsl:with-param>
      </xsl:call-template>

      <!--
        Transformation rule: dateRevised
      -->
      <xsl:if test="DateRevised">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>A supplemental record can have a date on which it was revised.</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <uri prefix='&mesh;'>
              <xsl:value-of select="SupplementalRecordUI"/>
            </uri>
            <uri prefix='&meshv;'>dateRevised</uri>
            <xsl:call-template name="DateLiteral">
              <xsl:with-param name="context" select="DateRevised"/>
            </xsl:call-template>
          </xsl:with-param>
        </xsl:call-template>    
      </xsl:if>

      <!--
        Transformation rule: activeMeSHYear
      -->
      <xsl:for-each select="ActiveMeSHYearList/Year">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>A supplemental record has at least one MeSH year in which it was active.</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <uri prefix='&mesh;'>
              <xsl:value-of select="../../SupplementalRecordUI"/>
            </uri>
            <uri prefix='&meshv;'>activeMeSHYear</uri>
            <literal type='&xs;#date'>
              <xsl:value-of select="."/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>       
      </xsl:for-each>

      <!--
        Transformation rule: note
      -->
      <xsl:if test="Note">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>A supplemental record can have a note that provides information about the substance.</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <uri prefix='&mesh;'>
              <xsl:value-of select="SupplementalRecordUI"/>
            </uri>
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
          <uri prefix='&mesh;'>
            <xsl:value-of select="SupplementalRecordUI"/>
          </uri>
          <uri prefix='&meshv;'>frequency</uri>
          <literal>
            <xsl:value-of select="Frequency"/>
          </literal>
        </xsl:with-param>
      </xsl:call-template>
      </xsl:if>

      <!--
        Transformation rule: previousIndexing
      -->
      <xsl:for-each select="PreviousIndexingList/PreviousIndexing">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>A supplemental record can have a previous indexing. See http://www.nlm.nih.gov/mesh/xml_data_elements.html 
              accessed on 9/9/2008 for more information.</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <uri prefix='&mesh;'>
              <xsl:value-of select="../../SupplementalRecordUI"/>
            </uri>
            <uri prefix='&meshv;'>previousIndexing</uri>
            <literal>
              <xsl:value-of select="."/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>           
      </xsl:for-each>

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
            <uri prefix='&mesh;'>
              <xsl:value-of select='../../SupplementalRecordUI'/>
            </uri>
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
            <desc>This relation states that a Subject node used to identify a Supplementary Concept Record (SCR) is of type "SupplementaryConceptRecord".</desc>
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
        Transformation rule: pharmacologicalAction
      -->
      <xsl:for-each select="PharmacologicalActionList/PharmacologicalAction">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>A supplemental record can have a pharmacological action that is a reference to a descriptor record describing observed 
              biological activity of an exogenously administered chemical.</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$supprec_uri"/>
            <uri prefix='&meshv;'>pharmacologicalAction</uri>
            <uri prefix='&mesh;'>
              <xsl:value-of select="DescriptorReferredTo/DescriptorUI"/>
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


      <xsl:call-template name='RecordOriginatorsList'>
        <xsl:with-param name="parent" select="$supprec_uri"/>
      </xsl:call-template>
      

      <xsl:for-each select="ConceptList/Concept">
        <xsl:variable name='concept_uri'>
          <uri prefix='&mesh;'>
            <xsl:value-of select="ConceptUI"/>
          </uri>
        </xsl:variable>

        <!--
          Transformation rule: concept
        -->
        <xsl:call-template name='triple'>
          <xsl:with-param name='spec'>
            <xsl:copy-of select='$supprec_uri'/>
            <uri prefix='&meshv;'>concept</uri>
            <xsl:copy-of select="$concept_uri"/>
          </xsl:with-param>
        </xsl:call-template>

        <!--
          Transformation rule/Relation: rdf:type
        -->
        <xsl:call-template name='triple'>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$concept_uri"/>
            <uri prefix='&rdf;'>type</uri>
            <uri prefix='&meshv;'>Concept</uri>
          </xsl:with-param>
        </xsl:call-template>

        <!--
          Transformation rule: isPreferredConcept
        -->
        <xsl:if test="@PreferredConceptYN = 'Y' or @PreferredConceptYN = 'N'">
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <fixme reporter='klortho'>Predicate with literal should be changed to rdf:type and appropriate
                class.</fixme>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$concept_uri"/>
              <uri prefix='&meshv;'>isPreferredConcept</uri>
              <literal>
                <xsl:value-of select="@PreferredConceptYN"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>

        <!--
          Transformation rule: rdfs:label
        -->
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>A concept has a name</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select='$concept_uri'/>
            <uri prefix='&rdfs;'>label</uri>
            <literal>
              <xsl:value-of select="ConceptName/String"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>

        <!--
          Transformation rule: dcterms:identifier
        -->
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>A concept has a unique identifier.</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select='$concept_uri'/>
            <uri prefix='&dcterms;'>identifier</uri>
            <literal>
              <xsl:value-of select="ConceptUI"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
        
        <!--
          Transformation rule: CASN1_label
        -->
        <xsl:if test="CASN1Name">
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>A concept can have a Chemical Abstracts Type N1 Name (CASN1Name).</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select='$concept_uri'/>
              <uri prefix='&meshv;'>CASN1_label</uri>
              <literal>
                <xsl:value-of select="CASN1Name"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>

        <!--
          Transformation rule: registryNumber
        -->
        <xsl:if test="RegistryNumber">
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>A concept can have a registry number. See http://www.nlm.nih.gov/mesh/xml_data_elements.html accessed on 9/9/2008 for
                more details.</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select='$concept_uri'/>
              <uri prefix='&meshv;'>registryNumber</uri>
              <literal>
                <xsl:value-of select="RegistryNumber"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>

        <!--
          Transformation rule: skos:scopeNote
        -->
        <xsl:if test="ScopeNote">
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>A concept can have a scope note, a free-text narrative giving the scoe and meaning of a concept.</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select='$concept_uri'/>
              <uri prefix='&skos;'>scopeNote</uri>
              <literal>
                <xsl:value-of select="ScopeNote"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>


        <xsl:for-each select="SemanticTypeList/SemanticType">
          <xsl:variable name='semantic_type_uri'>
            <uri prefix='&mesh;'>
              <xsl:value-of select="SemanticTypeUI"/>
            </uri>
          </xsl:variable>

          <!--
            Transformation rule: semanticType
          -->
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>A concept can have a semantic type. I chose to model the semantic type information in the aforementioned fashion
                so that it would be consistent with our previous work with the MeSH descriptors. In this way, a semantic type has a semantic 
                type unique identifier as well as a semantic type name.</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$semantic_type_uri"/>
              <uri prefix='&rdf;'>type</uri>
              <uri prefix='&meshv;'>SemanticType</uri>
            </xsl:with-param>
          </xsl:call-template>

          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$concept_uri"/>
              <uri prefix='&meshv;'>semanticType</uri>
              <xsl:copy-of select="$semantic_type_uri"/>
            </xsl:with-param>
          </xsl:call-template>

          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$semantic_type_uri"/>
              <uri prefix='&dcterms;'>identifier</uri>
              <literal>
                <xsl:value-of select="SemanticTypeUI"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>

          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$semantic_type_uri"/>
              <uri prefix='&rdfs;'>label</uri>
              <literal>
                <xsl:value-of select="SemanticTypeName"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:for-each>

        <!--
          Transformation rule: relatedRegistryNumber
        -->
        <xsl:for-each select="RelatedRegistryNumberList/RelatedRegistryNumber">
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$concept_uri"/>
              <uri prefix='&meshv;'>relatedRegistryNumber</uri>
              <literal>
                <xsl:value-of select="."/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:for-each>

        
        <xsl:call-template name="ConceptRelationList"/>
        

        <xsl:for-each select="TermList/Term">
          <xsl:variable name='term_uri'>
            <uri prefix='&mesh;'>
              <xsl:value-of select="TermUI"/>
            </uri>
          </xsl:variable>

          <!--
            Transformation rule: term
          -->
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>This relation states that a concept has a term.</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$concept_uri"/>
              <uri prefix='&meshv;'>term</uri>
              <xsl:copy-of select="$term_uri"/>
            </xsl:with-param>
          </xsl:call-template>
          
          <!--
            Transformation rule: rdf:type
          -->
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>A concept has at least one term associated with it.</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$term_uri"/>
              <uri prefix='&rdf;'>type</uri>
              <uri prefix='&meshv;'>Term</uri>
            </xsl:with-param>
          </xsl:call-template>
          
          <!--
            Transformation rule: dcterms:identifier
          -->
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>This relation states that a term has a term unique identifier.</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$term_uri"/>
              <uri prefix='&dcterms;'>identifier</uri>
              <literal>
                <xsl:value-of select="TermUI"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>

          <xsl:if test="@IsPermutedTermYN = 'N'">
            <xsl:call-template name='triple'>
              <xsl:with-param name="doc">
                <fixme reporter='klortho'>Why do we only produce a label triple if @IsPermutedTermYN is "N"?  Is this
                  a mistake?</fixme>
              </xsl:with-param>
              <xsl:with-param name='spec'>
                <xsl:copy-of select="$term_uri"/>
                <uri prefix='&rdfs;'>label</uri>
                <literal>
                  <xsl:value-of select="String"/>
                </literal>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:if>
          
          <!--
            Transformation rule: termData
          -->
          <xsl:variable name='term_data_blank'>
            <named>
              <xsl:text>_:blank</xsl:text>
              <xsl:value-of select="TermUI"/>
              <xsl:text>_</xsl:text>
              <xsl:value-of select="position()"/>
            </named>
          </xsl:variable>
          
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>This relation states that a term has data associated with it. A blank node 
                stores the term data.</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$term_uri"/>
              <uri prefix='&meshv;'>termData</uri>
              <xsl:copy-of select="$term_data_blank"/>
            </xsl:with-param>
          </xsl:call-template>
          
          <!--
            Transformation rule/Relation: rdf:type
          -->
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>This relation states that a Subject node used to identify term data is of type "TermData".</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$term_data_blank"/>
              <uri prefix='&rdf;'>type</uri>
              <uri prefix='&meshv;'>TermData</uri>
            </xsl:with-param>
          </xsl:call-template>
          
          <!--
            Transformation rule: isConceptPreferredTerm
          -->
          
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>This relation states that a term can be a concept-preferred-term. But it does 
                so indirectly because the isConceptPreferredTerm relation is with a blank node.</desc>
              <fixme reporter='klortho'>Don't like literal Y/N values (as mentioned elsewhere)</fixme>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$term_data_blank"/>
              <uri prefix='&meshv;'>isConceptPreferredTerm</uri>
              <literal>
                <xsl:value-of select="@ConceptPreferredTermYN"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>
          
          <!--
            Transformation rule: isPermutedTerm
          -->
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>This relation states that a term can be a permuted term. But it does so indirectly because the isPermutedTerm relation is with a blank node.</desc>
              <fixme reporter='klortho'>Don't like literal Y/N values (as mentioned elsewhere)</fixme>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$term_data_blank"/>
              <uri prefix='&meshv;'>isPermutedTerm</uri>
              <literal>
                <xsl:value-of select="@IsPermutedTermYN"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>
          
          <!--
            Transformation rule: lexicalTag
          -->
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>This relation states that a term has a lexical tag. But it does so indirectly 
                becuase the hasLexicalTag relation is with a blank node.</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$term_data_blank"/>
              <uri prefix='&meshv;'>lexicalTag</uri>
              <literal>
                <xsl:value-of select="@LexicalTag"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>
          
          <!--
            Transformation rule: printFlag
          -->
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>This relation states that a term has a print flag. But it does this 
                indirectly because the hasPrintFlag relation is with a blank node.</desc>
              <fixme reporter='klortho'>Don't like literal Y/N values (as mentioned elsewhere)</fixme>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$term_data_blank"/>
              <uri prefix='&meshv;'>printFlag</uri>
              <literal>
                <xsl:value-of select="@PrintFlagYN"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>
          
          <!--
            Transformation rule: isRecordPreferredTerm
          -->
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>This relation states that a term can be a record preferred term. But it does this indirectly because the relation is with a blank node.</desc>
              <fixme reporter='klortho'>Don't like literal Y/N values (as mentioned elsewhere)</fixme>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$term_data_blank"/>
              <uri prefix='&meshv;'>isRecordPreferredTerm</uri>              
              <literal>
                <xsl:value-of select="@RecordPreferredTermYN"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>
          
          <!--
           Transformation rule: dcterms:identifier
          -->
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>This relation states that a term has a term unique identifier. However, 
                it does so indirectly because the relation is with a blank node.</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$term_data_blank"/>
              <uri prefix='&dcterms;'>identifier</uri>
              <literal>
                <xsl:value-of select="TermUI"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>
          
          <!--
            Transformation rule: rdfs:label
          -->
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>This relation states that a term has a term name. But it does so indirectly because the relation is with a blank node.</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$term_data_blank"/>
              <uri prefix='&rdfs;'>label</uri>
              <literal>
                <xsl:value-of select="String"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>
          
          <!--
            Transformation rule: dateCreated
          -->
          <xsl:if test="DateCreated">
            <xsl:call-template name='triple'>
              <xsl:with-param name="doc">
                <desc>This relation states that a term can have a date on which it was created.</desc>
              </xsl:with-param>
              <xsl:with-param name='spec'>
                <xsl:copy-of select="$term_data_blank"/>
                <uri prefix='&meshv;'>dateCreated</uri>
                <xsl:call-template name="DateLiteral">
                  <xsl:with-param name="context" select="DateCreated"/>
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:if>
          
          <!--
            Transformation rule: abbreviation
          -->
          <xsl:if test="Abbreviation">
            <xsl:call-template name='triple'>
              <xsl:with-param name="doc">
                <desc>This relation states that a term has a term abbreviation.</desc>
              </xsl:with-param>
              <xsl:with-param name='spec'>
                <xsl:copy-of select="$term_data_blank"/>
                <uri prefix='&meshv;'>abbreviation</uri>
                <literal>
                  <xsl:value-of select="Abbreviation"/>
                </literal>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:if>
          
          <!--
            Transformation rule: sortVersion
          -->
          <xsl:if test="SortVersion">
            <xsl:call-template name='triple'>
              <xsl:with-param name="doc">
                <desc>This rule states that a term has a sort version.</desc>
              </xsl:with-param>
              <xsl:with-param name='spec'>
                <xsl:copy-of select="$term_data_blank"/>
                <uri prefix='&meshv;'>sortVersion</uri>
                <literal>
                  <xsl:value-of select="SortVersion"/>
                </literal>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:if>
          
          <!--
            Transformation rule: entryVersion
          -->
          <xsl:if test="EntryVersion">
            <xsl:call-template name='triple'>
              <xsl:with-param name="doc">
                <desc>This rule states that a term has an entry version.</desc>
              </xsl:with-param>
              <xsl:with-param name='spec'>
                <xsl:copy-of select="$term_data_blank"/>
                <uri prefix='&meshv;'>entryVersion</uri>
                <literal>
                  <xsl:value-of select="EntryVersion"/>
                </literal>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:if>
          
          <!--
            Transformation rule: thesaurusID
          -->
          <xsl:if test="ThesaurusIDlist">
            <xsl:variable name="pos" select="position()"/>
            <xsl:for-each select="ThesaurusIDlist/ThesaurusID">
              <xsl:call-template name='triple'>
                <xsl:with-param name="doc">
                  <desc>This relation states that a term has a thesaurus ID.</desc>
                  <fixme reporter='klortho'>Will we be getting rid of this blank node?</fixme>
                </xsl:with-param>
                <xsl:with-param name='spec'>
                  <named>
                    <xsl:text>_:blank</xsl:text>
                    <xsl:value-of select="../../TermUI"/>
                    <xsl:text>_</xsl:text>
                    <xsl:copy-of select="$pos"/>
                  </named>
                  <uri prefix='&meshv;'>thesaurusID</uri>
                  <literal>
                    <xsl:value-of select="."/>
                  </literal>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:for-each>
          </xsl:if>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
