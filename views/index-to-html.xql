xquery version "3.1";
declare namespace html="http://www.w3.org/1999/xhtml";
declare namespace hoax ="http://obdurodon.org/hoax";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare variable $data as document-node() := request:get-data();
declare function local:dispatch($node as node()) as item()* {
    typeswitch($node)
        case text() return $node
        case element(section) return local:section($node)
        case element(head) return local:head($node)
        default return local:passthru($node)
};
declare function local:head($node as element(head)) as element(html:h3) {
    <html:h3>{local:passthru($node)}</html:h3>
};
declare function local:section($node as element(section)) as element(html:section) {
    <html:section>{
        local:copy-attributes($node),
        local:passthru($node)
    }</html:section>
};
declare function local:copy-attributes($node as node()) as attribute()* {
    for $att in $node/@*
    return attribute {$att ! name()} {$att}
};
declare function local:passthru($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
};
local:dispatch($data)
