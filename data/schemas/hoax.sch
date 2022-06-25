<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
  xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
  <sch:ns uri="http://www.tei-c.org/ns/1.0" prefix="tei"/>
  <sch:p>Validation for ghost hoax source files</sch:p>
  <sch:pattern>
    <sch:let name="all-docs" value="collection('../hoax_xml?select=*.xml')/tei:TEI"/>
    <sch:let name="all-ids" value="$all-docs/@xml:id"/>
    <sch:rule context="tei:TEI">
      <sch:let name="myid" value="@xml:id"/>
      <sch:let name="filenames" value="$all-docs[@xml:id eq $myid] 
        ! base-uri(.)
        ! tokenize(., '/')[last()]"/>
      <sch:let name="count" value="count($all-ids[. = $myid])"/>
      <sch:report test="$count gt 1">The @xml:id value <sch:value-of select="@xml:id"/> appears in
          <sch:value-of select="$count"/> documents: <sch:value-of
          select="string-join($filenames, '; ')"/></sch:report>
    </sch:rule>
    <sch:rule context="@ref">
      <sch:report test=". eq ''">@ref attributes should not be empty</sch:report>
    </sch:rule>
    <sch:rule context="tei:body//(tei:p | tei:l)">
      <sch:report test="matches(., '^\s')">Paragraphs should not begin with whitespace.</sch:report>
      <sch:report test="matches(.,'\s$')">Paragraphs should not end with whitespace.</sch:report>
    </sch:rule>
  </sch:pattern>
</sch:schema>
