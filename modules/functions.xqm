xquery version "3.1";
(:~ 
 : This module provides all functions mported into modules
 : in the app, both those called directly to create models
 : and views and those used by collections.xconf to create
 : facets and fields.
 :
 : @author gab_keane
 : @version 1.0
 :)
(:==========
Import module (hoax), tei (tei), and model (m) namespaces
==========:)
module namespace hoax="http://www.obdurodon.org/hoax";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace m="http://www.obdurodon.org/hoax/model";

(:==========
Functions for places
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
 ;
 ; Arity-1 version supplies default precision of 2 and calls arity-2 version
 ; Arity-2 version requires user-supplied precision as second argument
 :
 : @param $input : xs:string any lat or long value
 : @return xs:double
 :)
declare function hoax:round-geo($input as xs:string) as xs:string {
    hoax:round-geo($input, 2)
};

declare function hoax:round-geo($input as xs:string, $precision as xs:integer) as xs:string {
    format-number(
        number($input), 
        '0.' || string-join((1 to $precision) ! '0')
    )
};

declare function hoax:get-place-info($place as element(tei:place)) as element(m:place) {
    let $place-id := $place/@xml:id
    let $name as xs:string := string-join($place/tei:placeName, ', ')
    let $type as xs:string? := $place/@type ! string()
    let $link as xs:string? := $place/tei:bibl ! string()
    let $geo as xs:string := $place/tei:location/tei:geo ! string()
    let $settlement as xs:string? := $place/tei:location/tei:settlement ! string ()
    let $parent-place as xs:string? := $place/parent::tei:place/tei:placeName ! string () 
    return (: NB: Some values may be empty and should be created anyway :)
        <m:place>
            {$place-id}
            <m:name>{$name}</m:name>
            <m:type>{$type}</m:type>
            <m:geo>{$geo}</m:geo>
            <m:settlement>{$settlement}</m:settlement>
            <m:parent>{$parent-place}</m:parent>
            {if (empty($link)) 
                then ()
                else <m:link>{$link}</m:link>}
        </m:place>
};
(: Compile map titles and create links. So far, I've been doing this by creating individual xql 
 : files for each map. this isn't scalable. 
 : Filter articles with place references, make the filename into a link so that when clicked it 
 : just appends to current URL.
 : this solution allowed me to play around with adding drawings and annotations to each map. I'm 
 : not against changing this functionality to a more robust solution, but could foresee this 
 : solution working well for a project this small :)
(: Not currently used 
declare function hoax:maplist($docs){
    for $doc in $docs
    let $filter := $doc[contains(descendant::tei:placeName/@ref,"#")]
    for $placedoc in $filter
    let $date := $placedoc//tei:date/@when
    let $printdate := substring-before($date, '-')
    let $title := concat($placedoc//tei:titleStmt//tei:title, ', ', $printdate)
    let $filename := concat(substring-before(tokenize(fn:base-uri($placedoc), '/')[last()], '.'), "-map.xql")
    let $linkpath := concat("read?", $filename)
    order by $date
    return <item><anchor xml:id="{$linkpath}">{$title}</anchor></item>
};
:)
(:==========
Functions for persons
==========:)
declare function hoax:get-person-info($person) as element(m:person) {
    let $surname as xs:string := $person/tei:persName/tei:surname ! string()
    let $forename as xs:string? := $person/tei:persName/tei:forename[1] ! string()
    let $abt as xs:string? := $person//tei:bibl ! normalize-space()
    let $job as xs:string? := $person//tei:occupation ! normalize-space()
    let $role as xs:string? := $person/@role ! normalize-space()
    let $gm as xs:string? := $person/@sex ! string()
    return
        <m:person>
            <m:name>{string-join(($surname, $forename), ', ')}</m:name>
            <m:about>{$abt}</m:about>
            <m:job>{$job}</m:job>
            <m:role>{$role}</m:role>
            <m:gm>{$gm}</m:gm>
        </m:person>
};
(:==========
Functions for manipulating data for indexing and rendering
==========:)
(: Move definite and indefinite article to end of title for rendering :)
declare function hoax:format-title($title as xs:string) as xs:string {
    if (matches($title, '^(The|An|A) '))
    then replace($title, '^(The|An|A)( )(.+)', '$3, $1')
        ! concat(upper-case(substring(., 1, 1)), substring(., 2)) => normalize-space()
    else normalize-space($title)
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
        if (empty($decades)) 
            then $month-years
            else if (empty($month-years)) 
                then () 
                else $month-years[not(matches(., $decade-starts))]
};

declare function hoax:word-count($body as element(tei:body)) as xs:integer {
   count(tokenize($body))
};

declare function hoax:initial-cap($input as xs:string) as xs:string {
    concat(upper-case(substring($input, 1, 1)), substring($input, 2))
};

declare function hoax:create-cuuid($input as xs:string?) as xs:string? {
    (: create stable (within run) uuid with leading consonant :)
    if ($input) then 'h' || util:uuid($input) else ()
};

(: ====
Function to sanitize user-supplied search term
Used in search.xql
==== :)
declare function hoax:sanitize-search-term(
        $path-to-data as xs:string, 
        $received-term as xs:string?
    ) as item()? {
    (: Function input could be:
        Empty sequence: return received empty sequence
        Empty string: return empty sequence (not empty string!)
        Non-empty valid Lucene string: return received non-empty received string
        Non-empty invalid (Lucene) string: <m:error> with system error message
            But: traps initial asterisk but not sequences like "hi**"
            Although "hi**" is an invalid regex in matches(), it appears to be valid
                for Lucene (whatever it might mean!)
    :)
    let $no-empty-strings := if ($received-term eq '') then () else $received-term
    return
        try {
            let $dummy as element(tei:TEI)* := collection($path-to-data)/tei:TEI[ft:query(., $no-empty-strings)]
            return $no-empty-strings
        } catch * {
            (: Lucene patterns cannot begin with ? or *. This traps any
            Lucene-invalid input :)
            <m:error>{$err:description}</m:error>
        }
};
