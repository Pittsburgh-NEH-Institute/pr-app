(: =====
Import functions
===== :)
import module namespace hoax ="http://obdurodon.org/hoax" at "../modules/functions.xqm";

(: =====
Declare namespaces
===== :)
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace m="http://www.obdurodon.org/model";

(: =====
Retrieve parameters
===== :)
declare variable $query-string as xs:string? := 
    request:get-parameter('text', ());
declare variable $exist:controller := request:get-parameter('exist:controller', 'hi');

(: =====
Find all values
===== :)
declare variable $hits as element(tei:TEI)+ := 
    collection('/db/apps/pr-app/data/hoax_xml')/tei:TEI
        [ft:query(., $query-string)];
(: =====
Retrieve information for faceted searching

All publisher facets (<m:publishers>)
All decade and year facets (<:decades>, which contain <m:years>)
All matching titles (TBA)
===== :)

<m:data>
    <m:publishers>{
        let $publisher-facets as map(*) := ft:facets($hits, "publisher", ())
        let $publisher-elements := 
            map:for-each($publisher-facets, function($label, $count) {
                <m:publisher>
                    <m:label>{$label}</m:label>
                    <m:count>{$count}</m:count>
            </m:publisher>})
        for $publisher-element in $publisher-elements
        order by $publisher-element/m:label
        return $publisher-element
    }</m:publishers>
    <m:decades>{
        let $publication-date-facets as map(*) := ft:facets($hits, "publication-date", ())
        let $publication-date-elements := 
            map:for-each($publication-date-facets, function($decade, $count) {
                <m:decade>
                    <m:label>{$decade}</m:label>
                    <m:count>{$count}</m:count>
                    <m:years>{
                        let $year-facets as map(*) := ft:facets($hits, "publication-date", (), $decade)
                        let $year-elements :=
                            map:for-each($year-facets, function($m-label, $m-count) {
                                <m:year>
                                    <m:label>{$m-label}</m:label>
                                    <m:count>{$m-count}</m:count>
                                </m:year>
                            })
                        for $year-element in $year-elements
                        order by $year-element
                        return $year-element
                    }</m:years>                    
            </m:decade>})
        for $publication-date-element in $publication-date-elements
        order by $publication-date-element/m:label
        return $publication-date-element
    }</m:decades>
</m:data>