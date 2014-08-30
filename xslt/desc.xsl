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

  <xsl:key name='tree-numbers' match="//TreeNumber" use='.'/>

  <xsl:template match="/">
    <xsl:for-each select="DescriptorRecordSet/DescriptorRecord">

      <xsl:variable name='descriptor_id' select='DescriptorUI'/>
      
      <!--
        Transformation rule: dcterms:identifier
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
          <uri prefix='&meshv;'>Descriptor</uri>
        </xsl:with-param>
      </xsl:call-template>

      <!-- 
        Transformation rule: descriptorClass
      -->
      <xsl:call-template name="triple">
        <xsl:with-param name="doc">
          <desc>This relation states that a descriptor record has a descriptor class to which 
            it belongs.</desc>
          <fixme reporter='klortho' issue='28'>Wouldn't this be done better by using a class hierarchy? For
            example, each of topical descriptor, publication type, check tag, and 
            geographical descriptor could be defined as a class in the ontology?</fixme>
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

      <!-- 
        Transformation rule: dateCreated
      -->
      <xsl:call-template name='triple'>
        <xsl:with-param name="doc">
          <desc>This relation states that a descriptor record has a date on which it was created, revised and established.</desc>
        </xsl:with-param>
        <xsl:with-param name='spec'>
          <xsl:copy-of select="$descriptor_uri"/>
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
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$descriptor_uri"/>
            <uri prefix='&meshv;'>dateRevised</uri>
            <xsl:call-template name="DateLiteral">
              <xsl:with-param name="context" select="DateRevised"/>
            </xsl:call-template>
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
            <uri prefix='&meshv;'>dateEstablished</uri>
            <xsl:call-template name="DateLiteral">
              <xsl:with-param name="context" select="DateEstablished"/>
            </xsl:call-template>
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
            <uri prefix='&meshv;'>activeMeSHYear</uri>
            <literal type="&xs;#date">
              <xsl:value-of select="."/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>

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
        Transformation rule: historyNote
      -->
      <xsl:if test="HistoryNote">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>This relation states that a descriptor has a history note.</desc>
            <fixme report='klortho' issue='27'>Should have (leading and) trailing whitespace removed</fixme>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$descriptor_uri"/>
            <uri prefix='&meshv;'>historyNote</uri>
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
            <uri prefix='&meshv;'>onlineNote</uri>
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
            <uri prefix='&meshv;'>previousIndexing</uri>
            <literal>
              <xsl:value-of select="."/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>

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
        Transformation rule: pharmacologicalAction.
        Documented in Descriptor-references
      -->
      <xsl:for-each select="PharmacologicalActionList/PharmacologicalAction">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>This relation states that a descriptor has a pharmacological action.</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$descriptor_uri"/>
            <uri prefix='&meshv;'>pharmacologicalAction</uri>
            <uri prefix='&mesh;'>
              <xsl:value-of select="DescriptorReferredTo/DescriptorUI"/>
            </uri>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>

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

      <!-- 
        Transformation rule: treeNumber
      -->
      <xsl:for-each select="TreeNumberList/TreeNumber">
        <xsl:variable name='tree-number-str' select='string(.)'/>
        <xsl:variable name='tree-number-uri'>
          <uri prefix='&mesh;'><xsl:value-of select="$tree-number-str"/></uri>
        </xsl:variable>
          
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>Every MeSH descriptor record can zero-to-many tree numbers.
              A tree number is a dot-delimited string of alphanumeric segments, that 
              loosely encode "broader" relationships.</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$descriptor_uri"/>
            <uri prefix='&meshv;'>treeNumber</uri>
            <xsl:copy-of select='$tree-number-uri'/>
          </xsl:with-param>
        </xsl:call-template>
        
        <xsl:call-template name="triple">
          <xsl:with-param name="doc">
            <desc>The tree number resource is of type meshv:TreeNumber</desc>
          </xsl:with-param>
          <xsl:with-param name="spec">
            <xsl:copy-of select='$tree-number-uri'/>
            <uri prefix='&rdf;'>type</uri>
            <uri prefix='&meshv;'>TreeNumber</uri>
          </xsl:with-param>
        </xsl:call-template>

        <xsl:call-template name="triple">
          <xsl:with-param name="doc">
            <desc>The human-readable label for the tree number is the identifier string itself.</desc>
          </xsl:with-param>
          <xsl:with-param name="spec">
            <xsl:copy-of select='$tree-number-uri'/>
            <uri prefix='&rdfs;'>label</uri>
            <literal><xsl:value-of select="$tree-number-str"/></literal>
          </xsl:with-param>
        </xsl:call-template>
        
        <!-- If this tree number has a parent, then we'll create some more links -->
        <xsl:if test='contains($tree-number-str, ".")'>
          <xsl:variable name="parent-tree-number" select="replace($tree-number-str, '^(.*)\..*', '$1')"/>
          
          <xsl:call-template name="triple">
            <xsl:with-param name="doc">
              <desc>Every time we reify a TreeNumber that has a dot in it, we'll create a triple
                to link it to its parent with skos:broaderTransitive.</desc>
            </xsl:with-param>
            <xsl:with-param name="spec">
              <xsl:copy-of select='$tree-number-uri'/>
              <uri prefix='&skos;'>broaderTransitive</uri>
              <uri prefix='&mesh;'>
                <xsl:value-of select="$parent-tree-number"/>
              </uri>
            </xsl:with-param>
          </xsl:call-template>
          
          <xsl:variable name='parent-tree-number-element' 
                        select='key("tree-numbers", $parent-tree-number)'/>
          <xsl:if test='$parent-tree-number-element'>
            <xsl:call-template name='triple'>
              <xsl:with-param name="doc">
                <desc>Also create a simple skos:broader relationship between this descriptor and
                  the descriptor that has the parent tree number</desc>
              </xsl:with-param>
              <xsl:with-param name="spec">
                <xsl:copy-of select="$descriptor_uri"/>
                <uri prefix='&skos;'>broader</uri>
                <uri prefix='&mesh;'>
                  <xsl:value-of select="$parent-tree-number-element/ancestor::DescriptorRecord/DescriptorUI"/>
                </uri>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:if>
        </xsl:if>
      </xsl:for-each>

      <xsl:call-template name='RecordOriginatorsList'>
        <xsl:with-param name="parent" select="$descriptor_uri"/>
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
        <xsl:call-template name="triple">
          <xsl:with-param name="doc">
            <desc>This relation states that a descriptor record has a concept,
              using either the meshv:concept or meshv:preferredConcept property</desc>
          </xsl:with-param>
          <xsl:with-param name="spec">
            <xsl:copy-of select="$descriptor_uri"/>
            <uri prefix='&meshv;'>
              <xsl:choose>
                <xsl:when test="@PreferredConceptYN = 'Y'">
                  <xsl:text>preferredConcept</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>concept</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </uri>
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
            <uri prefix='&meshv;'>Concept</uri>
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

        <!--
          Transformation rule: CASN1_label
        -->    
        <xsl:if test="CASN1Name">
          <xsl:call-template name="triple">
            <xsl:with-param name="doc">
              <desc>This relation states that a concept has a Chemical Abstracts Type N1 Name.</desc>
              <fixme>Do we want to parse the CASN1Name (e.g. for other purposes)?</fixme>
              <fixme reporter='klortho'>The name of this property does not match the convention that
                they start with lower-case letters.</fixme>
            </xsl:with-param>
            <xsl:with-param name="spec">
              <xsl:copy-of select="$concept_uri"/>
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
          <xsl:call-template name="triple">
            <xsl:with-param name="doc">
              <desc>This relation states that a concept has a registry number.</desc>
              <fixme reporter='klortho' issue='32'>According to the 
                [documentation](http://www.nlm.nih.gov/mesh/xml_data_elements.html#RegistryNumber),
                currently, this can be one of four types.  It would help the "linked data" cause if
                we could parse out excactly what the type was and point to the canonical linked-data
                URI, if one exists, whenever possible.</fixme>
            </xsl:with-param>
            <xsl:with-param name="spec">
              <xsl:copy-of select="$concept_uri"/>
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
              </xsl:with-param>
              <xsl:with-param name="spec">
                <xsl:copy-of select="$concept_uri"/>
                <uri prefix='&meshv;'>semanticType</uri>
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
                <uri prefix='&meshv;'>SemanticType</uri>
              </xsl:with-param>
            </xsl:call-template>
 
            <!--
              Transformation rule: rdfs:label
            -->
            <xsl:call-template name="triple">
              <xsl:with-param name="doc">
                <desc>This rule states the a semantic type unique identifier has a semantic type name.</desc>
                <fixme report='klortho'>Since SemanticTypes are not centrally defined, this will result in some
                  duplicate triples being created, if the same SemanticType occurs in multiple
                  places.
                </fixme>
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
                <fixme report='klortho'>Same concern as above.</fixme>
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

        <!--
          Transformation rule: relatedRegistryNumber
        -->
        <xsl:if test="RelatedRegistryNumberList">
          <xsl:for-each select="RelatedRegistryNumberList/RelatedRegistryNumber">
            <xsl:call-template name="triple">
              <xsl:with-param name="doc">
                <desc>This relation states that a concept has a related registry number.</desc>
                <fixme issue='32'>Maybe it would be good to reduce this value to only a number. But 
                  I'm not sure. Need to check with a MeSH expert to see how important is the text
                  after the number.  Also, according to the documentation, this takes the same
                  format as RegistryNumber above.  See the fixme item there.</fixme>
              </xsl:with-param>
              <xsl:with-param name="spec">
                <xsl:copy-of select="$concept_uri"/>
                <uri prefix='&meshv;'>relatedRegistryNumber</uri>
                <literal>
                  <xsl:value-of select="."/>
                </literal>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:if>

        <xsl:call-template name="ConceptRelationList"/>

        <!--
          Two separate `for-each` sections, one for non-permuted terms, and one for permuted.
        -->
        
        <xsl:for-each select="TermList/Term[@IsPermutedTermYN='N']">
          <xsl:variable name='term_uri'>
            <uri prefix='&mesh;'>
              <xsl:value-of select="TermUI"/>
            </uri>
          </xsl:variable>
          
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>This relation states that a concept has a term. The property used will either be
                meshv:term or mesh:preferredTerm</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$concept_uri"/>
              <uri prefix='&meshv;'>
                <xsl:choose>
                  <xsl:when test="@ConceptPreferredTermYN = 'Y'">
                    <xsl:text>preferredTerm</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>term</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </uri>
              <xsl:copy-of select='$term_uri'/>
            </xsl:with-param>
          </xsl:call-template>

          <!--
            Transformation rule: rdf:type
          -->          
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>A term is of type Term.</desc>
              <fixme reporter='klortho' issue='36'>
                Need official approval that this model is okay.
              </fixme>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select='$term_uri'/>
              <uri prefix='&rdf;'>type</uri>
              <xsl:choose>
                <xsl:when test="@LexicalTag = 'ABB'">
                  <uri prefix='&meshv;'>Abbreviation</uri>
                </xsl:when>
                <xsl:when test="@LexicalTag = 'ABX'">
                  <uri prefix='&meshv;'>EmbeddedAbbreviation</uri>
                </xsl:when>
                <xsl:when test="@LexicalTag = 'ACR'">
                  <uri prefix='&meshv;'>Acronym</uri>
                </xsl:when>
                <xsl:when test="@LexicalTag = 'ACX'">
                  <uri prefix='&meshv;'>EmbeddedAcronym</uri>
                </xsl:when>
                <xsl:when test="@LexicalTag = 'EPO'">
                  <uri prefix='&meshv;'>Eponym</uri>
                </xsl:when>
                <xsl:when test="@LexicalTag = 'LAB'">
                  <uri prefix='&meshv;'>LabNumber</uri>
                </xsl:when>
                <xsl:when test="@LexicalTag = 'NAM'">
                  <uri prefix='&meshv;'>ProperName</uri>
                </xsl:when>
                <xsl:when test="@LexicalTag = 'NON'">
                  <!-- Generic term - use the superclass -->
                  <uri prefix='&meshv;'>Term</uri>
                </xsl:when>
                <xsl:when test="@LexicalTag = 'TRD'">
                  <uri prefix='&meshv;'>TradeName</uri>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:message terminate="yes">
                    <xsl:text>Term </xsl:text>
                    <xsl:value-of select="TermUI"/>
                    <xsl:text> missing LexicalTag attribute.</xsl:text>
                  </xsl:message>
                </xsl:otherwise>
              </xsl:choose>
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

          <!-- 
            Transformation rule: rdfs:label, skos:prefLabel
            Since IsPermutedTermYN is "N", we know this is the
            preferred label: record that with both skos:prefLabel and rdfs:label. 
          -->
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>The label for this term.</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select='$term_uri'/>
              <uri prefix='&rdfs;'>label</uri>
              <literal>
                <xsl:value-of select="String"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>
          
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>Record the same thing with skos:prefLabel.</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select='$term_uri'/>
              <uri prefix='&skos;'>prefLabel</uri>
              <literal>
                <xsl:value-of select="String"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>
          
          <!--
            Transformation rule: lexicalTag
          -->
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>This relation states that a term has a lexical tag. </desc>
              <fixme reporter='klortho' issue='36'>
                See also above, where the @LexicalTag attribute is used to determine the class
                of this object as one of meshv:LabNumber, meshv:Eponym, etc., each of which is
                a subclass of meshv:Term.  The triple with the literal value is provided too,
                for convenience.
              </fixme>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select='$term_uri'/>
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
              <desc>This relation states that a term has a print flag.</desc>
              <fixme reporter='klortho'>Turn this into a typed boolean value.</fixme>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select='$term_uri'/>
              <uri prefix='&meshv;'>printFlag</uri>
              <literal>
                <xsl:value-of select="@PrintFlagYN"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>
          
          <!--
            Transformation rule: record preferred term
          -->
          <xsl:if test='@RecordPreferredTermYN = "Y"'>
            <xsl:call-template name='triple'>
              <xsl:with-param name="doc">
                <desc>This triple specifies that this is the preferred term of the entire record</desc>
                <fixme reporter='klortho' issue='36'>
                  Need confirmation that this model is okay.
                </fixme>
              </xsl:with-param>
              <xsl:with-param name='spec'>
                <xsl:copy-of select='$descriptor_uri'/>
                <uri prefix='&meshv;'>preferredTerm</uri>
                <xsl:copy-of select='$term_uri'/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:if>
          
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
                <xsl:copy-of select='$term_uri'/>
                <uri prefix='&meshv;'>dateCreated</uri>
                <xsl:call-template name="DateLiteral">
                  <xsl:with-param name="context" select="DateCreated"/>
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:if>
          
          <!--
          Documenting and diagramming all of these sub-graphs on the wiki. See issue #30.
          Done up to here.
        -->
          
          
          <!--
            Transformation rule: abbreviation
          -->
          <xsl:if test="Abbreviation">
            <xsl:call-template name='triple'>
              <xsl:with-param name="doc">
                <desc>This relation states that a term has a term abbreviation.</desc>
              </xsl:with-param>
              <xsl:with-param name='spec'>
                <xsl:copy-of select='$term_uri'/>
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
                <xsl:copy-of select='$term_uri'/>
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
                <xsl:copy-of select='$term_uri'/>
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
          <xsl:for-each select="ThesaurusIDlist/ThesaurusID">
            <xsl:call-template name='triple'>
              <xsl:with-param name="doc">
                <desc>This relation states that a term has a thesaurus ID.</desc>
              </xsl:with-param>
              <xsl:with-param name='spec'>
                <xsl:copy-of select='$term_uri'/>
                <uri prefix='&meshv;'>thesaurusID</uri>
                <literal>
                  <xsl:value-of select="."/>
                </literal>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:for-each>

        <!-- 
          Now permuted Terms.  This just produces a skos:altLabel
        -->
        <xsl:for-each select="TermList/Term[@IsPermutedTermYN='Y']">
          <xsl:variable name='term_uri'>
            <uri prefix='&mesh;'>
              <xsl:value-of select="TermUI"/>
            </uri>
          </xsl:variable>

          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>Alternate label.</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select='$term_uri'/>
              <uri prefix='&skos;'>altLabel</uri>
              <literal>
                <xsl:value-of select="String"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:for-each>

      <!--
        Transformation rule: annotation
      -->
      <xsl:if test="Annotation">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>This rule states that a descriptor record has an annotation.</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$descriptor_uri"/>
            <uri prefix='&meshv;'>annotation</uri>
            <literal>
              <xsl:value-of select="Annotation"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>

    </xsl:for-each>
    
  </xsl:template>
</xsl:stylesheet>
