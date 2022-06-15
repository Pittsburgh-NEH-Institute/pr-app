xquery version "3.1";
(: =====
Declare namespaces
===== :)
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace m="http://www.obdurodon.org/model";
declare namespace html="http://www.w3.org/1999/xhtml";
declare namespace hoax ="http://obdurodon.org/hoax";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "no";

declare variable $data as document-node() := request:get-data();

declare function local:dispatch($node as node()) as item()* {
    typeswitch($node)
        case text() return $node
        case element(m:result) return local:result($node)
        case element(tei:TEI) return local:TEI($node)
        default return local:passthru($node)
};

declare function local:result($node as element(m:result)) as element(html:section){
    <html:section>
        <html:p>No such document. This shouldn’t happen if you clicked on a link in the advanced search results.</html:p>
    </html:section>
};

declare function local:TEI($node as element(tei:TEI)) as element(html:section){
    <html:section>
        <html:p>Found a TEI document</html:p>
    </html:section>
};

declare function local:passthru($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
};
local:dispatch($data)
