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
    <xsl:variable name='o' select='$spec/*[3]'/>
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
    Create a literal string, wrapped in double-quotes, and properly escaped
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
        replace($literal, '&quot;', '\\&quot;'),
        '&#10;', '\\n'
      )"/>
  </xsl:function>

  <!--
    This function turns an enum value that is used throughout MeSH XML ('BRD', 'NRW', 'REL')
    into the related skos URI.
  -->
  <xsl:function name='f:skos_relation_uri'>
    <xsl:param name='rel'/>
    <uri prefix='&skos;'>
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

  <xsl:template name="RecordOriginatorsList">
    <xsl:param name='parent'/>
    
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
    
  </xsl:template>

  <xsl:template name='ConceptRelationList'>
    <xsl:param name="concept_uri"/>
    
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
          <uri prefix='&meshv;'>conceptRelation</uri>
          <xsl:copy-of select="$blank_node"/>
        </xsl:with-param>
      </xsl:call-template>
      
      <xsl:call-template name="triple">
        <xsl:with-param name="spec">
          <xsl:copy-of select="$blank_node"/>
          <uri prefix='&rdf;'>type</uri>
          <uri prefix='&meshv;'>ConceptRelation</uri>
        </xsl:with-param>
      </xsl:call-template>            
      
      <xsl:if test="@RelationName">
        <xsl:call-template name="triple">
          <xsl:with-param name="spec">
            <xsl:copy-of select="$blank_node"/>
            <uri prefix='&meshv;'>relation</uri>
            <xsl:copy-of select="f:skos_relation_uri(@RelationName)"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>
      
      <xsl:call-template name="triple">
        <xsl:with-param name="spec">
          <xsl:copy-of select="$blank_node"/>
          <uri prefix='&meshv;'>concept1</uri>
          <uri prefix='&mesh;'>
            <xsl:value-of select="Concept1UI"/>
          </uri>
        </xsl:with-param>
      </xsl:call-template>
      
      <xsl:call-template name="triple">
        <xsl:with-param name="spec">
          <xsl:copy-of select="$blank_node"/>
          <uri prefix='&meshv;'>concept2</uri>
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
            <uri prefix='&meshv;'>relationAttribute</uri>
            <literal>
              <xsl:value-of select="RelationAttribute"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name='DateLiteral'>
    <xsl:param name='context'/>
    <literal type='&xs;#date'>
      <xsl:value-of select="xs:date(string-join(($context/Year, $context/Month, $context/Day), '-'))"/>
    </literal>
  </xsl:template>
</xsl:stylesheet>