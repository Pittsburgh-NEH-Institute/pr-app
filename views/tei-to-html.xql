declare namespace html="http://www.w3.org/1999/xhtml";
declare namespace hoax ="http://obdurodon.org/hoax";
declare namespace tei="http://www.tei-c.org/ns/1.0";


declare variable $data as document-node() := request:get-data();
let $title := $data//tei:titleStmt/tei:title ! string()
return
<html:section>
    <html:h2>{$title}</html:h2>
        <html:pre class="tei"><html:code>{serialize($data)}</html:code></html:pre>
</html:section>
