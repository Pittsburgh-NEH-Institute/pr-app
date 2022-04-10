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
 : @param xs:string any lat or long value
 : @return xs:double
 :)
declare function hoax:round-geo($input as xs:string) as xs:double {
    $input ! number(.) ! format-number(. , '#.00') ! number(.)

};