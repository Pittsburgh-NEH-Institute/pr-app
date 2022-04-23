import module namespace hoax ="http://obdurodon.org/hoax" at "../modules/functions.xqm";

declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace m="http://www.obdurodon.org/model";

<m:facets>{
    let $query as element() := <query><wildcard>*</wildcard></query>
    let $hits as element(tei:TEI)+ := 
        collection('/db/apps/pr-app/data/hoax_xml')/tei:TEI[ft:query(., $query)]
    let $decade-facets as map(*) := ft:facets($hits, "decade", 100)
    let $facet-elements := 
        map:for-each($decade-facets, function($label, $count) {
            <m:facet>
                <m:label>{$label}</m:label>
                <m:count>{$count}</m:count>
        </m:facet>})
    for $facet-element in $facet-elements
    order by $facet-element/m:label
    return $facet-element
}</m:facets>
