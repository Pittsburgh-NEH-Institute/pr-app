xquery version "3.1";
declare namespace html="http://www.w3.org/1999/xhtml";
declare namespace hoax ="http://obdurodon.org/hoax";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare variable $data as document-node() := request:get-data();
(:request:get-data() is the function which receives whatever the controller forwards, without it you won't be able to forward onto views:)
(: temporarily ignore $data[1], which is <teiHeader>:)
declare variable $body as element(tei:body) := $data/descendant::tei:body;
declare function local:dispatch($node as node()) as item()* {
    typeswitch($node)
        case text() return $node
        case element(tei:body) return local:section($node)
        case element(tei:p) return local:p($node)
        default return local:passthru($node)
};
declare function local:p($node as element(tei:p)) as element(html:p) {
    <html:p>{local:passthru($node)}</html:p>
};
declare function local:section($node as element()) as element(html:section) {
    <html:section>{local:passthru($node)}</html:section>
};
declare function local:copy-attributes($node as node()) as attribute()* {
    for $att in $node/@*
    return attribute {$att ! name()} {$att}
};
declare function local:passthru($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
};
local:dispatch($body)