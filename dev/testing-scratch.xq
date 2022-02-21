import module namespace hoax ="http://obdurodon.org/hoax" at "../modules/functions.xqm";
declare namespace tei="http://www.tei-c.org/ns/1.0";

let $story:= doc('/db/apps/pr-app/data/hoax_xml/anotherstockwellghostcase_leader_1857_edited.xml')

return hoax:title($story)

