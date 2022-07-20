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

<m:articles>{
    for $article in collection($path-to-data)/tei:TEI
        let $title as xs:string := $article/descendant::tei:titleStmt/tei:title/string()
        let $date as xs:string := $article/descendant::tei:sourceDesc/descendant::tei:bibl/tei:date/@when 
                                    => string()
        let $id as xs:string := $article/@xml:id ! string()
        let $wc as xs:integer := tokenize($article//tei:body) => count()
        let $pc as xs:integer := $article//tei:body//tei:placeName 
                        => count()
    return    
        <m:article>
            <m:title>{$title}</m:title>
            <m:date>{$date}</m:date>
            <m:id>{$id}</m:id>
            <m:wc>{$wc}</m:wc>
            <m:pc>{$pc}</m:pc>
        </m:article>
}

</m:articles>