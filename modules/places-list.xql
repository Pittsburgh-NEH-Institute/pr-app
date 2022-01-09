xquery version "3.1";

import module namespace hoax ="http://obdurodon.org/hoax" at "../modules/functions.xqm";

declare namespace tei="http://www.tei-c.org/ns/1.0";

declare namespace html="http://www.w3.org/1999/xhtml";

declare variable $places :=collection('/db/apps/pr-app/data/aux_xml/places.xml');

(: declare function local:dispatch($node as node()) as item()* {
    typeswitch($node)
        case text() return $node
        case element(tei:body) return local:section($node)
        case element(tei:listplace) return local:table($node)
        case element(tei:place) return local:tr($node)
        case element (tei:)
        default return local:passthru($node)
}; :)


