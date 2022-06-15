xquery version "3.1";
declare variable $articles as document-node()+ := collection('/db/apps/pr-app/data/hoax_xml');
declare variable $element-names as xs:string+ := $articles//* ! local-name() => distinct-values() => sort();
<elements>{
    for $n in $element-names
return
("&#x0a;declare function local:" || $n || "($node as node()) as item()* {&#x0a;    for $child in $node/node() return local:dispatch($child)&#x0a;};")
}</elements>