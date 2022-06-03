import module namespace hoax ="http://obdurodon.org/hoax" at "../modules/index-functions.xqm";

declare namespace tei="http://www.tei-c.org/ns/1.0";

declare namespace m="http://www.obdurodon.org/model";

declare namespace html="http://www.w3.org/1999/xhtml";

declare variable $places as element(tei:TEI) := doc('/db/apps/pr-app/data/aux_xml/places.xml')/tei:TEI;

declare variable $collection as element(tei:TEI)+ :=
    collection('/db/apps/pr-app/data/hoax_xml')/tei:TEI;
<m:data> 

<m:by-article> {
    let $articles as element(tei:TEI)+ :=
        collection('/db/apps/pr-app/data/hoax_xml')/tei:TEI[ft:query(., (), map{'fields':'word-count'})]
        (:ft:query arguments: . is context (which we found with the preceding xpath), empty sequence is the text
        string you're looking for (empty means get all), third argument is options. Options have to be maps. In this case
        we're just looking for one field, word-count. Field information for your hits won't be available unless you
        specify the fields you want (there are other fields defined that we aren't looking for). The map 'keys' in the 
        key value pair can use either 'fields' or 'facets'. The 'value' in the key-value pair is a sequence of field names we care about.
        In our case, it's just one field, so we don't use parens :)

    for $article in $articles
    let $title as xs:string := $article/descendant::tei:titleStmt/tei:title/string()
    let $format-title := hoax:format-title($title)
    let $place-refs as element(tei:placeName)* := $article/descendant::tei:body/descendant::tei:placeName
    let $place-id := $place-refs[. = $places//tei:place/@xml:id]
    
    return 
    <m:article>
        <m:title>{$format-title}</m:title>
        <m:id>{$article/@xml:id}</m:id>
        <m:word-count>{ft:field($article, 'word-count')}</m:word-count>
        <m:place-count>{$place-refs}</m:place-count>
        <m:place-id>{$place-id}</m:place-id>

    </m:article>
    (:ft:field() takes two arguments: the haystack and the needle. Haystack is a node we filtered using ft:query
    and the needle is the name of the field we specified using ft:query. It returns the field value for the haystack.:)
}

</m:by-article>
<m:by-decade>
{
for $article in $collection
group by $decade := 
    $article/descendant::tei:publicationStmt/tei:date/@when ! substring(., 1, 3) || '0'
let $article-count as xs:integer := count($article)
let $ref-count as xs:integer := $article/descendant::tei:rs => count()
let $avg as xs:string := 
    ($ref-count div $article-count * 10) !
    (round(.) div 10) =>
    format-number('0.0')

order by $decade
return 
 <m:decade year="{$decade}">
    <m:article-count>{$article-count}</m:article-count>
    <m:ref-count>{$ref-count}</m:ref-count>
    <m:avg>{$avg}</m:avg>
 </m:decade>

}

</m:by-decade>
</m:data>







(: If you return XML, it must be well-formed, so two or more independent elements 
on their own either need a parent element
or should be a sequence separated with commas.:)


(:
pull out data for each article
- id no
- title
- dates
- decade
- publication
- length of article
- references count (political, religious, etc)
- place references + count
- people references + count

viz ideas
- average number of references (political, religious, etc) per article in a given decade
- are people or place references likely to co-occur with political references?

:)