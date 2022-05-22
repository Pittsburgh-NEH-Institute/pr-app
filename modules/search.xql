(: =====
Import functions
===== :)
import module namespace hoax ="http://obdurodon.org/hoax" at "../modules/index-functions.xqm";

(: =====
Declare namespaces
===== :)
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace m="http://www.obdurodon.org/model";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "no";

(: =====
Retrieve parameters
===== :)
declare variable $search-term as xs:string? := request:get-parameter('search-term', ());
declare variable $selected-publishers as xs:string* := request:get-parameter('publishers[]', ());
declare variable $selected-decades as xs:string* := request:get-parameter('decades[]', ());
declare variable $selected-month-years as xs:string* := request:get-parameter('month-years[]', ());
declare variable $exist:controller := request:get-parameter('exist:controller', 'hi');

(: =====
Find all values, retrieve formatted-title field
===== :)
declare variable $query-term as xs:string? := if ($search-term) then $search-term else ();
declare variable $date-facets-for-search as xs:string* := hoax:construct-date-facets($selected-decades, $selected-month-years);
declare variable $decade-facets-for-search as xs:string* := $date-facets-for-search[1] ! string(.);
declare variable $month-year-facets-for-search as xs:string* := $date-facets-for-search[2] ! string(.);
declare variable $fields as xs:string := "formatted-title";
declare variable $facets as map(*) := map {
    "publisher" : $selected-publishers
};
declare variable $options as map(*) := map {
    "facets" : $facets,
    "fields" : $fields
};
declare variable $all-hits as element(tei:TEI)* := 
    collection('/db/apps/pr-app/data/hoax_xml')/tei:TEI
    [ft:query(., (), map { "fields" : $fields})];
declare variable $filtered-hits as element(tei:TEI)* :=
    collection('/db/apps/pr-app/data/hoax_xml')/tei:TEI
    [ft:query(., $query-term, $options)];
(: =====
Retrieve information for faceted searching

All publisher facets (<m:publishers>)
All decade and year facets (<:decades>, which contain <m:month-years>)
Selected facet state (<m:selected-facets> and descendants)
All matching titles (TBA) 
===== :)

<m:data>
    <!-- Contains <m:all-content>, <m:filtered-content>, <m:selected-facets> -->
    <m:all-content>
        <m:search-term>{$search-term}</m:search-term>
        <m:publishers>{
            let $publisher-facets as map(*) := ft:facets($all-hits, "publisher", ())
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
            let $publication-date-facets as map(*) := ft:facets($all-hits, "publication-date", ())
            let $publication-date-elements := 
                map:for-each($publication-date-facets, function($decade, $count) {
                    <m:decade>
                        <m:label>{$decade}</m:label>
                        <m:count>{$count}</m:count>
                        <m:month-years>{
                            let $month-year-facets as map(*) := ft:facets($all-hits, "publication-date", (), $decade)
                            let $month-year-elements :=
                                map:for-each($month-year-facets, function($m-label, $m-count) {
                                    <m:month-year>
                                        <m:label>{$m-label}</m:label>
                                        <m:count>{$m-count}</m:count>
                                    </m:month-year>
                                })
                            for $month-year-element in $month-year-elements
                            order by $month-year-element
                            return $month-year-element
                        }</m:month-years>                    
                </m:decade>})
            for $publication-date-element in $publication-date-elements
            order by $publication-date-element/m:label
            return $publication-date-element
        }</m:decades>
        <m:articles>
            { (: article data for list of links :)
            for $hit in $all-hits
            let $id := $hit/@xml:id ! string()
            let $title := ft:field($hit, "formatted-title")
            let $publisher := $hit//tei:publicationStmt/tei:publisher ! string()
            let $date := $hit//tei:publicationStmt/tei:date/@when ! string()
            order by $title
            return
            <m:article>
                <m:id>{$id}</m:id>
                <m:title>{$title}</m:title>
                <m:publisher>{$publisher}</m:publisher>
                <m:date>{$date}</m:date>
            </m:article>
            }</m:articles>
    </m:all-content>
    <m:filtered-content>
        <m:publishers>{
            let $publisher-facets as map(*) := ft:facets($filtered-hits, "publisher", ())
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
            let $publication-date-facets as map(*) := ft:facets($filtered-hits, "publication-date", ())
            let $publication-date-elements := 
                map:for-each($publication-date-facets, function($decade, $count) {
                    <m:decade>
                        <m:label>{$decade}</m:label>
                        <m:count>{$count}</m:count>
                        <m:month-years>{
                            let $month-year-facets as map(*) := ft:facets($filtered-hits, "publication-date", (), $decade)
                            let $month-year-elements :=
                                map:for-each($month-year-facets, function($m-label, $m-count) {
                                    <m:month-year>
                                        <m:label>{$m-label}</m:label>
                                        <m:count>{$m-count}</m:count>
                                    </m:month-year>
                                })
                            for $month-year-element in $month-year-elements
                            order by $month-year-element
                            return $month-year-element
                        }</m:month-years>                    
                </m:decade>})
            for $publication-date-element in $publication-date-elements
            order by $publication-date-element/m:label
            return $publication-date-element
        }</m:decades>
        <m:articles>{ (: article data for list of links :)
            for $hit in $filtered-hits
            let $id := $hit/@xml:id ! string()
            let $title := ft:field($hit, "formatted-title")
            let $publisher := $hit//tei:publicationStmt/tei:publisher ! string()
            let $date := $hit//tei:publicationStmt/tei:date/@when ! string()
            order by $title
            return
            <m:article>
                <m:id>{$id}</m:id>
                <m:title>{$title}</m:title>
                <m:publisher>{$publisher}</m:publisher>
                <m:date>{$date}</m:date>
            </m:article>
        }</m:articles>
    </m:filtered-content>
    <m:selected-facets>
        <!-- Not rendered directly, but used to restore checkbox state -->
        <m:selected-publishers>{
            $selected-publishers ! <m:selected-publisher>{.}</m:selected-publisher>
        }</m:selected-publishers>
        <m:selected-decades>{
            $selected-decades ! <m:selected-decade>{.}</m:selected-decade>
        }</m:selected-decades>
        <m:selected-month-years>{
            $selected-month-years ! <m:selected-month-year>{.}</m:selected-month-year>
        }</m:selected-month-years>
    </m:selected-facets>
</m:data>