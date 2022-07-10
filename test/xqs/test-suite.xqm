xquery version "3.1";

(:~ This library module contains XQSuite tests for the pr-app app.
 :
 : @author gab_keane
 : @version 1.0.0
 : @see http://www.obdurodon.org
 :)

module namespace tests = "http://www.obdurodon.org/apps/pr-app/tests";
declare namespace test="http://exist-db.org/xquery/xqsuite";
import module namespace hoax="http://obdurodon.org/hoax" at "../../modules/functions.xqm";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace m="http://www.obdurodon.org/model";

(: ==========
Set up and tear down
========== :)
declare variable $tests:XML := document {
    <TEI xmlns="http://www.tei-c.org/ns/1.0">
        <tei:geo>51.513979 -0.098372</tei:geo>
        <tei:body>
            This sentence has five words.
        </tei:body>
        <tei:body/>
    </TEI>
};

declare variable $tests:place-test-1 as element(tei:place) :=
    <m:place xml:id="ealing">
        <m:name>Hampstead</m:name>
        <m:type>neighborhood</m:type>
        <m:geo>51.5126553 -0.3051952</m:geo>
        <m:settlement/>
        <m:parent>London</m:parent>
    </m:place>
;

declare variable $tests:person-test-1 as element(m:person) :=
    <m:person>
        <m:name>Nelson, Horatio</m:name>
        <m:about>Horatio Nelson was a Naval official known for his death at the Battle of Trafalgar in 1805.</m:about>
        <m:job>Vice Admiral of the Royal Navy</m:job>
        <m:role>admiral</m:role>
        <m:gm>M</m:gm>
    </m:person>
;

declare 
    %test:setUp
    function tests:_test-set() {    
        xmldb:store("/db/apps/pr-app", "test.xml", $tests:XML)
};

(: %test:tearDown will run after module testing is done, function names are arbitrary:)
declare
    %test:tearDown
    function tests:_test-teardown() {
        xmldb:remove("/db/apps/pr-app", "test.xml")
};

(: ==========
Tests for geo functions 
========== :)
declare
    %test:assertEquals('51.513979')
    function tests:get-lat() as xs:string {
        hoax:get-lat(doc("/db/apps/pr-app/test.xml")/tei:TEI/tei:geo)
    };

declare
    %test:assertEquals('-0.098372')
    function tests:get-long() as xs:string {
        hoax:get-long(doc("/db/apps/pr-app/test.xml")/tei:TEI/tei:geo)
    };

declare
    %tests:name('round-geo() with default precision')
    %test:arg('input', '51.513979')
    %test:assertEquals('51.51')
    %test:arg('input', '51.3')
    %test:assertEquals('51.30')
    %test:arg('input', '-.3')
    %test:assertEquals('-0.30')
    function tests:test-round-geo($input as xs:string) as xs:string {
        hoax:round-geo($input)
    };

declare
    %tests:name('round-geo() with specified precision')
    %test:arg('input', '51.513979')
    %test:arg('precision', 4)
    %test:assertEquals('51.5140')
    %test:arg('input', '51.3')
    %test:arg('precision', 4)
    %test:assertEquals('51.3000')
    %test:arg('input', '-.3')
    %test:arg('precision', 3)
    %test:assertEquals('-0.300')
    function tests:test-round-geo($input as xs:string, $precision as xs:integer) as xs:string {
        hoax:round-geo($input, $precision)
    };
(: ==========
Tests for fixing definitie and indefinite articles
========== :)
declare
    %test:arg('input', 'The Big Sleep')
    %test:assertEquals('Big Sleep, The')
    %test:arg('input', 'An Unusual Life')
    %test:assertEquals('Unusual Life, An')
    %test:arg('input', 'A Boring Life')
    %test:assertEquals('Boring Life, A')
    %test:arg('input', 'Andrea and Andrew')
    %test:assertEquals('Andrea and Andrew')
    %test:arg('input', 'A ghost, a bear, or a devil')
    %test:assertEquals('Ghost, a bear, or a devil, A')
    function tests:test-format-title($input as xs:string) as xs:string {
        hoax:format-title($input)
    };

(: ==========
 Tests for computing necessary month-year facets needed for next query 
 ========== :)
declare
    (: If no decades, return all month-years :)
    %test:arg('decades', '')
    %test:arg('month-years', '1800-01', '1820-01')
    %test:assertXPath("deep-equal($result, ('1800-01', '1820-01'))")
    (: Remove month-years shadowed by decades :)
    %test:arg('decades', '1800', '1810')
    %test:arg('month-years', '1800-01', '1820-01')
    %test:assertXPath("deep-equal($result, '1820-01')")
    (: If no month-years, return empty :)
    %test:arg('decades', '1800', '1810')
    %test:arg('month-years', '')
    %test:assertXPath("deep-equal($result, ())")
    function tests:construct-date-facets(
        $decades as xs:string*, 
        $month-years as xs:string*
    ) as xs:string* {
        let $d as xs:string* := if ($decades[1] eq '') then () else $decades
        let $m as xs:string* := if ($month-years[1] eq '') then () else $month-years
        return hoax:construct-date-facets($d, $m)
    };

 (: ==========
 Test for word count
 ========== :)  
 declare 
    %test:arg("pos", 1)
    %test:assertEquals(5)
    %test:arg("pos", 2)
    %test:assertEquals(0)
    function tests:word-count($pos as xs:integer) as xs:integer {
        hoax:word-count(doc("/db/apps/pr-app/test.xml")//tei:body[$pos])
    };

(: ==========
Test for retrieving place info from gazetteer
Depends on actual aux_xml/places.xml file
A better test would use test data, rather than real data
========== :)
declare
    %test:arg("placename", "ealing")
    %test:assertTrue
    function tests:get-place-info($placename) as xs:boolean {
        let $e as element(tei:place) := 
            doc("/db/apps/pr-app/data/aux_xml/places.xml")//id($placename)
        return deep-equal(hoax:get-place-info($e), $tests:place-test-1)
    };
(: ==========
Test for retrieving person info from prosopography
TODO: Should also test with bad data
========== :)
declare
    %test:arg("personname", "horationelson")
    %test:assertTrue
    function tests:get-person-info($personname as xs:string) as xs:boolean {
        let $e as element(tei:person) :=
            doc("/db/apps/pr-app/data/aux_xml/persons.xml")//id($personname)
        return deep-equal(hoax:get-person-info($e), $tests:person-test-1)
    };
(: ==========
Test for computing stable UUID that begins with consonant
========== :)
declare
    %test:arg("input", "ghost")
    %test:assertEquals("h8fd67d96-6d54-353a-b0f4-100c08b555a0")
    %test:arg("input", "")
    %test:assertEmpty
    function tests:create-uuid($input) as xs:string? {
        if ($input eq "") 
            then hoax:create-cuuid(())
        else
            hoax:create-cuuid($input)
    };
(: ==========
Test for initial capitalization
========== :)
declare
    %test:arg("input", "input")
    %test:assertEquals("Input")
    %test:arg("input", "potato salad")
    %test:assertEquals("Potato salad")
    %test:arg("input", "2") (: non-alphabetic :)
    %test:assertEquals("2")
    %test:arg("input", "ĳ") (: ligature :)
    %test:assertEquals("Ĳ")
    function tests:initial-cap($input as xs:string) as xs:string {
        hoax:initial-cap($input)
    };
(: No test for hoax:maplist(), which currently is not used :)
