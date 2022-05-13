xquery version "3.1";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare variable $query-string as xs:string? := ();
declare variable $publisher-names as xs:string* := ("Times, The", "Penny Satirist, The");
declare variable $fields as map(*) := map {
  "fields" : "formatted-title"  
};
(:declare variable $facets as map(*)? := ();:)
declare variable $facets as map(*) := map { "facets" : map { "publisher" : $publisher-names } };
declare variable $options as map(*) := map:merge(($fields, $facets));
declare variable $hits as element(tei:TEI)+ := 
    collection('/db/apps/pr-app/data/hoax_xml')/tei:TEI
    [ft:query(., $query-string, $options)];
$hits