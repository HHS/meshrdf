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
    <xsl:param name="value"/>
    <xsl:param name="from"/>
    <xsl:param name="to"/>
    <xsl:choose>
      <xsl:when test="contains($value,$from)">
        <xsl:value-of select="substring-before($value,$from)"/>
        <xsl:value-of select="$to"/>
        <xsl:call-template name="replace-substring">
          <xsl:with-param name="value" select="substring-after($value,$from)"/>
          <xsl:with-param name="from" select="$from"/>
          <xsl:with-param name="to" select="$to"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$value"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="/">

    <xsl:if test="SupplementalRecordSet/SupplementalRecord">

      <!-- triples for Supplementary Concept Records -->

      <xsl:for-each select="SupplementalRecordSet/SupplementalRecord">

        <!--
          Transformation rule: dcterms:identifier
          =========================================
          Output: <suppRec_uri> dcterms:identifier "suppRecUI" .
          =============================================================
          Additional: Every supplemental record has a unique identifier.
        -->

        <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text>
        <xsl:value-of select="SupplementalRecordUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;http://purl.org/dc/terms/identifier&gt; </xsl:text>
        <xsl:text>"</xsl:text>
        <xsl:value-of select="SupplementalRecordUI"/>
        <xsl:text>" .&#10;</xsl:text>


        <!--
         Transformation rule: SCRClass
         =========================================
         Output: <suppRec_uri> SCRClass "suppRecUI" .
         =============================================================
         Additional: Every supplemental record has a unique identifier.
        -->


        <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text>
        <xsl:value-of select="SupplementalRecordUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;http://nlm.nih.gov#MeSH:SCRClass&gt; </xsl:text>
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@SCRClass"/>
        <xsl:text>" .&#10;</xsl:text>


        <!--
          Transformation rule: rdf:type
          =================================
          Output: <suppRec_uri> rdf:type <SupplementaryConceptRecord> .
          =============================================================
          Additional: This relation states that a Subject node used to identify a Supplementary Concept Record (SCR) is of type "SupplementaryConceptRecord".
        -->

        <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text>
        <xsl:value-of select="SupplementalRecordUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#type&gt; </xsl:text>
        <xsl:text>&lt;http://nlm.nih.gov#MeSH:SupplementaryConceptRecord&gt; .&#10;</xsl:text>


        <!--
          Transformation rule: rdfs:label
          ==============================================
          Output: <suppRec_uri> rdfs:label "suppRecName" .
          =================================================================
          Additional: Every supplemental record has a name.
        -->

        <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text>
        <xsl:value-of select="SupplementalRecordUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;http://www.w3.org/2000/01/rdf-schema#label&gt; </xsl:text>
        <xsl:text>"</xsl:text>
        <xsl:value-of select="SupplementalRecordName/String"/>
        <xsl:text>" .&#10;</xsl:text>

        <!--
          Transformation rule: dateCreated
          ====================================================
          Output: <suppRec_uri> dateCreated "dateSuppRecCreated" .
          ===========================================================================
          Additional: Every supplemental record has a date on which it was created.
        -->

        <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text>
        <xsl:value-of select="SupplementalRecordUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;http://nlm.nih.gov#MeSH:dateCreated&gt; </xsl:text>
        <xsl:text>"</xsl:text>
        <xsl:value-of select="string-join((DateCreated/Year,DateCreated/Month,DateCreated/Day),'-')"/>
        <xsl:text>" .&#10;</xsl:text>

        <!--
          Transformation rule: dateRevised
          =====================================================
          Output: <suppRec_uri> dateRevised "dateSuppRecRevised" .
          ============================================================================
          Additional: A supplemental record can have a date on which it was revised.
        -->

        <xsl:if test="DateRevised">
          <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text>
          <xsl:value-of select="SupplementalRecordUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;http://nlm.nih.gov#MeSH:dateRevised> </xsl:text>
          <xsl:text>"</xsl:text>
          <xsl:value-of
            select="string-join((DateRevised/Year,DateRevised/Month,DateRevised/Day),'-')"/>
          <xsl:text>" .&#10;</xsl:text>
        </xsl:if>

        <!--
          Transformation rule: activeMeSHYear
          =======================================
          Output: <suppRec_uri> activeMeSHYear "activeMeSHYear" .
          =====================================================================================
          Additional: A supplemental record has at least one MeSH year in which it was active.
        -->

        <xsl:for-each select="ActiveMeSHYearList/Year">
          <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text>
          <xsl:value-of select="../../SupplementalRecordUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;http://nlm.nih.gov#MeSH:activeMeSHYear> </xsl:text>
          <xsl:text>"</xsl:text>
          <xsl:value-of select="."/>
          <xsl:text>" .&#10;</xsl:text>
        </xsl:for-each>

        <!--
          Transformation rule: note
          ==============================
          Output: <suppRec_uri> note "note" .
          ===================================================
          Additional: A supplemental record can have a note that provides information about the substance.
        -->

        <xsl:if test="Note">
          <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text>
          <xsl:value-of select="SupplementalRecordUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;http://nlm.nih.gov#MeSH:note> </xsl:text>
          <xsl:text>"</xsl:text>
          <xsl:call-template name="replace-substring">
            <!-- escape any double-quote character as per the N-Triple format specification -->
            <xsl:with-param name="value" select="normalize-space(Note)"/>
            <xsl:with-param name="from" select="'&quot;'"/>
            <xsl:with-param name="to">\"</xsl:with-param>
          </xsl:call-template>
          <xsl:text>" .&#10;</xsl:text>
        </xsl:if>

        <!--
          Transformation rule: frequency
          ==================================
          Output: <suppRec_uri> frequency "frequency" .
          ===================================================
          Additional: A supplemental record can have a frequency associated with it. This number represents the number of citations
          indexed with the supplemental record in PubMed.
        -->

        <xsl:if test="Frequency">
          <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text>
          <xsl:value-of select="SupplementalRecordUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;http://nlm.nih.gov#MeSH:frequency> </xsl:text>
          <xsl:text>"</xsl:text>
          <xsl:value-of select="Frequency"/>
          <xsl:text>" .&#10;</xsl:text>
        </xsl:if>

        <!--
          Transformation rule: previousIndexing
          =========================================
          Output: <suppRec_uri> previousIndexing "prevIndexing" .
          ===========================================================
          Additional: A supplemental record can have a previous indexing. See http://www.nlm.nih.gov/mesh/xml_data_elements.html 
          accessed on 9/9/2008 for more information.
        -->

        <xsl:if test="PreviousIndexingList">
          <xsl:for-each select="PreviousIndexingList/PreviousIndexing">
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text>
            <xsl:value-of select="../../SupplementalRecordUI"/>
            <xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:previousIndexing> </xsl:text>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="replace(normalize-space(.), '\\', '\\\\')"/>
            <xsl:text>" .&#10;</xsl:text>
          </xsl:for-each>
        </xsl:if>



        <xsl:for-each select="HeadingMappedToList/HeadingMappedTo">
          <!--
            Transformation rule: mappedData
            =====================================
            Output: <suppRec_uri> mappedData <blank_set1_uri> .
            ===================================================
            Additional: To remain true to the structure of the supplemental records in XML format, we created the hasMappedData relation.
            A supplemental record can be mappled to at least one descriptor record or descriptor record/qualifier record combination. A
            blank node makes up the mapped data entity.
          -->
          <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of
            select="../../SupplementalRecordUI"/><xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;http://nlm.nih.gov#MeSH:mappedData&gt; </xsl:text>
          <xsl:text>_:blank_set1_</xsl:text><xsl:value-of
            select="../../SupplementalRecordUI"/>_<xsl:value-of select="position()"/><xsl:text> .&#10;</xsl:text>
          <!--
            Transformation rule: rdf:type
            =================================
            Output: <blank_uri> rdf:type <MappedData> .
            =============================================================
            Additional: This relation states that a Subject node used to identify mapped data is of type "MappedData".
          -->
          <xsl:text>_:blank_set1_</xsl:text><xsl:value-of
            select="../../SupplementalRecordUI"/>_<xsl:value-of select="position()"/><xsl:text> </xsl:text>
          <xsl:text>&lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#type&gt; </xsl:text>
          <xsl:text>&lt;http://nlm.nih.gov#MeSH:MappedData&gt; .&#10;</xsl:text>
          <!--
            Transformation rule: isMappedToDescriptor
            ==========================================
            Output: <blank_uri> isMappedToDescriptor <desc_uri> .
            ======================================================
            Additional: A supplemental record is mapped to a descriptor record. In our representation the mapping is first to a blank node and then to
            the descriptor record.
          -->
          <xsl:text>_:blank_set1_</xsl:text><xsl:value-of
            select="../../SupplementalRecordUI"/>_<xsl:value-of select="position()"/><xsl:text> </xsl:text>
          <xsl:text>&lt;http://nlm.nih.gov#MeSH:isMappedToDescriptor&gt; </xsl:text>
          <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of
            select="replace(DescriptorReferredTo/DescriptorUI,'\*','')"/><xsl:text>&gt;</xsl:text><xsl:text> .&#10;</xsl:text>
          <!--
            Descriptor is starred
            =================================
            Output: <_blank_uri> isDescriptorStarred "Y/N" .
            =============================================================
            Additional:
          -->
          <xsl:variable name="descui" select="DescriptorReferredTo/DescriptorUI"/>
          <xsl:if test="starts-with($descui,'*')">
            <xsl:text>_:blank_set1_</xsl:text><xsl:value-of
              select="../../SupplementalRecordUI"/>_<xsl:value-of select="position()"/><xsl:text> </xsl:text>
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:isDescriptorStarred&gt; </xsl:text>
            <xsl:text>"Y"</xsl:text><xsl:text> .&#10;</xsl:text>
          </xsl:if>
          <!-- added by rw
            Transformation rule: rdfs:label
            =======================================
            Output: <desc_uri> rdfs:label "descName" .
            ================================================
            Additional: A descriptor has a name.
          -->
          <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of
            select="replace(DescriptorReferredTo/DescriptorUI,'\*','')"/><xsl:text>&gt;</xsl:text><xsl:text> </xsl:text>
          <xsl:text>&lt;http://www.w3.org/2000/01/rdf-schema#label&gt; </xsl:text>
          <xsl:text>"</xsl:text><xsl:value-of
            select="DescriptorReferredTo/DescriptorName/String"/><xsl:text>" .&#10;</xsl:text>
          <xsl:if test="QualifierReferredTo">
            <!--
              Transformation rule: isMappedToQualifier
              =========================================
              Output: <blank_uri> isMappedToQualifier <qual_uri> .
              ======================================================
              Additional: A supplemental record can be mapped to a qualifier record. In our representation the mapping is first to a blank node and then to
              the qualifier record.
            -->
            <xsl:text>_:blank_set1_</xsl:text><xsl:value-of
              select="../../SupplementalRecordUI"/>_<xsl:value-of select="position()"/><xsl:text> </xsl:text>
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:isMappedToQualifier&gt; </xsl:text>
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of
              select="replace(QualifierReferredTo/QualifierUI,'\*','')"/><xsl:text>&gt;</xsl:text><xsl:text> .&#10;</xsl:text>
            <!--
              Qualifier is starred
              =================================
              Output: <_blank_uri> isQualifierStarred "Y/N" .
              =============================================================
              Additional:
            -->
            <xsl:variable name="qualui" select="QualifierReferredTo/QualifierUI"/>
            <xsl:if test="starts-with($qualui,'*')">
              <xsl:text>_:blank_set1_</xsl:text><xsl:value-of
                select="../../SupplementalRecordUI"/>_<xsl:value-of select="position()"/><xsl:text> </xsl:text>
              <xsl:text>&lt;http://nlm.nih.gov#MeSH:isQualifierStarred&gt; </xsl:text>
              <xsl:text>"Y"</xsl:text><xsl:text> .&#10;</xsl:text>
            </xsl:if>
            <!-- added by rw
              Transformation rule: rdfs:label
              =======================================
              Output: <qual_uri> rdfs:label "descName" .
              ================================================
              Additional: A qualifier has a name.
            -->
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of
              select="replace(QualifierReferredTo/QualifierUI,'\*','')"/><xsl:text>&gt;</xsl:text><xsl:text> </xsl:text>
            <xsl:text>&lt;http://www.w3.org/2000/01/rdf-schema#label&gt; </xsl:text>
            <xsl:text>"</xsl:text><xsl:value-of
              select="QualifierReferredTo/QualifierName/String"
            /><xsl:text>" .&#10;</xsl:text>
          </xsl:if>
        </xsl:for-each>
        <!-- HeadingMappedToList/HeadingMappedT -->



        <xsl:if test="IndexingInformationList">
          <xsl:for-each select="IndexingInformationList/IndexingInformation">
            <!--
              Transformation rule: indexingData
              =====================================
              Output: <suppRec_uri> indexingData <blank_set2_uri> .
              =========================================================
              Additional: To remain true to the structure of the supplemental records in XML format, we created the hasIndexingData relation.
              A supplemental record can have indexing information that consists of at least one descriptor record or descriptor record/qualifier record combination. A
              blank node makes up the indexing data entity.
            -->
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of
              select="../../SupplementalRecordUI"/><xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:indexingData&gt; </xsl:text>
            <xsl:text>_:blank_set2_</xsl:text><xsl:value-of
              select="../../SupplementalRecordUI"/>_<xsl:value-of select="position()"/><xsl:text> .&#10;</xsl:text>
            <!--
              Transformation rule: rdf:type
              =================================
              Output: <blank_uri> rdf:type <IndexingData> .
              =============================================================
              Additional: This relation states that a Subject node used to identify a Supplementary Concept Record (SCR) is of type "SupplementaryConceptRecord".
            -->
            <xsl:text>_:blank_set2_</xsl:text><xsl:value-of
              select="../../SupplementalRecordUI"/>_<xsl:value-of select="position()"/><xsl:text> </xsl:text>
            <xsl:text>&lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#type&gt; </xsl:text>
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:IndexingData&gt; .&#10;</xsl:text>
            <!--
              Transformation rule: indexingDescriptor
              ===========================================
              Output: <blank_set2_uri> indexingDescriptor <desc_uri> .
              ============================================================
              Additional: A supplemental record can be indexed to more than one descriptor via a unique blank node.
            -->
            <xsl:text>_:blank_set2_</xsl:text><xsl:value-of
              select="../../SupplementalRecordUI"/>_<xsl:value-of select="position()"/><xsl:text> </xsl:text>
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:indexingDescriptor&gt; </xsl:text>
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of
              select="DescriptorReferredTo/DescriptorUI"/><xsl:text>&gt;</xsl:text><xsl:text> .&#10;</xsl:text>
            <!--
              Transformation rule: rdf:type
              =================================
              Output: <desc_uri> rdf:type <Descriptor> .
              =============================================================
              Additional: This relation states that a Subject node used to identify a Descriptor record is of type "Descritpor".
            -->
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of
              select="DescriptorReferredTo/DescriptorUI"/><xsl:text>&gt;</xsl:text><xsl:text> </xsl:text>
            <xsl:text>&lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#type&gt; </xsl:text>
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:Descriptor&gt; .&#10;</xsl:text>
            <!--
              Transformation rule: dcterms:identifier
              ========================================
              Output: <desc_uri> dcterms:identifier "descUI" .
              =================================================
              Additional: A descriptor has a unique identifier.
            -->
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of
              select="DescriptorReferredTo/DescriptorUI"/><xsl:text>&gt;</xsl:text><xsl:text> </xsl:text>
            <xsl:text>&lt;http://purl.org/dc/terms/identifier&gt; </xsl:text>
            <xsl:text>"</xsl:text><xsl:value-of
              select="DescriptorReferredTo/DescriptorUI"/><xsl:text>" .&#10;</xsl:text>
            <!--
              Transformation rule: rdfs:label
              =======================================
              Output: <desc_uri> rdfs:label "descName" .
              ================================================
              Additional: A descriptor has a name.
            -->
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of
              select="replace(DescriptorReferredTo/DescriptorUI,'\*','')"/><xsl:text>&gt;</xsl:text><xsl:text> </xsl:text>
            <xsl:text>&lt;http://www.w3.org/2000/01/rdf-schema#label&gt; </xsl:text>
            <xsl:text>"</xsl:text><xsl:value-of
              select="DescriptorReferredTo/DescriptorName/String"/><xsl:text>" .&#10;</xsl:text>
            <xsl:if test="QualifierReferredTo">
              <!--
                Transformation rule: indexingQualifier
                ==========================================
                Output: <blank_set2_uri> indexingQualifier <qual_uri> .
                ===========================================================
                Additional: A supplemental record can be indexed to more than one qualifier via a unique blank node.
              -->
              <xsl:text>_:blank_set2_</xsl:text><xsl:value-of
                select="../../SupplementalRecordUI"/>_<xsl:value-of select="position()"/><xsl:text> </xsl:text>
              <xsl:text>&lt;http://nlm.nih.gov#MeSH:indexingQualifier&gt; </xsl:text>
              <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of
                select="QualifierReferredTo/QualifierUI"/><xsl:text>&gt;</xsl:text><xsl:text> .&#10;</xsl:text>
              <!--
                Transformation rule: rdf:type
                =================================
                Output: <qual_uri> rdf:type <Qualifier> .
                =============================================================
                Additional: This relation states that a Subject node used to identify a Qualifier record is of type "Qualifier".
              -->
              <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of
                select="QualifierReferredTo/QualifierUI"/><xsl:text>&gt; </xsl:text>
              <xsl:text>&lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#type&gt; </xsl:text>
              <xsl:text>&lt;http://nlm.nih.gov#MeSH:Qualifier&gt; .&#10;</xsl:text>
              <!--
                Transformation rule: dcterms:identifier
                ==========================================
                Output: <qual_uri> dcterms:identifier "qualUI" .
                ===========================================================
                Additional: A qualifier record has a unique identifier.
              -->
              <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of
                select="QualifierReferredTo/QualifierUI"/><xsl:text>&gt;</xsl:text><xsl:text> </xsl:text>
              <xsl:text>&lt;http://purl.org/dc/terms/identifier&gt; </xsl:text>
              <xsl:text>"</xsl:text><xsl:value-of
                select="QualifierReferredTo/QualifierUI"/><xsl:text>" .&#10;</xsl:text>
              <!--
                Transformation rule: rdfs:label
                ======================================
                Output: <qual_uri> rdfs:label "qualName" .
                =================================================
                Additional: A qualifier record has a name.
              -->
              <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of
                select="replace(QualifierReferredTo/QualifierUI,'\*','')"/><xsl:text>&gt;</xsl:text><xsl:text> </xsl:text>
              <xsl:text>&lt;http://www.w3.org/2000/01/rdf-schema#label&gt; </xsl:text>
              <xsl:text>"</xsl:text><xsl:value-of
                select="QualifierReferredTo/QualifierName/String"
              /><xsl:text>" .&#10;</xsl:text>
            </xsl:if>
          </xsl:for-each>
          <!-- IndexingInformationList/IndexingInformation -->
        </xsl:if>



        <xsl:if test="PharmacologicalActionList">
          <xsl:for-each select="PharmacologicalActionList/PharmacologicalAction">

            <!--
              Transformation rule: pharmacologicalAction
              ===============================================
              Output: <suppRec_uri> pharmacologicalAction <desc_uri> .
              ==========================================================
              Additional: A supplemental record can have a pharmacological action that is a reference to a descriptor record describing observed 
              biological activity of an exogenously administered chemical.
            -->

            <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text>
            <xsl:value-of select="../../SupplementalRecordUI"/>
            <xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:pharmacologicalAction&gt; </xsl:text>
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text>
            <xsl:value-of select="DescriptorReferredTo/DescriptorUI"/>
            <xsl:text>&gt;</xsl:text>
            <xsl:text> .&#10;</xsl:text>


            <!--
              Transformation rule: rdf:type
              =================================
              Output: <desc_uri> rdf:type <Descriptor> .
              =============================================================
              Additional: This relation states that a Subject node used to identify a Descriptor record is of type "Descritpor".
            -->
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text>
            <xsl:value-of select="DescriptorReferredTo/DescriptorUI"/>
            <xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#type&gt; </xsl:text>
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:Descriptor&gt; .&#10;</xsl:text>


            <!--
              Transformation rule: dcterms:identifier
              =======================================
              Output: <desc_uri> dcterms:identifier "descUI" .
              ==================================================
              Additional: A descriptor has a name.
            -->

            <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text>
            <xsl:value-of select="DescriptorReferredTo/DescriptorUI"/>
            <xsl:text>&gt;</xsl:text>
            <xsl:text> </xsl:text>
            <xsl:text>&lt;http://purl.org/dc/terms/identifier&gt; </xsl:text>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="DescriptorReferredTo/DescriptorUI"/>
            <xsl:text>" .&#10;</xsl:text>

            <!--
              Transformation rule: rdfs:label
              =======================================
              Output: <desc_uri> rdfs:label "descName" .
              ==================================================
              Additional: A descriptor has a name.
            -->

            <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text>
            <xsl:value-of select="DescriptorReferredTo/DescriptorUI"/>
            <xsl:text>&gt;</xsl:text>
            <xsl:text> </xsl:text>
            <xsl:text>&lt;http://www.w3.org/2000/01/rdf-schema#label&gt; </xsl:text>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="DescriptorReferredTo/DescriptorName/String"/>
            <xsl:text>" .&#10;</xsl:text>
          </xsl:for-each>
        </xsl:if>



        <xsl:if test="SourceList">
          <xsl:for-each select="SourceList/Source">

            <!--
              Transformation rule: source
              ===============================
              Output: <suppRec_uri> source "source" .
              =============================================
              Additional: A supplemental record can have one or more sources. A source is a citation reference in which the indexing concept was first found.
            -->

            <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text>
            <xsl:value-of select="../../SupplementalRecordUI"/>
            <xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:source&gt; </xsl:text>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:text>" .&#10;</xsl:text>
          </xsl:for-each>
        </xsl:if>



        <xsl:if test="RecordOriginatorsList">

          <!--
            Transformation rule: recordOriginator, recordMaintainer, recordAuthorizer
            ===========================================================================
            Output: <supp_uri> recordOriginator "recordOriginator" .
                    <supp_uri> recordMaintainer "recordMaintainer" .
                    <supp_uri> recordAuthorizer "recordAuthorizer" .
            ===========================================================
            Additional: A supplemental record can have a record originator, record maintainer and record authorizer.
          -->

          <xsl:if test="RecordOriginatorsList/RecordOriginator">
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text>
            <xsl:value-of select="SupplementalRecordUI"/>
            <xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:recordOriginator> </xsl:text>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="RecordOriginatorsList/RecordOriginator"/>
            <xsl:text>" .&#10;</xsl:text>
          </xsl:if>

          <xsl:if test="RecordOriginatorsList/RecordMaintainer">
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text>
            <xsl:value-of select="SupplementalRecordUI"/>
            <xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:recordMaintainer> </xsl:text>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="RecordOriginatorsList/RecordMaintainer"/>
            <xsl:text>" .&#10;</xsl:text>
          </xsl:if>

          <xsl:if test="RecordOriginatorsList/RecordAuthorizer">
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text>
            <xsl:value-of select="SupplementalRecordUI"/>
            <xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:recordAuthorizer> </xsl:text>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="RecordOriginatorsList/RecordAuthorizer"/>
            <xsl:text>" .&#10;</xsl:text>
          </xsl:if>
        </xsl:if>



        <xsl:for-each select="ConceptList/Concept">

          <!--
            Transformation rule: concept
            ================================
            Output: <supp_uri> concept <conc_uri> .
            ===========================================
            Additional: A supplemental has at least one concept.
          -->

          <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text>
          <xsl:value-of select="../../SupplementalRecordUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;http://nlm.nih.gov#MeSH:concept&gt; </xsl:text>
          <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text>
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
          <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text>
          <xsl:value-of select="ConceptUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#type&gt; </xsl:text>
          <xsl:text>&lt;http://nlm.nih.gov#MeSH:Concept&gt; .&#10;</xsl:text>


          <!--
            Transformation rule: isPreferredConcept
            ========================================
            Output: <conc_uri> isPreferredConcept "Y/N" .
            ==============================================
            Additional: A supplementary record has a preferred concept.
          -->

          <!-- isPreferredConcept -->
          <!-- Y/N -->
          <xsl:if test="@PreferredConceptYN = 'Y'">
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text>
            <xsl:value-of select="ConceptUI"/>
            <xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:isPreferredConcept> </xsl:text>
            <xsl:text>"Y</xsl:text>
            <xsl:text>" .&#10;</xsl:text>
          </xsl:if>

          <xsl:if test="@PreferredConceptYN = 'N'">
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text>
            <xsl:value-of select="ConceptUI"/>
            <xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:isPreferredConcept> </xsl:text>
            <xsl:text>"N</xsl:text>
            <xsl:text>" .&#10;</xsl:text>
          </xsl:if>

          <!--
            Transformation rule: rdfs:label
            =====================================
            Output: <conc_uri> rdfs:label "concName" .
            ================================================
            Additional: A concept has a name.
          -->

          <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text>
          <xsl:value-of select="ConceptUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;http://www.w3.org/2000/01/rdf-schema#label&gt; </xsl:text>
          <xsl:text>"</xsl:text>
          <xsl:call-template name="replace-substring">
            <!-- escape any double-quote character as per the N-Triple format specification -->
            <xsl:with-param name="value" select="ConceptName/String"/>
            <xsl:with-param name="from" select="'&quot;'"/>
            <xsl:with-param name="to">\"</xsl:with-param>
          </xsl:call-template>
          <xsl:text>" .&#10;</xsl:text>

          <!--
            Transformation rule: dcterms:identifier
            ========================================
            Output: <conc_uri> dcterms:identifier "concUI" .
            ================================================
            Additional: A concept has a unique identifier.
          -->

          <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text>
          <xsl:value-of select="ConceptUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;http://purl.org/dc/terms/identifier&gt; </xsl:text>
          <xsl:text>"</xsl:text>
          <xsl:value-of select="ConceptUI"/>
          <xsl:text>" .&#10;</xsl:text>

          <!--
            Transformation rule: CASN1_label
            ======================================
            Output: <conc_uri> CASN1_label "CASN1Name" .
            ================================================
            Additional: A concept can have a Chemical Abstracts Type N1 Name (CASN1Name).
          -->

          <xsl:if test="CASN1Name">
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text>
            <xsl:value-of select="ConceptUI"/>
            <xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:CASN1_label> </xsl:text>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="CASN1Name"/>
            <xsl:text>" .&#10;</xsl:text>
          </xsl:if>

          <!--
            Transformation rule: registryNumber
            ======================================
            Output: <conc_uri> registryNumber "registryNumber" .
            ========================================================
            Additional: A concept can have a registry number. See http://www.nlm.nih.gov/mesh/xml_data_elements.html accessed on 9/9/2008 for
            more details.
          -->

          <xsl:if test="RegistryNumber">
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text>
            <xsl:value-of select="ConceptUI"/>
            <xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:registryNumber> </xsl:text>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="RegistryNumber"/>
            <xsl:text>" .&#10;</xsl:text>
          </xsl:if>

          <!--
            Transformation rule: skos:scopeNote
            ====================================
            Output: <conc_uri> skos:scopeNote "scopeNote" .
            ==============================================
            Additional: A concept can have a scope note, a free-text narrative giving the scoe and meaning of a concept.
          -->

          <xsl:if test="ScopeNote">
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text>
            <xsl:value-of select="ConceptUI"/>
            <xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;http://www.w3.org/2004/02/skos/core#scopeNote&gt; </xsl:text>
            <xsl:text>"</xsl:text>
            <xsl:call-template name="replace-substring">
              <!-- escape any double-quote character as per the N-Triple format specification -->
              <xsl:with-param name="value" select="normalize-space(ScopeNote)"/>
              <xsl:with-param name="from" select="'&quot;'"/>
              <xsl:with-param name="to">\"</xsl:with-param>
            </xsl:call-template>
            <xsl:text>" .&#10;</xsl:text>
          </xsl:if>


          <xsl:if test="SemanticTypeList">
            <xsl:for-each select="SemanticTypeList/SemanticType">

              <!--
                Transformation rule: semanticType, rdfs:label, dcterms:identifier
                =============================================================================
                Output: <conc_uri> semanticType <semType_uri> .
            <semType_uri> rdf:type <SemanticType> . (This relation is created first in the following for-loop)
                        <semType_uri> dcterms:identifier "semanticTypeUI" .
                        <semType_uri> rdfs:label "semanticTypeName" .
                =============================================================================
                Additional: A concept can have a semantic type. I chose to model the semantic type information in the aforementioned fashion
                so that it would be consistent with our previous work with the MeSH descriptors. In this way, a semantic type has a semantic 
                type unique identifier as well as a semantic type name.
              -->

              <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text>
              <xsl:value-of select="SemanticTypeUI"/>
              <xsl:text>&gt; </xsl:text>
              <xsl:text>&lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#type&gt; </xsl:text>
              <xsl:text>&lt;http://nlm.nih.gov#MeSH:SemanticType&gt; .&#10;</xsl:text>

              <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text>
              <xsl:value-of select="../../ConceptUI"/>
              <xsl:text>&gt; </xsl:text>
              <xsl:text>&lt;http://nlm.nih.gov#MeSH:semanticType> </xsl:text>
              <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text>
              <xsl:value-of select="SemanticTypeUI"/>
              <xsl:text>&gt;</xsl:text>
              <xsl:text> .&#10;</xsl:text>

              <!-- Added this on November 26, 2008 -->
              <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text>
              <xsl:value-of select="SemanticTypeUI"/>
              <xsl:text>&gt; </xsl:text>
              <xsl:text>&lt;http://purl.org/dc/terms/identifier&gt; </xsl:text>
              <xsl:text>"</xsl:text>
              <xsl:value-of select="SemanticTypeUI"/>
              <xsl:text>" .&#10;</xsl:text>

              <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text>
              <xsl:value-of select="SemanticTypeUI"/>
              <xsl:text>&gt; </xsl:text>
              <xsl:text>&lt;http://www.w3.org/2000/01/rdf-schema#label&gt; </xsl:text>
              <xsl:text>"</xsl:text>
              <xsl:value-of select="SemanticTypeName"/>
              <xsl:text>" .&#10;</xsl:text>
            </xsl:for-each>
          </xsl:if>

          <xsl:if test="RelatedRegistryNumberList">
            <xsl:for-each select="RelatedRegistryNumberList/RelatedRegistryNumber">

              <!--
                Transformation rule: relatedRegistryNumber
                ==============================================
                Output: <conc_uri> relatedRegistryNumber "relatedRegistryNumber" .
                ======================================================================
                Additional: A concept can have a related registry number. See http://www.nlm.nih.gov/mesh/xml_data_elements.html for more information.
              -->

              <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text>
              <xsl:value-of select="../../ConceptUI"/>
              <xsl:text>&gt; </xsl:text>
              <xsl:text>&lt;http://nlm.nih.gov#MeSH:relatedRegistryNumber> </xsl:text>
              <xsl:text>"</xsl:text>
              <xsl:value-of select="."/>
              <xsl:text>" .&#10;</xsl:text>
            </xsl:for-each>
          </xsl:if>


          <xsl:if test="ConceptRelationList">
            <xsl:for-each select="ConceptRelationList/ConceptRelation">
              <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of
                select="../../ConceptUI"/><xsl:text>&gt; </xsl:text>
              <xsl:text>&lt;http://nlm.nih.gov#MeSH:conceptRelation> </xsl:text>
              <xsl:text>_:blank_set1_</xsl:text><xsl:value-of
                select="../../ConceptUI"/>_<xsl:value-of select="position()"/>
              <xsl:text> .&#10;</xsl:text>
              <xsl:text>_:blank_set1_</xsl:text><xsl:value-of
                select="../../ConceptUI"/>_<xsl:value-of select="position()"/>
              <xsl:text> &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#type&gt; </xsl:text>
              <xsl:text>&lt;http://nlm.nih.gov#MeSH:ConceptRelation&gt; .&#10;</xsl:text>
              <xsl:if test="@RelationName">
                <xsl:text>_:blank_set1_</xsl:text><xsl:value-of
                  select="../../ConceptUI"/>_<xsl:value-of select="position()"/>
                <xsl:text> &lt;http://nlm.nih.gov#MeSH:relation&gt; </xsl:text>
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
              <xsl:text>_:blank_set1_</xsl:text><xsl:value-of
                select="../../ConceptUI"/>_<xsl:value-of select="position()"/>
              <xsl:text> &lt;http://nlm.nih.gov#MeSH:concept1> </xsl:text>
              <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of
                select="Concept1UI"/><xsl:text>&gt;</xsl:text><xsl:text> .&#10;</xsl:text>
              <xsl:text>_:blank_set1_</xsl:text><xsl:value-of
                select="../../ConceptUI"/>_<xsl:value-of select="position()"/>
              <xsl:text> &lt;http://nlm.nih.gov#MeSH:concept2> </xsl:text>
              <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of
                select="Concept2UI"/><xsl:text>&gt;</xsl:text><xsl:text> .&#10;</xsl:text>
              <!-- added by rw -->
              <xsl:if test="RelationAttribute">
                <xsl:text>_:blank_set1_</xsl:text><xsl:value-of
                  select="../../ConceptUI"/>_<xsl:value-of select="position()"/>
                <xsl:text> &lt;http://nlm.nih.gov#MeSH:relationAttribute> </xsl:text>
                <xsl:text>"</xsl:text><xsl:value-of
                  select="RelationAttribute"
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
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of
              select="../../ConceptUI"/><xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:term> </xsl:text>
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of
              select="TermUI"/><xsl:text>&gt;</xsl:text>
            <xsl:text> .&#10;</xsl:text>
            <!--
              Transformation rule: rdf:type
              ==============================
              Output: <term_uri> rdf:type <Term> .
              ========================================
              Additional: A concept has at least one term associated with it.
            -->
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of
              select="TermUI"/><xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#type&gt; </xsl:text>
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:Term&gt; .&#10;</xsl:text>
            <!--
              Transformation rule: dcterms:identifier
              =======================================
              Output: <term_uri> dcterms:identifier "termUI" .
              ==================================================
              Additional: This relation states that a term has a term unique identifier.
              ============================================================================
              Need to address: N/A.
            -->
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of
              select="TermUI"/><xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;http://purl.org/dc/terms/identifier&gt; </xsl:text>
            <xsl:text>"</xsl:text><xsl:value-of select="TermUI"/><xsl:text>" .&#10;</xsl:text>
            <xsl:if test="@IsPermutedTermYN = 'N'">
              <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of
                select="TermUI"/><xsl:text>&gt; </xsl:text>
              <xsl:text>&lt;http://www.w3.org/2000/01/rdf-schema#label&gt; </xsl:text>
              <xsl:text>"</xsl:text><xsl:value-of select="String"
              /><xsl:text>" .&#10;</xsl:text>
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
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:</xsl:text><xsl:value-of
              select="TermUI"/><xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:termData&gt; </xsl:text>
            <xsl:text>_:blank</xsl:text><xsl:value-of select="TermUI"
              />_<xsl:value-of select="position()"/><xsl:text> .&#10;</xsl:text>
            <!--
              Transformation rule/Relation: rdf:type
              =======================================
              Output: _:blankTermUI_termNumber rdf:type <TermData> .
              =======================================================
              Description: This relation states that a Subject node used to identify term data is of type "TermData".
              ========================================================================================================
              Need to address: N/A.
            -->
            <xsl:text>_:blank</xsl:text><xsl:value-of select="TermUI"
              />_<xsl:value-of select="position()"/><xsl:text> </xsl:text>
            <xsl:text>&lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#type&gt; </xsl:text>
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:TermData&gt; .&#10;</xsl:text>
            <!--
              Transformation rule: isConceptPreferredTerm
              ============================================
              Output: _:blankTermUI_termNo isConceptPreferredTerm "Y/N" .
              ============================================================
              Additional: This relation states that a term can be a concept-preferred-term. But it does so indirectly because the isConceptPreferredTerm relation is with a blank node.
              ===========================================================================================================================================================================
              Need to address: N/A.
            -->
            <xsl:text>_:blank</xsl:text><xsl:value-of select="TermUI"
              />_<xsl:value-of select="position()"/><xsl:text> </xsl:text>
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:isConceptPreferredTerm&gt; </xsl:text>
            <xsl:text>"</xsl:text><xsl:value-of
              select="@ConceptPreferredTermYN"/><xsl:text>" .&#10;</xsl:text>
            <!--
              Transformation rule: isPermutedTerm
              =====================================
              Output: _:blankTermUI_termNo isPermutedTerm "Y/N" .
              =====================================================
              Additional: This relation states that a term can be a permuted term. But it does so indirectly because the isPermutedTerm relation is with a blank node.
              =========================================================================================================================================================
              Need to address: N/A.
            -->
            <xsl:text>_:blank</xsl:text><xsl:value-of select="TermUI"
              />_<xsl:value-of select="position()"/><xsl:text> </xsl:text>
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:isPermutedTerm&gt; </xsl:text>
            <xsl:text>"</xsl:text><xsl:value-of
              select="@IsPermutedTermYN"/><xsl:text>" .&#10;</xsl:text>
            <!--
              Transformation rule: lexicalTag
              ===================================
              Output: _:blankTermUI_termNo lexicalTag "lexicalTag" .
              ==========================================================
              Additional: This relation states that a term has a lexical tag. But it does so indirectly becuase the hasLexicalTag relation is with a blank node.
              ====================================================================================================================================================
              Need to address: N/A.
            -->
            <xsl:text>_:blank</xsl:text><xsl:value-of select="TermUI"
              />_<xsl:value-of select="position()"/><xsl:text> </xsl:text>
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:lexicalTag&gt; </xsl:text>
            <xsl:text>"</xsl:text><xsl:value-of select="@LexicalTag"/><xsl:text>" .&#10;</xsl:text>
            <!--
              Transformation rule: printFlag
              ===================================
              Output: _:blankTermUI_termNo printFlag "Y/N" .
              ==================================================
              Additional: This relation states that a term has a print flag. But it does this indirectly because the hasPrintFlag relation is with a blank node.
              ===================================================================================================================================================
              Need to address: N/A.
            -->
            <xsl:text>_:blank</xsl:text><xsl:value-of select="TermUI"
              />_<xsl:value-of select="position()"/><xsl:text> </xsl:text>
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:printFlag&gt; </xsl:text>
            <xsl:text>"</xsl:text><xsl:value-of select="@PrintFlagYN"/><xsl:text>" .&#10;</xsl:text>
            <!--
              Transformation rule: isRecordPreferredTerm
              ===========================================
              Output: _:blankTermUI_termNo isRecordPreferredTerm "Y/N" .
              ============================================================
              Additional: This relation states that a term can be a record preferred term. But it does this indirectly because the relation is with a blank node.
              ====================================================================================================================================================
              Need to address: N/A.
            -->
            <xsl:text>_:blank</xsl:text><xsl:value-of select="TermUI"
              />_<xsl:value-of select="position()"/><xsl:text> </xsl:text>
            <xsl:text>&lt;http://nlm.nih.gov#MeSH:isRecordPreferredTerm&gt; </xsl:text>
            <xsl:text>"</xsl:text><xsl:value-of
              select="@RecordPreferredTermYN"/><xsl:text>" .&#10;</xsl:text>
            <!--
             Transformation rule: dcterms:identifier
             ========================================
             Output: _:blankTermUI_termNo dcterms:identifier "termUI" .
             ===========================================================
             Additional: This relation states that a term has a term unique identifier. However, it does so indirectly because the relation is with a blank node.
             ======================================================================================================================================================
             Additional: N/A.
            -->
            <xsl:text>_:blank</xsl:text><xsl:value-of select="TermUI"
              />_<xsl:value-of select="position()"/><xsl:text> </xsl:text>
            <xsl:text>&lt;http://purl.org/dc/terms/identifier&gt; </xsl:text>
            <xsl:text>"</xsl:text><xsl:value-of select="TermUI"/><xsl:text>" .&#10;</xsl:text>
            <!--
              Transformation rule: rdfs:label
              =================================
              Output: _:blankTermUI_termNo rdfs:label "termName" .
              ======================================================
              Additional: This relation states that a term has a term name. But it does so indirectly because the relation is with a blank node.
              ====================================================================================================================================
              Need to address: N/A.
            -->
            <xsl:text>_:blank</xsl:text><xsl:value-of select="TermUI"
              />_<xsl:value-of select="position()"/><xsl:text> </xsl:text>
            <xsl:text>&lt;http://www.w3.org/2000/01/rdf-schema#label&gt; </xsl:text>
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
              <xsl:text>_:blank</xsl:text><xsl:value-of
                select="TermUI"/>_<xsl:value-of select="position()"/><xsl:text> </xsl:text>
              <xsl:text>&lt;http://nlm.nih.gov#MeSH:dateCreated&gt; </xsl:text>
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
              <xsl:text>_:blank</xsl:text><xsl:value-of
                select="TermUI"/>_<xsl:value-of select="position()"/><xsl:text> </xsl:text>
              <xsl:text>&lt;http://nlm.nih.gov#MeSH:abbreviation> </xsl:text>
              <xsl:text>"</xsl:text><xsl:value-of
                select="Abbreviation"/><xsl:text>" .&#10;</xsl:text>
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
              <xsl:text>_:blank</xsl:text><xsl:value-of
                select="TermUI"/>_<xsl:value-of select="position()"/><xsl:text> </xsl:text>
              <xsl:text>&lt;http://nlm.nih.gov#MeSH:sortVersion> </xsl:text>
              <xsl:text>"</xsl:text><xsl:value-of select="SortVersion"
              /><xsl:text>" .&#10;</xsl:text>
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
              <xsl:text>_:blank</xsl:text><xsl:value-of
                select="TermUI"/>_<xsl:value-of select="position()"/><xsl:text> </xsl:text>
              <xsl:text>&lt;http://nlm.nih.gov#MeSH:entryVersion> </xsl:text>
              <xsl:text>"</xsl:text><xsl:value-of
                select="EntryVersion"/><xsl:text>" .&#10;</xsl:text>
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
                <xsl:text>_:blank</xsl:text><xsl:value-of
                  select="../../TermUI"/>_<xsl:copy-of select="$pos"/><xsl:text> </xsl:text>
                <xsl:text>&lt;http://nlm.nih.gov#MeSH:thesaurusID> </xsl:text>
                <xsl:text>"</xsl:text>
                <xsl:call-template name="replace-substring">
                  <xsl:with-param name="value" select="."/>
                  <xsl:with-param name="from" select="'&#10;'"/>
                  <xsl:with-param name="to">&#10;</xsl:with-param>
                </xsl:call-template>
                <xsl:text>" .&#10;</xsl:text>
              </xsl:for-each>
            </xsl:if>
          </xsl:for-each>

        </xsl:for-each>
        <!-- ConceptList/Concept -->

      </xsl:for-each>
      <!-- SupplementalRecordSet/SupplementalRecord -->
    </xsl:if>

  </xsl:template>

</xsl:stylesheet>
