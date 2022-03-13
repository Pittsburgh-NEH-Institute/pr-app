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

let $places :=$gazeteer//tei:place
for $entry in $places
let $placename := $entry/tei:placeName
let $geo :=$entry/tei:location/tei:geo
let $parent := $entry/parent::tei:place/tei:placeName[1]

return string-join($placename, ', ') || ' (' || replace($geo, ' ', ', ') || ')'
|| (if ($parent) then (' is located in ' || $parent) else ())

<placeEntry>
<placeName>Obdurodonia, Homeland of Digital Humanists<placeName>
<geo>
<lat>-169.866667</lat>
<long>-19.05</long>
</geo>
<parentPlace>Australia</parentPlace>

</placeEntry>

(:flattening TEI XML is a good idea:)



(:let $placename := $places/tei:placeName/text()
let $parentplace := $places/parent::tei:place/tei:placeName/text():)

(:Find places where it is not the case that there is a parent element is tei:place :)
(:let $parentlessplace :=$places[not(parent::tei:place)]/@xml:id:)


(:for $entry in $places
let $listitem := concat($placename, 'is in', $parentplace)

let $geo := $place//tei:geo
let $lat := substring-before($geo, ' ')
let $long := substring-after ($geo, ' '):)
