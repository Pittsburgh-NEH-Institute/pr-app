xquery version "3.1";
declare variable $exist:root as xs:string := request:get-parameter("exist:root", ());
declare variable $exist:controller as xs:string := request:get-parameter("exist:controller", ());
declare variable $path-to-data as xs:string := $exist:root || $exist:controller || '/data/hoax_xml';

<ul xmlns="http://www.w3.org/1999/xhtml">
<li>Root: {$exist:root}</li>
<li>Controller: {$exist:controller}</li>
<li>Path to data: {$path-to-data}</li>
</ul>