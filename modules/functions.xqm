xquery version "3.1";
(: tei and project namespaces :)
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace hoax="http://obdurodon.org/hoax";


(: title formatting :)
declare function hoax:title($story){
    let $storytitle := $story//tei:titleStmt/tei:title/text()
    let $pub := $story//tei:respStmt[1]/tei:name/text()
    let $date := $story//tei:publicationStmt/tei:date/@when/string(.)
  return
      <div>
      <h2>{$storytitle}</h2>
      <h3>{$pub}</h3>
      <h3>{$date}</h3>
      </div>
    
};
(: create list page for article titles :)
declare function hoax:titlelistdate($docs){
    
    for $doc in $docs
    let $date := $doc//tei:date/@when
    let $printdate := substring-before($date, '-')
    let $title := $doc//tei:titleStmt//tei:title
    let $pubname := $doc//tei:publisher[1] (:this is inelegant cheating on my part, returning to it later:)
    let $filename := concat(substring-before(tokenize(fn:base-uri($doc), '/')[last()], '.'), ".xml")
    let $listitem := concat($printdate, ", ", $title, ", ", $pubname)
    order by $date
    return
          <li><a href="{$filename}">{$listitem}</a></li>
};
declare function hoax:titlelistalpha($docs){
    
    for $doc in $docs
    let $date := $doc//tei:date/@when
    let $printdate := substring-before($date, '-')
    let $title := $doc//tei:titleStmt//tei:title
    let $pubname := $doc//tei:publisher[1] (:this is inelegant cheating on my part, returning to it later:)
    let $filename := concat(substring-before(tokenize(fn:base-uri($doc), '/')[last()], '.'), ".xml")
    let $listitem := concat($title, ", ", $printdate, ", ", $pubname)
    order by $title
    return
          <li><a href="{$filename}">{$listitem}</a></li>
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
    order by $date
return
      <li><a href="{$filename}">{$title}</a></li>
};

(:these functions do HTML wrapping:)
declare function hoax:wrapsection($content){
    <section class="container">
        return $content
    </section>
};

let $end := "end of file"
return $end