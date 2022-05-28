xquery version "3.1";

import module namespace hoax ="http://obdurodon.org/hoax" at "../modules/functions.xqm";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace m="http://www.obdurodon.org/model";

(:this should be a tei list or set of tei lists and should live in modules/:)
(:revisiting april 22 to approach with significantly better MVC implementation:)
(:return both, hide one, toggle with CSS/JS? maybe for institute purposes we should use params:)

declare variable $docs :=collection('/db/apps/pr-app/data/hoax_xml');

<m:items> {
for $doc in $docs
    let $date as attribute(when) := $doc//tei:date/@when
    let $year as xs:string := substring-before($date, '-')
    let $title as xs:string := $doc//tei:titleStmt//tei:title/string()
    let $pub-names as xs:string := $doc//tei:publisher => string-join(", ")
    let $filename as xs:string := concat(substring-before(tokenize(base-uri($doc), '/')[last()], '.'), ".xml")
    let $list-item as xs:string := string-join(($year,$title,$pub-names), "; ")
    order by $date
    return
          <m:item>
            <m:tei-link>tei?{$filename}</m:tei-link>
            <m:read-link>read?{$filename}</m:read-link>
            <m:title>{$title}</m:title>
            <m:pub-names>{$pub-names}</m:pub-names>
            <m:date>{$date}</m:date>
            <m:year>{$year}</m:year> 
          </m:item>}

</m:items>        

(:
<m:div>
    <m:list>
    {hoax:titlelistdate($docs)}
    </m:list>
    <m:list>
    {hoax:titlelistalpha($docs)}
    </m:list>
</m:div>
:)