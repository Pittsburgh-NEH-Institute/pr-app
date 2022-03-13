xquery version "3.1";

import module namespace hoax ="http://obdurodon.org/hoax" at "../modules/functions.xqm";

declare namespace tei="http://www.tei-c.org/ns/1.0";

declare namespace html="http://www.w3.org/1999/xhtml";

declare variable $pros :=doc('/db/apps/pr-app/data/aux_xml/persons.xml');

for $person in $pros//tei:listPerson
let $surname := $person//tei:surname
return $surname