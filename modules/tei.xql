xquery version "3.1";
import module namespace hoax ="http://obdurodon.org/hoax" at "../modules/functions.xqm";

declare namespace tei="http://www.tei-c.org/ns/1.0";
declare variable $doc-name := 
    request:get-parameter('title', 'hammersmithghost_times_1804') || '.xml';
declare variable $exist:controller := request:get-parameter('exist:controller', 'hi');
declare variable $exist:prefix := request:get-parameter('exist:prefix', 'hi');
declare variable $doc as document-node() := doc($exist:prefix || $exist:controller || '/data/hoax_xml/' || $doc-name);

$doc