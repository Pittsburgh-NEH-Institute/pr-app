xquery version "3.1";

import module namespace hoax ="http://obdurodon.org/hoax" at "../modules/functions.xqm";

declare namespace tei="http://www.tei-c.org/ns/1.0";

declare namespace html="http://www.w3.org/1999/xhtml";

declare variable $gazeteer :=doc('/db/apps/pr-app/data/aux_xml/places.xml');

(:create tei table (tables contain rows that contain cells
 you can have separate wrappers around head and body
:)

(: declare function local:dispatch($node as node()) as item()* {
    typeswitch($node)
        case text() return $node
        case element(tei:body) return local:section($node)
        case element(tei:listplace) return local:table($node)
        case element(tei:place) return local:tr($node)
        case element (tei:)
       (:) default return local:passthru($node)
}; :)

let $places as element()+ := $gazeteer//tei:place
return
<places xmlns:m="http://www.obdurodon.org/model">
{
  for $entry in $places
    let $placename as element(tei:placeName)+ := $entry/tei:placeName
    let $geo :=$entry/tei:location/tei:geo
    let $lat as xs:string := substring-before($geo, " ")
    let $long as xs:string := substring-after($geo, " ")
    let $parent as element(tei:placeName)? := $entry/parent::tei:place/tei:placeName[1]

    return
    <placeEntry>
    {$placename}
        <geo>
        <lat>{$lat}</lat>
        <long>{$long}</long>
        </geo>
    <parentPlace>{$parent}</parentPlace>
    </placeEntry>
    }
    </places>

(:need to fix the TEI namespace, I think maybe we should just make a namespace for the model?:)

(:flattening TEI XML is a good idea:)
(:(if {$parent} then <parentPlace>{$parent}</parentPlace> else ()):)


(:let $placename := $places/tei:placeName/text()
let $parentplace := $places/parent::tei:place/tei:placeName/text():)

(:Find places where it is not the case that there is a parent element is tei:place :)
(:let $parentlessplace :=$places[not(parent::tei:place)]/@xml:id:)


(:for $entry in $places
let $listitem := concat($placename, 'is in', $parentplace)

let $geo := $place//tei:geo
let $lat := substring-before($geo, ' ')
let $long := substring-after ($geo, ' '):)
