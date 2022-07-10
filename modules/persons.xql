xquery version "3.1";

import module namespace hoax ="http://obdurodon.org/hoax" at "../modules/functions.xqm";

declare namespace tei="http://www.tei-c.org/ns/1.0";

declare namespace html="http://www.w3.org/1999/xhtml";

declare variable $pros :=doc('/db/apps/pr-app/data/aux_xml/persons.xml');

<persons xmlns:m="http://www.obdurodon.org/model">
{
for $person in $pros//tei:listPerson/*
let $surname := $person/tei:persName/tei:surname
let $forename := $person/tei:persName/tei:forename => string-join(' ')
let $abt := $person//tei:bibl ! normalize-space(.)
let $job := $person//tei:occupation ! normalize-space(.)
let $role := $person/@role ! string()
let $gm := $person/@sex ! string()
return

    <entry>
        <name>{string-join(($surname, $forename), ', ')}</name>
        <about>{$abt}</about>
        <job>{$job}</job>
        <role>{$role}</role>
        <gm>{$gm}</gm>
    </entry>

}
</persons>