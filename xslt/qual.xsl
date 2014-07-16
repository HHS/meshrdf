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
        =================================================
        Output: <qual_uri> dcterms:identifier "qualUI" .
        ==================================================
        Description: This relation states that a qualifier has a qualifier identifier.
        ================================================================================
        Need to address: N/A.
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

      <!--<xsl:text>&lt;&mesh;</xsl:text>
      <xsl:value-of select="QualifierUI"/>
      <xsl:text>&gt; </xsl:text>
      <xsl:text>&lt;&dcterms;identifier&gt; </xsl:text>
      <xsl:text>"</xsl:text>
      <xsl:value-of select="QualifierUI"/>
      <xsl:text>" .&#10;</xsl:text>-->

      <!--
        Transformation rule/Relation: isQualifierType
        ==============================================
        Output: <qual_uri> isQualifierType "qualType" .
        =================================================
        Description: This relation states that a qualifier has a qualifier type.
        =========================================================================
        Need to address: N/A.
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

      <!--<xsl:text>&lt;&mesh;</xsl:text>
      <xsl:value-of select="QualifierUI"/>
      <xsl:text>&gt; </xsl:text>
      <xsl:text>&lt;&mesh;isQualifierType> </xsl:text>
      <xsl:text>"</xsl:text>
      <xsl:value-of select="@QualifierType"/>
      <xsl:text>" .&#10;</xsl:text>-->

      <!--
        Transformation rule/Relation: rdfs:label
        ===============================================
        Output: <qual_uri> rdfs:label "qualName" .
        =================================================
        Description: Every qualifier has a qualifier name.
        ===================================================
        Need to address: N/A.
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

      <!--<xsl:text>&lt;&mesh;</xsl:text>
      <xsl:value-of select="QualifierUI"/>
      <xsl:text>&gt; </xsl:text>
      <xsl:text>&lt;&rdfs;label&gt; </xsl:text>
      <xsl:text>"</xsl:text>
      <xsl:value-of select="QualifierName/String"/>
      <xsl:text>" .&#10;</xsl:text>-->

      <!--
        Transformation rule/Relation: dateCreated
        ===============================================
        Output: <qual_uri> dateCreated "dateCreated" .
        =================================================
        Description: This relation states that a qualifier has a date on which it was created.
        =======================================================================================
        Need to address: N/A.
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
      
      <!--<xsl:text>&lt;&mesh;</xsl:text>
      <xsl:value-of select="QualifierUI"/>
      <xsl:text>&gt; </xsl:text>
      <xsl:text>&lt;&mesh;dateCreated> </xsl:text>
      <xsl:text>"</xsl:text>
      <xsl:value-of select="string-join((DateCreated/Year,DateCreated/Month,DateCreated/Day),'-')"/>
      <xsl:text>" .&#10;</xsl:text>-->

      <!--
        Transformation rule/Relation: dateRevised
        ==============================================
        Output: <qual_uri> dateRevised "dateRevised" .
        ===================================================
        Description: A qualifier can have a date on which it was revised.
        =======================================================================================
        Need to address: N/A.
      -->
      <xsl:if test="DateRevised">
        <xsl:text>&lt;&mesh;</xsl:text>
        <xsl:value-of select="QualifierUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;&mesh;dateRevised> </xsl:text>
        <xsl:text>"</xsl:text>
        <xsl:value-of select="string-join((DateRevised/Year,DateRevised/Month,DateRevised/Day),'-')"/>
        <xsl:text>" .&#10;</xsl:text>
      </xsl:if>

      <!--
        Transformation rule/Relation: dateEstablished
        ===================================================
        Output: <qual_uri> dateEstablished "dateEstablished" .
        ============================================================
        Description: A qualifier can have a date on which it was established.
        =======================================================================
        Need to address: N/A.
      -->
      <xsl:if test="DateEstablished">
        <xsl:text>&lt;&mesh;</xsl:text>
        <xsl:value-of select="QualifierUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;&mesh;dateEstablished> </xsl:text>
        <xsl:text>"</xsl:text>
        <xsl:value-of
          select="string-join((DateEstablished/Year,DateEstablished/Month,DateEstablished/Day),'-')"/>
        <xsl:text>" .&#10;</xsl:text>
      </xsl:if>

      <!--
        Transformation rule/Relation: activeMeSHYear
        ================================================
        Output: <qual_uri> activeMeSHYear "year" .
        ===============================================
        Description: Every qualifier has at least one year in which the record was active since it was last modified.
        ==============================================================================================================
        Need to address: N/A.
      -->

      <xsl:for-each select="ActiveMeSHYearList/Year">
        <xsl:text>&lt;&mesh;</xsl:text>
        <xsl:value-of select="../../QualifierUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;&mesh;activeMeSHYear> </xsl:text>
        <xsl:text>"</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>" .&#10;</xsl:text>
      </xsl:for-each>

      <!--
        Transformation rule:Relation: annotation
        =============================================
        Output: <qual_uri> annotation "annotation" .
        =================================================
        Description: A Qualifier can have an annotation.
        ==================================================
        Need to address: This rule extracts that annotation and converts it into a string. But sometimes, if not always, the annotation will
        have a link to another qualifier or some manual. Hence, we might have to decipher a way to express this in our RDF conversion. 
        This might require some NLP? For now however, the annotation is simply converted to a string data type.
      -->


      <xsl:if test="Annotation">
        <!-- This if statement is necessary to ensure that the hasAnnotation relationship is extracted 
          ONLY when the Annotation element exists for a descriptor record. This if statements checks to 
          see if the element Annotation exists for a descriptor record. -->
        <xsl:text>&lt;&mesh;</xsl:text>
        <xsl:value-of select="QualifierUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;&mesh;annotation> </xsl:text>
        <xsl:text>"</xsl:text>

        <!-- FIXME:  What in the heck is this doing? -->
        <xsl:value-of select="replace(
          replace(Annotation,'&quot;','\\&quot;'), '&#10;', '&amp;#10;'
          )"/>

        <xsl:text>" .&#10;</xsl:text>
      </xsl:if>

      <!--
        Transformation rule/Relation: historyNote
        =============================================
        Output: <qual_uri> historyNote "historyNote" .
        ==================================================
        Description: A qualifier can have a history note.
        ==================================================
        Need to address: N/A.
      -->

      <xsl:if test="HistoryNote">
        <xsl:text>&lt;&mesh;</xsl:text>
        <xsl:value-of select="QualifierUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;&mesh;historyNote> </xsl:text>
        <xsl:text>"</xsl:text>

        <xsl:value-of select="replace(HistoryNote, '&#10;', '&amp;#10;')"/>
      <!--
        <xsl:call-template name="replace-substring">
          <xsl:with-param name="value" select="HistoryNote"/>
          <xsl:with-param name="from" select="'&#10;'"/>
          <xsl:with-param name="to">&amp;#10;</xsl:with-param>
        </xsl:call-template>
      -->
        <xsl:text>" .&#10;</xsl:text>
      </xsl:if>

      <!--
        Transformation rule/Relation: onlineNote
        ============================================
        Output: <qual_uri> onlineNote "onlineNote" .
        ================================================
        Description: A qualifier can have an online note.
        ==================================================
        Need to address: N/A.
      -->

      <xsl:if test="OnlineNote">
        <xsl:text>&lt;&mesh;</xsl:text>
        <xsl:value-of select="QualifierUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;&mesh;onlineNote> </xsl:text>
        <xsl:text>"</xsl:text>

        <xsl:value-of select="replace(OnlineNote, '&#10;', '&amp;#10;')"/>
        <!--
          <xsl:call-template name="replace-substring">
          <xsl:with-param name="value" select="OnlineNote"/>
          <xsl:with-param name="from" select="'&#10;'"/>
          <xsl:with-param name="to">&amp;#10;</xsl:with-param>
        </xsl:call-template>
        -->

        <xsl:text>" .&#10;</xsl:text>
      </xsl:if>

      <!--
        Transformation rule/Relation: treeNumber
        =========================================
        Output: <qual_uri> treeNumber "treeNumber" .
        ==============================================
        Description: A qualifier can have a tree number.
        =================================================
        Need to address: N/A.
      -->

      <xsl:if test="TreeNumberList">
        <xsl:for-each select="TreeNumberList/TreeNumber">

          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="../../QualifierUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&mesh;treeNumber&gt; </xsl:text>
          <xsl:text>"</xsl:text>
          <xsl:value-of select="."/>
          <xsl:text>" .&#10;</xsl:text>

        </xsl:for-each>
        <!-- TreeNumberList -->
      </xsl:if>

      <!--
        Transformation rule/Relation: allowedTreeNode
        =================================================
        Output: <qual_uri> allowedTreeNode "allowedTreeNode" .
        ============================================================
        Description: A qualifier can have at least one allowed tree node.
        ==================================================================
        Need to address: N/A.
      -->

      <xsl:if test="TreeNodeAllowedList">
        <xsl:for-each select="TreeNodeAllowedList/TreeNodeAllowed">
          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="../../QualifierUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&mesh;allowedTreeNode&gt; </xsl:text>
          <xsl:text>"</xsl:text>
          <xsl:value-of select="."/>
          <xsl:text>" .&#10;</xsl:text>
        </xsl:for-each>
      </xsl:if>

      <!--
        Transformation rule/Relation: recordOriginator, recordMaintainer, recordAuthorizer
        ====================================================================================
        Output: <qual_uri> recordOriginator "recordOriginator" .
                <qual_uri> recordMaintainer "recordMaintainer" .
                <qual_uri> recordAuthorizer "recordAuthorizer" .
        =========================================================
        Description: A qualifier has a record originator, record maintainer and record authorizer.
        ============================================================================================
        Need to address: N/A.
      -->

      <xsl:if test="RecordOriginatorsList">
        <xsl:text>&lt;&mesh;</xsl:text>
        <xsl:value-of select="QualifierUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;&mesh;recordOriginator> </xsl:text>
        <xsl:text>"</xsl:text>
        <xsl:value-of select="RecordOriginatorsList/RecordOriginator"/>
        <xsl:text>" .&#10;</xsl:text>

        <xsl:if test="RecordOriginatorsList/RecordMaintainer">
          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="QualifierUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&mesh;recordMaintainer> </xsl:text>
          <xsl:text>"</xsl:text>
          <xsl:value-of select="RecordOriginatorsList/RecordMaintainer"/>
          <xsl:text>" .&#10;</xsl:text>
        </xsl:if>

        <xsl:if test="RecordOriginatorsList/RecordAuthorizer">
          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="QualifierUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&mesh;recordAuthorizer> </xsl:text>
          <xsl:text>"</xsl:text>
          <xsl:value-of select="RecordOriginatorsList/RecordAuthorizer"/>
          <xsl:text>" .&#10;</xsl:text>
        </xsl:if>
      </xsl:if>

      <xsl:for-each select="ConceptList/Concept">

        <!--
          Transformation rule/Relation: concept
          =========================================
          Output: <qual_uri> concept <conc_uri> .
          ============================================
          Description: A qualifier has at least one concept.
          ===================================================
          Need to address: N/A.
        -->

        <xsl:text>&lt;&mesh;</xsl:text>
        <xsl:value-of select="../../QualifierUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;&mesh;concept> </xsl:text>
        <xsl:text>&lt;&mesh;</xsl:text>
        <xsl:value-of select="ConceptUI"/>
        <xsl:text>&gt;</xsl:text>
        <xsl:text> .&#10;</xsl:text>

        <!--
          Transformation rule/Relation: rdf:type
          =======================================
          Output: <conc_uri> rdf:type <Concept> .
          ===========================================
          Description: This relation states that a Subject node used to identify a concept is of type "Concept".
          ========================================================================================================
          Need to address: N/A.
        -->

        <xsl:text>&lt;&mesh;</xsl:text>
        <xsl:value-of select="ConceptUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;&rdf;type&gt; </xsl:text>
        <xsl:text>&lt;&mesh;Concept&gt; .&#10;</xsl:text>

        <!--
          Transformation rule/Relation: isPreferredConcept
          =================================================
          Output: <conc_uri> isPreferredConcept "Y/N" .
          ===============================================
          Description: A concept will or will not be the preferred concept associated with a Qualifier.
          ==============================================================================================
          Need to address: N/A.
        -->

        <xsl:if test="@PreferredConceptYN = 'Y'">
          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="ConceptUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&mesh;isPreferredConcept> </xsl:text>
          <xsl:text>"Y</xsl:text>
          <xsl:text>" .&#10;</xsl:text>
        </xsl:if>

        <xsl:if test="@PreferredConceptYN = 'N'">
          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="ConceptUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&mesh;isPreferredConcept> </xsl:text>
          <xsl:text>"N</xsl:text>
          <xsl:text>" .&#10;</xsl:text>
        </xsl:if>

        <!--
          Transformation rule/Relation: rdfs:label
          ===========================================
          Output: <conc_uri> rdfs:label "conceptName" .
          ===============================================
          Description: A concept has a name.
          ===================================
          Need to address: N/A.
        -->

        <xsl:text>&lt;&mesh;</xsl:text>
        <xsl:value-of select="ConceptUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;&rdfs;label&gt; </xsl:text>
        <xsl:text>"</xsl:text>

        <xsl:value-of select="replace(ConceptName/String, '&quot;', '\\&quot;')"/>
      <!--
        <xsl:call-template name="replace-substring">
          <!- - escape any double-quote character as per the N-Triple format specification - ->
          <xsl:with-param name="value" select="ConceptName/String"/>
          <xsl:with-param name="from" select="'&quot;'"/>
          <xsl:with-param name="to">\"</xsl:with-param>
        </xsl:call-template>
      -->
        <xsl:text>" .&#10;</xsl:text>

        <!--
          Transformation rule/Relation: dcterms:identifier
          ==================================================
          Output: <conc_uri> dcterms:identifier "conceptUI" .
          =====================================================
          Description: A concept has a unique identifier.
          ================================================
          Need to address: N/A.
        -->

        <xsl:text>&lt;&mesh;</xsl:text>
        <xsl:value-of select="ConceptUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;&dcterms;identifier&gt; </xsl:text>
        <xsl:text>"</xsl:text>
        <xsl:value-of select="ConceptUI"/>
        <xsl:text>" .&#10;</xsl:text>

        <!--
          Transformation rule/Relation: skos:scopeNote
          ===========================================
          Output: <conc_uri> skos:scopeNote "scopeNote" .
          ==============================================
          Description: A concept can have a scope note.
          ==============================================
          Need to address: N/A.
        -->

        <xsl:if test="ScopeNote">
          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="ConceptUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;http://www.w3.org/2004/02/skos/core#scopeNote&gt; </xsl:text>
          <xsl:text>"</xsl:text>
          <xsl:value-of select="replace(replace(ScopeNote, '&quot;', '\\&quot;'), '&#10;', '&amp;#10;')"/>
          <xsl:text>" .&#10;</xsl:text>
        </xsl:if>

        <!--
          Transformation rule/Relation: semanticType, dcterms:identifier, rdfs:label.
          ========================================================================================
          Output: <conc_uri> semanticType <semType_uri> .
                  <semType_uri> rdf:type <SemanticType> . (This relation is created first in the following 
                    for-loop)
                  <semType_uri> dcterms:identifier "semTypeUI" .
                  <semType_uri> rdfs:label "semTypeName" .
          ==========================================================
          Description: A concept can have a semantic type UI and semantic type name. However, I abstracted 
          this relation into the formulation stated in the output above. In this formulation, the concept 
          has a semantic type which in turn has a UI and name.
          ================================================================================================
          Need to address: N/A.
        -->

        <xsl:if test="SemanticTypeList">
          <xsl:for-each select="SemanticTypeList/SemanticType">

            <xsl:text>&lt;&mesh;</xsl:text>
            <xsl:value-of select="SemanticTypeUI"/>
            <xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;&rdf;type&gt; </xsl:text>
            <xsl:text>&lt;&mesh;SemanticType&gt; .&#10;</xsl:text>

            <xsl:text>&lt;&mesh;</xsl:text>
            <xsl:value-of select="../../ConceptUI"/>
            <xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;&mesh;semanticType> </xsl:text>
            <xsl:text>&lt;&mesh;</xsl:text>
            <xsl:value-of select="SemanticTypeUI"/>
            <xsl:text>&gt;</xsl:text>
            <xsl:text> .&#10;</xsl:text>

            <xsl:text>&lt;&mesh;</xsl:text>
            <xsl:value-of select="SemanticTypeUI"/>
            <xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;&dcterms;identifier&gt; </xsl:text>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="SemanticTypeUI"/>
            <xsl:text>" .&#10;</xsl:text>

            <xsl:text>&lt;&mesh;</xsl:text>
            <xsl:value-of select="SemanticTypeUI"/>
            <xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;&rdfs;label&gt; </xsl:text>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="SemanticTypeName"/>
            <xsl:text>" .&#10;</xsl:text>
          </xsl:for-each>
        </xsl:if>

        <!--
          Transformation rule: conceptRelation, relation, concept1, concept2 (relevant to NRW|BRD|REL)
          =============================================================================================
          Output: <conc_uri1> conceptRelation _:blank_set1_ConceptUI_RelationNumber .
                  _:blank_set1_ConceptUI_RelationNumber 	relationName 	skos:broader/skos:narrower/skos:related .
                  _:blank_set1_ConceptUI_RelationNumber 	concept1 	<concept1> .
                  _:blank_set1_ConceptUI_RelationNumber 	concept2 	<concept2> .
          =============================================================================================================
          Description: There are several predicates mentioned here. The conceptRelation states that a concept has a relation to another concept.
          That relation is identified with a blank node. This blank node stores the information that describes how the current concept (concept1) is 
          related to a second concept (concept2). The first concept is either broader, narrower, or related, in relation to the second concept. We
          use the skos:broader, skos:narrower, and skos:related predicates in this case.
          This rule applies when a qualifier has a concept in its concept list that possesses a concept relation list. If this is the case,
          then there will be at least one concept relation in the concept relation list.
          ============================================================================================================================================
          Need to address: N/A.
        -->

        <xsl:if test="ConceptRelationList">
          <xsl:for-each select="ConceptRelationList/ConceptRelation">
            <xsl:text>&lt;&mesh;</xsl:text>
            <xsl:value-of
              select="../../ConceptUI"/>
            <xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;&mesh;conceptRelation> </xsl:text>
            <xsl:text>_:blank_set1_</xsl:text>
            <xsl:value-of
              select="../../ConceptUI"/>_<xsl:value-of select="position()"/>
            <xsl:text> .&#10;</xsl:text>
            <xsl:text>_:blank_set1_</xsl:text>
            <xsl:value-of
              select="../../ConceptUI"/>_<xsl:value-of select="position()"/>
            <xsl:text> &lt;&rdf;type&gt; </xsl:text>
            <xsl:text>&lt;&mesh;ConceptRelation&gt; .&#10;</xsl:text>
            <xsl:if test="@RelationName">
              <xsl:text>_:blank_set1_</xsl:text>
              <xsl:value-of
                select="../../ConceptUI"/>_<xsl:value-of select="position()"/>
              <xsl:text> &lt;&mesh;relation&gt; </xsl:text>
              <xsl:text>&lt;http://www.w3.org/2004/02/skos/core#</xsl:text>
              <xsl:if test="matches(@RelationName, 'BRD')">
                <xsl:text>broader</xsl:text>
              </xsl:if>
              <xsl:if test="matches(@RelationName, 'NRW')">
                <xsl:text>narrower</xsl:text>
              </xsl:if>
              <xsl:if test="matches(@RelationName, 'REL')">
                <xsl:text>related</xsl:text>
              </xsl:if>
              <xsl:text>&gt; .&#10;</xsl:text>
            </xsl:if>
            <xsl:text>_:blank_set1_</xsl:text>
            <xsl:value-of
              select="../../ConceptUI"/>_<xsl:value-of select="position()"/>
            <xsl:text>&lt;&mesh;concept1> </xsl:text>
            <xsl:text>&lt;&mesh;</xsl:text>
            <xsl:value-of
              select="Concept1UI"/><xsl:text>&gt;</xsl:text><xsl:text> .&#10;</xsl:text>
            <xsl:text>_:blank_set1_</xsl:text>
            <xsl:value-of
              select="../../ConceptUI"/>_<xsl:value-of select="position()"/>
            <xsl:text>&lt;&mesh;concept2> </xsl:text>
            <xsl:text>&lt;&mesh;</xsl:text><xsl:value-of
              select="Concept2UI"
            /><xsl:text>&gt;</xsl:text>
            <xsl:text> .&#10;</xsl:text>
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
        <!-- TermList/Term -->
      </xsl:for-each>
      <!-- ConceptList/Concept -->

    </xsl:for-each>
    <!-- QualifierRecordSet/QualifierRecord -->

  </xsl:template>

</xsl:stylesheet>
