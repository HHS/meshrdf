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

      <!--
        Transformation rule: dcterms:identifier
      -->
      <xsl:variable name='descriptor_uri'>
        <uri prefix='&mesh;'>
          <xsl:value-of select="DescriptorUI"/>
        </uri>
      </xsl:variable>
      
      <xsl:call-template name='triple'>
        <xsl:with-param name="doc">
          <desc>This relation states that a descriptor record has a unique identifier.</desc>
        </xsl:with-param>
        <xsl:with-param name='spec'>
          <xsl:copy-of select="$descriptor_uri"/>
          <uri prefix='&dcterms;'>identifier</uri>
          <literal>
            <xsl:value-of select="DescriptorUI"/>
          </literal>
        </xsl:with-param>
      </xsl:call-template>

      <!--
        Transformation rule: rdf:type
      -->
      <xsl:call-template name='triple'>
        <xsl:with-param name="doc">
          <desc>This relation states that a Subject node used to identify a Descriptor record 
            is of type "Descriptor".</desc>
        </xsl:with-param>
        <xsl:with-param name='spec'>
          <xsl:copy-of select="$descriptor_uri"/>
          <uri prefix='&rdf;'>type</uri>
          <uri prefix='&mesh;'>Descriptor</uri>
        </xsl:with-param>
      </xsl:call-template>

      <!-- 
        Transformation rule: descriptorClass
      -->
      <xsl:call-template name="triple">
        <xsl:with-param name="doc">
          <desc>This relation states that a descriptor record has a descriptor class to which 
            it belongs.</desc>
          <fixme reporter='klortho'>Wouldn't this be done better by using a class hierarchy? For
            example, each of topical descriptor, publication type, check tag, and 
            geographical descriptor could be defined as a class in the ontology?</fixme>
        </xsl:with-param>
        <xsl:with-param name="spec">
          <xsl:copy-of select="$descriptor_uri"/>
          <uri prefix="&mesh;">descriptorClass</uri>
          <literal>
            <xsl:value-of select="@DescriptorClass"/>
          </literal>
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

      <!-- 
        Transformation rule: dateCreated
      -->
      <xsl:call-template name='triple'>
        <xsl:with-param name="doc">
          <desc>This relation states that a descriptor record has a date on which it was created, revised and established.</desc>
          <fixme>Whether this date representation will be sufficient for us to compute on? We could also change it to the date-time format as provided by the dateTime
            XSLT 2.0 function.</fixme>
        </xsl:with-param>
        <xsl:with-param name='spec'>
          <xsl:copy-of select="$descriptor_uri"/>
          <uri prefix='&mesh;'>dateCreated</uri>
          <literal>
            <xsl:value-of select="xs:date(string-join((DateCreated/Year,DateCreated/Month,DateCreated/Day),'-'))"/>
          </literal>
        </xsl:with-param>
      </xsl:call-template>
      
      <!-- 
        Transformation rule: dateRevised
      -->
      <xsl:if test="DateRevised">
        <xsl:call-template name='triple'>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$descriptor_uri"/>
            <uri prefix='&mesh;'>dateRevised</uri>
            <literal>
              <xsl:value-of select="xs:date(string-join((DateRevised/Year,DateRevised/Month,DateRevised/Day),'-'))"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>
      
      <!-- 
        Transformation rule: dateEstablished
      -->
      <xsl:if test="DateEstablished">
        <xsl:call-template name='triple'>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$descriptor_uri"/>
            <uri prefix='&mesh;'>dateEstablished</uri>
            <literal>
              <xsl:value-of select="xs:date(string-join((DateEstablished/Year,DateEstablished/Month,DateEstablished/Day),'-'))"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>
      
      <!--
        Tranformation rule: activeMeSHYear
      -->
      <xsl:for-each select="ActiveMeSHYearList/Year">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>This relation states that a descriptor record has an active MeSH year.</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$descriptor_uri"/>
            <uri prefix='&mesh;'>activeMeSHYear</uri>
            <literal>
              <xsl:value-of select="."/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>

      <xsl:for-each select="AllowableQualifiersList/AllowableQualifier">
        <xsl:variable name='qualifier_uri'>
          <uri prefix='&mesh;'>
            <xsl:value-of select="QualifierReferredTo/QualifierUI"/>
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
            <uri prefix='&mesh;'>allowableQualifier</uri>
            <xsl:copy-of select='$qualifier_uri'/>
          </xsl:with-param>
        </xsl:call-template>
        
        <!--
          Transformation rule: rdf:type
         -->
        <xsl:call-template name="triple">
          <xsl:with-param name="doc">
            <desc>This relation states that a Subject node used to identify a Descriptor record is of type "Descritpor".</desc>
          </xsl:with-param>
          <xsl:with-param name="spec">
            <xsl:copy-of select='$qualifier_uri'/>
            <uri prefix='&rdf;'>type</uri>
            <uri prefix='&mesh;'>Qualifier</uri>
          </xsl:with-param>
        </xsl:call-template>
        
        <!--
          Transformation rule: dcterms:identifier
        -->
        <xsl:call-template name="triple">
          <xsl:with-param name="doc">
            <desc>This relation states that an allowable qualifier has a unique identifier.</desc>
          </xsl:with-param>
          <xsl:with-param name="spec">
            <xsl:copy-of select='$qualifier_uri'/>
            <uri prefix='&dcterms;'>identifier</uri>
            <literal>
              <xsl:value-of select="QualifierReferredTo/QualifierUI"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
        
        <!--
          Transformation rule: rdfs:label
        -->
        <xsl:call-template name="triple">
          <xsl:with-param name="doc">
            <desc>This relation states that an allowable qualifier has a name.</desc>
          </xsl:with-param>
          <xsl:with-param name="spec">
            <xsl:copy-of select='$qualifier_uri'/>
            <uri prefix='&rdfs;'>label</uri>
            <literal>
              <xsl:value-of select="QualifierReferredTo/QualifierName/String"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
        
        <!--
          Transformation rule: abbreviation
        -->
        <xsl:call-template name="triple">
          <xsl:with-param name="doc">
            <desc>This relation states that an allowable qualifier has an abbreviation.</desc>
          </xsl:with-param>
          <xsl:with-param name="spec">
            <xsl:copy-of select='$qualifier_uri'/>
            <uri prefix='&mesh;'>abbreviation</uri>
            <literal>
              <xsl:value-of select="Abbreviation"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
        
      </xsl:for-each>
      
      <!--
        Transformation rule: historyNote
      -->
      <xsl:if test="HistoryNote">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>This relation states that a descriptor has a history note.</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$descriptor_uri"/>
            <uri prefix='&mesh;'>historyNote</uri>
            <literal>
              <xsl:value-of select="HistoryNote"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>
      
      <!--
        Transformation rule: onlineNote
      -->
      <xsl:if test="OnlineNote">
        <xsl:call-template name='triple'>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$descriptor_uri"/>
            <uri prefix='&mesh;'>onlineNote</uri>
            <literal>
              <xsl:value-of select="OnlineNote"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>
      
      <!--
        Transformation rule: publicMeSHNote
      -->
      <xsl:if test="PublicMeSHNote">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>This relation states that a descriptor has a public MeSH note.</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$descriptor_uri"/>
            <uri prefix='&mesh;'>publicMeSHNote</uri>
            <literal>
              <xsl:value-of select="PublicMeSHNote"/>
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
            <desc>This relation states that a descriptor has some previous indexing.</desc>
            <fixme>Whether there is any use in parsing the previous indexing text to derive 
              other triples.</fixme>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$descriptor_uri"/>
            <uri prefix='&mesh;'>previousIndexing</uri>
            <literal>
              <xsl:value-of select="."/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>
      
      <!--
        Transformation rule: pharmacologicalAction>
      -->
      <xsl:for-each select="PharmacologicalActionList/PharmacologicalAction">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>This relation states that a descriptor hasa pharmacological action.</desc>
            <fixme>The pharmacological action is represented here as a &lt;desc_uri>. That is, 
              as a descriptor unique identifier. I felt this was the best thing to do since the 
              pharmacological action consists of a descriptor unique identifier and a name.
              But this information is already obtained by the XSLT code when it extracts the relations 
              in RDF. We can always get the name referred to by the pharmacological action by fetching 
              the name corresponding to the descriptor unique identifier, the &lt;desc_uri>.</fixme>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$descriptor_uri"/>
            <uri prefix='&mesh;'>pharmacologicalAction</uri>
            <uri prefix='&mesh;'>
              <xsl:value-of select="DescriptorReferredTo/DescriptorUI"/>
            </uri>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>
      
      <!-- 
        Transformation rule: treeNumber
      -->
      <xsl:for-each select="TreeNumberList/TreeNumber">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>Every MeSH descriptor record can have some integer number of tree numbers. These are presented as characters separated by perionds in the MeSH browser under the 
              "Tree Number" relation. I named this the hasTreeNumber relation in RDF.</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$descriptor_uri"/>
            <uri prefix='&mesh;'>treeNumber</uri>
            <literal>
              <xsl:value-of select="."/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>
      
      <!--
        Transformation rule: recordOriginator
      -->
      <xsl:if test="RecordOriginatorsList">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>This relation states that a descriptor has a record originator</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$descriptor_uri"/>
            <uri prefix='&mesh;'>recordOriginator</uri>
            <literal>
              <xsl:value-of select="RecordOriginatorsList/RecordOriginator"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
        
        <!--
          Transformation rule: recordMaintainer
        -->
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>This relation states that a descriptor has a record maintainer</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$descriptor_uri"/>
            <uri prefix='&mesh;'>recordMaintainer</uri>
            <literal>
              <xsl:value-of select="RecordOriginatorsList/RecordMaintainer"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
        
        <!--
          Transformation rule: recordAuthorizer
        -->
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>This relation states that a descriptor has a record authorizer</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$descriptor_uri"/>
            <uri prefix='&mesh;'>recordAuthorizer</uri>
            <literal>
              <xsl:value-of select="RecordOriginatorsList/RecordAuthorizer"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>
      
      <xsl:for-each select="ConceptList/Concept">
        <!-- $concept_uri is used in many calls to the `triple` template below -->
        <xsl:variable name='concept_uri'>
          <uri prefix='&mesh;'>
            <xsl:value-of select="ConceptUI"/>
          </uri>
        </xsl:variable>

        <!--
          Transformation rule: concept
        -->
        <xsl:call-template name="triple">
          <xsl:with-param name="doc">
            <desc>This relation states that a descriptor record has a concept.</desc>
          </xsl:with-param>
          <xsl:with-param name="spec">
            <xsl:copy-of select="$descriptor_uri"/>
            <uri prefix='&mesh;'>concept</uri>
            <xsl:copy-of select="$concept_uri"/>
          </xsl:with-param>
        </xsl:call-template>

        <!--
          Transformation rule: rdf:type
        -->
        <xsl:call-template name="triple">
          <xsl:with-param name="doc">
            <desc>This relation states that a Subject node used to identify a concept 
              is of type "Concept".</desc>
          </xsl:with-param>
          <xsl:with-param name="spec">
            <xsl:copy-of select="$concept_uri"/>
            <uri prefix='&rdf;'>type</uri>
            <uri prefix='&mesh;'>Concept</uri>
          </xsl:with-param>
        </xsl:call-template>

        <!--
          Transformation rule: isPreferredConcept
        -->
        <xsl:call-template name="triple">
          <xsl:with-param name="doc">
            <desc>This relation states that yes, "Y", a concept is the preferred concept or 
              no, "N", the concept is not the preferred concept.</desc>
            <fixme>Wouldn't it be better to define a PreferredConcept class, and use that as
              this concept's rdf:type, instead of have a triple with a literal "Y" or "N"
              value?</fixme>
          </xsl:with-param>
          <xsl:with-param name="spec">
            <xsl:copy-of select="$concept_uri"/>
            <uri prefix='&mesh;'>isPreferredConcept</uri>
            <literal>
              <xsl:value-of select="@PreferredConceptYN"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
        
        <!--
          Transformation rule: rdfs:label
        -->
        <xsl:call-template name="triple">
          <xsl:with-param name="doc">
            <desc>This relation states that a concept has a concept name.</desc>
          </xsl:with-param>
          <xsl:with-param name="spec">
            <xsl:copy-of select="$concept_uri"/>
            <uri prefix='&rdfs;'>label</uri>
            <literal>
              <xsl:value-of select="ConceptName/String"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>

        <!--
          Transformation rule: dcterms:identifier
        -->
        <xsl:call-template name="triple">
          <xsl:with-param name="doc">
            <desc>This relation states that a concept has a unique identifier.</desc>
          </xsl:with-param>
          <xsl:with-param name="spec">
            <xsl:copy-of select="$concept_uri"/>
            <uri prefix='&dcterms;'>identifier</uri>
            <literal>
              <xsl:value-of select="ConceptUI"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>

        <xsl:if test="CASN1Name">
          <!--
            Transformation rule: CASN1_label
          -->    
          <xsl:call-template name="triple">
            <xsl:with-param name="doc">
              <desc>This relation states that a concept has a Chemical Abstracts Type N1 Name.</desc>
              <fixme>Do we want to parse the CASN1Name (e.g. for other purposes)?</fixme>
            </xsl:with-param>
            <xsl:with-param name="spec">
              <xsl:copy-of select="$concept_uri"/>
              <uri prefix='&mesh;'>CASN1_label</uri>
              <literal>
                <xsl:value-of select="CASN1Name"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>

        <xsl:if test="RegistryNumber">
          <!--
            Transformation rule: registryNumber
          -->
          <xsl:call-template name="triple">
            <xsl:with-param name="doc">
              <desc>This relation states that a concept has a registry number.</desc>
            </xsl:with-param>
            <xsl:with-param name="spec">
              <xsl:copy-of select="$concept_uri"/>
              <uri prefix='&mesh;'>registryNumber</uri>
              <literal>
                <xsl:value-of select="RegistryNumber"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>

        <xsl:if test="ScopeNote">
          <!--
            Transformation rule: skos:scopeNote
          -->
          <xsl:call-template name="triple">
            <xsl:with-param name="doc">
              <desc>This relation states tht a concept has a scope note.</desc>
            </xsl:with-param>
            <xsl:with-param name="spec">
              <xsl:copy-of select="$concept_uri"/>
              <uri prefix='&skos;'>scopeNote</uri>
              <literal>
                <xsl:value-of select="ScopeNote"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>

        <xsl:if test="SemanticTypeList">
          <xsl:for-each select="SemanticTypeList/SemanticType">
            <xsl:variable name='semantic_type_uri'>
              <uri prefix='&mesh;'>
                <xsl:value-of select="SemanticTypeUI"/>
              </uri>
            </xsl:variable>

            <!--
              Transformation rule: semanticType
            -->            
            <xsl:call-template name="triple">
              <xsl:with-param name="doc">
                <desc>This relation states that a concept has a semantic type.</desc>
                <fixme></fixme>
              </xsl:with-param>
              <xsl:with-param name="spec">
                <xsl:copy-of select="$concept_uri"/>
                <uri prefix='&mesh;'>semanticType</uri>
                <xsl:copy-of select="$semantic_type_uri"/>
              </xsl:with-param>
            </xsl:call-template>

            <!--
              Transformation rule: rdf:type
            -->
            <xsl:call-template name="triple">
              <xsl:with-param name="doc">
                <desc>Specifies the class of the semantic type resource.</desc>
              </xsl:with-param>
              <xsl:with-param name="spec">
                <xsl:copy-of select="$semantic_type_uri"/>
                <uri prefix='&rdf;'>type</uri>
                <uri prefix='&mesh;'>SemanticType</uri>
              </xsl:with-param>
            </xsl:call-template>
 
            <!--
              Transformation rule: rdfs:label
            -->
            <xsl:call-template name="triple">
              <xsl:with-param name="doc">
                <desc>This rule states the a semantic type unique identifier has a semantic type name.</desc>
                <fixme>I'm not sure if this relation is correct. But we've created this 
                  type of relation for the concepts of a descriptor. We should check this (for e.g.,
                  with a MeSH expert or by a literature search).</fixme>
              </xsl:with-param>
              <xsl:with-param name="spec">
                <xsl:copy-of select="$semantic_type_uri"/>
                <uri prefix='&rdfs;'>label</uri>
                <literal>
                  <xsl:value-of select="SemanticTypeName"/>
                </literal>
              </xsl:with-param>
            </xsl:call-template>

            <!--
              Transformation rule: dcterms:identifier
            -->
            <xsl:call-template name="triple">
              <xsl:with-param name="doc">
                <desc>This rule states that a semantic type has a unique identifier.</desc>
              </xsl:with-param>
              <xsl:with-param name="spec">
                <xsl:copy-of select="$semantic_type_uri"/>
                <uri prefix='&dcterms;'>identifier</uri>
                <literal>
                  <xsl:value-of select="SemanticTypeUI"/>
                </literal>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:if>

        <xsl:if test="RelatedRegistryNumberList">
          <xsl:for-each select="RelatedRegistryNumberList/RelatedRegistryNumber">
            <!--
              Transformation rule: relatedRegistryNumber
            -->
            <xsl:call-template name="triple">
              <xsl:with-param name="doc">
                <desc>This relation states that a concept has a related registry number.</desc>
                <fixme>Maybe it would be good to reduce this value to only a number. But 
                  I'm not sure. Need to check with a MeSH expert to see how important is the text
                  after the number.</fixme>
              </xsl:with-param>
              <xsl:with-param name="spec">
                <xsl:copy-of select="$concept_uri"/>
                <uri prefix='&mesh;'>relatedRegistryNumber</uri>
                <literal>
                  <xsl:value-of select="."/>
                </literal>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:if>

        <xsl:if test="ConceptRelationList">
          <xsl:for-each select="ConceptRelationList/ConceptRelation">
            <xsl:variable name='blank_node'>
              <named>
                <xsl:text>_:blank_set1_</xsl:text>
                <xsl:value-of select="../../ConceptUI"/>
                <xsl:text>_</xsl:text>
                <xsl:value-of select="position()"/>
              </named>
            </xsl:variable>

            <xsl:call-template name="triple">
              <xsl:with-param name="spec">
                <xsl:copy-of select="$concept_uri"/>
                <uri prefix='&mesh;'>conceptRelation</uri>
                <xsl:copy-of select="$blank_node"/>
              </xsl:with-param>
            </xsl:call-template>
            
            <xsl:call-template name="triple">
              <xsl:with-param name="spec">
                <xsl:copy-of select="$blank_node"/>
                <uri prefix='&rdf;'>type</uri>
                <uri prefix='&mesh;'>ConceptRelation</uri>
              </xsl:with-param>
            </xsl:call-template>            
            
            <xsl:if test="@RelationName">
              <xsl:call-template name="triple">
                <xsl:with-param name="spec">
                  <xsl:copy-of select="$blank_node"/>
                  <uri prefix='&mesh;'>relation</uri>
                  <xsl:copy-of select="f:skos_relation_uri(@RelationName)"/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:if>

            <xsl:call-template name="triple">
              <xsl:with-param name="spec">
                <xsl:copy-of select="$blank_node"/>
                <uri prefix='&mesh;'>concept1</uri>
                <uri prefix='&mesh;'>
                  <xsl:value-of select="Concept1UI"/>
                </uri>
              </xsl:with-param>
            </xsl:call-template>
            
            <xsl:call-template name="triple">
              <xsl:with-param name="spec">
                <xsl:copy-of select="$blank_node"/>
                <uri prefix='&mesh;'>concept2</uri>
                <uri prefix='&mesh;'>
                  <xsl:value-of select="Concept2UI"/>
                </uri>
              </xsl:with-param>
            </xsl:call-template>
            
            <!-- added by rw -->
            <xsl:if test="RelationAttribute">
              <xsl:call-template name="triple">
                <xsl:with-param name="spec">
                  <xsl:copy-of select="$blank_node"/>
                  <uri prefix='&mesh;'>relationAttribute</uri>
                  <literal>
                    <xsl:value-of select="RelationAttribute"/>
                  </literal>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:if>
          </xsl:for-each>
        </xsl:if>

        <xsl:for-each select="TermList/Term">
          <xsl:variable name='term_uri'>
            <uri prefix='&mesh;'>
              <xsl:value-of select="TermUI"/>
            </uri>
          </xsl:variable>
          
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>This relation states that a concept has a term.</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$concept_uri"/>
              <uri prefix='&mesh;'>term</uri>
              <xsl:copy-of select='$term_uri'/>
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
              <xsl:copy-of select='$term_uri'/>
              <uri prefix='&rdf;'>type</uri>
              <uri prefix='&mesh;'>Term</uri>
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
              <xsl:copy-of select='$term_uri'/>
              <uri prefix='&dcterms;'>identifier</uri>
              <literal>
                <xsl:value-of select="TermUI"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>
          
          <xsl:if test="@IsPermutedTermYN = 'N'">
            <xsl:call-template name='triple'>
              <xsl:with-param name='spec'>
                <xsl:copy-of select='$term_uri'/>
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
              <fixme>This relation was created in order to stick with the XML representation of MeSH.</fixme>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select='$term_uri'/>
              <uri prefix='&mesh;'>termData</uri>
              <xsl:copy-of select='$term_data_blank'/>
            </xsl:with-param>
          </xsl:call-template>
          
          <!--
            Transformation rule/Relation: rdf:type
          -->
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>This relation states that a Subject node used to identify term data is 
                of type "TermData".</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select='$term_data_blank'/>
              <uri prefix='&rdf;'>type</uri>
              <uri prefix='&mesh;'>TermData</uri>
            </xsl:with-param>
          </xsl:call-template>
          
          <!--
            Transformation rule: isConceptPreferredTerm
          -->
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <fixme>As with concept, wouldn't it be better to define a superclass for this, rather than
                use a literal value?</fixme>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select='$term_data_blank'/>
              <uri prefix='&mesh;'>isConceptPreferredTerm</uri>
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
              <desc>This relation states that a term can be a permuted term. But it does so 
                indirectly because the isPermutedTerm relation is with a blank node.</desc>
              <fixme>Can we use a class for this, rather than a literal value?</fixme>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select='$term_data_blank'/>
              <uri prefix='&mesh;'>isPermutedTerm</uri>
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
              <desc>This relation states that a term has a lexical tag. But it does so 
                indirectly becuase the hasLexicalTag relation is with a blank node.</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select='$term_data_blank'/>
              <uri prefix='&mesh;'>lexicalTag</uri>
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
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select='$term_data_blank'/>
              <uri prefix='&mesh;'>printFlag</uri>
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
              <desc>This relation states that a term can be a record preferred term. But it does 
                this indirectly because the relation is with a blank node.</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select='$term_data_blank'/>
              <uri prefix='&mesh;'>isRecordPreferredTerm</uri>
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
              <desc>This relation states that a term has a term unique identifier. However, it 
                does so indirectly because the relation is with a blank node.</desc>
              <fixme reporter='klortho'>I don't understand why the blank node, with a well defined term_id, is being 
                used here.</fixme>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select='$term_data_blank'/>
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
              <desc>This relation states that a term has a term name. But it does so 
                indirectly because the relation is with a blank node.</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select='$term_data_blank'/>
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
                <fixme>Is this date-string creation method robust enough?</fixme>
              </xsl:with-param>
              <xsl:with-param name='spec'>
                <xsl:copy-of select='$term_data_blank'/>
                <uri prefix='&mesh;'>dateCreated</uri>
                <literal>
                  <xsl:value-of select="string-join((DateCreated/Year,DateCreated/Month,DateCreated/Day),'-')"/>
                </literal>
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
                <xsl:copy-of select='$term_data_blank'/>
                <uri prefix='&mesh;'>abbreviation</uri>
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
                <xsl:copy-of select='$term_data_blank'/>
                <uri prefix='&mesh;'>sortVersion</uri>
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
                <xsl:copy-of select='$term_data_blank'/>
                <uri prefix='&mesh;'>entryVersion</uri>
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
            <xsl:for-each select="ThesaurusIDlist/ThesaurusID">
              <xsl:call-template name='triple'>
                <xsl:with-param name="doc">
                  <desc>This relation states that a term has a thesaurus ID.</desc>
                </xsl:with-param>
                <xsl:with-param name='spec'>
                  <xsl:copy-of select='$term_data_blank'/>
                  <uri prefix='&mesh;'>thesaurusID</uri>
                  <literal>
                    <xsl:value-of select="."/>
                  </literal>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:for-each>
          </xsl:if>
        </xsl:for-each>
      </xsl:for-each>

      <xsl:for-each select="EntryCombinationList/EntryCombination">
        
        <!--
          Transformation rule: entryCombination
        -->
        <xsl:variable name='entry_combination_blank'>
          <named>
            <xsl:text>_:blank</xsl:text>
            <xsl:value-of select="../../DescriptorUI"/>
            <xsl:text>_</xsl:text>
            <xsl:value-of select="position()"/>
          </named>
        </xsl:variable>
        
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>This relation states that a descriptor record has a entry combination. The entry
              combination has an ECIN and an ECOUT (see below). </desc>
            <fixme>See GitHub issue #10</fixme>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select='$descriptor_uri'/>
            <uri prefix='&mesh;'>entryCombination</uri>
            <xsl:copy-of select="$entry_combination_blank"/>
          </xsl:with-param>
        </xsl:call-template>
        
        <!--
          Transformation rule/Relation: rdf:type
        -->
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>This relation states that a Subject node used to identify an entry 
              combination is of type "EntryCombination".</desc>
            <fixme></fixme>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select='$entry_combination_blank'/>
            <uri prefix='&rdf;'>type</uri>
            <uri prefix='&mesh;'>EntryCombination</uri>
          </xsl:with-param>
        </xsl:call-template>
        
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select='$entry_combination_blank'/>
            <uri prefix='&mesh;'>ECINDescriptor</uri>
            <uri prefix='&mesh;'>
              <xsl:value-of select="ECIN/DescriptorReferredTo/DescriptorUI"/>
            </uri>
          </xsl:with-param>
        </xsl:call-template>

        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select='$entry_combination_blank'/>
            <uri prefix='&mesh;'>ECINQualifier</uri>
            <uri prefix='&mesh;'>
              <xsl:value-of select="ECIN/QualifierReferredTo/QualifierUI"/>
            </uri>
          </xsl:with-param>
        </xsl:call-template>
        
        <xsl:call-template name='triple'>
          <xsl:with-param name='spec'>
            <xsl:copy-of select='$entry_combination_blank'/>
            <uri prefix='&mesh;'>ECOUTDescriptor</uri>
            <uri prefix='&mesh;'>
              <xsl:value-of select="ECOUT/DescriptorReferredTo/DescriptorUI"/>
            </uri>
          </xsl:with-param>
        </xsl:call-template>
        
        <xsl:if test="ECOUT/QualifierReferredTo">
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select='$entry_combination_blank'/>
              <uri prefix='&mesh;'>ECOUTQualifier</uri>
              <uri prefix='&mesh;'>
                <xsl:value-of select="ECOUT/QualifierReferredTo/QualifierUI"/>
              </uri>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
      </xsl:for-each>

      <!--
        Transformation rule: annotation
      -->
      <xsl:if test="Annotation">
        <!-- This if statement is necessary to ensure that the hasAnnotation relationship is 
          extracted ONLY when the Annotation element exists for a descriptor record. This if 
          statements checks to see if the element Annotation exists for a descriptor record. -->
        <!-- hasAnnotation -->

        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>This rule states that a descriptor record has an annotation.</desc>
            <fixme>Every MeSH descriptor can have an annotation. This rule extracts that annotation and converts it into a string. But sometimes, if not always, the annotation will
              have a link to another descriptor. Hence, we might have to decipher a way to express this in our RDF conversion. This might require some NLP? For now however, the 
              annotation is simply converted to a string data type.</fixme>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$descriptor_uri"/>
            <uri prefix='&mesh;'>annotation</uri>
            <literal>
              <xsl:value-of select="Annotation"/>
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
            <uri prefix='&mesh;'>runningHead</uri>
            <literal>
              <xsl:value-of select="RunningHead"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>

      <!--
        Transformation rules: seeAlso, hasRelatedDescriptor
      -->
      <xsl:for-each select="SeeRelatedList/SeeRelatedDescriptor">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>This relation is different from what a person would see in the 
              MeSH browser. In the browser one would see `&lt;desc_uri> seeAlso "name"`.
              The `&lt;desc_uri> hasRelatedDescriptor &lt;desc_uri>` is where I decided to deviate from what 
              I saw in the browser b/c the descriptor UI remains unchanged even though the 
              descriptor name can change.</desc>
            <fixme>I felt that some of the information in the SeeRelatedList element was 
              repetative b/c it consisted of a list of descriptor unique identifiers and names. Hence, 
              I decided to use the output specified above b/c we could always access the unique 
              identifier and name for a descriptor given its unique identifier, we extract this 
              information from the XML already. I thought the hasRelatedDescriptor relation was more 
              expressive and explicit in this case than the seeAlso relation.</fixme>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$descriptor_uri"/>
            <uri prefix='&rdfs;'>seeAlso</uri>
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
            <fixme>Maybe we can break this up into several considerTermsAt</fixme>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$descriptor_uri"/>
            <uri prefix='&mesh;'>considerAlso</uri>
            <literal>
              <xsl:value-of select="ConsiderAlso"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
