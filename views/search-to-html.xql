declare namespace html="http://www.w3.org/1999/xhtml";
declare namespace hoax ="http://obdurodon.org/hoax";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace m="http://www.obdurodon.org/model";
declare variable $data as document-node() := request:get-data();

declare function local:dispatch($node as node()) as item()* {
    typeswitch($node)
        case text() return $node
        case element(m:data) return local:data($node)
        case element(m:publishers) return local:publishers($node)
        case element(m:publisher) return local:publisher($node)
        case element(m:decades) return local:decades($node)
        default return local:passthru($node)
};
declare function local:data($node as element(m:data)) as element(html:section) {
    <html:section>{local:passthru($node)}</html:section>
};
declare function local:publishers($node as element(m:publishers)) as element()+ {
    <html:h2>Publishers</html:h2>,
    <html:ul>{local:passthru($node)}</html:ul>
};
declare function local:publisher($node as element(m:publisher)) as element(html:li) {
    <html:li>{local:passthru($node)}</html:li>
};
declare function local:decades($node as element(m:decades)) as element()+ {
    <html:h2>Date</html:h2>
};
declare function local:passthru($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
};
local:dispatch($data)