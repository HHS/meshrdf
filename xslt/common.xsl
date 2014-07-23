<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0"
                xmlns:f="http://nlm.nih.gov/ns/f"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs f">
  
  <!-- 
    The main named template used for outputting triples.
    This takes two parameters:  
    - doc - for self-documentation only; this isn't used when generating the triples.  It can contain:
        - <output> - put a stylized summary of the triple here
        - <desc> - short description of the rule
        - <fixme> - (optional) any work to be done? 
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
          <uri prefix='&mesh;'>property</uri>
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
  <xsl:function name='f:serialize'>
    <xsl:param name='v'/>
    <xsl:choose>
      <xsl:when test='$v/self::uri'>
        <xsl:value-of select='f:delimit-uri(concat($v/@prefix, $v))'/>
      </xsl:when>
      <xsl:when test='$v/self::literal'>
        <xsl:value-of select="f:literal-str($v)"/>
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


</xsl:stylesheet>