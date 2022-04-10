xquery version "3.1";

import module namespace hoax ="http://obdurodon.org/hoax" at "../modules/functions.xqm";
declare namespace tei="http://www.tei-c.org/ns/1.0";

(:this should be a tei list or set of tei lists and should live in modules/:)
(:return both, hide one, toggle with CSS/JS? maybe for institute purposes we should use params:)

declare variable $docs :=collection('/db/apps/pr-app/data/hoax_xml');


<tei:div>
    <tei:list>
    {hoax:titlelistdate($docs)}
    </tei:list>
    <tei:list>
    {hoax:titlelistalpha($docs)}
    </tei:list>
</tei:div>