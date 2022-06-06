(: =====
modules/search.xql

Last update 2022-06-06 djb

Constructs model, which is serialized by views/search-to-html.xql

Behaviors:

1. Facets and term are multi-select, with update only on Search button.
2. Normally returns articles that match combination of search term (Lucene),
   publisher facets, date facets. Left panel maintains checkbox state and
   filters facets to show only those that can be used to broaden or narrow.
3. If search term is not found in *any* documents (not just for selected
   facets), return informative message and clear term and facet selections
   for completely new search.
4. If search term is not found in selected documents (but appears in others),
   return informative message, facets to broaden, plus checked facet settings
   with count values of 0. These must be added explicitly because facets with
   0 values are not returned.
5. If no search term and no results because selected publishers and dates do
   do not intersect, return (different) informative message, facets to broaden,
   plus checked facet settings with count values of 0. This is the same result
   as above, except with different informative message because no search term.

Create facet values for 3–5, above, only as needed. Create default values 
first.

TODO: Perform the triage first and don't create default values if they won't be 
used.
==== :)

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
Retrieve controller parameters

Default path to data is xmldb:exist:///db/apps/pr-app/data/hoax_xml
===== :)
declare variable $exist:root as xs:string := request:get-parameter("exist:root", "xmldb:exist:///db/apps");
declare variable $exist:controller as xs:string := request:get-parameter("exist:controller", "/pr-app");
declare variable $path-to-data as xs:string := $exist:root || $exist:controller || '/data/hoax_xml';
(: =====
Retrieve query parameters
User can specify:
    term : typically single word (as per Lucene defaults)
    publishers
    decades
    month-years
Null term value is return as an empty string, and not as missing, so set
    $term explicitly to an empty sequence if no meaningful value is supplied
    to avoid raising an error
===== :)
declare variable $retrieved-term as xs:string? := (request:get-parameter('term', ()));
declare variable $publishers as xs:string* := request:get-parameter('publishers[]', ());
declare variable $decades as xs:string* := request:get-parameter('decades[]', ());
declare variable $month-years as xs:string* := request:get-parameter('month-years[]', ());
declare variable $term as xs:string? := if ($retrieved-term) then $retrieved-term else ();
(: =====
hoax:construct-date-facets() removes redundant (because of decades) month-years 
===== :)
declare variable $month-year-facets-for-search as xs:string* := 
    hoax:construct-date-facets($decades, $month-years);
(: =====
$date-facets-array formats all date-related facet values (decades and month-years)
    for use in searching (requires an array because of nesting)
No such formatting is required for publishers because they are not hierarchical
===== :)
declare variable $date-facets-array as array(*)? := array:join((
        $decades ! [.],
        $month-year-facets-for-search ! [(substring(., 1, 3) || '0', substring(., 1, 7))]
    ));
(: =====
Fields must be specified in initial ft:query() in order to be retrievable
===== :)
declare variable $fields as xs:string+ := ("formatted-title", "formatted-date");
(: =====
$all-hits is used for articles list, but not for facets to refine search
===== :)
declare variable $all-facets as map(*) := map {
    "publisher" : $publishers,
    "publication-date" : $date-facets-array
};
declare variable $all-options as map(*) := map {
    "facets" : $all-facets,
    "fields" : $fields
};
declare variable $all-hits as element(tei:TEI)* := 
    collection($path-to-data)/tei:TEI
    [ft:query(., $term, $all-options)];
(: =====
Publisher options returns hits filtered by publishers and term
Used only to supply date facets to refine search
===== :)
declare variable $publisher-options as map(*) := map {
    "facets" : map { "publisher" : $publishers},
    "fields" : $fields
};
declare variable $publisher-hits as element(tei:TEI)* :=
    collection($path-to-data)/tei:TEI
    [ft:query(., $term, $publisher-options)];
(: =====
Date option returns hits filter by date and term
Used only to supply publisher facets to refine search
===== :)
declare variable $date-options as map(*) := map {
    "facets" : map { "publication-date": $date-facets-array}
};
declare variable $date-hits as element(tei:TEI)* :=
    collection($path-to-data)/tei:TEI
    [ft:query(., $term, $date-options)]
;
(: =====
Return results, order is meaningful (order is used to create view): 
    1) Search term
    2) Publisher facets to refine search
    3) Date facets to refine search
    4) Articles
    5) Selected facets (checkbox state)
===== :)
<m:data>
    <m:search-term>{$term}</m:search-term>
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
    <m:articles>
        { (: from $all-hits: article data for list of articles with links :)
        for $hit in $all-hits
        let $id as xs:string := 
            $hit/@xml:id ! string()
        let $title as xs:string := 
            ft:field($hit, "formatted-title")
        let $publisher as xs:string+ := 
            $hit/descendant::tei:sourceDesc/descendant::tei:bibl/tei:publisher ! string()
        let $date as xs:string := 
            ft:field($hit, "formatted-date")
        order by $title
        return
        <m:article>
            <m:id>{$id}</m:id>
            <m:title>{$title}</m:title>
            {
                for $p in $publisher
                return
                <m:publisher>{$p}</m:publisher>
            }
            <m:date>{$date}</m:date>
        </m:article>
    }</m:articles>
    <m:selected-facets>
        <!-- Not rendered directly, but used to restore 
        checkbox state and triage returns with no hits -->
        <m:term>{$term}</m:term>
        <m:decades>{$decades}</m:decades>
        <m:date-facets-for-search>{serialize(
                $date-facets-array, 
                map { "method" : "json"}
            )}</m:date-facets-for-search>
        <m:all-facets>{serialize($all-facets, map { "method" : "json" })}</m:all-facets>
        <m:publishers>{
            $publishers ! <m:publisher>{.}</m:publisher>
        }</m:publishers>
        <m:decades>{
            $decades ! <m:decade>{.}</m:decade>
        }</m:decades>
        <m:month-years>{
            $month-years ! <m:month-year>{.}</m:month-year>
        }</m:month-years>
    </m:selected-facets>
</m:data>