import module namespace hoax ="http://obdurodon.org/hoax" at "../modules/functions.xqm";

declare namespace tei="http://www.tei-c.org/ns/1.0";

declare namespace m="http://www.obdurodon.org/model";

declare namespace html="http://www.w3.org/1999/xhtml";

declare variable $collection as element(tei:TEI)+ :=
    collection('/db/apps/pr-app/data/hoax_xml')/tei:TEI;
<m:data> 

<m:by-article> {
    let $articles as element(tei:TEI)+ :=
        collection('/db/apps/pr-app/data/hoax_xml')/tei:TEI[ft:query(., (), map{'fields':('wordcount')})]
    for $article in $articles
    return 
    <m:article>
        <m:id>{$article/@xml:id}</m:id>
        <m:count>{ft:field($article, 'wordcount')}</m:count>
    </m:article>
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
    <m:article_count>{$article-count}</m:article_count>
    <m:ref_count>{$ref-count}</m:ref_count>
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