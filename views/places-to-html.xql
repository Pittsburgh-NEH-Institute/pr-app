declare namespace html="http://www.w3.org/1999/xhtml";
declare namespace hoax ="http://www.obdurodon.org/hoax";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace m="http://www.obdurodon.org/hoax/model";
declare variable $data as document-node() := request:get-data();
declare function local:dispatch($node as node()) as item()* {
    typeswitch($node)
        case text() return $node
        case element(m:places) return local:table($node)
        case element(m:placeEntry) return local:row($node)
        case element(m:placeName) return local:placeName($node)
        case element (m:lat) return local:cell($node)
        case element (m:long) return local:cell($node)
        case element (m:parentPlace) return local:cell($node)
        default return local:passthru($node)
};

declare function local:table($node as element(m:places)) as element(html:table){
    <html:table>
        <html:tr>
            <html:th>Placename</html:th>
            <html:th>Latitude</html:th>
            <html:th>Longitude</html:th>
            <html:th>Parent place</html:th>
        </html:tr>
        {local:passthru($node)}
    </html:table>
};
declare function local:row ($node as element(m:placeEntry)) as element(html:tr){
    <html:tr>{local:passthru($node)}</html:tr>
};
declare function local:cell ($node as element()) as element(html:td){
    <html:td>{local:passthru($node)}</html:td>
};
declare function local:placeName($node as element(m:placeName)) as element(html:td) {
    <html:td>{local:passthru($node)}</html:td>
};
declare function local:passthru($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
};
local:dispatch($data)
