xquery version "3.1";
(: =====
Import functions
===== :)
import module namespace hoax ="http://obdurodon.org/hoax" at "functions.xqm";

(: =====
Declare namespaces
===== :)
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace m="http://www.obdurodon.org/model";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "no";

(: =====
Retrieve controller parameters
Default path to data is xmldb:exist:///db/apps/pr-app/data/hoax_xml
===== :)
declare variable $exist:root as xs:string := request:get-parameter("exist:root", "xmldb:exist:///db/apps");
declare variable $exist:controller as xs:string := request:get-parameter("exist:controller", "/pr-app");
declare variable $path-to-data as xs:string := $exist:root || $exist:controller || '/data/hoax_xml//';
(: =====
Retrieve query parameters

declare variable $id as xs:string? := request:get-parameter('id', ());
===== :)
declare variable $id as xs:string := 'GH-TIMES-1804-01-17-P';
declare variable $term as xs:string? := request:get-parameter('term', ());

(: ====
Retrieve auxiliary data
==== :)
declare variable $gazetteer := doc($exist:root || $exist:controller || '/data/aux_xml/places.xml');
declare variable $pros := doc($exist:root || $exist:controller || '/data/aux_xml/people.xml');
 
(: ====
Retrieve article using $id
=== :)
declare variable $article as element() := collection($path-to-data)//id($id)[ft:query(., $term)];

if ($id) then 

<m:result>
{$article => util:expand()}
<m:aux>
<m:places>{$gazetteer//tei:place[@xml:id = $article//tei:placeName/@ref[starts-with(., '#')] ! substring(., 2)]}</m:places>
<m:people>{$pros//tei:person[@xml:id = $article//tei:persName/@ref[starts-with(., '#')] ! substring(., 2)]}</m:people>
</m:aux>
</m:result>
else <m:result>None</m:result>

