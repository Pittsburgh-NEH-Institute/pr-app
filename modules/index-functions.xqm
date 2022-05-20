xquery version "3.1";
(:~ 
 : This module provides the functions that will be imported into 
 : collections.xconf for use when creating facets and fields.
 :
 : @author gab_keane
 : @version 1.0
 :)


(:module namespace:)
module namespace hoax="http://obdurodon.org/hoax";
(: tei and project namespaces :)
declare namespace tei="http://www.tei-c.org/ns/1.0";
(:model namespace:)
declare namespace m="http://www.obdurodon.org/model";

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
 : @param $decades : xs:string* (e.g., 1800)
 : @param $month-years : xs:string* (e.g., 1800-01)
 :
 : @return sequence of two arrays:
 :      one with decades that do not require month-years
 :      the other with month-years that do not require decades
 : Logic:
 :      If decade is present, all month-years are implicit, and need not be specified
 :      If month-year is present and decade is not, month-year must be specified
 :  Note:
 :      One or both of the inputs could be empty, in which case the other is not filtered
 :)
declare function hoax:construct-date-facets($decades as xs:string*, $month-years as xs:string*) as array(*)+ {
    let $decade-starts as xs:string? := $decades ! substring(., 1, 3) => string-join('|')
    let $month-year-starts as xs:string? := $month-years ! substring(., 1, 3) => string-join('|')
    let $filtered-decades as xs:string* := 
        if (count($month-years)) then $decades[not(matches(., $month-year-starts))] else $decades
    let $filtered-month-years as xs:string* := 
        if (count($decades)) then $month-years[not(matches(., $decade-starts))] else $month-years
    return (array { $filtered-decades } , array { $filtered-month-years })
};

