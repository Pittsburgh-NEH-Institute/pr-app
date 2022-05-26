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
declare variable $query-term as xs:string? := if ($search-term) then $search-term else ();

(: TODO: Remove unneeded uses of formatted-title field :)
(: =====
Find all values, retrieve formatted-title field
hoax:construct-date-facets() removes redundant (because of decades) month-years 
===== :)
declare variable $date-facets-for-search as xs:string* := 
    hoax:construct-date-facets($selected-decades, $selected-month-years);
declare variable $fields as xs:string := "formatted-title";
declare variable $all-facets as map(*) := map {
    "publisher" : $selected-publishers,
    "publication-date" : $date-facets-for-search
};
(: =====
All options returns hits that match all facets
Use articles list but ignore facets 
===== :)
declare variable $all-options as map(*) := map {
    "facets" : $all-facets,
    "fields" : $fields
};
declare variable $all-hits as element(tei:TEI)* := 
    collection('/db/apps/pr-app/data/hoax_xml')/tei:TEI
    [ft:query(., (), $all-options)];
(: =====
Publisher options returns hits filtered by publishers
Use only date facets 
===== :)
declare variable $publisher-options as map(*) := map {
    "facets" : map { "publisher" : $selected-publishers},
    "fields" : $fields
};
declare variable $publisher-hits as element(tei:TEI)* :=
    collection('/db/apps/pr-app/data/hoax_xml')/tei:TEI
    [ft:query(., $query-term, $publisher-options)];
(: =====
Date option returns hits filter by date
Use only publisher facets 
===== :)
declare variable $date-options as map(*) := map {
    "facets" : map { "publication-date": $date-facets-for-search},
    "fields" : $fields
};
declare variable $date-hits as element(tei:TEI)* :=
    collection('/db/apps/pr-app/data/hoax_xml')/tei:TEI
    [ft:query(., $query-term, $date-options)]
;
(: =====
Return results
===== :)
<m:data>
    <!-- Contains 
        <m:articles> : article titles with links
        <m:publisher-facets> : render only these publisher facets (filtered by date)
        <m:date-facets> : render only these date facets (filtered by publisher)
        <m:selected-facets> : for highlighting 
    -->
    <m:articles>
        { (: from $all-hits: article data for list of articles with links :)
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
    <m:publisher-facets>
        <m:publishers>{
            let $publisher-facets as map(*) := ft:facets($date-hits, "publisher", ())
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
    </m:publisher-facets>
    <m:date-facets>
        <m:dates>{
            <m:decades>{
                let $publication-date-facets as map(*) := ft:facets($publisher-hits, "publication-date", ())
                let $publication-date-elements := 
                    map:for-each($publication-date-facets, function($decade, $count) {
                        <m:decade>
                            <m:label>{$decade}</m:label>
                            <m:count>{$count}</m:count>
                            <m:month-years>{
                                let $month-year-facets as map(*) := ft:facets($publisher-hits, "publication-date", (), $decade)
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
        }</m:dates>
    </m:date-facets>
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