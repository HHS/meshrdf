<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY dcterms "http://purl.org/dc/terms/">
  <!ENTITY mesh "http://nlm.nih.gov#MeSH:">
  <!ENTITY rdf "http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <!ENTITY rdfs "http://www.w3.org/2000/01/rdf-schema#">
]>


<xsl:stylesheet version="2.0"
                xmlns:f="http://nlm.nih.gov/ns/f"
                xmlns:dcterms='&dcterms;'
                xmlns:mesh="&mesh;"
                xmlns:rdfs="&rdfs;"
                xmlns:rdf="&rdf;"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="f">

  <xsl:import href="common.xsl"/>
  <xsl:output method="text"/>


  <xsl:template match="/">

    <xsl:for-each select="DescriptorRecordSet/DescriptorRecord">

      <!--
        Transformation rule: dcterms:identifier
        ========================================
        Output: <desc_uri> dcterms:identifier "D123456" .
        =================================================
        Additional: This relation states that a descriptor record has a unique identifier.
        ===================================================================================
        Need to address: N/A
      -->

      <xsl:value-of select='f:triple-literal(
          concat("&mesh;", DescriptorUI), 
          "&dcterms;identifier", 
          DescriptorUI
        )'/>

      <!--
        Transformation rule: rdf:type
        =================================
        Output: <desc_uri> rdf:type mesh:Descriptor .
        =============================================================
        Additional: This relation states that a Subject node used to identify a Descriptor record 
        is of type "Descriptor".
      -->

      <xsl:value-of select='f:triple-uri(
          concat("&mesh;", DescriptorUI), 
          "&rdf;type",
          "&mesh;Descriptor"
        )'/>


      <!-- 
        Transformation rule: descriptorClass
        ======================================
        Output: <desc_uri> mesh:descriptorClass "descriptorClass" .
        =======================================================
        Additional: This relation states that a descriptor record has a descriptor class to which it belongs to.
        =========================================================================================================
        Need to address: N/A
      -->

      <xsl:value-of select='f:triple-literal(
          concat("&mesh;", DescriptorUI), 
          "&mesh;descriptorClass", 
          @DescriptorClass
        )'/>

      <!--
        Transformation rule: rdfs:label
        =======================================
        Output: <desc_uri> rdfs:label "descName" .
        ==================================================
        Additional: This relation states that a descriptor record has a name.
        ======================================================================
        Need to address: N/A.
      -->

      <xsl:value-of select='f:triple-literal(
          concat("&mesh;", DescriptorUI), 
          "&rdfs;label", 
          DescriptorName/String
        )'/>
      
      <xsl:for-each select="ConceptList/Concept">

        <!--
          Transformation rule: concept
          =======================================
          Output: <desc_uri> concept <conc_uri> .
          ===========================================
          Additional: This relation states that a descriptor record has a concept.
          ====================================================================================
          Need to address: N/A.
        -->

        <xsl:value-of select='f:triple-uri(
            concat("&mesh;", ../../DescriptorUI), 
            "&mesh;concept",
            concat("&mesh;", ConceptUI)
          )'/>

        <!--
          Transformation rule/Relation: rdf:type
          =======================================
          Output: <conc_uri> rdf:type <Concept> .
          =========================================
          Description: This relation states that a Subject node used to identify a concept is of type "Concept".
          ========================================================================================================
          Need to address: N/A.
        -->

        <xsl:value-of select='f:triple-uri(
            concat("&mesh;", ConceptUI), 
            "&rdf;type",
            "&mesh;Concept"
          )'/>

        <!--
          Transformation rule: isPreferredConcept
          ========================================
          Output: <conc_uri> isPreferredConcept "Y"/"N" .
          ================================================
          Additional: This relation states that yes, "Y", a concept is the preferred concept or no, "N", the concept is not the preferred concept.
          =========================================================================================================================================
          Need to address: N/A
        -->

        <!-- isPreferredConcept -->
        <!-- Y/N -->
        <xsl:if test="@PreferredConceptYN = 'Y' or @PreferredConceptYN = 'N'">
          <xsl:value-of select='f:triple-literal(
              concat("&mesh;", ConceptUI), 
              "&mesh;isPreferredConcept", 
              @PreferredConceptYN
            )'/>
        <!--
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
        -->
        </xsl:if>

        <!--
          Transformation rule: rdfs:label
          ====================================
          Output: <conc_uri> rdfs:label "concName" .
          ================================================
          Additional: This relation states that a concept has a concept name.
          ====================================================================
          Need to address: N/A
        -->

        <xsl:text>&lt;&mesh;</xsl:text>
        <xsl:value-of select="ConceptUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;&rdfs;label&gt; </xsl:text>
        <xsl:value-of select="f:literal(ConceptName/String)"/>
        <xsl:text> .&#10;</xsl:text>

        <!--
          Transformation rule: dcterms:identifier
          ========================================
          Output: <conc_uri> dcterms:identifier "concUI" .
          =================================================
          Additional: This relation states that a concept has a unique identifier.
          =========================================================================
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
          Transformation rule: UMLS_CUI
          ==============================
          Output: <conc_uri> UMLS_CUI "concUMLSUI" .
          ===========================================
          Additional: This relation states that a concept has a unique UMLS identifier.
          ==============================================================================
          Need to address: N/A.
        -->

        <xsl:if test="ConceptUMLSUI">
          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="ConceptUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&mesh;UMLS_CUI> </xsl:text>
          <xsl:text>&lt;http://nlm.nih.gov#UMLS_MT:</xsl:text>
          <xsl:value-of select="ConceptUMLSUI"/>
          <xsl:text>&gt; .&#10;</xsl:text>
        </xsl:if>

        <!--
          Transformation rule: CASN1_label
          ===================================
          Output: <conc_uri> CASN1_label "CASN1Name" .
          ===============================================
          Additional: This relation states that a concept has a Chemical Abstracts Type N1 Name.
          =======================================================================================
          Need to address: Do we want to parse the CASN1Name (e.g. for other purposes)?
        -->

        <xsl:if test="CASN1Name">
          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="ConceptUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&mesh;CASN1_label&gt; </xsl:text>
          <xsl:text>"</xsl:text>
          <xsl:value-of select="CASN1Name"/>
          <xsl:text>" .&#10;</xsl:text>
        </xsl:if>

        <!--
          Transformation rule: registryNumber
          =======================================
          Output: <conc_uri> registryNumber "registryNumber" .
          =========================================================
          Additional: This relation states that a concept has a registry number.
          =======================================================================
          Need to address: N/A
        -->

        <xsl:if test="RegistryNumber">
          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="ConceptUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&mesh;registryNumber> </xsl:text>
          <xsl:text>"</xsl:text>
          <xsl:value-of select="RegistryNumber"/>
          <xsl:text>" .&#10;</xsl:text>
        </xsl:if>

        <!--
          Transformation rule: skos:scopeNote
          ===================================
          Output: <conc_uri> skos:scopeNote "scopeNote" .
          ===============================================
          Additional: This relation states tht a concept has a scope note.
          =================================================================
          Need to address: N/A.
        -->
        <xsl:if test="ScopeNote">
          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="ConceptUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;http://www.w3.org/2004/02/skos/core#scopeNote&gt; </xsl:text>
          
          <xsl:value-of select='f:literal(ScopeNote)'/>
          <xsl:text> .&#10;</xsl:text>
        </xsl:if>

        <xsl:if test="SemanticTypeList">
          <xsl:for-each select="SemanticTypeList/SemanticType">

            <!--
              Transformation rule: semanticType
              =====================================
              Output: <conc_uri> semanticType <semType_uri> .
              ===================================================
              Additional: This relation states that a concept has a semantic type.
              =====================================================================
              Need to address: N/A.
            -->
            <xsl:text>&lt;&mesh;</xsl:text>
            <xsl:value-of select="../../ConceptUI"/>
            <xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;&mesh;semanticType> </xsl:text>
            <xsl:text>&lt;&mesh;</xsl:text>
            <xsl:value-of select="SemanticTypeUI"/>
            <xsl:text>&gt;</xsl:text>
            <xsl:text> .&#10;</xsl:text>


            <!--
              Transformation rule: rdf:type
              ===============================
              Output: <semType_uri> rdf:type <SemanticType> .
              =================================================
              Additional: This relation states that a concept has a semantic type.
              =====================================================================
              Need to address: N/A.
            -->

            <xsl:text>&lt;&mesh;</xsl:text>
            <xsl:value-of select="SemanticTypeUI"/>
            <xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;&rdf;type&gt; </xsl:text>
            <xsl:text>&lt;&mesh;SemanticType&gt; .&#10;</xsl:text>


            <!--
              Transformation rule: rdfs:label
              ==========================================
              Output: <semType_uri> rdfs:label "semanticTypeName" .
              ===============================================================
              Additional: This rule states the a semantic type unique identifier has a semantic type name.
              ==============================================================================================
              Need to address: I'm not sure if this relation is correct. But we've created this 
              type of relation for the concepts of a descriptor. We should check this (for e.g.,
              with a MeSH expert or by a literature search).
            -->

            <xsl:text>&lt;&mesh;</xsl:text>
            <xsl:value-of select="SemanticTypeUI"/>
            <xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;&rdfs;label&gt; </xsl:text>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="SemanticTypeName"/>
            <xsl:text>" .&#10;</xsl:text>

            <!--
              Transformation rule: dcterms:identifier
              =========================================
              Output: <semType_uri> dcterms:identifier "semTypeUI" .
              =======================================================
              Additional: This rule states that a semantic type has a unique identifier.
            -->

            <xsl:text>&lt;&mesh;</xsl:text>
            <xsl:value-of select="SemanticTypeUI"/>
            <xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;&dcterms;identifier&gt; </xsl:text>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="SemanticTypeUI"/>
            <xsl:text>" .&#10;</xsl:text>
          </xsl:for-each>
        </xsl:if>

        <!--
          Transformation rule: relatedRegistryNumber
          ===============================================
          Output: <conc_uri> relatedRegistryNumber "relatedRegistryNumber" .
          ======================================================================
          Additional: This relation states that a concept has a related registry number.
          ================================================================================
          Need to address: Maybe it would be good to reduce this value to only a number. But 
          I'm not sure. Need to check with a MeSH epert to see how important is the text
          after the number.
        -->

        <xsl:if test="RelatedRegistryNumberList">
          <xsl:for-each select="RelatedRegistryNumberList/RelatedRegistryNumber">
            <xsl:text>&lt;&mesh;</xsl:text>
            <xsl:value-of select="../../ConceptUI"/>
            <xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;&mesh;relatedRegistryNumber> </xsl:text>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>" .&#10;</xsl:text>
          </xsl:for-each>
        </xsl:if>


        <xsl:if test="ConceptRelationList">
          <xsl:for-each select="ConceptRelationList/ConceptRelation">
            <xsl:text>&lt;&mesh;</xsl:text><xsl:value-of select="../../ConceptUI"/><xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;&mesh;conceptRelation> </xsl:text>
            <xsl:text>_:blank_set1_</xsl:text><xsl:value-of select="../../ConceptUI"/>_<xsl:value-of
              select="position()"/>
            <xsl:text> .&#10;</xsl:text>
            <xsl:text>_:blank_set1_</xsl:text><xsl:value-of select="../../ConceptUI"/>_<xsl:value-of
              select="position()"/>
            <xsl:text> &lt;&rdf;type&gt; </xsl:text>
            <xsl:text>&lt;&mesh;ConceptRelation&gt; .&#10;</xsl:text>
            <xsl:if test="@RelationName">
              <xsl:text>_:blank_set1_</xsl:text><xsl:value-of select="../../ConceptUI"
                />_<xsl:value-of select="position()"/>
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
            <xsl:text>_:blank_set1_</xsl:text><xsl:value-of select="../../ConceptUI"/>_<xsl:value-of
              select="position()"/>
            <xsl:text> &lt;&mesh;concept1> </xsl:text>
            <xsl:text>&lt;&mesh;</xsl:text><xsl:value-of select="Concept1UI"/><xsl:text>&gt;</xsl:text><xsl:text> .&#10;</xsl:text>
            <xsl:text>_:blank_set1_</xsl:text><xsl:value-of select="../../ConceptUI"/>_<xsl:value-of
              select="position()"/>
            <xsl:text> &lt;&mesh;concept2> </xsl:text>
            <xsl:text>&lt;&mesh;</xsl:text><xsl:value-of select="Concept2UI"/><xsl:text>&gt;</xsl:text><xsl:text> .&#10;</xsl:text>
            <!-- added by rw -->
            <xsl:if test="RelationAttribute">
              <xsl:text>_:blank_set1_</xsl:text><xsl:value-of select="../../ConceptUI"
                />_<xsl:value-of select="position()"/>
              <xsl:text> &lt;&mesh;relationAttribute> </xsl:text>
              <xsl:text>"</xsl:text><xsl:value-of select="RelationAttribute"
              /><xsl:text>" .&#10;</xsl:text>
            </xsl:if>
          </xsl:for-each>
          <!-- ConceptRelationList/ConceptRelation -->
        </xsl:if>
        <!-- ConceptRelationList -->

        <xsl:for-each select="TermList/Term">
          <!--
            Transformation rule: term
            =============================
            Output: <conc_uri> term <term_uri> .
            ========================================
            Additional: This relation states that a concept has a term.
            ============================================================
            Need to addresa: N/A
          -->
          <xsl:text>&lt;&mesh;</xsl:text><xsl:value-of select="../../ConceptUI"/><xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&mesh;term> </xsl:text>
          <xsl:text>&lt;&mesh;</xsl:text><xsl:value-of select="TermUI"/><xsl:text>&gt;</xsl:text>
          <xsl:text> .&#10;</xsl:text>
          <!--
            Transformation rule: rdf:type
            ==============================
            Output: <term_uri> rdf:type <Term> .
            ========================================
            Additional: A concept has at least one term associated with it.
          -->
          <xsl:text>&lt;&mesh;</xsl:text><xsl:value-of select="TermUI"/><xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&rdf;type&gt; </xsl:text>
          <xsl:text>&lt;&mesh;Term&gt; .&#10;</xsl:text>
          <!--
            Transformation rule: dcterms:identifier
            =======================================
            Output: <term_uri> dcterms:identifier "termUI" .
            ==================================================
            Additional: This relation states that a term has a term unique identifier.
            ============================================================================
            Need to address: N/A.
          -->
          <xsl:text>&lt;&mesh;</xsl:text><xsl:value-of select="TermUI"/><xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&dcterms;identifier&gt; </xsl:text>
          <xsl:text>"</xsl:text><xsl:value-of select="TermUI"/><xsl:text>" .&#10;</xsl:text>
          <xsl:if test="@IsPermutedTermYN = 'N'">
            <xsl:text>&lt;&mesh;</xsl:text><xsl:value-of select="TermUI"/><xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;&rdfs;label&gt; </xsl:text>
            <xsl:text>"</xsl:text><xsl:value-of select="String"/><xsl:text>" .&#10;</xsl:text>
          </xsl:if>
          <!--
            Transformation rule: termData
            =================================================================
            Output: <term_uri> termData _:blankTermUI_termNumber .
            ==========================================================
            Addtional: This relation states that a term has data associated with it. A blank node 
            stores the term data.
            ======================================================================================
            Need to address: This relation was created in order to stick with the XML representation of MeSH.
          -->
          <xsl:text>&lt;&mesh;</xsl:text><xsl:value-of select="TermUI"/><xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&mesh;termData&gt; </xsl:text>
          <xsl:text>_:blank</xsl:text><xsl:value-of select="TermUI"/>_<xsl:value-of
            select="position()"/><xsl:text> .&#10;</xsl:text>
          <!--
            Transformation rule/Relation: rdf:type
            =======================================
            Output: _:blankTermUI_termNumber rdf:type <TermData> .
            =======================================================
            Description: This relation states that a Subject node used to identify term data is 
            of type "TermData".
            ====================================================================================
            Need to address: N/A.
          -->
          <xsl:text>_:blank</xsl:text><xsl:value-of select="TermUI"/>_<xsl:value-of
            select="position()"/><xsl:text> </xsl:text>
          <xsl:text>&lt;&rdf;type&gt; </xsl:text>
          <xsl:text>&lt;&mesh;TermData&gt; .&#10;</xsl:text>
          <!--
            Transformation rule: isConceptPreferredTerm
            ============================================
            Output: _:blankTermUI_termNo isConceptPreferredTerm "Y/N" .
            ============================================================
            Additional: This relation states that a term can be a concept-preferred-term. But it
            does so indirectly because the isConceptPreferredTerm relation is with a blank node.
            ======================================================================================
            Need to address: N/A.
          -->
          <xsl:text>_:blank</xsl:text><xsl:value-of select="TermUI"/>_<xsl:value-of
            select="position()"/><xsl:text> </xsl:text>
          <xsl:text>&lt;&mesh;isConceptPreferredTerm&gt; </xsl:text>
          <xsl:text>"</xsl:text><xsl:value-of select="@ConceptPreferredTermYN"/><xsl:text>" .&#10;</xsl:text>
          <!--
            Transformation rule: isPermutedTerm
            =====================================
            Output: _:blankTermUI_termNo isPermutedTerm "Y/N" .
            =====================================================
            Additional: This relation states that a term can be a permuted term. But it does so 
            indirectly because the isPermutedTerm relation is with a blank node.
            ====================================================================================
            Need to address: N/A.
          -->
          <xsl:text>_:blank</xsl:text><xsl:value-of select="TermUI"/>_<xsl:value-of
            select="position()"/><xsl:text> </xsl:text>
          <xsl:text>&lt;&mesh;isPermutedTerm&gt; </xsl:text>
          <xsl:text>"</xsl:text><xsl:value-of select="@IsPermutedTermYN"/><xsl:text>" .&#10;</xsl:text>
          <!--
            Transformation rule: lexicalTag
            ===================================
            Output: _:blankTermUI_termNo lexicalTag "lexicalTag" .
            ==========================================================
            Additional: This relation states that a term has a lexical tag. But it does so indirectly becuase the hasLexicalTag relation is with a blank node.
            ====================================================================================================================================================
            Need to address: N/A.
          -->
          <xsl:text>_:blank</xsl:text><xsl:value-of select="TermUI"/>_<xsl:value-of
            select="position()"/><xsl:text> </xsl:text>
          <xsl:text>&lt;&mesh;lexicalTag&gt; </xsl:text>
          <xsl:text>"</xsl:text><xsl:value-of select="@LexicalTag"/><xsl:text>" .&#10;</xsl:text>
          <!--
            Transformation rule: printFlag
            ===================================
            Output: _:blankTermUI_termNo printFlag "Y/N" .
            ==================================================
            Additional: This relation states that a term has a print flag. But it does this 
            indirectly because the hasPrintFlag relation is with a blank node.
            ======================================================================================
            Need to address: N/A.
          -->
          <xsl:text>_:blank</xsl:text><xsl:value-of select="TermUI"/>_<xsl:value-of
            select="position()"/><xsl:text> </xsl:text>
          <xsl:text>&lt;&mesh;printFlag&gt; </xsl:text>
          <xsl:text>"</xsl:text><xsl:value-of select="@PrintFlagYN"/><xsl:text>" .&#10;</xsl:text>
          <!--
            Transformation rule: isRecordPreferredTerm
            ===========================================
            Output: _:blankTermUI_termNo isRecordPreferredTerm "Y/N" .
            ============================================================
            Additional: This relation states that a term can be a record preferred term. But it does 
            this indirectly because the relation is with a blank node.
            ========================================================================================
            Need to address: N/A.
          -->
          <xsl:text>_:blank</xsl:text><xsl:value-of select="TermUI"/>_<xsl:value-of
            select="position()"/><xsl:text> </xsl:text>
          <xsl:text>&lt;&mesh;isRecordPreferredTerm&gt; </xsl:text>
          <xsl:text>"</xsl:text><xsl:value-of select="@RecordPreferredTermYN"/><xsl:text>" .&#10;</xsl:text>
          <!--
            Transformation rule: dcterms:identifier
            ========================================
            Output: _:blankTermUI_termNo dcterms:identifier "termUI" .
            ===========================================================
            Additional: This relation states that a term has a term unique identifier. However, it 
            does so indirectly because the relation is with a blank node.
            ======================================================================================
            Additional: N/A.
          -->
          <xsl:text>_:blank</xsl:text><xsl:value-of select="TermUI"/>_<xsl:value-of
            select="position()"/><xsl:text> </xsl:text>
          <xsl:text>&lt;&dcterms;identifier&gt; </xsl:text>
          <xsl:text>"</xsl:text><xsl:value-of select="TermUI"/><xsl:text>" .&#10;</xsl:text>
          <!--
            Transformation rule: rdfs:label
            =================================
            Output: _:blankTermUI_termNo rdfs:label "termName" .
            ======================================================
            Additional: This relation states that a term has a term name. But it does so 
            indirectly because the relation is with a blank node.
            ====================================================================================
            Need to address: N/A.
          -->
          <xsl:text>_:blank</xsl:text><xsl:value-of select="TermUI"/>_<xsl:value-of
            select="position()"/><xsl:text> </xsl:text>
          <xsl:text>&lt;&rdfs;label&gt; </xsl:text>
          <xsl:text>"</xsl:text><xsl:value-of select="String"/><xsl:text>" .&#10;</xsl:text>
          <!--
            Transformation rule: dateCreated
            ======================================
            Output: _:blankTermUI_termNo dateCreated "dateCreated" .
            ============================================================
            Additional: This relation states that a term can have a date on which it was created.
            ======================================================================================
            Need to address: N/A.
          -->
          <xsl:if test="DateCreated">
            <xsl:text>_:blank</xsl:text><xsl:value-of select="TermUI"/>_<xsl:value-of
              select="position()"/><xsl:text> </xsl:text>
            <xsl:text>&lt;&mesh;dateCreated&gt; </xsl:text>
            <xsl:text>"</xsl:text><xsl:value-of
              select="string-join((DateCreated/Year,DateCreated/Month,DateCreated/Day),'-')"
            /><xsl:text>" .&#10;</xsl:text>
          </xsl:if>
          <!--
            Transformation rule: abbreviation
            =========================================
            Output: _:blankTermUI_termNo abbreviation "termAbbreviation" .
            =============================================================
            Additional: This relation states that a term has a term abbreviation.
            =======================================================================
            Need to address: N/A.
          -->
          <xsl:if test="Abbreviation">
            <xsl:text>_:blank</xsl:text><xsl:value-of select="TermUI"/>_<xsl:value-of
              select="position()"/><xsl:text> </xsl:text>
            <xsl:text>&lt;&mesh;abbreviation> </xsl:text>
            <xsl:text>"</xsl:text><xsl:value-of select="Abbreviation"/><xsl:text>" .&#10;</xsl:text>
          </xsl:if>
          <!--
            Transformation rule: sortVersion
            ====================================
            Output: _:blankTermUI_termNo sortVersion "sortVersion" .
            ===================================================
            Additional: This rule states that a term has a sort version.
            ==============================================================
            Need to address: N/A.
          -->
          <xsl:if test="SortVersion">
            <xsl:text>_:blank</xsl:text><xsl:value-of select="TermUI"/>_<xsl:value-of
              select="position()"/><xsl:text> </xsl:text>
            <xsl:text>&lt;&mesh;sortVersion> </xsl:text>
            <xsl:text>"</xsl:text><xsl:value-of select="SortVersion"/><xsl:text>" .&#10;</xsl:text>
          </xsl:if>
          <!--
            Transformation rule: entryVersion
            =======================================
            Output: _:blankTermUI_termNo entryVersion "entryVersion" .
            =====================================================
            Additional: This rule states that a term has an entry version.
            =================================================================
            Need to address: N/A.
          -->
          <xsl:if test="EntryVersion">
            <xsl:text>_:blank</xsl:text><xsl:value-of select="TermUI"/>_<xsl:value-of
              select="position()"/><xsl:text> </xsl:text>
            <xsl:text>&lt;&mesh;entryVersion> </xsl:text>
            <xsl:text>"</xsl:text><xsl:value-of select="EntryVersion"/><xsl:text>" .&#10;</xsl:text>
          </xsl:if>
          <!--
            Transformation rule: thesaurusID
            =====================================
            Output: _:blankTermUI_termNo thesaurusID "thesaurusID" .
            ===================================================
            Additional: This relation states that a term has a thesaurus ID.
            ===================================================================
            Need to address: N/A.
          -->
          <xsl:if test="ThesaurusIDlist">
            <xsl:variable name="pos" select="position()"/>
            <xsl:for-each select="ThesaurusIDlist/ThesaurusID">
              <xsl:text>_:blank</xsl:text><xsl:value-of select="../../TermUI"/>_<xsl:copy-of
                select="$pos"/><xsl:text> </xsl:text>
              <xsl:text>&lt;&mesh;thesaurusID> </xsl:text>
              
              <xsl:value-of select='f:literal(.)'/>
              <xsl:text> .&#10;</xsl:text>
            </xsl:for-each>
          </xsl:if>
        </xsl:for-each>
        <!-- TermList/Term -->
      </xsl:for-each>
      <!-- ConceptList/Concept -->

      <xsl:if test="EntryCombinationList">
        <xsl:for-each select="EntryCombinationList/EntryCombination">
          <!--
            Transformation rule: entryCombination
            =========================================
            Output: <desc_uri> entryCombination _:blankDescriptorUI_entryCombinationNumber .
            ====================================================================================
            Additional: This relation states that a descriptor record has a entry combination. The entry combination has an ECIN and an ECOUT (see below). 
            ================================================================================================================================================
            Need to address: N/A
          -->
          <xsl:text>&lt;&mesh;</xsl:text><xsl:value-of select="../../DescriptorUI"/><xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&mesh;entryCombination&gt; </xsl:text>
          <xsl:text>_:blank</xsl:text><xsl:value-of select="../../DescriptorUI"/>_<xsl:value-of
            select="position()"/><xsl:text> .&#10;</xsl:text>
          <!--
            Transformation rule/Relation: rdf:type
            ========================================
            Output: _:blankDescriptorUI_entryCombinationNumber	 rdf:type 	<EntryCombination> .
            ==============================================================================================
            Description: This relation states that a Subject node used to identify an entry combination is of type "EntryCombination".
            ============================================================================================================================
            Need to address: N/A.
          -->
          <xsl:text>_:blank</xsl:text><xsl:value-of select="../../DescriptorUI"/>_<xsl:value-of
            select="position()"/><xsl:text> </xsl:text>
          <xsl:text>&lt;&rdf;type&gt; </xsl:text>
          <xsl:text>&lt;&mesh;EntryCombination&gt; .&#10;</xsl:text>
          <xsl:text>_:blank</xsl:text><xsl:value-of select="../../DescriptorUI"/>_<xsl:value-of
            select="position()"/><xsl:text> </xsl:text>
          <xsl:text>&lt;&mesh;ECINDescriptor&gt; </xsl:text>
          <xsl:text>&lt;&mesh;</xsl:text><xsl:value-of
            select="ECIN/DescriptorReferredTo/DescriptorUI"/><xsl:text>&gt;</xsl:text>
          <xsl:text> .&#10;</xsl:text>
          <xsl:text>_:blank</xsl:text><xsl:value-of select="../../DescriptorUI"/>_<xsl:value-of
            select="position()"/><xsl:text> </xsl:text>
          <xsl:text>&lt;&mesh;ECINQualifier&gt; </xsl:text>
          <xsl:text>&lt;&mesh;</xsl:text><xsl:value-of select="ECIN/QualifierReferredTo/QualifierUI"/><xsl:text>&gt;</xsl:text>
          <xsl:text> .&#10;</xsl:text>
          <xsl:text>_:blank</xsl:text><xsl:value-of select="../../DescriptorUI"/>_<xsl:value-of
            select="position()"/><xsl:text> </xsl:text>
          <xsl:text>&lt;&mesh;ECOUTDescriptor&gt; </xsl:text>
          <xsl:text>&lt;&mesh;</xsl:text><xsl:value-of
            select="ECOUT/DescriptorReferredTo/DescriptorUI"/><xsl:text>&gt;</xsl:text>
          <xsl:text> .&#10;</xsl:text>
          <xsl:if test="ECOUT/QualifierReferredTo">
            <xsl:text>_:blank</xsl:text><xsl:value-of select="../../DescriptorUI"/>_<xsl:value-of
              select="position()"/><xsl:text> </xsl:text>
            <xsl:text>&lt;&mesh;ECOUTQualifier&gt; </xsl:text>
            <xsl:text>&lt;&mesh;</xsl:text><xsl:value-of
              select="ECOUT/QualifierReferredTo/QualifierUI"/><xsl:text>&gt;</xsl:text>
            <xsl:text> .&#10;</xsl:text>
          </xsl:if>
        </xsl:for-each>
      </xsl:if>

      <xsl:if test="AllowableQualifiersList">

        <xsl:for-each select="AllowableQualifiersList/AllowableQualifier">

          <!--
            Transformation rule: allowableQualifier
            ===========================================
            Output: <desc_uri> allowableQualifier <qual_uri> .
            ======================================================
            Additional: This relation states that a descriptor record has an allowable qualifier.
            ======================================================================================
            Need to address: N/A.
          -->

          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="../../DescriptorUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&mesh;allowableQualifier&gt; </xsl:text>
          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="QualifierReferredTo/QualifierUI"/>
          <xsl:text>&gt;</xsl:text>
          <xsl:text> .&#10;</xsl:text>


          <!--
      	    Transformation rule: rdf:type
      	    =================================
      	    Output: <qual_uri> rdf:type <Qualifier> .
      	    =============================================================
      	    Additional: This relation states that a Subject node used to identify a Descriptor record is of type "Descritpor".
     	    -->

          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="QualifierReferredTo/QualifierUI"/>
          <xsl:text>&gt;</xsl:text>
          <xsl:text> </xsl:text>
          <xsl:text>&lt;&rdf;type&gt; </xsl:text>
          <xsl:text>&lt;&mesh;Qualifier&gt; .&#10;</xsl:text>


          <!--
            Transformation rule: dcterms:identifier
            =========================================
            Output: <qual_uri> dcterms:identifier "qualUI" .
            =================================================
            Additional: This relation states that an allowable qualifier has a unique identifier.
            ======================================================================================
            Need to address: N/A.
          -->

          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="QualifierReferredTo/QualifierUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&dcterms;identifier&gt; </xsl:text>
          <xsl:text>"</xsl:text>
          <xsl:value-of select="QualifierReferredTo/QualifierUI"/>
          <xsl:text>" .&#10;</xsl:text>

          <!--
            Transformation rule: rdfs:label
            ======================================
            Output: <qual_uri> rdfs:label "qualName" .
            ===================================================
            Additional: This relation states that an allowable qualifier has a name.
            =========================================================================
            Need to address: N/A.
          -->

          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="QualifierReferredTo/QualifierUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&rdfs;label&gt; </xsl:text>
          <xsl:text>"</xsl:text>
          <xsl:value-of select="QualifierReferredTo/QualifierName/String"/>
          <xsl:text>" .&#10;</xsl:text>

          <!--
            Transformation rule: abbreviation
            ==============================================
            Output: <qual_uri> abbreviation "qualAbbrev" .
            ===================================================
            Additional: This relation states that an allowable qualifier has an abbreviation.
            ===================================================================================
            Need to address: N/A.
          -->

          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="QualifierReferredTo/QualifierUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&mesh;abbreviation&gt; </xsl:text>
          <xsl:text>"</xsl:text>
          <xsl:value-of select="Abbreviation"/>
          <xsl:text>" .&#10;</xsl:text>

        </xsl:for-each>
        <!-- AllowableQualifiersList/AllowableQualifier" -->

      </xsl:if>

      <xsl:if test="TreeNumberList">
        <xsl:for-each select="TreeNumberList/TreeNumber">
          <!-- xsl:for-each select="TreeNumber" -->

          <!-- 
            Transformation rule: treeNumber
            ===================================
            Output: <desc_uri> treeNumber "treeNumber"
            ==============================================
            Additional: Every MeSH descriptor record can have some integer number of tree numbers. These are presented as characters separated by perionds in the MeSH browser under the 
            "Tree Number" relation. I named this the hasTreeNumber relation in RDF.
          -->

          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="../../DescriptorUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&mesh;treeNumber&gt; </xsl:text>
          <xsl:text>"</xsl:text>
          <xsl:value-of select="."/>
          <xsl:text>" .&#10;</xsl:text>

          <!-- /xsl:for-each -->
          <!-- TreeNumber -->
        </xsl:for-each>
        <!-- TreeNumberList -->
      </xsl:if>

      <!--
        Transformation rule: annotation
        ====================================
        Output: <desc_uri> annotation "annotation" .
        ================================================
        Additional: This rule states that a descriptor record has an annotation.
        =========================================================================
        Need to address: Every MeSH descriptor can have an annotation. This rule extracts that annotation and converts it into a string. But sometimes, if not always, the annotation will
        have a link to another descriptor. Hence, we might have to decipher a way to express this in our RDF conversion. This might require some NLP? For now however, the 
        annotation is simply converted to a string data type.
      -->

      <!-- xsl:template match="Annotation" -->
      <!-- I'm not sure why, but template cannot go here in the document -->
      <xsl:if test="Annotation">
        <!-- This if statement is necessary to ensure that the hasAnnotation relationship is extracted ONLY when the Annotation element exists
        for a descriptor record. This if statements checks to see if the element Annotation exists for a descriptor record. -->
        <!-- hasAnnotation -->
        <xsl:text>&lt;&mesh;</xsl:text>
        <xsl:value-of select="DescriptorUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;&mesh;annotation> </xsl:text>
        
        <xsl:value-of select='f:literal(Annotation)'/>
        <xsl:text> .&#10;</xsl:text>
      </xsl:if>
      <!-- /xsl:template -->

      <!-- 
        Transformation rules: dateCreated, dateRevised, dateEstablished
        ================================================================
        Output: <desc_uri> dateCreated "dateCreated" ., <desc_uri> dateRevised "dateRevised" ., <desc_uri> dateEstablished "dateEstablished" .
        ========================================================================================================================================
        Additional: This relation states that a descriptor record has a date on which it was created, revised and established.
        ========================================================================================================================
        Need to address: Whether this date representation will be sufficient for us to compute on? We could also change it to the date-time format as provided by the dateTime
        XSLT 2.0 function.
      -->

      <xsl:text>&lt;&mesh;</xsl:text>
      <xsl:value-of select="DescriptorUI"/>
      <xsl:text>&gt; </xsl:text>
      <xsl:text>&lt;&mesh;dateCreated> </xsl:text>
      <xsl:text>"</xsl:text>
      <xsl:value-of
        select="xs:date(string-join((DateCreated/Year,DateCreated/Month,DateCreated/Day),'-'))"/>
      <xsl:text>" .&#10;</xsl:text>

      <xsl:if test="DateRevised">
        <xsl:text>&lt;&mesh;</xsl:text>
        <xsl:value-of select="DescriptorUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;&mesh;dateRevised> </xsl:text>
        <xsl:text>"</xsl:text>
        <xsl:value-of
          select="xs:date(string-join((DateRevised/Year,DateRevised/Month,DateRevised/Day),'-'))"/>
        <xsl:text>" .&#10;</xsl:text>
      </xsl:if>

      <xsl:if test="DateEstablished">
        <xsl:text>&lt;&mesh;</xsl:text>
        <xsl:value-of select="DescriptorUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;&mesh;dateEstablished> </xsl:text>
        <xsl:text>"</xsl:text>
        <xsl:value-of
          select="xs:date(string-join((DateEstablished/Year,DateEstablished/Month,DateEstablished/Day),'-'))"/>
        <xsl:text>" .&#10;</xsl:text>
      </xsl:if>

      <!--
        Tranformation rule: activeMeSHYear
        =======================================
        Output: <desc_uri> activeMeSHYear "year" .
        ==============================================
        Additional: This relation states that a descriptor record has an active MeSH year.
        ===================================================================================
        Need to address: N/A.
      -->
      <xsl:for-each select="ActiveMeSHYearList/Year">
        <xsl:text>&lt;&mesh;</xsl:text>
        <xsl:value-of select="../../DescriptorUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;&mesh;activeMeSHYear> </xsl:text>
        <xsl:text>"</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>" .&#10;</xsl:text>
      </xsl:for-each>

      <!--
        Transformation rule: historyNote
        ====================================
        Output: <desc_uri> historyNote "historyNote" .
        ==================================================
        Additional: This relation states that a descriptor has a history note.
        =======================================================================
        Need to address: N/A.
      -->

      <xsl:if test="HistoryNote">
        <xsl:text>&lt;&mesh;</xsl:text>
        <xsl:value-of select="DescriptorUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;&mesh;historyNote> </xsl:text>
        <xsl:value-of select='f:literal(HistoryNote)'/>
        <xsl:text> .&#10;</xsl:text>
      </xsl:if>

      <!--
        Transformation rule: onlineNote
        ====================================
        Output: <desc_uri> onlineNote "onlineote" .
        ================================================
        Additional: This relation states that a descriptor has a online note.
        =======================================================================
        Need to address: N/A.
      -->

      <xsl:if test="OnlineNote">
        <xsl:text>&lt;&mesh;</xsl:text>
        <xsl:value-of select="DescriptorUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;&mesh;onlineNote> </xsl:text>
        <xsl:value-of select='f:literal(OnlineNote)'/>
        <xsl:text> .&#10;</xsl:text>
      </xsl:if>

      <!--
        Transformation rule: publicMeSHNote
        ====================================
        Output: <desc_uri> publicMeSHNote "publicMeSHNote" .
        ==========================================================
        Additional: This relation states that a descriptor has a public MeSH note.
        =======================================================================
        Need to address: N/A
      -->

      <xsl:if test="PublicMeSHNote">
        <xsl:text>&lt;&mesh;</xsl:text>
        <xsl:value-of select="DescriptorUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;&mesh;publicMeSHNote> </xsl:text>
        <xsl:value-of select='f:literal(PublicMeSHNote)'/>
        <xsl:text> .&#10;</xsl:text>
      </xsl:if>

      <!--
        Transformation rule: previousIndexing
        =========================================
        Output: <desc_uri> previousIndexing "previousIndexing" .
        ============================================================
        Additional: This relation states that a descriptor has some previous indexing.
        ================================================================================
        Need to address: Whether there is any use in parsing the previous indexing text to derive 
        other triples.
      -->

      <xsl:if test="PreviousIndexingList">
        <xsl:for-each select="PreviousIndexingList/PreviousIndexing">
          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="../../DescriptorUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&mesh;previousIndexing> </xsl:text>
          <xsl:value-of select="f:literal(.)"/>
          <xsl:text> .&#10;</xsl:text>
        </xsl:for-each>
      </xsl:if>

      <!--
        Transformation rule: pharmacologicalAction>
        ===============================================
        Output: <desc_uri> pharmacologicalAction <desc_uri> ., where the two <desc_uri> values are 
        different.
        ==========================================================================================
        Additional: This relation states that a descriptor hasa pharmacological action.
        ================================================================================
        Need to address: The pharmacological action is represented here as a <desc_uri>. That is, 
        as a descriptor unique identifier. I felt this was the best thing to do since the 
        pharmacological action consists of a descriptor unique identifier and a name.
        But this information is already obtained by the XSLT code when it extracts the relations 
        in RDF. We can always get the name referred to by the pharmacological action by fetching 
        the name corresponding to the descriptor unique identifier, the <desc_uri>.
      -->

      <xsl:if test="PharmacologicalActionList">
        <xsl:for-each select="PharmacologicalActionList/PharmacologicalAction">
          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="../../DescriptorUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&mesh;pharmacologicalAction> </xsl:text>
          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="DescriptorReferredTo/DescriptorUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text> .&#10;</xsl:text>
        </xsl:for-each>
      </xsl:if>

      <!--
        Transformation rule: runningHead
        =====================================
        Output: <desc_uri> runningHead "runningHead" .
        ====================================================
        Additional: This relation says that a descriptor has a running head.
        =====================================================================
        Need to address: Whether or not there would be any value to breaking up the text of the 
        running head.
      -->

      <xsl:if test="RunningHead">
        <xsl:text>&lt;&mesh;</xsl:text>
        <xsl:value-of select="DescriptorUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;&mesh;runningHead> </xsl:text>
        <xsl:value-of select="f:literal(RunningHead)"/>
        <xsl:text> .&#10;</xsl:text>
      </xsl:if>

      <!--
        Transformation rule: recordOriginator, recordMaintainer, recordAuthorizer
        ===========================================================================
        Output: <desc_uri> recordOriginator "recordOriginator" .,
                <desc_uri> recordMaintainer "recordMaintainer" .,
                <desc_uri> recordOriginator "recordAuthorizer" .
        ==========================================================
        Additional: This relation states that a descriptor has a record originator, maintainer and 
        authorizer.
        ========================================================================================
        Need to address: N/A.
      -->

      <xsl:if test="RecordOriginatorsList">
        <xsl:text>&lt;&mesh;</xsl:text>
        <xsl:value-of select="DescriptorUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;&mesh;recordOriginator> </xsl:text>
        <xsl:text>"</xsl:text>
        <xsl:value-of select="RecordOriginatorsList/RecordOriginator"/>
        <xsl:text>" .&#10;</xsl:text>

        <xsl:text>&lt;&mesh;</xsl:text>
        <xsl:value-of select="DescriptorUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;&mesh;recordMaintainer> </xsl:text>
        <xsl:text>"</xsl:text>
        <xsl:value-of select="RecordOriginatorsList/RecordMaintainer"/>
        <xsl:text>" .&#10;</xsl:text>

        <xsl:text>&lt;&mesh;</xsl:text>
        <xsl:value-of select="DescriptorUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;&mesh;recordAuthorizer> </xsl:text>
        <xsl:text>"</xsl:text>
        <xsl:value-of select="RecordOriginatorsList/RecordAuthorizer"/>
        <xsl:text>" .&#10;</xsl:text>
      </xsl:if>

      <!--
        Transformation rules: seeAlso, hasRelatedDescriptor
        =====================================================
        Output: <desc_uri> seeAlso <desc_uri>, <desc_uri> hasRelatedDescriptor <desc_uri> .
        =============================================================================
        Additional:
        
        The <desc_uri> seeAlso <desc_uri> is different from what a person would see in the 
        MeSH browser. In the browser one would see <desc_uri> seeAlso "name".
        
        The <desc_uri> hasRelatedDescriptor <desc_uri> is where I decided to deviate from what 
        I saw in the browser b/c the descriptor UI remains unchanged even though the 
        descriptor name can change.
        ============================
        Need to address: I felt that some of the information in the SeeRelatedList element was 
        repetative b/c it consisted of a list of descriptor unique identifiers and names. Hence, 
        I decided to use the output specified above b/c we could always access the unique 
        identifier and name for a descriptor given its unique identifier, we extract this 
        information from the XML already. I thought the hasRelatedDescriptor relation was more 
        expressive and explicit in this case than the seeAlso relation.
      -->

      <xsl:if test="SeeRelatedList">
        <xsl:for-each select="SeeRelatedList/SeeRelatedDescriptor">

          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="../../DescriptorUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&rdfs;seeAlso&gt; </xsl:text>
          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="DescriptorReferredTo/DescriptorUI"/>
          <xsl:text>&gt;</xsl:text>
          <xsl:text> .&#10;</xsl:text>

        </xsl:for-each>
      </xsl:if>

      <!--
        Transformation rule: considerAlso
        ===================================
        Output: <desc_uri> considerAlso "considerAlso" .
        ==================================================
        Additional: 
        =================
        Need to address: Maybe we can break this up into several considerTermsAt
      -->

      <xsl:if test="ConsiderAlso">

        <xsl:text>&lt;&mesh;</xsl:text>
        <xsl:value-of select="DescriptorUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;&mesh;considerAlso> </xsl:text>
        <xsl:value-of select="f:literal(ConsiderAlso)"/>
        <xsl:text> .&#10;</xsl:text>
      </xsl:if>
    </xsl:for-each>

  </xsl:template>

</xsl:stylesheet>
