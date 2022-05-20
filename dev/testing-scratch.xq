import module namespace hoax ="http://obdurodon.org/hoax" at "../modules/index-functions.xqm";
declare namespace tei="http://www.tei-c.org/ns/1.0";

(: let $story:= doc('/db/apps/pr-app/data/hoax_xml/anotherstockwellghostcase_leader_1857_edited.xml')

return hoax:title($story) :)

<results>
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
</results>