<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY dcterms "http://purl.org/dc/terms/">
  <!ENTITY mesh "http://nlm.nih.gov#MeSH:">
  <!ENTITY rdf "http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <!ENTITY rdfs "http://www.w3.org/2000/01/rdf-schema#">
  <!ENTITY skos "http://www.w3.org/2004/02/skos/core#">
]>

<xsl:stylesheet version="2.0" 
                xmlns:defaultns="http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#"
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
        Transformation rule/Relation: rdf:type
      -->
      <xsl:call-template name='triple'>
        <xsl:with-param name="doc">
          <output>*qualifier_uri* rdf:type mesh:Qualifier</output>
          <desc>This relation states that a Subject node used to identify a Qualifier is of type "Qualifier".</desc>
        </xsl:with-param>
        <xsl:with-param name='spec'>
          <xsl:copy-of select="$qualifier_uri"/>
          <uri prefix='&rdf;'>type</uri>
          <uri prefix='&mesh;'>Qualifier</uri>
        </xsl:with-param>
      </xsl:call-template>
      
      <!--
        Transformation rule/Relation: dcterms:identifier
      -->
      <xsl:call-template name='triple'>
        <xsl:with-param name="doc">
          <output>*qualifier_uri* dcterms:identifier *qualifier_id*</output>
          <desc>This relation states that a qualifier has a qualifier identifier.</desc>
        </xsl:with-param>
        <xsl:with-param name='spec'>
          <xsl:copy-of select="$qualifier_uri"/>
          <uri prefix='&dcterms;'>identifier</uri>
          <literal>
            <xsl:value-of select="QualifierUI"/>
          </literal>
        </xsl:with-param>
      </xsl:call-template>

      <!--
        Transformation rule/Relation: isQualifierType
      -->
      <xsl:call-template name='triple'>
        <xsl:with-param name="doc">
          <output>*qualifier_uri* mesh:isQualifierType *qualifier_type*</output>
          <desc>This relation states that a qualifier has a qualifier type.</desc>
        </xsl:with-param>
        <xsl:with-param name='spec'>
          <xsl:copy-of select="$qualifier_uri"/>
          <uri prefix='&mesh;'>isQualifierType</uri>
          <literal>
            <xsl:value-of select="@QualifierType"/>
          </literal>
        </xsl:with-param>
      </xsl:call-template>

      <!--
        Transformation rule/Relation: rdfs:label
      -->
      <xsl:call-template name='triple'>
        <xsl:with-param name="doc">
          <output>*qualifier_uri* rdfs:label *qualifier_name*</output>
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
        Transformation rule/Relation: dateCreated
      -->
      <xsl:call-template name='triple'>
        <xsl:with-param name="doc">
          <output>*qualifier_uri* mesh:dateCreated *object*</output>
          <desc>This relation states that a qualifier has a date on which it was created.</desc>
        </xsl:with-param>
        <xsl:with-param name='spec'>
          <xsl:copy-of select="$qualifier_uri"/>
          <uri prefix='&mesh;'>dateCreated</uri>
          <literal>
            <xsl:value-of select="string-join((DateCreated/Year,DateCreated/Month,DateCreated/Day),'-')"/>
          </literal>
        </xsl:with-param>
      </xsl:call-template>
      
      <!--
        Transformation rule/Relation: dateRevised
      -->
      <xsl:if test="DateRevised">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <output>*qualifier_uri* mesh:dateRevised *date-revised*</output>
            <desc>A qualifier can have a date on which it was revised.</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$qualifier_uri"/>
            <uri prefix='&mesh;'>dateRevised</uri>
            <literal>
              <xsl:value-of select="string-join((DateRevised/Year,DateRevised/Month,DateRevised/Day),'-')"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>

      <!--
        Transformation rule/Relation: dateEstablished
      -->
      <xsl:if test="DateEstablished">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <output>*qualifier_uri* mesh:dateEstablished *date_established*</output>
            <desc>A qualifier can have a date on which it was established.</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$qualifier_uri"/>
            <uri prefix='&mesh;'>dateEstablished</uri>
            <literal>
              <xsl:value-of select="string-join((DateEstablished/Year,DateEstablished/Month,DateEstablished/Day),'-')"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>

      <!--
        Transformation rule/Relation: activeMeSHYear
      -->
      <xsl:for-each select="ActiveMeSHYearList/Year">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <output>*qualifier_uri* mesh:activeMeSHYear *active-mesh-year*</output>
            <desc>Every qualifier has at least one year in which the record was active since it was last modified.</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$qualifier_uri"/>
            <uri prefix='&mesh;'>activeMeSHYear</uri>
            <literal>
              <xsl:value-of select="."/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>

      <!--
        Transformation rule:Relation: annotation
      -->
      <xsl:if test="Annotation">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <output>*qualifier_uri* mesh:annotation *annotation*</output>
            <desc>A Qualifier can have an annotation.</desc>
            <fixme>This rule extracts that annotation and converts it into a string. But sometimes, if not always, the annotation will
              have a link to another qualifier or some manual. Hence, we might have to decipher a way to express this in our RDF conversion. 
              This might require some NLP? For now however, the annotation is simply converted to a string data type.</fixme>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$qualifier_uri"/>
            <uri prefix='&mesh;'>property</uri>
            <literal>
              <xsl:value-of select="Annotation"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>

      <!--
        Transformation rule: historyNote
      -->
      <xsl:if test="HistoryNote">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <output>*qualifier_uri* mesh:historyNote *history-note*</output>
            <desc>A qualifier can have a history note.</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$qualifier_uri"/>
            <uri prefix='&mesh;'>historyNote</uri>
            <literal>
              <xsl:value-of select="HistoryNote"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>

      <!--
        Transformation rule/Relation: onlineNote
      -->
      <xsl:if test="OnlineNote">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <output>*qualifier_uri* mesh:onlineNote *online-note*</output>
            <desc>A qualifier can have an online note.</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$qualifier_uri"/>
            <uri prefix='&mesh;'>onlineNote</uri>
            <literal>
              <xsl:value-of select="OnlineNote"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>

      <!--
        Transformation rule: treeNumber
      -->
      <xsl:if test="TreeNumberList">
        <xsl:for-each select="TreeNumberList/TreeNumber">
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <output>*qualifier_uri* mesh:treeNumber *object*</output>
              <desc>A qualifier can have a tree number.</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$qualifier_uri"/>
              <uri prefix='&mesh;'>treeNumber</uri>
              <literal>
                <xsl:value-of select="."/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:if>

      <!--
        Transformation rule: allowedTreeNode
      -->
      <xsl:if test="TreeNodeAllowedList">
        <xsl:for-each select="TreeNodeAllowedList/TreeNodeAllowed">
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <output>*qualifier_uri* mesh:allowedTreeNode *allowed-tree-node*</output>
              <desc>A qualifier can have at least one allowed tree node.</desc>
              <fixme></fixme>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$qualifier_uri"/>
              <uri prefix='&mesh;'>allowedTreeNode</uri>
              <literal>
                <xsl:value-of select="."/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:if>

      <xsl:if test="RecordOriginatorsList">
        <!--
          Transformation rule: recordOriginator
        -->
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <output>*qualifier_uri* mesh:recordOriginator *record-originator*</output>
            <desc>A qualifier has a record originator</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$qualifier_uri"/>
            <uri prefix='&mesh;'>recordOriginator</uri>
            <literal>
              <xsl:value-of select="RecordOriginatorsList/RecordOriginator"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>

        <!--
          Transformation rule: recordMaintainer
        -->
        <xsl:if test="RecordOriginatorsList/RecordMaintainer">
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <output>*qualifier_uri* mesh:recordMaintainer *record-maintainerject*</output>
              <desc>A qualifier has a record maintainer</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$qualifier_uri"/>
              <uri prefix='&mesh;'>recordMaintainer</uri>
              <literal>
                <xsl:value-of select="RecordOriginatorsList/RecordMaintainer"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>

        <!--
          Transformation rule: recordAuthorizer
        -->
        <xsl:if test="RecordOriginatorsList/RecordAuthorizer">
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <output>*qualifier_uri* mesh:recordAuthorizer *authorizer*</output>
              <desc>A qualifier has a record authorizer</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$qualifier_uri"/>
              <uri prefix='&mesh;'>recordAuthorizer</uri>
              <literal>
                <xsl:value-of select="RecordOriginatorsList/RecordAuthorizer"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
      </xsl:if>

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
          <xsl:with-param name="doc">
            <output>*qualifier_uri* mesh:concept *concept_uri*</output>
            <desc>A qualifier has at least one concept.</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$qualifier_uri"/>
            <uri prefix='&mesh;'>concept</uri>
            <xsl:copy-of select='$concept_uri'/>
          </xsl:with-param>
        </xsl:call-template>

        <!--
          Transformation rule: rdf:type
        -->
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <output>*concept_uri* rdf:type mesh:Concept*</output>
            <desc>This relation states that a Subject node used to identify a concept is of type "Concept".</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select='$concept_uri'/>
            <uri prefix='&rdf;'>type</uri>
            <uri prefix='&mesh;'>Concept</uri>
          </xsl:with-param>
        </xsl:call-template>

        <!--
          Transformation rule/Relation: isPreferredConcept
        -->
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <output>*concept_uri* mesh:isPreferredConcept *object*</output>
            <desc>A concept will or will not be the preferred concept associated with a Qualifier.</desc>
            <fixme>As with a few cases in desc, I [cfm] think using a different class here would be better
              than a literal Y/N value.</fixme>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select='$concept_uri'/>
            <uri prefix='&mesh;'>isPreferredConcept</uri>
            <literal>
              <xsl:value-of select="@PreferredConceptYN"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>

        <!--
          Transformation rule: rdfs:label
        -->
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <output>*concept_uri* rdfs:label *label*</output>
            <desc>A concept has a name.</desc>
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
          Transformation rule/Relation: dcterms:identifier
        -->
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <output>*concept_uri* dcterms:identifier *concept-identifier*</output>
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
          Transformation rule: skos:scopeNote
        -->
        <xsl:if test="ScopeNote">
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <output>*concept_uri* skos:scopeNote *scope-note*</output>
              <desc>A concept can have a scope note.</desc>
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


        <xsl:if test="SemanticTypeList">
          <xsl:for-each select="SemanticTypeList/SemanticType">
            <xsl:variable name='semantic_type_uri'>
              <uri prefix='&mesh;'>
                <xsl:value-of select="SemanticTypeUI"/>
              </uri>
            </xsl:variable>

            <!--
              Transformation rule: SemanticType
            -->
            <xsl:call-template name='triple'>
              <xsl:with-param name="doc">
                <output>*semantic_type_uri* rdf:type mesh:SemanticType</output>
                <desc>A concept can have a semantic type UI and semantic type name. However, I abstracted 
                  this relation into the formulation stated in the output above. In this formulation, the concept 
                  has a semantic type which in turn has a UI and name.</desc>
              </xsl:with-param>
              <xsl:with-param name='spec'>
                <xsl:copy-of select="$semantic_type_uri"/>
                <uri prefix='&rdf;'>type</uri>
                <uri prefix='&mesh;'>SemanticType</uri>
              </xsl:with-param>
            </xsl:call-template>

            <!--
              Transformation rule: semanticType
            -->
            <xsl:call-template name='triple'>
              <xsl:with-param name="doc">
                <output>*concept_uri* mesh:semanticType *semantic_type_uri*</output>
                <desc></desc>
              </xsl:with-param>
              <xsl:with-param name='spec'>
                <xsl:copy-of select="$concept_uri"/>
                <uri prefix='&mesh;'>semanticType</uri>
                <xsl:copy-of select="$semantic_type_uri"/>
              </xsl:with-param>
            </xsl:call-template>

            <!--
              Transformation rule: dcterms:identifier
            -->
            <xsl:call-template name='triple'>
              <xsl:with-param name="doc">
                <output>*semantic_type_uri* dcterms:identifier *semantic_type_id*</output>
                <desc></desc>
              </xsl:with-param>
              <xsl:with-param name='spec'>
                <xsl:copy-of select="$semantic_type_uri"/>
                <uri prefix='&dcterms;'>identifier</uri>
                <literal>
                  <xsl:value-of select="SemanticTypeUI"/>
                </literal>
              </xsl:with-param>
            </xsl:call-template>

            <!--
              Transformation rule: rdfs:label
            -->
            <xsl:call-template name='triple'>
              <xsl:with-param name="doc">
                <output>*semantic_type_uri* rdfs:label *semantic_type_name*</output>
                <desc></desc>
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
        </xsl:if>

        <xsl:if test="ConceptRelationList">
          <xsl:for-each select="ConceptRelationList/ConceptRelation">
            <xsl:variable name='blank_concept_relation'>
              <named>
                <xsl:text>_:blank_set1_</xsl:text>
                <xsl:value-of select="../../ConceptUI"/>
                <xsl:text>_</xsl:text>
                <xsl:value-of select="position()"/>
              </named>
            </xsl:variable>

            <!-- 
              Transformation rule: conceptRelation
            -->
            <xsl:call-template name='triple'>
              <xsl:with-param name="doc">
                <output>*concept_uri* mesh:conceptRelation *blank_concept_relation*</output>
                <desc>There are several predicates mentioned here. The conceptRelation states that a concept has a relation to another concept.
                  That relation is identified with a blank node. This blank node stores the information that describes how the current concept (concept1) is 
                  related to a second concept (concept2). The first concept is either broader, narrower, or related, in relation to the second concept. We
                  use the skos:broader, skos:narrower, and skos:related predicates in this case.
                  This rule applies when a qualifier has a concept in its concept list that possesses a concept relation list. If this is the case,
                  then there will be at least one concept relation in the concept relation list.</desc>
                <fixme>Do we need to use a blank node here?</fixme>
              </xsl:with-param>
              <xsl:with-param name='spec'>
                <xsl:copy-of select="$concept_uri"/>
                <uri prefix='&mesh;'>conceptRelation</uri>
                <xsl:copy-of select="$blank_concept_relation"/>
              </xsl:with-param>
            </xsl:call-template>
            
            <!-- 
              Transformation rule: rdf:type
            -->
            <xsl:call-template name='triple'>
              <xsl:with-param name="doc">
                <output>*blank_concept_relation* rdf:type mesh:ConceptRelation</output>
                <desc></desc>
              </xsl:with-param>
              <xsl:with-param name='spec'>
                <xsl:copy-of select="$blank_concept_relation"/>
                <uri prefix='&rdf;'>type</uri>
                <uri prefix='&mesh;'>ConceptRelation</uri>
              </xsl:with-param>
            </xsl:call-template>
            
            <!-- 
              Transformation rule: mesh:relation
            -->
            <xsl:if test="@RelationName">
              <xsl:call-template name='triple'>
                <xsl:with-param name="doc">
                  <output>*blank_concept_relation* mesh:relation *skos_relation_uri*</output>
                  <desc></desc>
                </xsl:with-param>
                <xsl:with-param name='spec'>
                  <xsl:copy-of select="$blank_concept_relation"/>
                  <uri prefix='&mesh;'>relation</uri>
                  <uri prefix='&skos;'>
                    <xsl:choose>
                      <xsl:when test="matches(@RelationName, 'BRD')">
                        <xsl:text>broader</xsl:text>
                      </xsl:when>
                      <xsl:when test="matches(@RelationName, 'NRW')">
                        <xsl:text>narrower</xsl:text>
                      </xsl:when>
                      <xsl:when test="matches(@RelationName, 'REL')">
                        <xsl:text>related</xsl:text>
                      </xsl:when>
                    </xsl:choose>
                  </uri>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:if>
            
            <!-- 
              Transformation rule: mesh:concept1
            -->
            <xsl:call-template name='triple'>
              <xsl:with-param name="doc">
                <output>*blank_concept_relation* mesh:concept1 *concept1_uri*</output>
                <desc></desc>
              </xsl:with-param>
              <xsl:with-param name='spec'>
                <xsl:copy-of select="$blank_concept_relation"/>
                <uri prefix='&mesh;'>concept1</uri>
                <uri prefix='&mesh;'>
                  <xsl:value-of select="Concept1UI"/>
                </uri>
              </xsl:with-param>
            </xsl:call-template>
            
            <!-- 
              Transformation rule: mesh:concept2
            -->
            <xsl:call-template name='triple'>
              <xsl:with-param name="doc">
                <output>*blank_concept_relation* mesh:concept2 *concept2_uri*</output>
                <desc></desc>
                <fixme>Do we really want two predicates for these, mesh:concept1 and mesh:concept2?  Are they the same
                  relationship?  Does order matter?</fixme>
              </xsl:with-param>
              <xsl:with-param name='spec'>
                <xsl:copy-of select="$blank_concept_relation"/>
                <uri prefix='&mesh;'>concept2</uri>
                <uri prefix='&mesh;'>
                  <xsl:value-of select="Concept2UI"/>
                </uri>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:if>


        <xsl:for-each select="TermList/Term">

          <!--
            Transformation rule: term
            =============================
            Output: <conc_uri> term <term_uri> .
            ========================================
            Description: This relation states that a concept has a term.
            ============================================================
            Need to addresa: N/A
          -->

          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="../../ConceptUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&mesh;term> </xsl:text>
          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="TermUI"/>
          <xsl:text>&gt;</xsl:text>
          <xsl:text> .&#10;</xsl:text>


          <!--
            Transformation rule: rdf:type
            ========================================
            Output: <term_uri> rdf:type <Term> .
            =================================================
            Description: This relation states that a Subject node used to identify a term is of type "Term".
            =============================================================================================================
            Need to address: N/A.
          -->

          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="TermUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&rdf;type&gt; </xsl:text>
          <xsl:text>&lt;&mesh;Term&gt; .&#10;</xsl:text>


          <!--
            Transformation rule: dcterms:identifier
            ========================================
            Output: <term_uri> dcterms:identifier "termUI" .
            =================================================
            Description: This relation states that a term has a term unique identifier.
            ===========================================================================
            Need to address: N/A.
          -->

          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="TermUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&dcterms;identifier&gt; </xsl:text>
          <xsl:text>"</xsl:text>
          <xsl:value-of select="TermUI"/>
          <xsl:text>" .&#10;</xsl:text>

          <!--
            Transformation rule: rdfs:label
            =================================
            Output: <term_uri> rdfs:label "termName" .
            ============================================
            Description: A term has a term name.
            ======================================
            Need to address: N/A.
          -->

          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="TermUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&rdfs;label&gt; </xsl:text>
          <xsl:text>"</xsl:text>
          <xsl:value-of select="String"/>
          <xsl:text>" .&#10;</xsl:text>

          <!--
            Transformation rule: dateCreated
            ============================================
            Output: <term_uri> dateCreated "dateCreated" .
            ============================================================
            Additional: This relation states that a term can have a date on which it was created.
            ======================================================================================
            Need to address: N/A.
          -->

          <xsl:if test="DateCreated">
            <xsl:text>&lt;&mesh;</xsl:text>
            <xsl:value-of select="TermUI"/>
            <xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;&mesh;dateCreated&gt; </xsl:text>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="string-join((DateCreated/Year,DateCreated/Month,DateCreated/Day),'-')"/>
            <xsl:text>" .&#10;</xsl:text>
          </xsl:if>


          <!--
            Transformation rule: abbreviation
            ==========================================
            Output: <term_uri> abbreviation "termAbbreviation" .
            ============================================================
            Description: A term can have a term abbreviation.
            ====================================================
            Need to address: N/A.
          -->

          <xsl:if test="Abbreviation">
            <xsl:text>&lt;&mesh;</xsl:text>
            <xsl:value-of select="TermUI"/>
            <xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;&mesh;abbreviation> </xsl:text>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="Abbreviation"/>
            <xsl:text>" .&#10;</xsl:text>
          </xsl:if>

          <!--
            Transformation rule: sortVersion
            ====================================
            Output: <term_uri> sortVersion "sortVersion" .
            ===================================================
            Additional: A term can have a sort version.
            ============================================
            Need to address: N/A.
          -->

          <xsl:if test="SortVersion">
            <xsl:text>&lt;&mesh;</xsl:text>
            <xsl:value-of select="TermUI"/>
            <xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;&mesh;sortVersion> </xsl:text>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="SortVersion"/>
            <xsl:text>" .&#10;</xsl:text>
          </xsl:if>

          <!--
            Transformation rule: entryVersion
            =======================================
            Output: <term_uri> entryVersion "entryVersion" .
            =====================================================
            Additional: A term can have an entry version.
            ===============================================
            Need to address: N/A.
          -->

          <xsl:if test="EntryVersion">
            <xsl:text>&lt;&mesh;</xsl:text>
            <xsl:value-of select="TermUI"/>
            <xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;&mesh;entryVersion> </xsl:text>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="EntryVersion"/>
            <xsl:text>" .&#10;</xsl:text>
          </xsl:if>

          <!--
            Transformation rule: isConceptPreferredTerm
            ============================================
            Output: <term_uri> isConceptPreferredTerm "Y/N" .
            ============================================================
            Additional: This relation states that a term can be a concept-preferred-term. 
            ==============================================================================
            Need to address: N/A.
          -->

          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="TermUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&mesh;isConceptPreferredTerm&gt; </xsl:text>
          <xsl:text>"</xsl:text>
          <xsl:value-of select="@ConceptPreferredTermYN"/>
          <xsl:text>" .&#10;</xsl:text>

          <!--
            Transformation rule: isPermutedTerm
            =====================================
            Output: <term_uri> isPermutedTerm "Y/N" .
            ===========================================
            Additional: A term can be a permuted term.
            ============================================
            Need to address: N/A.
          -->

          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="TermUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&mesh;isPermutedTerm&gt; </xsl:text>
          <xsl:text>"</xsl:text>
          <xsl:value-of select="@IsPermutedTermYN"/>
          <xsl:text>" .&#10;</xsl:text>

          <!--
            Transformation rule: lexicalTag
            ===================================
            Output: <term_uri> lexicalTag "lexicalTag" .
            ================================================
            Additional: A term has a lexical tag.
            ======================================
            Need to address: N/A.
          -->

          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="TermUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&mesh;lexicalTag&gt; </xsl:text>
          <xsl:text>"</xsl:text>
          <xsl:value-of select="@LexicalTag"/>
          <xsl:text>" .&#10;</xsl:text>

          <!--
            Transformation rule: printFlag
            ===================================
            Output: <term_uri> printFlag "Y/N" .
            ========================================
            Additional: A term has a print flag. 
            =====================================
            Need to address: N/A.
          -->

          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="TermUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&mesh;printFlag&gt; </xsl:text>
          <xsl:text>"</xsl:text>
          <xsl:value-of select="@PrintFlagYN"/>
          <xsl:text>" .&#10;</xsl:text>

          <!--
            Transformation rule: isRecordPreferredTerm
            ===========================================
            Output: <term_uri> isRecordPreferredTerm "Y/N" .
            =================================================
            Additional: A term can be a record preferred term.
            ===================================================
            Need to address: N/A.
          -->

          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="TermUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&mesh;isRecordPreferredTerm&gt; </xsl:text>
          <xsl:text>"</xsl:text>
          <xsl:value-of select="@RecordPreferredTermYN"/>
          <xsl:text>" .&#10;</xsl:text>

        </xsl:for-each>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
