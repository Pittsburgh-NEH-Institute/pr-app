declare namespace html="http://www.w3.org/1999/xhtml";
declare namespace hoax ="http://obdurodon.org/hoax";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare variable $data as document-node() := request:get-data();
declare variable $lists as element(tei:div) := $data/descendant::tei:div;
declare function local:dispatch($node as node()) as item()* {
    typeswitch($node)
        case text() return $node
        case element(tei:div) return local:section($node)
        case element(tei:list) return local:ul($node)
        case element (tei:item) return local:li($node)
        case element (tei:anchor) return local:a($node)
        default return local:passthru($node)
};
declare function local:ul($node as element(tei:list)) as element(html:ul) {
    <html:ul>{local:passthru($node)}</html:ul>
};
declare function local:section($node as element(tei:div)) as element(html:section) {
    <html:section>{local:passthru($node)}</html:section>
};
declare function local:li($node as element(tei:item)) as element(html:li) {
    <html:li>{local:passthru($node)}</html:li>
};
declare function local:a($node as element(tei:anchor)) as element(html:a) {
    <html:a>{local:passthru($node)}</html:a>
};
declare function local:copy-attributes($node as node()) as attribute()* {
    for $att in $node/@*
    return attribute {$att ! name()} {$att}
};
declare function local:passthru($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
};
local:dispatch($lists)