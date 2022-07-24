declare namespace html="http://www.w3.org/1999/xhtml";
declare namespace hoax ="http://www.obdurodon.org/hoax";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace m="http://www.obdurodon.org/hoax/model";
declare variable $data as document-node() := request:get-data();
declare function local:dispatch($node as node()) as item()* {
    typeswitch($node)
        case text() return $node
        case element(m:persons) return local:table($node)
        case element(m:entry) return local:row($node)
        case element(m:name) return local:cell($node)
        case element (m:about) return local:cell($node)
        case element (m:job) return local:cell($node)
        case element (m:role) return local:cell($node)
        case element (m:gm) return local:cell($node)
        default return local:passthru($node)
};

declare function local:table($node as element(m:persons)) as element(html:table){
    <html:table>
    <html:tr>
        <html:th>Name</html:th>
        <html:th>About</html:th>
        <html:th>Job</html:th>
        <html:th>Role</html:th>
        <html:th>Sex</html:th>
    </html:tr>
    {local:passthru($node)}
    </html:table>
};
declare function local:row ($node as element(m:entry)) as element(html:tr){
    <html:tr>{local:passthru($node)}</html:tr>
};
declare function local:cell ($node as element()) as element(html:td){
    <html:td>{local:passthru($node)}</html:td>
};
declare function local:passthru($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
};
local:dispatch($data)
