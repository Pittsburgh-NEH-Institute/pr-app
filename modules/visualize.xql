(: =====
Import functions
===== :)
import module namespace hoax ="http://www.obdurodon.org/hoax" at "../modules/functions.xqm";

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

Default path to data is xmldb:exist:///db/apps/pr-app/data/hoax_xml
===== :)
declare variable $exist:root as xs:string := request:get-parameter("exist:root", "xmldb:exist:///db/apps");
declare variable $exist:controller as xs:string := request:get-parameter("exist:controller", "/pr-app");
declare variable $path-to-data as xs:string := $exist:root || $exist:controller || '/data/hoax_xml';

<m:data> 

<m:by-article> {
    let $articles as element(tei:TEI)+ :=
        collection($path-to-data)/tei:TEI[ft:query(., (), map{'fields':('word-count', 'place-count', 'rel-count', 'pol-count', 'ghost-count')})]
        (:ft:query arguments: . is context (which we found with the preceding xpath), empty sequence is the text
        string you're looking for (empty means get all), third argument is options. Options have to be maps. In this case
        we're just looking for one field, word-count. Field information for your hits won't be available unless you
        specify the fields you want (there are other fields defined that we aren't looking for). The map 'keys' in the 
        key value pair can use either 'fields' or 'facets'. The 'value' in the key-value pair is a sequence of field names we care about.
        In our case, it's just one field, so we don't use parens :)

    for $article in $articles
    let $title as xs:string := $article/descendant::tei:titleStmt/tei:title/string()
    let $date := $article/descendant::tei:sourceDesc/descendant::tei:bibl/tei:date/@when => string() 
    return 
    <m:article>
        <m:title>{$title}</m:title>
        <m:id>{$article/@xml:id ! string(.)}</m:id>
        <m:date>{$date}</m:date>
        <m:word-count>{ft:field($article, 'word-count')}</m:word-count>
        <m:place-count>{ft:field($article, 'place-count')}</m:place-count>
        <m:rel-count>{ft:field($article, 'rel-count')}</m:rel-count>
        <m:pol-count>{ft:field($article, 'pol-count')}</m:pol-count>
        <m:ghost-count>{ft:field($article, 'ghost-count')}</m:ghost-count>
    </m:article>
    (:ft:field() takes two arguments: the haystack and the needle. Haystack is a node we filtered using ft:query
    and the needle is the name of the field we specified using ft:query. It returns the field value for the haystack.:)
}
</m:by-article>
</m:data>
