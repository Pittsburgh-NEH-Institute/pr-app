xquery version "3.1";
(:~ 
 : This module provides the functions that will be imported into 
 : collections.xconf for use when creating facets and fields.
 :
 : @author gab_keane
 : @version 1.0
 :)
(:==========
Import module (hoax), tei (tei), and model (m) namespaces
==========:)
module namespace hoax="http://obdurodon.org/hoax";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace m="http://www.obdurodon.org/model";

(:==========
Functions for creating map view
==========:)
(:~ 
 : hoax:get-lat() retrieves the latitude value from a given place entry in
 : places.xml. 
 : @param $geo a TEI geo element
 : @return xs:string
 :)
declare function hoax:get-lat($geo as element(tei:geo)) as xs:string {
    substring-before($geo, " ")
};
(:~ 
 : hoax:get-long() retrieves the longitude value from a given place entry in
 : places.xml.
 : @param $geo a TEI geo element
 : @return xs:string
 :)
declare function hoax:get-long($geo as element(tei:geo)) as xs:string {
    substring-after($geo, " ")
};
(:~ 
 : hoax:round-geo() retrieves the latitude value from a given place entry in
 : places.xml. 
 :
 : @param $input : xs:string any lat or long value
 : @return xs:double
 :)
declare function hoax:round-geo($input as xs:string) as xs:double {
    $input ! number(.) ! format-number(. , '#.00') ! number(.)

};
(: Compile map titles and create links. So far, I've been doing this by creating individual xql files for each map. this isn't scalable
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


(:==========
Functions for manipulating data for indexing and rendering
==========:)
(: Move definite and indefinite article to end of title for rendering :)
declare function hoax:format-title($title as xs:string) as xs:string {
    if (matches($title, '^(The|An|A) '))
        then replace($title, '^(The|An|A)( )(.+)', '$3, $1')
            ! concat(upper-case(substring(., 1, 1)), substring(., 2))
        else $title
};

(:~ 
 : hoax:construct-date-facets() maps input date-related facets onto query 
 : format
 :
 : @param $decades : xs:string* (e.g., '1800')
 : @param $month-years : xs:string* (e.g., '1800-01')
 :
 : @return filtered month-years
 :
 : Logic:
 :  If decade is present, all month-years are also checked, and should 
 :      be removed before querying because they are implicit
  :  Note:
 :      One or both of the inputs could be empty
 :)
declare function hoax:construct-date-facets($decades as xs:string*, $month-years as xs:string*) as xs:string* {
    let $decade-starts as xs:string := 
        '^(' || $decades ! substring(., 1, 3) => string-join('|') || ')'
    return 
        if (empty($decades)) then $month-years
        else if (empty($month-years)) then () else  
        $month-years[not(matches(., $decade-starts))]
};

declare function hoax:word-count($body as element(tei:body)) as xs:integer {
   count(tokenize($body))
};
