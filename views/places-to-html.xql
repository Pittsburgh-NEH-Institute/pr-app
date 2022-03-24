declare namespace html="http://www.w3.org/1999/xhtml";
declare namespace hoax ="http://obdurodon.org/hoax";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare variable $data as document-node() := request:get-data();
declare function local:dispatch($node as node()) as item()* {
    typeswitch($node)
        case text() return $node
        case element(places) return local:table($node)
        case element(placeEntry) return local:row($node)
        case element(placeName) return local:cell($node)
        case element (lat) return local:cell($node)
        case element (long) return local:cell($node)
        case element (parentPlace) return local:cell($node)
        default return local:passthru($node)
};

declare function local:table($node as element(places)) as element(html:table){
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
declare function local:row ($node as element(placeEntry)) as element(html:tr){
    <html:tr>{local:passthru($node)}</html:tr>
};
declare function local:cell ($node as element()) as element(html:td){
    <html:td>{local:passthru($node)}</html:td>
};
declare function local:passthru($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
};
local:dispatch($data)
