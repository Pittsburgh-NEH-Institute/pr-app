xquery version "3.1";
(:module namespace:)
module namespace hoax="http://obdurodon.org/hoax";
import module namespace test="http://exist-db.org/xquery/xqsuite" at "resource:org/exist/xquery/lib/xqsuite/xqsuite.xql";


(: tei and project namespaces :)
declare namespace tei="http://www.tei-c.org/ns/1.0";


(: title header 

%test:arg("story", "<story xmlns='http://www.tei-c.org/ns/1.0'>
<titleStmt>
<title>silly title</title>
<respStmt><name>Gabi</name></respStmt>
<publicationStmt><date>2022-02-21</date></publicationStmt>
</titleStmt></story>") %test:assertEquals('silly title', 'Gabi', '2022-02-21'):)
declare 
%test:args('/db/apps/pr-app/data/hoax_xml/anotherstockwellghostcase_leader_1857_edited.xml')
%test:assertEquals('xyz','abc','efg')

function hoax:title($story as document-node()) as element()+ {
    let $storytitle := $story//tei:titleStmt/tei:title
    let $pub := $story//tei:respStmt[1]/tei:name
    let $date as element(tei:date) := $story//tei:publicationStmt/tei:date
  return
      ($storytitle, $pub, $date)
    
};

(: create list page for article titles :)
declare function hoax:titlelistdate($docs as document-node()+){
    
    for $doc in $docs
    let $date as attribute(when) := $doc//tei:date/@when
    let $year as xs:string := substring-before($date, '-')
    let $title as element(tei:title) := $doc//tei:titleStmt//tei:title
    let $pubnames as xs:string := $doc//tei:publisher => string-join(", ")
    let $filename as xs:string := concat(substring-before(tokenize(base-uri($doc), '/')[last()], '.'), ".xml")
    let $listitem as xs:string := string-join(($year,$title,$pubnames), "; ")
    order by $date
    return
          <tei:item><tei:anchor href="{$filename}">{$listitem}</tei:anchor></tei:item>
};
declare function hoax:titlelistalpha($docs){
    
    for $doc in $docs
    let $date as attribute(when) := $doc//tei:date/@when
    let $year as xs:string := substring-before($date, '-')
    let $title as element(tei:title) := $doc//tei:titleStmt//tei:title
    let $pubnames as xs:string := $doc//tei:publisher => string-join(", ")
    let $filename as xs:string := concat(substring-before(tokenize(base-uri($doc), '/')[last()], '.'), ".xml")
    let $listitem as xs:string := string-join(($title,$pubnames,$year), "; ")
    order by $title
    return
          <tei:item><tei:anchor href="{$filename}">{$listitem}</tei:anchor></tei:item>
};

(: compile map titles and create links. So far, I've been doing this by creating individual xql files for each map. this isn't scalable
 : filter articles with place references, make the filename into a link so that when clicked it just appends to current URL
 : this solution allowed me to play around with adding drawings and annotations to each map. I'm not against changing this functionality to a more robust solution, but could foresee this solution working well for a project this small :)
 
declare function hoax:maplist($docs){
    for $doc in $docs
    let $filter := $doc[contains(.//tei:placeName/@ref,"#")]
    for $placedoc in $filter
    let $date := $placedoc//tei:date/@when
    let $printdate := substring-before($date, '-')
    let $title := concat($placedoc//tei:titleStmt//tei:title, ', ', $printdate)
    let $filename := concat(substring-before(tokenize(fn:base-uri($placedoc), '/')[last()], '.'), "-map.xql")
    let $linkpath := concat("read?", $filename)
    order by $date
return
      <item><anchor xml:id="{$linkpath}">{$title}</anchor></item>
};

(:these functions do HTML wrapping:)
declare function hoax:wrapsection($content){
    <section class="container">
        {$content}
    </section>
};
