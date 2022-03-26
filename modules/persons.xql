xquery version "3.1";

import module namespace hoax ="http://obdurodon.org/hoax" at "../modules/functions.xqm";

declare namespace tei="http://www.tei-c.org/ns/1.0";

declare namespace html="http://www.w3.org/1999/xhtml";

declare variable $pros :=doc('/db/apps/pr-app/data/aux_xml/persons.xml');

<persons xmlns:m="http://www.obdurodon.org/model">
{
for $person in $pros//tei:listPerson/*
let $surname := $person/tei:persName/tei:surname
let $forename := $person/tei:persName/tei:forename[1]
let $abt := $person//tei:bibl
let $job := $person//tei:occupation
let $gm := $person/@sex/text()
return

    <entry>
        <name>{$surname || ', ' || $forename}</name>
        <about>{$abt}</about>
        <job>{$job} </job>
        <gm>{$gm}</gm>
    </entry>

}
</persons>