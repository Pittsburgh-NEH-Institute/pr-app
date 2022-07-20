(: =====
Declare namespaces
===== :)
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace m="http://www.obdurodon.org/model";
import module namespace hoax ="http://obdurodon.org/hoax" at "functions.xqm";


declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "no";

(: =====
Retrieve controller parameters
Default path to data is xmldb:exist:///db/apps/pr-app/data/hoax_xml
===== :)
declare variable $exist:root as xs:string := request:get-parameter("exist:root", "xmldb:exist:///db/apps");
declare variable $exist:controller as xs:string := request:get-parameter("exist:controller", "/06-controller");
declare variable $path-to-data as xs:string := $exist:root || $exist:controller || '/data/hoax_xml//';

(: =====
Retrieve query parameters
===== :)
declare variable $id as xs:string? := request:get-parameter('id', ());

(: ====
Retrieve auxiliary data
==== :)
declare variable $gazetteer := doc($exist:root || $exist:controller || '/data/aux_xml/places.xml');
declare variable $pros := doc($exist:root || $exist:controller || '/data/aux_xml/persons.xml');

(: ====
Retrieve article using $id
=== :)
declare variable $article as element(tei:TEI)? := 
    collection($path-to-data)//id($id);

if ($article) then
    let $pub-string as xs:string := $article//tei:sourceDesc//tei:publisher 
        ! string-join((@rend, .), ' ') 
        => normalize-space()
    let $pub-date as xs:string := $article//tei:sourceDesc//tei:bibl/tei:date/@when
                ! xs:date(.)
                ! format-date(., '[MNn] [D], [Y]')
    return
    <m:result>
    {$article}
        <m:aux>
            <m:publisher>{$pub-string}</m:publisher>
            <m:date>{$pub-date}</m:date>
            <m:places>
                {for $place in $gazetteer//tei:place[@xml:id = 
                    $article//tei:placeName
                        [starts-with(@ref, '#')]/@ref 
                        ! substring(., 2)]
                    return
                        <m:place>
                            <m:name>{$place/tei:placeName ! string(.)}</m:name>
                            <m:type>{$place/@type ! string(.)}</m:type>
                            <m:geo>{$place/tei:location/tei:geo ! string(.)}</m:geo>
                        </m:place>}
            </m:places>
        </m:aux>
    </m:result>
else
    <m:no-result>
    None
    </m:no-result>





(:if ($article) then
<m:result> 
        {$article}
        <m:aux>
            <m:publisher>{ft:field($article, 'formatted-publisher')}</m:publisher>
            <m:date>{ft:field($article, 'formatted-date')}</m:date>
            <m:places>{
                (: TODO: Create field to avoid having to navigate the leading hash :)
                for $place in $gazetteer//tei:place
                    [@xml:id = $article//tei:placeName[starts-with(@ref, '#')]/@ref ! substring(., 2)]
                return hoax:get-place-info($place)
            }</m:places>
            
        </m:aux>
    </m:result>
else 
    <m:no-result>None</m:no-result>:)