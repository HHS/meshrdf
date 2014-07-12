<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0"
                xmlns:f="http://nlm.nih.gov/ns/f"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs f">
  
  <!-- 
    Define some functions to aid in outputting triples
    ==================================================
  -->
  
  <!-- 
    Output a triple whose object is a string literal
  -->
  <xsl:function name="f:triple-literal">
    <xsl:param name="subject-uri"/>
    <xsl:param name="predicate-uri"/>
    <xsl:param name="object-literal"/>
    <xsl:value-of select="concat('&lt;', $subject-uri, '&gt; ')"/>
    <xsl:value-of select="concat('&lt;', $predicate-uri, '&gt; ')"/>
    <xsl:value-of select="concat(f:literal($object-literal), ' .&#10;')"/>
  </xsl:function>
  
  <!-- 
    Output a triple whose object is a uri
  -->
  <xsl:function name="f:triple-uri">
    <xsl:param name="subject-uri"/>
    <xsl:param name="predicate-uri"/>
    <xsl:param name="object-uri"/>
    <xsl:value-of select="concat('&lt;', $subject-uri, '&gt; ')"/>
    <xsl:value-of select="concat('&lt;', $predicate-uri, '&gt; ')"/>
    <xsl:value-of select="concat('&lt;', $object-uri, '&gt; .&#10;')"/>
  </xsl:function>

  <!-- 
    Create a literal string, wrapped in double-quotes, and properly escaped
  -->
  <xsl:function name='f:literal'>
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