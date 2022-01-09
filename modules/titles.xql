xquery version "3.1";

import module namespace hoax ="http://obdurodon.org/hoax" at "../modules/functions.xqm";
declare namespace tei="http://www.tei-c.org/ns/1.0";

(:this should be a tei list or set of tei lists and should live in modules/:)

declare variable $docs :=collection('/db/apps/pr-app/data/hoax_xml');

<section class="container">
    <ol>
    {hoax:titlelistdate($docs)}
    </ol>
    <ol>
    {hoax:titlelistalpha($docs)}
    </ol>


</section> 