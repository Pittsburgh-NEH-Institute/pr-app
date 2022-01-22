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
        <field_test>{
            let $articles-f as element(tei:TEI)+ :=
                collection('/db/apps/pr-app/data/hoax_xml')/tei:TEI[ft:query(., "publisher:(Times)")]
            for $article-f in $articles-f
            return $article-f//tei:publicationStmt/tei:publisher
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
        <field_test>{
            let $hits as element(tei:TEI)+ := collection('/db/apps/pr-app/data/hoax_xml')/tei:TEI[ft:query(., "theme:rapping")]
            for $hit in $hits
            return $hit//tei:titleStmt/tei:title
        }</field_test>
        <old_fashioned>{
            let $hits as document-node()* := 
                collection('/db/apps/pr-app/data/hoax_xml')//descendant::tei:rs/@ref[contains-token(., 'rapping')]/root()
            for $hit in $hits
            return $hit//tei:titleStmt/tei:title
        }</old_fashioned>
    </tests>