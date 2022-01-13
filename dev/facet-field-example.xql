xquery version "3.1";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare variable $articles as element(tei:TEI)+ := collection('/db/apps/pr-app/data/hoax_xml')/tei:TEI;
declare variable $places as document-node() := doc('/db/apps/pr-app/data/aux_xml/places.xml');
declare variable $hammersmith as document-node() := doc('/db/apps/pr-app/data/hoax_xml/hammersmithghost_times_1804.xml');
let $hits as element(tei:TEI)+ := $articles[ft:query(., 'ghost',map {
                "fields": "publisher"
            })]
let $facets := ft:facets($hits, "publisher")
return 
    <tests>
        <field_test>{
            for $hit in $hits
            let $publisher := ft:field($hit, "publisher")
            order by $publisher
            return $publisher ! <publisher>{.}</publisher>
        }</field_test>
        <facet_test>{
            let $facet-elements := 
                map:for-each($facets, function($label, $count) {
                    <facet>
                        <label>{$label}</label>
                        <count>{$count}</count>
                </facet>})
            for $facet-element in $facet-elements
            order by $facet-element/count ! number(.) descending,
                $facet-element/label
            return $facet-element
        }</facet_test>
    </tests>