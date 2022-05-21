import module namespace hoax ="http://obdurodon.org/hoax" at "../modules/index-functions.xqm";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace array="http://www.w3.org/2005/xpath-functions/array";
 
let $publisher-facets as xs:string* := ('Times, The', 'Penny Satirist, The')
let $decades-input as xs:string* := ('1810', '1840')
let $month-years-input as xs:string* := ('1830-06', '1838-01', '1840-02')
let $month-years-filtered as xs:string* := hoax:construct-date-facets($decades-input, $month-years-input)
let $date-facets as array(*):= array:join((
        $decades-input ! [.], $month-years-filtered ! [tokenize(., '-')]
    ))
let $options as map(*) := map {
    "facets" : map { 
        "publisher": $publisher-facets
    }
} 
let $hits as element(tei:TEI)* := 
    collection('/db/apps/pr-app/data/hoax_xml/')/tei:TEI[ft:query(., (), $options)]
return ($date-facets)

(: <results>
<test>('1800', '1810'), ('1810-01', '1820-01')</test>
<both>{
    hoax:construct-date-facets(('1800', '1810'), ('1810-01', '1820-01'))
}</both>
<no-decades>{
    hoax:construct-date-facets((), ('1810-01', '1820-01'))
}</no-decades>
<no-month-years>{
    hoax:construct-date-facets(('1800', '1810'), ())
}</no-month-years> 
</results> :)