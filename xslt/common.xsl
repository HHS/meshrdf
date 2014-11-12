<?xml version="1.0" encoding="UTF-8"?>

<!--
  This external subset defines all of the entities that we'll use for URI prefixes from other
  various ontologies.
-->
<!DOCTYPE xsl:stylesheet SYSTEM "mesh-rdf-prefixes.ent" >

<xsl:stylesheet version="2.0"
                xmlns:f="http://nlm.nih.gov/ns/f"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="&xs;"
                exclude-result-prefixes="xs f">

  <xsl:key name='tree-numbers' match="//TreeNumber" use='.'/>

  <!--
    The main named template used for outputting triples.
    This takes two parameters:
    - doc - for self-documentation only; this isn't used when generating the triples.  It can contain:
        - <output> - put a stylized summary of the triple here
        - <desc> - short description of the rule
        - <fixme reporter='github-user' issue='github-issue-num'> - (optional) any work to be done? The
          value of the reporter attribute (if present) should be the GitHub username of the user.  The
          issue attribute can be used to point to a specific GitHub issue number.
    - spec - the three element children of this parameter define what to put out for the subject,
      predicate, and object, respectively.  The name of the child element defines the type thing to emit
      (see the n-triples grammar specification, http://www.w3.org/2001/sw/RDFCore/ntriples/):
        - <uri prefix='&pref;'>suffix</url> - generates a properly escaped and delimited URI.  The
          @prefix attribute should have the prefix, and the contents should hold the rest.
        - <literal>some string</literal> - generates a properly escaped and delimited literal
          (string) value.
        - <named>_:blank_123</named> - for blank nodes

    Template:
      * For fixme/@reporter, use the GitHub username
      * Within the `spec` parameter, put three children.  Any of which could look something like this:
          <uri prefix='&meshv;'>property</uri>
          <uri prefix='&mesh;'>
            <xsl:value-of select='$something_uri'/>
          </uri>
          <literal>
            <xsl:value-of select="xpath"/>
          </literal>
          <named>
            <xsl:value-of select='$blank_node_variable'/>
          </named>

      <xsl:call-template name='triple'>
        <xsl:with-param name="doc">
          <desc></desc>
          <fixme reporter=''></fixme>
        </xsl:with-param>
        <xsl:with-param name='spec'>
        </xsl:with-param>
      </xsl:call-template>

  -->

  <xsl:template name='triple'>
    <xsl:param name='doc'/>
    <xsl:param name='spec'/>
    <xsl:if test='count($spec/*) != 3'>
      <xsl:message terminate="yes">
        <xsl:text>Wrong number of element children of spec param of triple template</xsl:text>
      </xsl:message>
    </xsl:if>
    <xsl:variable name='s' select='$spec/*[1]'/>
    <xsl:variable name='p' select='$spec/*[2]'/>

    <!-- Strip leading and/or trailing whitespace from all literal values.  See issue #27.  We will issue a warning when these are
      encountered, and strip them out. -->
    <xsl:variable name='o' as="element()">
      <xsl:variable name='oo' select='$spec/*[3]'/>
      <xsl:choose>
        <xsl:when test="$oo/self::literal and matches($oo, '(^\s+)|(\s+$)')">
          <xsl:message>
            <xsl:text>&#xA;------------------------------------------------------------&#xA;</xsl:text>
            <xsl:text>Warning: literal value that has leading or trailing whitespace: '</xsl:text>
            <xsl:value-of select='$oo'/>
            <xsl:text>'</xsl:text>
          </xsl:message>
          <literal><xsl:value-of select="replace($oo, '^\s+|\s+$', '')"/></literal>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select='$oo'/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:value-of select='f:triple(
        f:serialize($s),
        f:serialize($p),
        f:serialize($o)
      )'/>
  </xsl:template>

  <!--
    This helper function serializes one of the three types of the components of the spec
    parameter sent to the triple template.
  -->
  <xsl:function name='f:serialize' as="text()">
    <xsl:param name='v'/>
    <xsl:choose>
      <xsl:when test='$v/self::uri'>
        <xsl:value-of select='f:delimit-uri(concat($v/@prefix, $v))'/>
      </xsl:when>
      <xsl:when test='$v/self::literal'>
        <xsl:variable name='type-string'>
          <xsl:if test='$v/@type'>
            <xsl:value-of select='concat("^^&lt;", $v/@type, ">")'/>
          </xsl:if>
        </xsl:variable>
        <xsl:value-of select="concat(f:literal-str($v), $type-string)"/>
      </xsl:when>
      <xsl:when test='$v/self::named'>
        <xsl:value-of select='$v'/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message terminate="yes">
          <xsl:text>Bad element in triple spec: </xsl:text>
          <xsl:value-of select="name($v)"/>
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>


  <!--
    Put delimiters (angle brackets) around a URI during serialization to NTriples format.
  -->
  <xsl:function name='f:delimit-uri'>
    <xsl:param name="uri"/>
    <xsl:value-of select='concat("&lt;", $uri, "&gt;")'/>
  </xsl:function>

  <!--
    Output a single triple.  The arguments should be already in their serialized form
  -->
  <xsl:function name='f:triple'>
    <xsl:param name="s"/>
    <xsl:param name="p"/>
    <xsl:param name="o"/>
    <xsl:value-of select='concat($s, " ", $p, " ", $o, " .&#10;")'/>
  </xsl:function>

  <!--
    Create a literal string, wrapped in double-quotes, and properly escaped.
  -->
  <xsl:function name='f:literal-str'>
    <xsl:param name='lit'/>
    <xsl:value-of select="concat('&quot;', f:n3-escape($lit), '&quot;')"/>
  </xsl:function>

  <!--
    Escapes literals properly for the N3 format.
  -->
  <xsl:function name="f:n3-escape">
    <xsl:param name="literal"/>
    <xsl:value-of select="replace(
        replace(
          replace(
            $literal, '\\' , '\\\\'
          ), '&quot;', '\\&quot;'
        ), '&#10;', '\\n'
      )"/>
  </xsl:function>

  <!--
    This function turns an enum value that is used throughout MeSH XML ('BRD', 'NRW', 'REL')
    into the related meshv URI. (This used to use skos predicates, but we were advised that
    it's better to keep our vocabulary separate.)
  -->
  <xsl:function name='f:meshv_relation_uri'>
    <xsl:param name='rel'/>
    <uri prefix='&meshv;'>
      <xsl:choose>
        <xsl:when test="matches($rel, 'BRD')">
          <xsl:text>broader</xsl:text>
        </xsl:when>
        <xsl:when test="matches($rel, 'NRW')">
          <xsl:text>narrower</xsl:text>
        </xsl:when>
        <xsl:when test="matches($rel, 'REL')">
          <xsl:text>related</xsl:text>
        </xsl:when>
      </xsl:choose>
    </uri>
  </xsl:function>


  <!--============================================================================
   The following are named templates that handle chunks of XML that are shared among
   more than one of the main XML files.
  -->

  <xsl:template name="CommonKids">
    <xsl:param name='parent'/>

    <!--
        Transformation rule: dateCreated
      -->
    <xsl:if test='DateCreated'>
      <xsl:call-template name='triple'>
        <xsl:with-param name="doc">
          <desc>A record has a date on which it was created.</desc>
        </xsl:with-param>
        <xsl:with-param name='spec'>
          <xsl:copy-of select="$parent"/>
          <uri prefix='&meshv;'>dateCreated</uri>
          <xsl:call-template name="DateLiteral">
            <xsl:with-param name="context" select="DateCreated"/>
          </xsl:call-template>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>

    <!--
      Transformation rule: dateRevised
    -->
    <xsl:if test="DateRevised">
      <xsl:call-template name='triple'>
        <xsl:with-param name="doc">
          <desc>A record can have a date on which it was revised.</desc>
        </xsl:with-param>
        <xsl:with-param name='spec'>
          <xsl:copy-of select="$parent"/>
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
          <xsl:copy-of select="$parent"/>
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
          <xsl:copy-of select="$parent"/>
          <uri prefix='&meshv;'>activeMeSHYear</uri>
          <literal type="&xs;#date">
            <xsl:value-of select="."/>
          </literal>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:for-each>

    <!--
      Transformation rule: annotation
    -->
    <xsl:if test="Annotation">
      <xsl:call-template name='triple'>
        <xsl:with-param name="doc">
          <desc>This rule states that a record has an annotation.</desc>
        </xsl:with-param>
        <xsl:with-param name='spec'>
          <xsl:copy-of select="$parent"/>
          <uri prefix='&meshv;'>annotation</uri>
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
          <desc>This relation states that a descriptor has a history note.</desc>
          <fixme report='klortho' issue='27'>Should have (leading and) trailing whitespace removed</fixme>
        </xsl:with-param>
        <xsl:with-param name='spec'>
          <xsl:copy-of select="$parent"/>
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
          <xsl:copy-of select="$parent"/>
          <uri prefix='&meshv;'>onlineNote</uri>
          <literal>
            <xsl:value-of select="OnlineNote"/>
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
          <desc>A record can have some previous indexing.</desc>
          <fixme>Whether there is any use in parsing the previous indexing text to
            derive other triples.</fixme>
        </xsl:with-param>
        <xsl:with-param name='spec'>
          <xsl:copy-of select="$parent"/>
          <uri prefix='&meshv;'>previousIndexing</uri>
          <literal>
            <xsl:value-of select="."/>
          </literal>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:for-each>

    <!--
      Transformation rule: pharmacologicalAction.
    -->
    <xsl:for-each select="PharmacologicalActionList/PharmacologicalAction">
      <xsl:call-template name='triple'>
        <xsl:with-param name="doc">
          <desc>A records can have a pharmacological action.</desc>
        </xsl:with-param>
        <xsl:with-param name='spec'>
          <xsl:copy-of select="$parent"/>
          <uri prefix='&meshv;'>pharmacologicalAction</uri>
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
      <xsl:variable name='tree-number-str' select='string(.)'/>
      <xsl:variable name='tree-number-uri'>
        <uri prefix='&mesh;'><xsl:value-of select="$tree-number-str"/></uri>
      </xsl:variable>

      <xsl:call-template name='triple'>
        <xsl:with-param name="doc">
          <desc>Records can have zero-to-many tree numbers.
            A tree number is a dot-delimited string of alphanumeric segments, that
            loosely encode "broader" relationships.</desc>
        </xsl:with-param>
        <xsl:with-param name='spec'>
          <xsl:copy-of select="$parent"/>
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
              to link it to its parent with meshv:broaderTransitive.</desc>
          </xsl:with-param>
          <xsl:with-param name="spec">
            <xsl:copy-of select='$tree-number-uri'/>
            <uri prefix='&meshv;'>broaderTransitive</uri>
            <uri prefix='&mesh;'>
              <xsl:value-of select="$parent-tree-number"/>
            </uri>
          </xsl:with-param>
        </xsl:call-template>
        
        <!-- Create triples to relate descriptors to descriptors and qualifiers to qualifiers using meshv:broader -->
        <xsl:variable name='parent-tree-number-element'
          select='key("tree-numbers", $parent-tree-number)'/>
         <xsl:if test='$parent-tree-number-element'>
           <xsl:if test='ancestor::DescriptorRecord'>
            <xsl:call-template name='triple'>
              <xsl:with-param name="doc">
                <desc>Also create a simple meshv:broader relationship between this descriptor and
                  the descriptor that has the parent tree number</desc>
              </xsl:with-param>
              <xsl:with-param name="spec">
                <xsl:copy-of select="$parent"/>
                <uri prefix='&meshv;'>broader</uri>
                <uri prefix='&mesh;'>
                  <xsl:value-of select="$parent-tree-number-element/ancestor::DescriptorRecord/DescriptorUI"/>
                </uri>
              </xsl:with-param>
            </xsl:call-template>
            </xsl:if>
            <xsl:if test='ancestor::QualifierRecord'>
              <xsl:call-template name='triple'>
                <xsl:with-param name="doc">
                  <desc>Also create a simple meshv:broader relationship between this qualifier and
                    the qualifier that has the parent tree number</desc>
                </xsl:with-param>
                <xsl:with-param name="spec">
                  <xsl:copy-of select="$parent"/>
                  <uri prefix='&meshv;'>broader</uri>
                  <uri prefix='&mesh;'>
                    <xsl:value-of select="$parent-tree-number-element/ancestor::QualifierRecord/QualifierUI"/>
                  </uri>
                </xsl:with-param>
              </xsl:call-template>
           </xsl:if>
        </xsl:if>
      </xsl:if>
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
          <xsl:copy-of select="$parent"/>
          <uri prefix='&meshv;'>recordOriginator</uri>
          <literal>
            <xsl:value-of select="RecordOriginatorsList/RecordOriginator"/>
          </literal>
        </xsl:with-param>
      </xsl:call-template>

      <!--
        Transformation rule: recordMaintainer
      -->
      <xsl:if test='RecordOriginatorsList/RecordMaintainer'>
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>This relation states that a descriptor has a record maintainer</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$parent"/>
            <uri prefix='&meshv;'>recordMaintainer</uri>
            <literal>
              <xsl:value-of select="RecordOriginatorsList/RecordMaintainer"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>

      <!--
        Transformation rule: recordAuthorizer
      -->
      <xsl:if test='RecordOriginatorsList/RecordAuthorizer'>
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>This relation states that a descriptor has a record authorizer</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$parent"/>
            <uri prefix='&meshv;'>recordAuthorizer</uri>
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
      <xsl:call-template name="triple">
        <xsl:with-param name="doc">
          <desc>This relation states that a record has a concept,
            using either the meshv:concept or meshv:preferredConcept property</desc>
        </xsl:with-param>
        <xsl:with-param name="spec">
          <xsl:copy-of select="$parent"/>
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
        Transformation rule: meshv:identifier
      -->
      <xsl:call-template name="triple">
        <xsl:with-param name="doc">
          <desc>This relation states that a concept has a unique identifier.</desc>
        </xsl:with-param>
        <xsl:with-param name="spec">
          <xsl:copy-of select="$concept_uri"/>
          <uri prefix='&meshv;'>identifier</uri>
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
            <uri prefix='&meshv;'>casn1_label</uri>
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
        Transformation rule: meshv:scopeNote
      -->
      <xsl:if test="ScopeNote">
        <xsl:call-template name="triple">
          <xsl:with-param name="doc">
            <desc>A concept has a scope note.</desc>
          </xsl:with-param>
          <xsl:with-param name="spec">
            <xsl:copy-of select="$concept_uri"/>
            <uri prefix='&meshv;'>scopeNote</uri>
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
          Transformation rule: meshv:identifier
        -->
        <xsl:call-template name="triple">
          <xsl:with-param name="doc">
            <desc>This rule states that a semantic type has a unique identifier.</desc>
            <fixme report='klortho'>Same concern as above.</fixme>
          </xsl:with-param>
          <xsl:with-param name="spec">
            <xsl:copy-of select="$semantic_type_uri"/>
            <uri prefix='&meshv;'>identifier</uri>
            <literal>
              <xsl:value-of select="SemanticTypeUI"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>

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

      <xsl:for-each select="ConceptRelationList/ConceptRelation">
        <xsl:if test="@RelationName">
          <xsl:call-template name="triple">
            <xsl:with-param name="spec">
              <uri prefix='&mesh;'>
                <xsl:value-of select="Concept1UI"/>
              </uri>
              <xsl:copy-of select="f:meshv_relation_uri(@RelationName)"/>
              <uri prefix='&mesh;'>
                <xsl:value-of select="Concept2UI"/>
              </uri>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>

      <!--
        We had originally discussed creating separate predicates for each of these
        RelationAttributes (see GitHub issue #15, https://github.com/HHS/mesh-rdf/issues/15,
        but, later, decided against it.
        <xsl:if test="RelationAttribute">
          <xsl:call-template name="triple">
            <xsl:with-param name="spec">
              <uri prefix='&mesh;'>
                <xsl:value-of select="Concept1UI"/>
              </uri>
              <uri prefix='&mesh;'>
                <xsl:value-of select="concat('rela/', RelationAttribute)"/>
              </uri>
              <uri prefix='&mesh;'>
                <xsl:value-of select="Concept2UI"/>
              </uri>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
      -->
      </xsl:for-each>

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
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select='$term_uri'/>
            <uri prefix='&rdf;'>type</uri>

            <!-- In issue #36, we discussed this, and decided not to create individual subclasses of meshv:Term.
              Leaving the code here, just in case they ever change their minds.
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
            -->
            <uri prefix='&meshv;'>Term</uri>

          </xsl:with-param>
        </xsl:call-template>

        <!--
          Transformation rule: meshv:identifier
        -->
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>This relation states that a term has a term unique identifier.</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select='$term_uri'/>
            <uri prefix='&meshv;'>identifier</uri>
            <literal>
              <xsl:value-of select="TermUI"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>

        <!--
          Transformation rule: meshv:prefLabel
          Since IsPermutedTermYN is "N", we know this is the
          preferred label: record that with both meshv:prefLabel and rdfs:label.
        -->
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>The label for this term. meshv:prefLabel is a subproperty of rdfs:label.</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select='$term_uri'/>
            <uri prefix='&meshv;'>prefLabel</uri>
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
              <xsl:copy-of select='$parent'/>
              <uri prefix='&meshv;'>recordPreferredTerm</uri>
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
        Now permuted Terms.  This just produces a meshv:altLabel
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
            <uri prefix='&meshv;'>altLabel</uri>
            <literal>
              <xsl:value-of select="String"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name='DateLiteral'>
    <xsl:param name='context'/>
    <literal type='&xs;#date'>
      <xsl:value-of select="xs:date(string-join(($context/Year, $context/Month, $context/Day), '-'))"/>
    </literal>
  </xsl:template>
</xsl:stylesheet>