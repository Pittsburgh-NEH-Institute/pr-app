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

Default path to data is xmldb:exist:///db/apps/pr-app/data/aux_xml
===== :)
declare variable $exist:root as xs:string := request:get-parameter("exist:root", "xmldb:exist:///db/apps");
declare variable $exist:controller as xs:string := request:get-parameter("exist:controller", "/pr-app");
declare variable $path-to-data as xs:string := $exist:root || $exist:controller || '/data';
declare variable $articles as element(tei:TEI)+ := collection($path-to-data || '/hoax_xml')/tei:TEI;

let $places as element(tei:place)+ := doc($path-to-data || '/aux_xml/places.xml')/descendant::tei:place
return
<m:geo-places>
{
  for $entry in $places
    let $place-name as xs:string := $entry/tei:placeName => string-join('; ')
    let $geo :=$entry/tei:location/tei:geo
    let $lat as xs:string := substring-before($geo, " ")
    let $long as xs:string := substring-after($geo, " ")
    let $articles as element(tei:TEI)* :=  $articles[descendant::tei:placeName
                                    [substring-after(@ref, '#') eq $entry/@xml:id]]
                                    
                                    (:if using the index in a predicate, you should put the path to the data in the same statement:)                          
    where exists($geo)
    return
    <m:place>
    <m:name>{$place-name}</m:name>
        <m:geo>
        <m:lat>{$lat}</m:lat>
        <m:long>{$long}</m:long>
        <m:articles>{for $article in $articles
                      return <m:article>{$article/@xml:id, $article/descendant::tei:titleStmt/tei:title ! string(.)}</m:article>

        }</m:articles>
        </m:geo>
    </m:place>
    }
    </m:geo-places>
