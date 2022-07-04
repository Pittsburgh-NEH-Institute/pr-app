xquery version "3.1";
(: =====
Import functions
===== :)
import module namespace hoax ="http://obdurodon.org/hoax" at "../modules/functions.xqm";

(: =====
Declare namespaces
===== :)
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace m="http://www.obdurodon.org/model";
declare namespace html="http://www.w3.org/1999/xhtml";
declare namespace exist="http://exist.sourceforge.net/NS/exist";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "no";

declare variable $data as document-node() := request:get-data();

declare function local:dispatch($node as node()) as item()* {
    typeswitch($node)
        case text() return $node
        case element(m:no-result) return local:no-result($node)
        case element(m:result) return local:TEI($node)
        (:process tei:body:)
            case element(tei:bibl) return local:bibl($node)
            case element(tei:p) return local:p($node)
            case element(tei:rs) return local:rs($node)
            case element(tei:q) return local:quote($node)
        case element(m:aux) return local:aux($node)
        (:process m:aux:)
            case element(m:ghost-references) return local:ghost-references($node)
            case element(m:ghost-reference) return local:ghost-reference($node)
            case element (m:places) return local:places($node)
            case element (m:place) return local:row($node)
            case element (m:name) return local:link($node)
            case element (m:type) return local:cell($node)
            case element (m:geo) return local:geo($node)
            case element (m:parent) return local:cell($node)
            case element (m:link) return ()
        case element(exist:match) return local:match($node)
        default return local:passthru($node)
};

(: ==========
Function for no-result (error)
========== :)
declare function local:no-result($node as element(m:no-result)) as element(html:section){
    <html:section>
        <html:p>No such document. This shouldn’t happen if you clicked on a link in the <html:a href="search">search</html:a> results.</html:p>
    </html:section>
};

(: ==========
Functions for TEI body
========== :)
declare function local:TEI($node as element(m:result)) as element(html:section){
    <html:section>
        <html:h2>{local:dispatch($node/descendant::tei:titleStmt/tei:title)}</html:h2>
        <html:h3>{"From " || local:dispatch($node/descendant::m:publisher) || ", " || local:dispatch($node/descendant::m:date)}</html:h3>
        <html:h4>{local:dispatch($node/descendant::m:word-count) || " words"}</html:h4>
        {local:dispatch($node/descendant::tei:body),
        local:dispatch($node/descendant::m:aux),
        local:dispatch($node/descendant::tei:sourceDesc/descendant::tei:bibl)}
    </html:section>
};

declare function local:bibl($node as element(tei:bibl)) as item()* {
    <html:p class="bibl">{for $child in $node/node() return local:dispatch($child)}</html:p>
}; 

declare function local:p($node as element(tei:p)) as element(html:p) {
    <html:p>{for $child in $node/node() return local:dispatch($child)}</html:p>
};

declare function local:quote($node as element(tei:q)) as element(html:q) {
    <html:q>{for $child in $node/node() return local:dispatch($child)}</html:q>
};

declare function local:rs($node as element(tei:rs)) as element(html:span) {
    <html:span class="ref" title="{$node/@ref}">{for $child in$node/node() return local:dispatch($child)}</html:span>
};

declare function local:match($node as element(exist:match)) as element(html:mark) {
    <html:mark>{for $child in $node/node() return local:dispatch($child)}</html:mark>
};

declare function local:passthru($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
};

(: =====
Functions for auxiliary data
===== :)
declare function local:aux($node as element(m:aux)) as element()* {
    (: Aux processing assumes that all articles have at least one ghost reference :)
    if (empty($node/*/*))
    then ()
    else (
        <html:hr/>,
        <html:section id="aux">{
            for $child in $node/(m:ghost-references, m:places, m:people) return local:dispatch($child)
        }</html:section>)
};

declare function local:ghost-references($node as element(m:ghost-references)) as element()+ {
    <html:h2>Ghost references</html:h2>,
    <html:ul>{
        for $child in $node/node() return local:dispatch($child)
    }</html:ul>
};

declare function local:ghost-reference($node as element(m:ghost-reference)) as element(html:li) {
    <html:li>{
        for $child in $node/node() return local:dispatch($child)
    }</html:li>
};

declare function local:places($node as element(m:places)) as element()* {
    if (exists($node/*)) then
    (<html:h2>Place references</html:h2>,
    <html:table>
        <html:tr>
            <html:th>Place name</html:th>
            <html:th>Type/Settlement</html:th>
            <html:th>Geo</html:th>
            <html:th>Parent place</html:th>
        </html:tr>
      {for $child in $node/node() return local:dispatch($child)}  
    </html:table>)
    else ()
};
declare function local:row ($node as element(m:place)) as element(html:tr){
    <html:tr>{local:passthru($node)}</html:tr>
};

declare function local:cell ($node as element()) as element(html:td){
    <html:td>{local:passthru($node)}</html:td>
};

declare function local:geo ($node as element(m:geo)) as element(html:td) {
    (: Specify precision for rounding geo value :)
    <html:td>{
        tokenize($node) ! hoax:round-geo(., 4) => string-join(' ')
    }</html:td>
};

declare function local:link ($node as element (m:name)) as element (html:td){
    <html:td>
    {if ($node/parent::m:place/m:link)
    then <html:a href='{$node/parent::m:place/m:link/string()}'>{local:passthru($node)}</html:a>
    else (local:passthru($node))}
    </html:td>
};

local:dispatch($data)