xquery version "3.1";
import module namespace hoax ="http://www.obdurodon.org/hoax" at "../modules/functions.xqm";

declare namespace tei="http://www.tei-c.org/ns/1.0";
declare variable $id as xs:string := request:get-parameter('id', ());
declare variable $exist:root as xs:string := request:get-parameter("exist:root", "xmldb:exist:///db/apps");
declare variable $exist:controller as xs:string := request:get-parameter("exist:controller", "/pr-app");
declare variable $path-to-data as xs:string := $exist:root || $exist:controller || '/data/hoax_xml/';
declare variable $doc := collection($path-to-data)/id($id);


$doc
