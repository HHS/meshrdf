<?xml version="1.0" encoding="ISO-8859-1"?>

<!--
<!DOCTYPE xsl:stylesheet [
  <!ENTITY uri1 "<http://nlm.nih.gov#MeSH:">
]>
-->

<xsl:stylesheet version="2.0" 
     xmlns:defaultns="http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#"
     xmlns:xs="http://www.w3.org/2001/XMLSchema"
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text"/>

<!--
Function name: replace-substring
=================================
Description: This function takes a string and replaces the occurence of a substring, "from", with that of another substring, "to".
-->

<xsl:template name="replace-substring">
      <xsl:param name="value" />
      <xsl:param name="from" />
      <xsl:param name="to" />
      <xsl:choose>
         <xsl:when test="contains($value,$from)">
            <xsl:value-of select="substring-before($value,$from)" />
            <xsl:value-of select="$to" />
            <xsl:call-template name="replace-substring">
               <xsl:with-param name="value" select="substring-after($value,$from)" />
               <xsl:with-param name="from" select="$from" />
               <xsl:with-param name="to" select="$to" />
            </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$value" />
         </xsl:otherwise>
      </xsl:choose>
</xsl:template>

<xsl:template match="/">

  <!-- triples for Descriptors -->
  
  <xsl:for-each select="DescriptorRecordSet/DescriptorRecord">

      
      <!--
      Transformation rule: dcterms:identifier
      ========================================
      Output: <desc_uri> dcterms:identifier "descUI" .
      =================================================
      Additional: This relation states that a descriptor record has a unique identifier.
      ===================================================================================
      Need to address: N/A
      -->
            
      <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="DescriptorUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text> 
      <xsl:text disable-output-escaping="yes">&lt;http://purl.org/dc/terms/identifier&gt; </xsl:text> 
      <xsl:text disable-output-escaping="yes">"</xsl:text><xsl:value-of select="DescriptorUI"/><xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>


      <!--
      Transformation rule: rdf:type
      =================================
      Output: <desc_uri> rdf:type <Descriptor> .
      =============================================================
      Additional: This relation states that a Subject node used to identify a Descriptor record is of type "Descritpor".
      -->

      <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="DescriptorUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text>
      <xsl:text disable-output-escaping="yes">&lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#type&gt; </xsl:text> 
      <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:Descriptor&gt; .&#10;</xsl:text> 

      
      <!-- 
      Transformation rule: descriptorClass
      ======================================
      Output: <desc_uri> descriptorClass "descriptorClass" .
      =======================================================
      Additional: This relation states that a descriptor record has a descriptor class to which it belongs to.
      =========================================================================================================
      Need to address: N/A
      -->
      
      <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="DescriptorUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text> 
      <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:descriptorClass> </xsl:text> 
      <xsl:text disable-output-escaping="yes">"</xsl:text><xsl:value-of select="@DescriptorClass"/><xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>  

      <!--
      Transformation rule: rdfs:label
      =======================================
      Output: <desc_uri> rdfs:label "descName" .
      ==================================================
      Additional: This relation states that a descriptor record has a name.
      ======================================================================
      Need to address: N/A.
      -->
      
      <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="DescriptorUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text> 
      <xsl:text disable-output-escaping="yes">&lt;http://www.w3.org/2000/01/rdf-schema#label&gt; </xsl:text> 
      <xsl:text disable-output-escaping="yes">"</xsl:text>
      <xsl:call-template name="replace-substring">
         <!-- escape any double-quote character as per the N-Triple format specification --> 
         <xsl:with-param name="value" select="DescriptorName/String"/>
         <xsl:with-param name="from" select="'&quot;'"/>
         <xsl:with-param name="to">\"</xsl:with-param>
      </xsl:call-template>
      <xsl:text disable-output-escaping="yes">" .&#10;</xsl:text> 
      
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
        
        <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="../../DescriptorUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text> 
        <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:concept&gt; </xsl:text> 
        <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="ConceptUI"/><xsl:text disable-output-escaping="yes">&gt;</xsl:text>
        <xsl:text disable-output-escaping="yes"> .&#10;</xsl:text> 


       <!--
       Transformation rule/Relation: rdf:type
       =======================================
       Output: <conc_uri> rdf:type <Concept> .
       =========================================
       Description: This relation states that a Subject node used to identify a concept is of type "Concept".
       ========================================================================================================
       Need to address: N/A.
       -->
       <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="ConceptUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text>
       <xsl:text disable-output-escaping="yes">&lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#type&gt; </xsl:text> 
       <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:Concept&gt; .&#10;</xsl:text> 

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
        <xsl:if test="@PreferredConceptYN = 'Y'">
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="ConceptUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text>
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:isPreferredConcept> </xsl:text>
          <xsl:text disable-output-escaping="yes">"Y</xsl:text><xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
        </xsl:if>

        <xsl:if test="@PreferredConceptYN = 'N'">
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="ConceptUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text>
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:isPreferredConcept> </xsl:text>
          <xsl:text disable-output-escaping="yes">"N</xsl:text><xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
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
        
        <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="ConceptUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text> 
        <xsl:text disable-output-escaping="yes">&lt;http://www.w3.org/2000/01/rdf-schema#label&gt; </xsl:text>
        <xsl:text disable-output-escaping="yes">"</xsl:text>
        <xsl:call-template name="replace-substring">
          <!-- escape any double-quote character as per the N-Triple format specification --> 
          <xsl:with-param name="value" select="ConceptName/String"/>
          <xsl:with-param name="from" select="'&quot;'"/>
          <xsl:with-param name="to">\"</xsl:with-param>
        </xsl:call-template>
        <xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>

        <!--
        Transformation rule: dcterms:identifier
        ========================================
        Output: <conc_uri> dcterms:identifier "concUI" .
        =================================================
        Additional: This relation states that a concept has a unique identifier.
        =========================================================================
        Need to address: N/A.
        -->

        <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="ConceptUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text> 
        <xsl:text disable-output-escaping="yes">&lt;http://purl.org/dc/terms/identifier&gt; </xsl:text> 
        <xsl:text disable-output-escaping="yes">"</xsl:text><xsl:value-of select="ConceptUI"/><xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
        
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
            <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="ConceptUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text> 
            <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:UMLS_CUI> </xsl:text> 
            <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#UMLS_MT:</xsl:text><xsl:value-of select="ConceptUMLSUI"/><xsl:text disable-output-escaping="yes">&gt; .&#10;</xsl:text>
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
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="ConceptUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text> 
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:CASN1_label&gt; </xsl:text> 
          <xsl:text disable-output-escaping="yes">"</xsl:text><xsl:value-of select="CASN1Name"/><xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
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
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="ConceptUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text> 
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:registryNumber> </xsl:text> 
          <xsl:text disable-output-escaping="yes">"</xsl:text><xsl:value-of select="RegistryNumber"/><xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
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
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="ConceptUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text> 
          <xsl:text disable-output-escaping="yes">&lt;http://www.w3.org/2004/02/skos/core#scopeNote&gt; </xsl:text> 
          <xsl:text disable-output-escaping="yes">"</xsl:text>
          
          
          <xsl:call-template name="replace-substring">
            <xsl:with-param name="value" select="replace(ScopeNote, '&quot;', '\\&quot;')"/>
            <xsl:with-param name="from" select="'&#10;'"/>
            <xsl:with-param name="to">&#10;</xsl:with-param>
          </xsl:call-template>
          <xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
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
            <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="../../ConceptUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text> 
            <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:semanticType> </xsl:text> 
            <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="SemanticTypeUI"/><xsl:text disable-output-escaping="yes">&gt;</xsl:text>
            <xsl:text disable-output-escaping="yes"> .&#10;</xsl:text>


	    <!--
            Transformation rule: rdf:type
            ===============================
            Output: <semType_uri> rdf:type <SemanticType> .
            =================================================
            Additional: This relation states that a concept has a semantic type.
            =====================================================================
            Need to address: N/A.
            -->

           <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="SemanticTypeUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text>
           <xsl:text disable-output-escaping="yes">&lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#type&gt; </xsl:text> 
           <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:SemanticType&gt; .&#10;</xsl:text> 
        
    
            <!--
            Transformation rule: rdfs:label
            ==========================================
            Output: <semType_uri> rdfs:label "semanticTypeName" .
            ===============================================================
            Additional: This rule states the a semantic type unique identifier has a semantic type name.
            ==============================================================================================
            Need to address: I'm not sure if this relation is correct. But we've created this type of relation for the concepts of a descriptor. We should check this (for e.g.,
            with a MeSH expert or by a literature search).
            -->
            
            <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="SemanticTypeUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;http://www.w3.org/2000/01/rdf-schema#label&gt; </xsl:text>
            <xsl:text disable-output-escaping="yes">"</xsl:text><xsl:value-of select="SemanticTypeName"/><xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>

	    <!--
            Transformation rule: dcterms:identifier
            =========================================
            Output: <semType_uri> dcterms:identifier "semTypeUI" .
            =======================================================
            Additional: This rule states that a semantic type has a unique identifier.
            -->
            
            <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="SemanticTypeUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;http://purl.org/dc/terms/identifier&gt; </xsl:text>
            <xsl:text disable-output-escaping="yes">"</xsl:text><xsl:value-of select="SemanticTypeUI"/><xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
          </xsl:for-each>
        </xsl:if>
        
        <!--
        Transformation rule: relatedRegistryNumber
        ===============================================
        Output: <conc_uri> relatedRegistryNumber "relatedRegistryNumber" .
        ======================================================================
        Additional: This relation states that a concept has a related registry number.
        ================================================================================
        Need to address: Maybe it would be good to reduce this value to only a number. But I'm not sure. Need to check with a MeSH epert to see how important is the text
        after the number.
        -->
        
        <xsl:if test="RelatedRegistryNumberList">
          <xsl:for-each select="RelatedRegistryNumberList/RelatedRegistryNumber">
            <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="../../ConceptUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text> 
            <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:relatedRegistryNumber> </xsl:text> 
            <xsl:text disable-output-escaping="yes">"</xsl:text><xsl:value-of select="."/><xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
          </xsl:for-each>
        </xsl:if>
        
        
        <xsl:if test="ConceptRelationList">
          <xsl:for-each select="ConceptRelationList/ConceptRelation">

            <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="../../ConceptUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:conceptRelation> </xsl:text>
            <xsl:text disable-output-escaping="yes">_:blank_set1_</xsl:text><xsl:value-of select="../../ConceptUI"/>_<xsl:value-of select="position()"/>           
            <xsl:text disable-output-escaping="yes"> .&#10;</xsl:text>


	    <xsl:text disable-output-escaping="yes">_:blank_set1_</xsl:text><xsl:value-of select="../../ConceptUI"/>_<xsl:value-of select="position()"/>
            <xsl:text disable-output-escaping="yes"> &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#type&gt; </xsl:text> 
            <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:ConceptRelation&gt; .&#10;</xsl:text>


	    <xsl:if test="@RelationName">
               <xsl:text disable-output-escaping="yes">_:blank_set1_</xsl:text><xsl:value-of select="../../ConceptUI"/>_<xsl:value-of select="position()"/>
               <xsl:text disable-output-escaping="yes"> &lt;http://nlm.nih.gov#MeSH:relation&gt; </xsl:text>
               <xsl:text disable-output-escaping="yes">&lt;http://www.w3.org/2004/02/skos/core#</xsl:text>
		<xsl:if test= "matches(@RelationName, 'BRD')">
			<xsl:text disable-output-escaping="yes">broader</xsl:text>
		</xsl:if>
		<xsl:if test= "matches(@RelationName, 'NRW')">
			<xsl:text disable-output-escaping="yes">narrower</xsl:text>
		</xsl:if>
		<xsl:if test= "matches(@RelationName, 'REL')">
			<xsl:text disable-output-escaping="yes">related</xsl:text>
		</xsl:if>
            <xsl:text disable-output-escaping="yes">&gt; .&#10;</xsl:text>
	   </xsl:if>

            <xsl:text disable-output-escaping="yes">_:blank_set1_</xsl:text><xsl:value-of select="../../ConceptUI"/>_<xsl:value-of select="position()"/>
            <xsl:text disable-output-escaping="yes"> &lt;http://nlm.nih.gov#MeSH:concept1> </xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="Concept1UI"/><xsl:text disable-output-escaping="yes">&gt;</xsl:text><xsl:text disable-output-escaping="yes"> .&#10;</xsl:text>
            
            <xsl:text disable-output-escaping="yes">_:blank_set1_</xsl:text><xsl:value-of select="../../ConceptUI"/>_<xsl:value-of select="position()"/>
            <xsl:text disable-output-escaping="yes"> &lt;http://nlm.nih.gov#MeSH:concept2> </xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="Concept2UI"/><xsl:text disable-output-escaping="yes">&gt;</xsl:text><xsl:text disable-output-escaping="yes"> .&#10;</xsl:text>
            

	<!-- added by rw -->
	<xsl:if test="RelationAttribute">
          <xsl:text disable-output-escaping="yes">_:blank_set1_</xsl:text><xsl:value-of select="../../ConceptUI"/>_<xsl:value-of select="position()"/>
          <xsl:text disable-output-escaping="yes"> &lt;http://nlm.nih.gov#MeSH:relationAttribute> </xsl:text>
          <xsl:text disable-output-escaping="yes">"</xsl:text><xsl:value-of select="RelationAttribute"/><xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
	</xsl:if>


          </xsl:for-each><!-- ConceptRelationList/ConceptRelation -->
        </xsl:if><!-- ConceptRelationList -->
        
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
          
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="../../ConceptUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text> 
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:term> </xsl:text>
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="TermUI"/><xsl:text disable-output-escaping="yes">&gt;</xsl:text>
          <xsl:text disable-output-escaping="yes"> .&#10;</xsl:text>


	  <!--
          Transformation rule: rdf:type
          ==============================
          Output: <term_uri> rdf:type <Term> .
          ========================================
          Additional: A concept has at least one term associated with it.
          -->

	  <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="TermUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text>
	  <xsl:text disable-output-escaping="yes">&lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#type&gt; </xsl:text> 
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:Term&gt; .&#10;</xsl:text> 

          
          <!--
          Transformation rule: dcterms:identifier
          =======================================
          Output: <term_uri> dcterms:identifier "termUI" .
          ==================================================
          Additional: This relation states that a term has a term unique identifier.
          ============================================================================
          Need to address: N/A.
          -->
          
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="TermUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text>
          <xsl:text disable-output-escaping="yes">&lt;http://purl.org/dc/terms/identifier&gt; </xsl:text>
          <xsl:text disable-output-escaping="yes">"</xsl:text><xsl:value-of select="TermUI"/><xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
          
          <xsl:if test= "@IsPermutedTermYN = 'N'">
              <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="TermUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text>
              <xsl:text disable-output-escaping="yes">&lt;http://www.w3.org/2000/01/rdf-schema#label&gt; </xsl:text>
              <xsl:text disable-output-escaping="yes">"</xsl:text><xsl:value-of select="String"/><xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
          </xsl:if>
          
          <!--
          Transformation rule: termData
          =================================================================
          Output: <term_uri> termData _:blankTermUI_termNumber .
          ==========================================================
          Addtional: This relation states that a term has data associated with it. A blank node stores the term data.
          ============================================================================================================
          Need to address: This relation was created in order to stick with the XML representation of MeSH.
          -->
          
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="TermUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text> 
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:termData&gt; </xsl:text>
          <xsl:text disable-output-escaping="yes">_:blank</xsl:text><xsl:value-of select="TermUI"/>_<xsl:value-of select="position()"/><xsl:text disable-output-escaping="yes"> .&#10;</xsl:text>


          <!--
          Transformation rule/Relation: rdf:type
          =======================================
          Output: _:blankTermUI_termNumber rdf:type <TermData> .
          =======================================================
          Description: This relation states that a Subject node used to identify term data is of type "TermData".
          ========================================================================================================
          Need to address: N/A.
          -->   

	  <xsl:text disable-output-escaping="yes">_:blank</xsl:text><xsl:value-of select="TermUI"/>_<xsl:value-of select="position()"/><xsl:text disable-output-escaping="yes"> </xsl:text>
          <xsl:text disable-output-escaping="yes">&lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#type&gt; </xsl:text> 
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:TermData&gt; .&#10;</xsl:text> 


          <!--
          Transformation rule: isConceptPreferredTerm
          ============================================
          Output: _:blankTermUI_termNo isConceptPreferredTerm "Y/N" .
          ============================================================
          Additional: This relation states that a term can be a concept-preferred-term. But it does so indirectly because the isConceptPreferredTerm relation is with a blank node.
          ===========================================================================================================================================================================
          Need to address: N/A.
          -->

          <xsl:text disable-output-escaping="yes">_:blank</xsl:text><xsl:value-of select="TermUI"/>_<xsl:value-of select="position()"/><xsl:text disable-output-escaping="yes"> </xsl:text>
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:isConceptPreferredTerm&gt; </xsl:text>
          <xsl:text disable-output-escaping="yes">"</xsl:text><xsl:value-of select="@ConceptPreferredTermYN"/><xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
          
          
          <!--
          Transformation rule: isPermutedTerm
          =====================================
          Output: _:blankTermUI_termNo isPermutedTerm "Y/N" .
          =====================================================
          Additional: This relation states that a term can be a permuted term. But it does so indirectly because the isPermutedTerm relation is with a blank node.
          =========================================================================================================================================================
          Need to address: N/A.
          -->
          
          <xsl:text disable-output-escaping="yes">_:blank</xsl:text><xsl:value-of select="TermUI"/>_<xsl:value-of select="position()"/><xsl:text disable-output-escaping="yes"> </xsl:text>
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:isPermutedTerm&gt; </xsl:text>
          <xsl:text disable-output-escaping="yes">"</xsl:text><xsl:value-of select="@IsPermutedTermYN"/><xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
          
          <!--
          Transformation rule: lexicalTag
          ===================================
          Output: _:blankTermUI_termNo lexicalTag "lexicalTag" .
          ==========================================================
          Additional: This relation states that a term has a lexical tag. But it does so indirectly becuase the hasLexicalTag relation is with a blank node.
          ====================================================================================================================================================
          Need to address: N/A.
          -->
          
          <xsl:text disable-output-escaping="yes">_:blank</xsl:text><xsl:value-of select="TermUI"/>_<xsl:value-of select="position()"/><xsl:text disable-output-escaping="yes"> </xsl:text>
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:lexicalTag&gt; </xsl:text>
          <xsl:text disable-output-escaping="yes">"</xsl:text><xsl:value-of select="@LexicalTag"/><xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
          
          <!--
          Transformation rule: printFlag
          ===================================
          Output: _:blankTermUI_termNo printFlag "Y/N" .
          ==================================================
          Additional: This relation states that a term has a print flag. But it does this indirectly because the hasPrintFlag relation is with a blank node.
          ===================================================================================================================================================
          Need to address: N/A.
          -->
          
          <xsl:text disable-output-escaping="yes">_:blank</xsl:text><xsl:value-of select="TermUI"/>_<xsl:value-of select="position()"/><xsl:text disable-output-escaping="yes"> </xsl:text>
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:printFlag&gt; </xsl:text>
          <xsl:text disable-output-escaping="yes">"</xsl:text><xsl:value-of select="@PrintFlagYN"/><xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
          
          <!--
          Transformation rule: isRecordPreferredTerm
          ===========================================
          Output: _:blankTermUI_termNo isRecordPreferredTerm "Y/N" .
          ============================================================
          Additional: This relation states that a term can be a record preferred term. But it does this indirectly because the relation is with a blank node.
          ====================================================================================================================================================
          Need to address: N/A.
          -->
          
          <xsl:text disable-output-escaping="yes">_:blank</xsl:text><xsl:value-of select="TermUI"/>_<xsl:value-of select="position()"/><xsl:text disable-output-escaping="yes"> </xsl:text>
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:isRecordPreferredTerm&gt; </xsl:text>
          <xsl:text disable-output-escaping="yes">"</xsl:text><xsl:value-of select="@RecordPreferredTermYN"/><xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
          
          <!--
          Transformation rule: dcterms:identifier
          ========================================
          Output: _:blankTermUI_termNo dcterms:identifier "termUI" .
          ===========================================================
          Additional: This relation states that a term has a term unique identifier. However, it does so indirectly because the relation is with a blank node.
          ======================================================================================================================================================
          Additional: N/A.
          -->

          <xsl:text disable-output-escaping="yes">_:blank</xsl:text><xsl:value-of select="TermUI"/>_<xsl:value-of select="position()"/><xsl:text disable-output-escaping="yes"> </xsl:text>
          <xsl:text disable-output-escaping="yes">&lt;http://purl.org/dc/terms/identifier&gt; </xsl:text>
          <xsl:text disable-output-escaping="yes">"</xsl:text><xsl:value-of select="TermUI"/><xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
          
          <!--
          Transformation rule: rdfs:label
          =================================
          Output: _:blankTermUI_termNo rdfs:label "termName" .
          ======================================================
          Additional: This relation states that a term has a term name. But it does so indirectly because the relation is with a blank node.
          ====================================================================================================================================
          Need to address: N/A.
          -->
          
          <xsl:text disable-output-escaping="yes">_:blank</xsl:text><xsl:value-of select="TermUI"/>_<xsl:value-of select="position()"/><xsl:text disable-output-escaping="yes"> </xsl:text>
          <xsl:text disable-output-escaping="yes">&lt;http://www.w3.org/2000/01/rdf-schema#label&gt; </xsl:text>
          <xsl:text disable-output-escaping="yes">"</xsl:text><xsl:value-of select="String"/><xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
          
          
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
              <xsl:text disable-output-escaping="yes">_:blank</xsl:text><xsl:value-of select="TermUI"/>_<xsl:value-of select="position()"/><xsl:text disable-output-escaping="yes"> </xsl:text>
              <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:dateCreated&gt; </xsl:text>
              <xsl:text disable-output-escaping="yes">"</xsl:text><xsl:value-of select="string-join((DateCreated/Year,DateCreated/Month,DateCreated/Day),'-')"/><xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
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
            <xsl:text disable-output-escaping="yes">_:blank</xsl:text><xsl:value-of select="TermUI"/>_<xsl:value-of select="position()"/><xsl:text disable-output-escaping="yes"> </xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:abbreviation> </xsl:text>
            <xsl:text disable-output-escaping="yes">"</xsl:text><xsl:value-of select="Abbreviation"/><xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
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
            <xsl:text disable-output-escaping="yes">_:blank</xsl:text><xsl:value-of select="TermUI"/>_<xsl:value-of select="position()"/><xsl:text disable-output-escaping="yes"> </xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:sortVersion> </xsl:text>
            <xsl:text disable-output-escaping="yes">"</xsl:text><xsl:value-of select="SortVersion"/><xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
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
            <xsl:text disable-output-escaping="yes">_:blank</xsl:text><xsl:value-of select="TermUI"/>_<xsl:value-of select="position()"/><xsl:text disable-output-escaping="yes"> </xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:entryVersion> </xsl:text>
            <xsl:text disable-output-escaping="yes">"</xsl:text><xsl:value-of select="EntryVersion"/><xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
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
              <xsl:text disable-output-escaping="yes">_:blank</xsl:text><xsl:value-of select="../../TermUI"/>_<xsl:copy-of select="$pos"/><xsl:text disable-output-escaping="yes"> </xsl:text>
              <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:thesaurusID> </xsl:text>
              <xsl:text disable-output-escaping="yes">"</xsl:text>
              
              <xsl:call-template name="replace-substring"> 
                <xsl:with-param name="value" select="."/>
                <xsl:with-param name="from" select="'&#10;'"/>
                <xsl:with-param name="to">&#10;</xsl:with-param>
              </xsl:call-template>
              <xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
            </xsl:for-each>
          </xsl:if>
          
        </xsl:for-each><!-- TermList/Term -->
      </xsl:for-each><!-- ConceptList/Concept -->
      
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
          
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="../../DescriptorUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text> 
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:entryCombination&gt; </xsl:text>
          <xsl:text disable-output-escaping="yes">_:blank</xsl:text><xsl:value-of select="../../DescriptorUI"/>_<xsl:value-of select="position()"/><xsl:text disable-output-escaping="yes"> .&#10;</xsl:text>


	  <!--
          Transformation rule/Relation: rdf:type
          ========================================
          Output: _:blankDescriptorUI_entryCombinationNumber	 rdf:type 	<EntryCombination> .
          ==============================================================================================
          Description: This relation states that a Subject node used to identify an entry combination is of type "EntryCombination".
          ============================================================================================================================
          Need to address: N/A.
          -->
	  <xsl:text disable-output-escaping="yes">_:blank</xsl:text><xsl:value-of select="../../DescriptorUI"/>_<xsl:value-of select="position()"/><xsl:text disable-output-escaping="yes"> </xsl:text>
	  <xsl:text disable-output-escaping="yes">&lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#type&gt; </xsl:text> 
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:EntryCombination&gt; .&#10;</xsl:text> 
          
          <xsl:text disable-output-escaping="yes">_:blank</xsl:text><xsl:value-of select="../../DescriptorUI"/>_<xsl:value-of select="position()"/><xsl:text disable-output-escaping="yes"> </xsl:text>
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:ECINDescriptor&gt; </xsl:text>
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="ECIN/DescriptorReferredTo/DescriptorUI"/><xsl:text disable-output-escaping="yes">&gt;</xsl:text>
          <xsl:text disable-output-escaping="yes"> .&#10;</xsl:text>
          
          <xsl:text disable-output-escaping="yes">_:blank</xsl:text><xsl:value-of select="../../DescriptorUI"/>_<xsl:value-of select="position()"/><xsl:text disable-output-escaping="yes"> </xsl:text>
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:ECINQualifier&gt; </xsl:text>
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="ECIN/QualifierReferredTo/QualifierUI"/><xsl:text disable-output-escaping="yes">&gt;</xsl:text>
          <xsl:text disable-output-escaping="yes"> .&#10;</xsl:text>
          
          <xsl:text disable-output-escaping="yes">_:blank</xsl:text><xsl:value-of select="../../DescriptorUI"/>_<xsl:value-of select="position()"/><xsl:text disable-output-escaping="yes"> </xsl:text>
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:ECOUTDescriptor&gt; </xsl:text>
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="ECOUT/DescriptorReferredTo/DescriptorUI"/><xsl:text disable-output-escaping="yes">&gt;</xsl:text>
          <xsl:text disable-output-escaping="yes"> .&#10;</xsl:text>
          
          <xsl:if test="ECOUT/QualifierReferredTo">
            <xsl:text disable-output-escaping="yes">_:blank</xsl:text><xsl:value-of select="../../DescriptorUI"/>_<xsl:value-of select="position()"/><xsl:text disable-output-escaping="yes"> </xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:ECOUTQualifier&gt; </xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="ECOUT/QualifierReferredTo/QualifierUI"/><xsl:text disable-output-escaping="yes">&gt;</xsl:text>
            <xsl:text disable-output-escaping="yes"> .&#10;</xsl:text>
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
          
            <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="../../DescriptorUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text> 
            <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:allowableQualifier&gt; </xsl:text> 
            <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="QualifierReferredTo/QualifierUI"/><xsl:text disable-output-escaping="yes">&gt;</xsl:text>
            <xsl:text disable-output-escaping="yes"> .&#10;</xsl:text>


	    <!--
      	    Transformation rule: rdf:type
      	    =================================
      	    Output: <qual_uri> rdf:type <Qualifier> .
      	    =============================================================
      	    Additional: This relation states that a Subject node used to identify a Descriptor record is of type "Descritpor".
      	    -->

	    <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="QualifierReferredTo/QualifierUI"/><xsl:text disable-output-escaping="yes">&gt;</xsl:text><xsl:text disable-output-escaping="yes"> </xsl:text>
	    <xsl:text disable-output-escaping="yes">&lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#type&gt; </xsl:text> 
      	    <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:Qualifier&gt; .&#10;</xsl:text> 

            
            <!--
            Transformation rule: dcterms:identifier
            =========================================
            Output: <qual_uri> dcterms:identifier "qualUI" .
            =================================================
            Additional: This relation states that an allowable qualifier has a unique identifier.
            ======================================================================================
            Need to address: N/A.
            -->
            
            <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="QualifierReferredTo/QualifierUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;http://purl.org/dc/terms/identifier&gt; </xsl:text> 
            <xsl:text disable-output-escaping="yes">"</xsl:text><xsl:value-of select="QualifierReferredTo/QualifierUI"/><xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
            
            <!--
            Transformation rule: rdfs:label
            ======================================
            Output: <qual_uri> rdfs:label "qualName" .
            ===================================================
            Additional: This relation states that an allowable qualifier has a name.
            =========================================================================
            Need to address: N/A.
            -->
            
            <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="QualifierReferredTo/QualifierUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;http://www.w3.org/2000/01/rdf-schema#label&gt; </xsl:text> 
            <xsl:text disable-output-escaping="yes">"</xsl:text><xsl:value-of select="QualifierReferredTo/QualifierName/String"/><xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
            
            <!--
            Transformation rule: abbreviation
            ==============================================
            Output: <qual_uri> abbreviation "qualAbbrev" .
            ===================================================
            Additional: This relation states that an allowable qualifier has an abbreviation.
            ===================================================================================
            Need to address: N/A.
            -->
            
            <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="QualifierReferredTo/QualifierUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:abbreviation&gt; </xsl:text> 
            <xsl:text disable-output-escaping="yes">"</xsl:text><xsl:value-of select="Abbreviation"/><xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
            
          </xsl:for-each><!-- AllowableQualifiersList/AllowableQualifier" -->
          
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
            
              <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="../../DescriptorUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text> 
              <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:treeNumber&gt; </xsl:text> 
              <xsl:text disable-output-escaping="yes">"</xsl:text><xsl:value-of select="."/>
              <xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
              
            <!-- /xsl:for-each --><!-- TreeNumber -->
          </xsl:for-each><!-- TreeNumberList -->
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
        
        <!-- xsl:template match="Annotation" --><!-- I'm not sure why, but template cannot go here in the document -->
        <xsl:if test="Annotation"><!-- This if statement is necessary to ensure that the hasAnnotation relationship is extracted ONLY when the Annotation element exists
        for a descriptor record. This if statements checks to see if the element Annotation exists for a descriptor record. -->
          <!-- hasAnnotation -->
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="DescriptorUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text> 
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:annotation> </xsl:text> 
          <xsl:text disable-output-escaping="yes">"</xsl:text>
          
          <xsl:call-template name="replace-substring">
            <xsl:with-param name="value" select="replace(Annotation, '&quot;', '\\&quot;')"/>
            <xsl:with-param name="from" select="'&#10;'"/>
            <xsl:with-param name="to">&#10;</xsl:with-param>
          </xsl:call-template>         
          <xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
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
        
        <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="DescriptorUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text> 
        <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:dateCreated> </xsl:text> 
        <xsl:text disable-output-escaping="yes">"</xsl:text><xsl:value-of select="xs:date(string-join((DateCreated/Year,DateCreated/Month,DateCreated/Day),'-'))"/><xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
        
        <xsl:if test="DateRevised">
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="DescriptorUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text> 
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:dateRevised> </xsl:text> 
          <xsl:text disable-output-escaping="yes">"</xsl:text><xsl:value-of select="xs:date(string-join((DateRevised/Year,DateRevised/Month,DateRevised/Day),'-'))"/><xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
        </xsl:if>
        
        <xsl:if test="DateEstablished">
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="DescriptorUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text> 
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:dateEstablished> </xsl:text> 
          <xsl:text disable-output-escaping="yes">"</xsl:text><xsl:value-of select="xs:date(string-join((DateEstablished/Year,DateEstablished/Month,DateEstablished/Day),'-'))"/><xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
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
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="../../DescriptorUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text> 
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:activeMeSHYear> </xsl:text> 
          <xsl:text disable-output-escaping="yes">"</xsl:text><xsl:value-of select="."/><xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
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
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="DescriptorUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text> 
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:historyNote> </xsl:text>
          <xsl:text disable-output-escaping="yes">"</xsl:text>

          <xsl:call-template name="replace-substring">
                     <xsl:with-param name="value" select="replace(HistoryNote, '&quot;', '\\&quot;')"/>
                     <xsl:with-param name="from" select="'&#10;'"/>
                     <xsl:with-param name="to">&#10;</xsl:with-param>
          </xsl:call-template>
          <xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
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
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="DescriptorUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text> 
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:onlineNote> </xsl:text>
          <xsl:text disable-output-escaping="yes">"</xsl:text>

          <xsl:call-template name="replace-substring"> 
                     <xsl:with-param name="value" select="replace(OnlineNote, '&quot;', '\\&quot;')"/>
                     <xsl:with-param name="from" select="'&#10;'"/>
                     <xsl:with-param name="to">&#10;</xsl:with-param>
          </xsl:call-template>
          <xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
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
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="DescriptorUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text> 
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:publicMeSHNote> </xsl:text>
          <xsl:text disable-output-escaping="yes">"</xsl:text>

          <xsl:call-template name="replace-substring"> 
            <xsl:with-param name="value" select="replace(PublicMeSHNote, '&quot;', '\\&quot;')"/>
            <xsl:with-param name="from" select="'&#10;'"/>
            <xsl:with-param name="to">&#10;</xsl:with-param>
          </xsl:call-template>
          <xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
        </xsl:if>
        
        <!--
        Transformation rule: previousIndexing
        =========================================
        Output: <desc_uri> previousIndexing "previousIndexing" .
        ============================================================
        Additional: This relation states that a descriptor has some previous indexing.
        ================================================================================
        Need to address: Whether there is any use in parsing the previous indexing text to derive other triples.
        -->
        
        <xsl:if test="PreviousIndexingList">
          <xsl:for-each select="PreviousIndexingList/PreviousIndexing">
            <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="../../DescriptorUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text> 
            <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:previousIndexing> </xsl:text>
            <xsl:text disable-output-escaping="yes">"</xsl:text>

            <xsl:call-template name="replace-substring"> 
              <xsl:with-param name="value" select="."/>
              <xsl:with-param name="from" select="'&#10;'"/>
              <xsl:with-param name="to">&#10;</xsl:with-param>
            </xsl:call-template>
            <xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
          </xsl:for-each>
        </xsl:if>
        
        <!--
        Transformation rule: pharmacologicalAction>
        ===============================================
        Output: <desc_uri> pharmacologicalAction <desc_uri> ., where the two <desc_uri> values are different.
        =======================================================================================================
        Additional: This relation states that a descriptor hasa pharmacological action.
        ================================================================================
        Need to address: The pharmacological action is represented here as a <desc_uri>. That is, as a descriptor unique identifier.
        I felt this was the best thing to do since the pharmacological action consists of a descriptor unique identifier and a name.
        But this information is already obtained by the XSLT code when it extracts the relations in RDF. We can always get the name
        referred to by the pharmacological action by fetching the name corresponding to the descriptor unique identifier, the <desc_uri>.
        -->
        
        <xsl:if test="PharmacologicalActionList">
          <xsl:for-each select="PharmacologicalActionList/PharmacologicalAction">
            <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="../../DescriptorUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:pharmacologicalAction> </xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="DescriptorReferredTo/DescriptorUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text>
            <xsl:text disable-output-escaping="yes"> .&#10;</xsl:text>
          </xsl:for-each>
        </xsl:if>
        
        <!--
        Transformation rule: runningHead
        =====================================
        Output: <desc_uri> runningHead "runningHead" .
        ====================================================
        Additional: This relation says that a descriptor has a running head.
        =====================================================================
        Need to address: Whether or not there would be any value to breaking up the text of the running head.
        -->
        
        <xsl:if test="RunningHead">
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="DescriptorUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text>
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:runningHead> </xsl:text>
          <xsl:text disable-output-escaping="yes">"</xsl:text>
          
          <xsl:call-template name="replace-substring"> 
            <xsl:with-param name="value" select="replace(RunningHead, '&quot;', '\\&quot;')"/>
            <xsl:with-param name="from" select="'&#10;'"/>
            <xsl:with-param name="to">&#10;</xsl:with-param>
          </xsl:call-template>
          <xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
        </xsl:if>
        
        <!--
        Transformation rule: recordOriginator, recordMaintainer, recordAuthorizer
        ===========================================================================
        Output: <desc_uri> recordOriginator "recordOriginator" .,
                <desc_uri> recordMaintainer "recordMaintainer" .,
                <desc_uri> recordOriginator "recordAuthorizer" .
        ==========================================================
        Additional: This relation states that a descriptor has a record originator, maintainer and authorizer.
        =======================================================================================================
        Need to address: N/A.
        -->
                
        <xsl:if test="RecordOriginatorsList">
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="DescriptorUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text>
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:recordOriginator> </xsl:text>
          <xsl:text disable-output-escaping="yes">"</xsl:text><xsl:value-of select="RecordOriginatorsList/RecordOriginator"/><xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>

          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="DescriptorUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text>
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:recordMaintainer> </xsl:text>
          <xsl:text disable-output-escaping="yes">"</xsl:text><xsl:value-of select="RecordOriginatorsList/RecordMaintainer"/><xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>

          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="DescriptorUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text>
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:recordAuthorizer> </xsl:text>
          <xsl:text disable-output-escaping="yes">"</xsl:text><xsl:value-of select="RecordOriginatorsList/RecordAuthorizer"/><xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
        </xsl:if>
        
        <!--
        Transformation rules: seeAlso, hasRelatedDescriptor
        =====================================================
        Output: <desc_uri> seeAlso <desc_uri>, <desc_uri> hasRelatedDescriptor <desc_uri> .
        =============================================================================
        Additional:
        
        The <desc_uri> seeAlso <desc_uri> is different from what a person would see in the MeSH browser. In the browser one would see <desc_uri> seeAlso "name".
        
        The <desc_uri> hasRelatedDescriptor <desc_uri> is where I decided to deviate from what I saw in the browser b/c the descriptor UI remains unchanged even though the 
        descriptor name can change.
        ============================
        Need to address: I felt that some of the information in the SeeRelatedList element was repetative b/c it consisted of a list of descriptor unique identifiers
        and names. Hence, I decided to use the output specified above b/c we could always access the unique identifier and name for a descriptor given its unique 
        identifier, we extract this information from the XML already. I thought the hasRelatedDescriptor relation was more expressive and explicit in this case than the seeAlso relation.
        -->
        
        <xsl:if test="SeeRelatedList">
          <xsl:for-each select="SeeRelatedList/SeeRelatedDescriptor">

            <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="../../DescriptorUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text> 
            <xsl:text disable-output-escaping="yes">&lt;http://www.w3.org/2000/01/rdf-schema#seeAlso&gt; </xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="DescriptorReferredTo/DescriptorUI"/><xsl:text disable-output-escaping="yes">&gt;</xsl:text>
            <xsl:text disable-output-escaping="yes"> .&#10;</xsl:text>

          </xsl:for-each><!-- SeeRelatedList/SeeRelatedDescriptor -->
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
        
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of select="DescriptorUI"/><xsl:text disable-output-escaping="yes">&gt; </xsl:text> 
          <xsl:text disable-output-escaping="yes">&lt;http://nlm.nih.gov#MeSH:considerAlso> </xsl:text> 
          <xsl:text disable-output-escaping="yes">"</xsl:text>
          
          <xsl:call-template name="replace-substring">
              <xsl:with-param name="value" select="replace(ConsiderAlso, '&quot;', '\\&quot;')"/>
              <xsl:with-param name="from" select="'&#10;'"/>
              <xsl:with-param name="to">&#10;</xsl:with-param>
          </xsl:call-template>
          <xsl:text disable-output-escaping="yes">" .&#10;</xsl:text>
        </xsl:if>
    <!-- /xsl:if -->
  </xsl:for-each><!-- DescriptorRecordSet/DescriptorRecord -->

</xsl:template>

</xsl:stylesheet>
