xquery version "3.1";

(:~ This library module contains XQSuite tests for the pr-app app.
 :
 : @author gab_keane
 : @version 1.0.0
 : @see http://www.obdurodon.org
 :)

module namespace tests = "http://www.obdurodon.org/pr-app/tests";

declare namespace test="http://exist-db.org/xquery/xqsuite";
import module namespace hoax="http://obdurodon.org/hoax" at "../../modules/index-functions.xqm";
declare namespace tei="http://www.tei-c.org/ns/1.0";


(: Testing geo functions :)
declare variable $tests:XML := document {
    <TEI xmlns="http://www.tei-c.org/ns/1.0">
        <tei:geo>51.513979 -0.098372</tei:geo>

    </TEI>
};

declare %test:setUp
function tests:_test-set() {    
    xmldb:store("/db/apps/pr-app", "test.xml", $tests:XML)
};

(: %test:tearDown will run after module testing is done, function names are arbitrary:)
declare
    %test:tearDown
function tests:_test-teardown() {
    xmldb:remove("/db/apps/pr-app", "test.xml")
};

declare
    %test:assertEquals('51.513979')
    function tests:get-lat() as xs:string {
        hoax:get-lat(doc("/db/apps/pr-app/test.xml")//tei:geo)
    };

declare
    %test:arg('input', '51.513979')
    %test:assertEquals(51.51)
    function tests:test-round-geo($input as xs:string) as xs:double {
        hoax:round-geo($input)
    };

(: Test function to move definite and indefinite article to end of string:)
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