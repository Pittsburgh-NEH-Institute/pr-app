(: =====
Import functions
===== :)
import module namespace hoax ="http://www.obdurodon.org/hoax" at "functions.xqm";

(: =====
Declare namespaces
===== :)
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace m="http://www.obdurodon.org/hoax/model";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "no";

(: =====
Retrieve controller parameters
Default path to data is xmldb:exist:///db/apps/pr-app/data/hoax_xml
===== :)
declare variable $exist:root as xs:string := request:get-parameter("exist:root", "xmldb:exist:///db/apps");
declare variable $exist:controller as xs:string := request:get-parameter("exist:controller", "/pr-app");
declare variable $pros as xs:string := $exist:root || $exist:controller || '/data/aux_xml/persons.xml';

<persons xmlns="http://www.obdurodon.org/hoax/model">{
    for $person in doc($pros)/descendant::tei:listPerson/*
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
}</persons>
