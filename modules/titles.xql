xquery version "3.1";

import module namespace hoax ="http://obdurodon.org/hoax" at "../modules/functions.xqm";
declare namespace tei="http://www.tei-c.org/ns/1.0";

declare variable $docs :=collection('/db/apps/pr-app/data/hoax_xml');

<section class="container">
    <ol>
    {
        let $listdate := hoax:titlelistdate($docs)
        return $listdate
    }
    </ol>

 <ol>
    {
        let $listalpha := hoax:titlelistalpha($docs)
        return $listalpha
    }
    </ol>


</section> 