<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
  xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
  <sch:ns uri="http://www.tei-c.org/ns/1.0" prefix="tei"/>
  <sch:pattern>
    <sch:rule context="tei:geo">
      <sch:assert test="matches(., '^\S+ \S+$')">Whitespace error in &lt;geo&gt;
        element</sch:assert>
      <sch:assert test="every $geopart in tokenize(., ' ') satisfies $geopart castable as xs:double">Some part of <sch:value-of select="."/> is not numeric. Is there a comma inside?</sch:assert>
    </sch:rule>
    <sch:rule context="tei:placeName">
      <sch:assert test=". eq normalize-space(.)">Whitespace error in placeName: <sch:value-of
          select="."/></sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>
