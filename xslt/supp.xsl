<?xml version="1.0" encoding="ISO-8859-1"?>

<!-- 
  This external subset defines all of the entities that we'll use for URI prefixes from other
  various ontologies.
-->
<!DOCTYPE xsl:stylesheet SYSTEM "mesh-rdf-prefixes.ent" >

<xsl:stylesheet version="2.0" 
                xmlns:xs="http://www.w3.org/2001/XMLSchema" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="common.xsl"/>
  <xsl:output method="text"/>



  <xsl:template match="/">

    <xsl:if test="SupplementalRecordSet/SupplementalRecord">

      <!-- triples for Supplementary Concept Records -->

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
            <output>*supprec_uri* dcterms:identifier *supprec_identifier*</output>
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
            <output>*supprec_uri* mesh:SCRClass *scr_class*</output>
            <desc></desc>
            <fixme></fixme>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$supprec_uri"/>
            <uri prefix='&mesh;'>SCRClass</uri>
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
            <output>*supprec_uri* rdf:type *object*</output>
            <desc>This relation states that a Subject node used to identify a Supplementary Concept Record (SCR) is of type "SupplementaryConceptRecord".</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$supprec_uri"/>
            <uri prefix='&rdf;'>type</uri>
            <uri prefix='&mesh;'>SupplementaryConceptRecord</uri>
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
          ====================================================
          Output: <suppRec_uri> dateCreated "dateSuppRecCreated" .
          ===========================================================================
          Additional: Every supplemental record has a date on which it was created.
        -->

        <xsl:text>&lt;&mesh;</xsl:text>
        <xsl:value-of select="SupplementalRecordUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;&mesh;dateCreated&gt; </xsl:text>
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
          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="SupplementalRecordUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&mesh;dateRevised> </xsl:text>
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
          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="../../SupplementalRecordUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&mesh;activeMeSHYear> </xsl:text>
          <xsl:text>"</xsl:text>
          <xsl:value-of select="."/>
          <xsl:text>" .&#10;</xsl:text>
        </xsl:for-each>

        <!--
          Transformation rule: note
        -->
        <xsl:if test="Note">
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <output>*supprec_uri* mesh:note *mesh_note*</output>
              <desc>A supplemental record can have a note that provides information about the substance.</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <uri prefix='&mesh;'>
                <xsl:value-of select="SupplementalRecordUI"/>
              </uri>
              <uri prefix='&mesh;'>note</uri>
              <literal>
                <xsl:value-of select="Note"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>
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
          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="SupplementalRecordUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&mesh;frequency> </xsl:text>
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
            <xsl:text>&lt;&mesh;</xsl:text>
            <xsl:value-of select="../../SupplementalRecordUI"/>
            <xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;&mesh;previousIndexing> </xsl:text>
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
          <xsl:text>&lt;&mesh;</xsl:text><xsl:value-of
            select="../../SupplementalRecordUI"/><xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&mesh;mappedData&gt; </xsl:text>
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
          <xsl:text>&lt;&rdf;type&gt; </xsl:text>
          <xsl:text>&lt;&mesh;MappedData&gt; .&#10;</xsl:text>
          
          <!--
            Transformation rule: isMappedToDescriptor
            ==========================================
            Output: <blank_uri> isMappedToDescriptor <desc_uri> .
            ======================================================
            Additional: A supplemental record is mapped to a descriptor record. In our representation the mapping is first to a blank node and then to
            the descriptor record.
          -->
          
          <xsl:text>_:blank_set1_</xsl:text><xsl:value-of
            select="../../SupplementalRecordUI"/>_<xsl:value-of select="position()"/>
          <xsl:text> </xsl:text>
          <xsl:text>&lt;&mesh;isMappedToDescriptor&gt; </xsl:text>
          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of
            select="replace(DescriptorReferredTo/DescriptorUI,'\*','')"/>
          <xsl:text>&gt;</xsl:text>
          <xsl:text> .&#10;</xsl:text>
          
          <!--
            Descriptor is starred
            =================================
            Output: <_blank_uri> isDescriptorStarred "Y/N" .
            =============================================================
            Additional:
          -->
          
          <xsl:variable name="descui" select="DescriptorReferredTo/DescriptorUI"/>
          <xsl:if test="starts-with($descui,'*')">
            <xsl:text>_:blank_set1_</xsl:text>
            <xsl:value-of
              select="../../SupplementalRecordUI"/>_<xsl:value-of select="position()"/>
            <xsl:text> </xsl:text>
            <xsl:text>&lt;&mesh;isDescriptorStarred&gt; </xsl:text>
            <xsl:text>"Y"</xsl:text>
            <xsl:text> .&#10;</xsl:text>
          </xsl:if>
          
          <!-- added by rw
            Transformation rule: rdfs:label
            =======================================
            Output: <desc_uri> rdfs:label "descName" .
            ================================================
            Additional: A descriptor has a name.
          -->
          
          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of
            select="replace(DescriptorReferredTo/DescriptorUI,'\*','')"/>
          <xsl:text>&gt;</xsl:text>
          <xsl:text> </xsl:text>
          <xsl:text>&lt;&rdfs;label&gt; </xsl:text>
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
            <xsl:text>&lt;&mesh;isMappedToQualifier&gt; </xsl:text>
            <xsl:text>&lt;&mesh;</xsl:text><xsl:value-of
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
              <xsl:text>&lt;&mesh;isQualifierStarred&gt; </xsl:text>
              <xsl:text>"Y"</xsl:text><xsl:text> .&#10;</xsl:text>
            </xsl:if>
            <!-- added by rw
              Transformation rule: rdfs:label
              =======================================
              Output: <qual_uri> rdfs:label "descName" .
              ================================================
              Additional: A qualifier has a name.
            -->
            <xsl:text>&lt;&mesh;</xsl:text><xsl:value-of
              select="replace(QualifierReferredTo/QualifierUI,'\*','')"/><xsl:text>&gt;</xsl:text><xsl:text> </xsl:text>
            <xsl:text>&lt;&rdfs;label&gt; </xsl:text>
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
              Additional: To remain true to the structure of the supplemental records in XML 
              format, we created the hasIndexingData relation.
              A supplemental record can have indexing information that consists of at least one 
              descriptor record or descriptor record/qualifier record combination. A
              blank node makes up the indexing data entity.
            -->
            <xsl:text>&lt;&mesh;</xsl:text><xsl:value-of
              select="../../SupplementalRecordUI"/><xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;&mesh;indexingData&gt; </xsl:text>
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
              select="../../SupplementalRecordUI"/>
            <xsl:text>_</xsl:text>
            <xsl:value-of select="position()"/>
            <xsl:text> </xsl:text>
            <xsl:text>&lt;&rdf;type&gt; </xsl:text>
            <xsl:text>&lt;&mesh;IndexingData&gt; .&#10;</xsl:text>
            
            <!--
              Transformation rule: indexingDescriptor
              ===========================================
              Output: <blank_set2_uri> indexingDescriptor <desc_uri> .
              ============================================================
              Additional: A supplemental record can be indexed to more than one descriptor via a unique blank node.
            -->
            
            <xsl:text>_:blank_set2_</xsl:text>
            <xsl:value-of select="../../SupplementalRecordUI"/>
            <xsl:text>_</xsl:text>
            <xsl:value-of select="position()"/>
            <xsl:text> </xsl:text>
            <xsl:text>&lt;&mesh;indexingDescriptor&gt; </xsl:text>
            <xsl:text>&lt;&mesh;</xsl:text>
            <xsl:value-of
              select="DescriptorReferredTo/DescriptorUI"/>
            <xsl:text>&gt; .&#10;</xsl:text>
            
            <!--
              Transformation rule: rdf:type
              =================================
              Output: <desc_uri> rdf:type <Descriptor> .
              =============================================================
              Additional: This relation states that a Subject node used to identify a Descriptor record is of type "Descritpor".
            -->
            
            <xsl:text>&lt;&mesh;</xsl:text>
            <xsl:value-of
              select="DescriptorReferredTo/DescriptorUI"/>
            <xsl:text>&gt;</xsl:text><xsl:text> </xsl:text>
            <xsl:text>&lt;&rdf;type&gt; </xsl:text>
            <xsl:text>&lt;&mesh;Descriptor&gt; .&#10;</xsl:text>
            
            <!--
              Transformation rule: dcterms:identifier
              ========================================
              Output: <desc_uri> dcterms:identifier "descUI" .
              =================================================
              Additional: A descriptor has a unique identifier.
            -->
            
            <xsl:text>&lt;&mesh;</xsl:text>
            <xsl:value-of
              select="DescriptorReferredTo/DescriptorUI"/>
            <xsl:text>&gt;</xsl:text><xsl:text> </xsl:text>
            <xsl:text>&lt;&dcterms;identifier&gt; </xsl:text>
            <xsl:text>"</xsl:text>
            <xsl:value-of
              select="DescriptorReferredTo/DescriptorUI"/>
            <xsl:text>" .&#10;</xsl:text>
            
            <!--
              Transformation rule: rdfs:label
              =======================================
              Output: <desc_uri> rdfs:label "descName" .
              ================================================
              Additional: A descriptor has a name.
            -->
            
            <xsl:text>&lt;&mesh;</xsl:text>
            <xsl:value-of
              select="replace(DescriptorReferredTo/DescriptorUI,'\*','')"/>
            <xsl:text>&gt;</xsl:text>
            <xsl:text> </xsl:text>
            <xsl:text>&lt;&rdfs;label&gt; </xsl:text>
            <xsl:text>"</xsl:text>
            <xsl:value-of
              select="DescriptorReferredTo/DescriptorName/String"/>
            <xsl:text>" .&#10;</xsl:text>
            
            <xsl:if test="QualifierReferredTo">
              <!--
                Transformation rule: indexingQualifier
                ==========================================
                Output: <blank_set2_uri> indexingQualifier <qual_uri> .
                ===========================================================
                Additional: A supplemental record can be indexed to more than one qualifier via a unique blank node.
              -->
              <xsl:text>_:blank_set2_</xsl:text>
              <xsl:value-of
                select="../../SupplementalRecordUI"/>
              <xsl:text>_</xsl:text>
              <xsl:value-of select="position()"/>
              <xsl:text> </xsl:text>
              <xsl:text>&lt;&mesh;indexingQualifier&gt; </xsl:text>
              <xsl:text>&lt;&mesh;</xsl:text>
              <xsl:value-of select="QualifierReferredTo/QualifierUI"/>
              <xsl:text>&gt; .&#10;</xsl:text>
              
              <!--
                Transformation rule: rdf:type
                =================================
                Output: <qual_uri> rdf:type <Qualifier> .
                =============================================================
                Additional: This relation states that a Subject node used to identify a Qualifier record is of type "Qualifier".
              -->
              
              <xsl:text>&lt;&mesh;</xsl:text>
              <xsl:value-of select="QualifierReferredTo/QualifierUI"/>
              <xsl:text>&gt; </xsl:text>
              <xsl:text>&lt;&rdf;type&gt; </xsl:text>
              <xsl:text>&lt;&mesh;Qualifier&gt; .&#10;</xsl:text>
              
              <!--
                Transformation rule: dcterms:identifier
                ==========================================
                Output: <qual_uri> dcterms:identifier "qualUI" .
                ===========================================================
                Additional: A qualifier record has a unique identifier.
              -->
              
              <xsl:text>&lt;&mesh;</xsl:text>
              <xsl:value-of
                select="QualifierReferredTo/QualifierUI"/>
              <xsl:text>&gt; </xsl:text>
              <xsl:text>&lt;&dcterms;identifier&gt; </xsl:text>
              <xsl:text>"</xsl:text>
              <xsl:value-of select="QualifierReferredTo/QualifierUI"/>
              <xsl:text>" .&#10;</xsl:text>
              
              <!--
                Transformation rule: rdfs:label
                ======================================
                Output: <qual_uri> rdfs:label "qualName" .
                =================================================
                Additional: A qualifier record has a name.
              -->
              
              <xsl:text>&lt;&mesh;</xsl:text>
              <xsl:value-of select="replace(QualifierReferredTo/QualifierUI,'\*','')"/>
              <xsl:text>&gt; </xsl:text>
              <xsl:text>&lt;&rdfs;label&gt; </xsl:text>
              <xsl:text>"</xsl:text>
              <xsl:value-of select="QualifierReferredTo/QualifierName/String"/>
              <xsl:text>" .&#10;</xsl:text>
            </xsl:if>
          </xsl:for-each>        </xsl:if>



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

            <xsl:text>&lt;&mesh;</xsl:text>
            <xsl:value-of select="../../SupplementalRecordUI"/>
            <xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;&mesh;pharmacologicalAction&gt; </xsl:text>
            <xsl:text>&lt;&mesh;</xsl:text>
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
            
            <xsl:text>&lt;&mesh;</xsl:text>
            <xsl:value-of select="DescriptorReferredTo/DescriptorUI"/>
            <xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;&rdf;type&gt; </xsl:text>
            <xsl:text>&lt;&mesh;Descriptor&gt; .&#10;</xsl:text>


            <!--
              Transformation rule: dcterms:identifier
              =======================================
              Output: <desc_uri> dcterms:identifier "descUI" .
              ==================================================
              Additional: A descriptor has a name.
            -->

            <xsl:text>&lt;&mesh;</xsl:text>
            <xsl:value-of select="DescriptorReferredTo/DescriptorUI"/>
            <xsl:text>&gt;</xsl:text>
            <xsl:text> </xsl:text>
            <xsl:text>&lt;&dcterms;identifier&gt; </xsl:text>
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

            <xsl:text>&lt;&mesh;</xsl:text>
            <xsl:value-of select="DescriptorReferredTo/DescriptorUI"/>
            <xsl:text>&gt;</xsl:text>
            <xsl:text> </xsl:text>
            <xsl:text>&lt;&rdfs;label&gt; </xsl:text>
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
              Additional: A supplemental record can have one or more sources. A source is a 
              citation reference in which the indexing concept was first found.
            -->

            <xsl:text>&lt;&mesh;</xsl:text>
            <xsl:value-of select="../../SupplementalRecordUI"/>
            <xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;&mesh;source&gt; </xsl:text>
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
            Additional: A supplemental record can have a record originator, record 
            maintainer and record authorizer.
          -->

          <xsl:if test="RecordOriginatorsList/RecordOriginator">
            <xsl:text>&lt;&mesh;</xsl:text>
            <xsl:value-of select="SupplementalRecordUI"/>
            <xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;&mesh;recordOriginator> </xsl:text>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="RecordOriginatorsList/RecordOriginator"/>
            <xsl:text>" .&#10;</xsl:text>
          </xsl:if>

          <xsl:if test="RecordOriginatorsList/RecordMaintainer">
            <xsl:text>&lt;&mesh;</xsl:text>
            <xsl:value-of select="SupplementalRecordUI"/>
            <xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;&mesh;recordMaintainer> </xsl:text>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="RecordOriginatorsList/RecordMaintainer"/>
            <xsl:text>" .&#10;</xsl:text>
          </xsl:if>

          <xsl:if test="RecordOriginatorsList/RecordAuthorizer">
            <xsl:text>&lt;&mesh;</xsl:text>
            <xsl:value-of select="SupplementalRecordUI"/>
            <xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;&mesh;recordAuthorizer> </xsl:text>
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

          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="../../SupplementalRecordUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&mesh;concept&gt; </xsl:text>
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
            Transformation rule: isPreferredConcept
            ========================================
            Output: <conc_uri> isPreferredConcept "Y/N" .
            ==============================================
            Additional: A supplementary record has a preferred concept.
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
            Transformation rule: rdfs:label
          -->
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <output>*concept_uri* rdfs:label *concept_name*</output>
              <desc>A concept has a name</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <uri prefix='&mesh;'>
                <xsl:value-of select="ConceptUI"/>
              </uri>
              <uri prefix='&rdfs;'>label</uri>
              <literal>
                <xsl:value-of select="ConceptName/String"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>

          <!--
            Transformation rule: dcterms:identifier
            ========================================
            Output: <conc_uri> dcterms:identifier "concUI" .
            ================================================
            Additional: A concept has a unique identifier.
          -->

          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="ConceptUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&dcterms;identifier&gt; </xsl:text>
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
            <xsl:text>&lt;&mesh;</xsl:text>
            <xsl:value-of select="ConceptUI"/>
            <xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;&mesh;CASN1_label> </xsl:text>
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
          -->
          <xsl:if test="ScopeNote">
            <xsl:call-template name='triple'>
              <xsl:with-param name="doc">
                <output>*concept_uri* skos:scopeNote *scope_note*</output>
                <desc>A concept can have a scope note, a free-text narrative giving the scoe and meaning of a concept.</desc>
              </xsl:with-param>
              <xsl:with-param name='spec'>
                <uri prefix='&mesh;'>
                  <xsl:value-of select="ConceptUI"/>
                </uri>
                <uri prefix='&skos;'>scopeNote</uri>
                <literal>
                  <xsl:value-of select="ScopeNote"/>
                </literal>
              </xsl:with-param>
            </xsl:call-template>
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

              <!-- Added this on November 26, 2008 -->
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

          <xsl:if test="RelatedRegistryNumberList">
            <xsl:for-each select="RelatedRegistryNumberList/RelatedRegistryNumber">

              <!--
                Transformation rule: relatedRegistryNumber
                ==============================================
                Output: <conc_uri> relatedRegistryNumber "relatedRegistryNumber" .
                ======================================================================
                Additional: A concept can have a related registry number. See http://www.nlm.nih.gov/mesh/xml_data_elements.html for more information.
              -->

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
              <xsl:text>&lt;&mesh;</xsl:text>
              <xsl:value-of select="../../ConceptUI"/>
              <xsl:text>&gt; </xsl:text>
              <xsl:text>&lt;&mesh;conceptRelation> </xsl:text>
              <xsl:text>_:blank_set1_</xsl:text>
              <xsl:value-of select="../../ConceptUI"/>
              <xsl:text>_</xsl:text>
              <xsl:value-of select="position()"/>
              <xsl:text> .&#10;</xsl:text>
              
              <xsl:text>_:blank_set1_</xsl:text>
              <xsl:value-of select="../../ConceptUI"/>
              <xsl:text>_</xsl:text>
              <xsl:value-of select="position()"/>
              <xsl:text> &lt;&rdf;type&gt; </xsl:text>
              <xsl:text>&lt;&mesh;ConceptRelation&gt; .&#10;</xsl:text>
              
              <xsl:if test="@RelationName">
                <xsl:text>_:blank_set1_</xsl:text>
                <xsl:value-of select="../../ConceptUI"/>
                <xsl:text>_</xsl:text>
                <xsl:value-of select="position()"/>
                <xsl:text> &lt;&mesh;relation&gt; </xsl:text>
                <xsl:text>&lt;&skos;</xsl:text>
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
              <xsl:value-of select="../../ConceptUI"/>
              <xsl:text>_</xsl:text>
              <xsl:value-of select="position()"/>
              <xsl:text> &lt;&mesh;concept1> </xsl:text>
              <xsl:text>&lt;&mesh;</xsl:text>
              <xsl:value-of select="Concept1UI"/>
              <xsl:text>&gt; .&#10;</xsl:text>
              
              <xsl:text>_:blank_set1_</xsl:text>
              <xsl:value-of select="../../ConceptUI"/>
              <xsl:text>_</xsl:text>
              <xsl:value-of select="position()"/>
              <xsl:text> &lt;&mesh;concept2> </xsl:text>
              <xsl:text>&lt;&mesh;</xsl:text>
              <xsl:value-of select="Concept2UI"/>
              <xsl:text>&gt; .&#10;</xsl:text>
              
              <!-- added by rw -->
              <xsl:if test="RelationAttribute">
                <xsl:text>_:blank_set1_</xsl:text>
                <xsl:value-of select="../../ConceptUI"/>  
                <xsl:text>_</xsl:text>
                <xsl:value-of select="position()"/>
                <xsl:text> &lt;&mesh;relationAttribute> </xsl:text>
                <xsl:text>"</xsl:text>
                <xsl:value-of select="RelationAttribute"/>
                <xsl:text>" .&#10;</xsl:text>
              </xsl:if>
            </xsl:for-each>
          </xsl:if>

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
            <xsl:text>&lt;&mesh;</xsl:text>
            <xsl:value-of select="../../ConceptUI"/>
            <xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;&mesh;term> </xsl:text>
            <xsl:text>&lt;&mesh;</xsl:text>
            <xsl:value-of select="TermUI"/>
            <xsl:text>&gt; .&#10;</xsl:text>
            
            <!--
              Transformation rule: rdf:type
              ==============================
              Output: <term_uri> rdf:type <Term> .
              ========================================
              Additional: A concept has at least one term associated with it.
            -->
            
            <xsl:text>&lt;&mesh;</xsl:text>
            <xsl:value-of select="TermUI"/>
            <xsl:text>&gt; </xsl:text>
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
            
            <xsl:text>&lt;&mesh;</xsl:text>
            <xsl:value-of select="TermUI"/>
            <xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;&dcterms;identifier&gt; </xsl:text>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="TermUI"/>
            <xsl:text>" .&#10;</xsl:text>
            
            <xsl:if test="@IsPermutedTermYN = 'N'">
              <xsl:text>&lt;&mesh;</xsl:text>
              <xsl:value-of select="TermUI"/>
              <xsl:text>&gt; </xsl:text>
              <xsl:text>&lt;&rdfs;label&gt; </xsl:text>
              <xsl:text>"</xsl:text>
              <xsl:value-of select="String"/>
              <xsl:text>" .&#10;</xsl:text>
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
            
            <xsl:text>&lt;&mesh;</xsl:text>
            <xsl:value-of select="TermUI"/>
            <xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;&mesh;termData&gt; </xsl:text>
            <xsl:text>_:blank</xsl:text>
            <xsl:value-of select="TermUI"/>
            <xsl:text>_</xsl:text>
            <xsl:value-of select="position()"/>
            <xsl:text> .&#10;</xsl:text>
            
            <!--
              Transformation rule/Relation: rdf:type
              =======================================
              Output: _:blankTermUI_termNumber rdf:type <TermData> .
              =======================================================
              Description: This relation states that a Subject node used to identify term data is of type "TermData".
              ========================================================================================================
              Need to address: N/A.
            -->
            
            <xsl:text>_:blank</xsl:text>
            <xsl:value-of select="TermUI"/>
            <xsl:text>_</xsl:text>
            <xsl:value-of select="position()"/>
            <xsl:text> </xsl:text>
            <xsl:text>&lt;&rdf;type&gt; </xsl:text>
            <xsl:text>&lt;&mesh;TermData&gt; .&#10;</xsl:text>
            
            <!--
              Transformation rule: isConceptPreferredTerm
              ============================================
              Output: _:blankTermUI_termNo isConceptPreferredTerm "Y/N" .
              ============================================================
              Additional: This relation states that a term can be a concept-preferred-term. But it does so indirectly because the isConceptPreferredTerm relation is with a blank node.
              ===========================================================================================================================================================================
              Need to address: N/A.
            -->
            
            <xsl:text>_:blank</xsl:text>
            <xsl:value-of select="TermUI"/>
            <xsl:text>_</xsl:text>
            <xsl:value-of select="position()"/>
            <xsl:text> </xsl:text>
            <xsl:text>&lt;&mesh;isConceptPreferredTerm&gt; </xsl:text>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="@ConceptPreferredTermYN"/>
            <xsl:text>" .&#10;</xsl:text>
            
            <!--
              Transformation rule: isPermutedTerm
              =====================================
              Output: _:blankTermUI_termNo isPermutedTerm "Y/N" .
              =====================================================
              Additional: This relation states that a term can be a permuted term. But it does so indirectly because the isPermutedTerm relation is with a blank node.
              =========================================================================================================================================================
              Need to address: N/A.
            -->
            
            <xsl:text>_:blank</xsl:text>
            <xsl:value-of select="TermUI"/>
            <xsl:text>_</xsl:text>
            <xsl:value-of select="position()"/>
            <xsl:text> </xsl:text>
            <xsl:text>&lt;&mesh;isPermutedTerm&gt; </xsl:text>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="@IsPermutedTermYN"/>
            <xsl:text>" .&#10;</xsl:text>
            
            <!--
              Transformation rule: lexicalTag
              ===================================
              Output: _:blankTermUI_termNo lexicalTag "lexicalTag" .
              ==========================================================
              Additional: This relation states that a term has a lexical tag. But it does so indirectly becuase the hasLexicalTag relation is with a blank node.
              ====================================================================================================================================================
              Need to address: N/A.
            -->
            
            <xsl:text>_:blank</xsl:text>
            <xsl:value-of select="TermUI"/>
            <xsl:text>_</xsl:text>
            <xsl:value-of select="position()"/>
            <xsl:text> </xsl:text>
            <xsl:text>&lt;&mesh;lexicalTag&gt; </xsl:text>
            <xsl:text>"</xsl:text><xsl:value-of select="@LexicalTag"/>
            <xsl:text>" .&#10;</xsl:text>
            
            <!--
              Transformation rule: printFlag
              ===================================
              Output: _:blankTermUI_termNo printFlag "Y/N" .
              ==================================================
              Additional: This relation states that a term has a print flag. But it does this indirectly because the hasPrintFlag relation is with a blank node.
              ===================================================================================================================================================
              Need to address: N/A.
            -->
            
            <xsl:text>_:blank</xsl:text>
            <xsl:value-of select="TermUI"/>
            <xsl:text>_</xsl:text>
            <xsl:value-of select="position()"/>
            <xsl:text> </xsl:text>
            <xsl:text>&lt;&mesh;printFlag&gt; </xsl:text>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="@PrintFlagYN"/>
            <xsl:text>" .&#10;</xsl:text>
            
            <!--
              Transformation rule: isRecordPreferredTerm
              ===========================================
              Output: _:blankTermUI_termNo isRecordPreferredTerm "Y/N" .
              ============================================================
              Additional: This relation states that a term can be a record preferred term. But it does this indirectly because the relation is with a blank node.
              ====================================================================================================================================================
              Need to address: N/A.
            -->
            
            <xsl:text>_:blank</xsl:text>
            <xsl:value-of select="TermUI"/>
            <xsl:text>_</xsl:text>
            <xsl:value-of select="position()"/>
            <xsl:text> </xsl:text>
            <xsl:text>&lt;&mesh;isRecordPreferredTerm&gt; </xsl:text>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="@RecordPreferredTermYN"/>
            <xsl:text>" .&#10;</xsl:text>
            
            <!--
             Transformation rule: dcterms:identifier
             ========================================
             Output: _:blankTermUI_termNo dcterms:identifier "termUI" .
             ===========================================================
             Additional: This relation states that a term has a term unique identifier. However, it does so indirectly because the relation is with a blank node.
             ======================================================================================================================================================
             Additional: N/A.
            -->
            <xsl:text>_:blank</xsl:text>
            <xsl:value-of select="TermUI"/>
            <xsl:text>_</xsl:text>
            <xsl:value-of select="position()"/>
            <xsl:text> </xsl:text>
            <xsl:text>&lt;&dcterms;identifier&gt; </xsl:text>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="TermUI"/>
            <xsl:text>" .&#10;</xsl:text>
            
            <!--
              Transformation rule: rdfs:label
              =================================
              Output: _:blankTermUI_termNo rdfs:label "termName" .
              ======================================================
              Additional: This relation states that a term has a term name. But it does so indirectly because the relation is with a blank node.
              ====================================================================================================================================
              Need to address: N/A.
            -->
            
            <xsl:text>_:blank</xsl:text>
            <xsl:value-of select="TermUI"/>
            <xsl:text>_</xsl:text>
            <xsl:value-of select="position()"/>
            <xsl:text> </xsl:text>
            <xsl:text>&lt;&rdfs;label&gt; </xsl:text>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="String"/>
            <xsl:text>" .&#10;</xsl:text>
            
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
              <xsl:text>_:blank</xsl:text>
              <xsl:value-of select="TermUI"/>
              <xsl:text>_</xsl:text>
              <xsl:value-of select="position()"/>
              <xsl:text> </xsl:text>
              <xsl:text>&lt;&mesh;dateCreated&gt; </xsl:text>
              <xsl:text>"</xsl:text>
              <xsl:value-of select="string-join((DateCreated/Year,DateCreated/Month,DateCreated/Day),'-')"/>
              <xsl:text>" .&#10;</xsl:text>
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
              <xsl:text>_:blank</xsl:text>
              <xsl:value-of select="TermUI"/>
              <xsl:text>_</xsl:text>
              <xsl:value-of select="position()"/>
              <xsl:text> </xsl:text>
              <xsl:text>&lt;&mesh;abbreviation> </xsl:text>
              <xsl:text>"</xsl:text>
              <xsl:value-of select="Abbreviation"/>
              <xsl:text>" .&#10;</xsl:text>
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
              <xsl:text>_:blank</xsl:text>
              <xsl:value-of select="TermUI"/>
              <xsl:text>_</xsl:text>
              <xsl:value-of select="position()"/>
              <xsl:text> </xsl:text>
              <xsl:text>&lt;&mesh;sortVersion> </xsl:text>
              <xsl:text>"</xsl:text>
              <xsl:value-of select="SortVersion"/>
              <xsl:text>" .&#10;</xsl:text>
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
              <xsl:call-template name='triple'>
                <xsl:with-param name="doc">
                  <output>*supprec_uri* mesh:property *object*</output>
                  <desc></desc>
                  <fixme></fixme>
                </xsl:with-param>
                <xsl:with-param name='spec'>
                  <xsl:copy-of select="$supprec_uri"/>
                  <uri prefix='&mesh;'>property</uri>
                  <literal>
                    <xsl:value-of select="xpath"/>
                  </literal>
                </xsl:with-param>
              </xsl:call-template>
              <xsl:text>_:blank</xsl:text>
              <xsl:value-of select="TermUI"/>
              <xsl:text>_</xsl:text>
              <xsl:value-of select="position()"/>
              <xsl:text> &lt;&mesh;entryVersion> </xsl:text>
              <xsl:text>"</xsl:text>
              <xsl:value-of select="EntryVersion"/>
              <xsl:text>" .&#10;</xsl:text>
            </xsl:if>
            
            <!--
              Transformation rule: thesaurusID
            -->
            <xsl:if test="ThesaurusIDlist">
              <xsl:variable name="pos" select="position()"/>
              <xsl:for-each select="ThesaurusIDlist/ThesaurusID">
                <xsl:call-template name='triple'>
                  <xsl:with-param name="doc">
                    <output>*blank_node* mesh:thesaurusID *thesaurus_id*</output>
                    <desc>This relation states that a term has a thesaurus ID.</desc>
                  </xsl:with-param>
                  <xsl:with-param name='spec'>
                    <named>
                      <xsl:text>_:blank</xsl:text>
                      <xsl:value-of select="../../TermUI"/>
                      <xsl:text>_</xsl:text>
                      <xsl:copy-of select="$pos"/>
                    </named>
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
      </xsl:for-each>
    </xsl:if>

  </xsl:template>

</xsl:stylesheet>
