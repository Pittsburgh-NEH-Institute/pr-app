xquery version "3.1";
(: =====
Import functions
===== :)
import module namespace hoax ="http://www.obdurodon.org/hoax" at "../modules/functions.xqm";

(: =====
Declare namespaces
===== :)
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace m="http://www.obdurodon.org/hoax/model";
declare namespace html="http://www.w3.org/1999/xhtml";
declare namespace exist="http://exist.sourceforge.net/NS/exist";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "no";

declare variable $gms as map(*) := map {
    "M" : "Male",
    "F" : "Female",
    "U" : "Unknown"
    };

declare variable $refs as map(*) := map {
    "rel": "religion",
    "or": "orientalism",
    "mis": "misinformation",
    "pub": "public",
    "just": "justice"
    };

declare variable $data as document-node() := request:get-data();

declare function local:dispatch($node as node()) as item()* {
    typeswitch($node)
        case text() return $node
        case element(m:no-result) return local:no-result($node)
        case element(m:result) return local:TEI($node)
        (:process tei:body:)
            case element(tei:bibl) return local:bibl($node)
            case element(tei:publisher) return local:publisher($node)
            case element(tei:p) return local:p($node)
            case element(tei:ab) return local:p($node)
            case element(tei:lg) return local:p($node)
            case element(tei:l) return local:l($node)
            case element(tei:opener) return local:p($node)
            case element(tei:closer) return local:closer($node)
            case element(tei:rs) return local:rs($node)
            case element(tei:q) return local:quote($node)
            case element(tei:head) return local:head($node)
            case element(tei:emph) return local:emph($node)
        case element(m:aux) return local:aux($node)
        (:process m:aux:)
            case element(m:ghost-references) return local:ghost-references($node)
            case element(m:ghost-reference) return local:ghost-reference($node)
            case element (m:places) return local:places($node)
            case element (m:place) return local:row($node)
            case element (m:place) return local:row($node)
            case element(m:people) return local:people($node)
            case element(m:person) return local:person($node)
            case element (m:name) return local:name($node)
            case element (m:job) return local:cap-cell($node)
            case element (m:role) return local:cap-cell($node)
            case element (m:gm) return local:gm($node)
            case element (m:type) return local:cap-cell($node)
            case element (m:geo) return local:geo($node)
            case element (m:parent) return local:cell($node)
            case element(m:settlement) return local:cell($node)
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
    <html:section class="reading">
        <html:div id="reading-title">
            <html:h2>{local:dispatch($node/descendant::tei:titleStmt/tei:title)}</html:h2>
            {if (exists(root($node)/descendant::m:ghost-references/*)) then 
            <html:div class="info">ⓘ
                <html:div class="tooltip">Hover over green outlines to see reference type</html:div>
            </html:div>
            else ()}            
        </html:div>
        <html:h3><html:cite>{root($node)/descendant::m:aux/m:publisher ! string()}</html:cite>,
        <html:span>{root($node)/descendant::m:aux/m:date ! string()} 
        ({root($node)/descendant::m:aux/m:word-count ! string()} words)</html:span></html:h3>
        {local:dispatch($node/descendant::tei:body),
        local:dispatch($node/descendant::m:aux),
        local:dispatch($node/descendant::tei:sourceDesc/descendant::tei:bibl)}
        <html:script type="text/javascript" src="resources/js/read.js"></html:script>
    </html:section>
};

declare function local:bibl($node as element(tei:bibl)) as item()* {
    if ($node/ancestor::tei:sourceDesc) then 
    <html:p class="bibl">{
        local:passthru($node),
        concat(' (', root($node)/descendant::m:word-count ,' words)')
    }</html:p>
    else if ($node/ancestor::tei:cit) then
    (' (', local:passthru($node), ')')
    else local:passthru($node)
}; 

declare function local:publisher($node as element(tei:publisher)) as element(html:cite) {
    <html:cite>{
        if ($node/@rend) then concat('(', $node/@rend, ') ') else (),
        local:passthru($node)
    }</html:cite>
};

declare function local:p($node as element()) as element(html:p) {
    <html:p>{for $child in $node/node() return local:dispatch($child)}</html:p>
};

declare function local:l($node as element(tei:l)) as item()+ {
    local:passthru($node),
    if ($node/following-sibling::tei:l) then <html:br/> else ()
};

declare function local:head($node as element(tei:head)) as element(html:p) {
    <html:p>{local:passthru($node)}</html:p>
};

declare function local:closer($node as element(tei:closer)) as element(html:p) {  
    <html:p>{local:passthru($node)}</html:p>
};

declare function local:quote($node as element(tei:q)) as element(html:q) {
    <html:q>{for $child in $node/node() return local:dispatch($child)}</html:q>
};

declare function local:emph($node as element(tei:emph)) as element(tei:emph) {
    (: Defaults to <em> which is rendered as italic; all examples in corpus
        are either rend="italic" or have no @rend attribute:)
    <html:em>{local:passthru($node)}</html:em>
};

declare function local:rs($node as element(tei:rs)) as element(html:span) {
    <html:span 
        class="{string-join(('ref', $node/@ref, hoax:create-cuuid($node/@ref)), ' ')}" 
        title="{for $ref in $node/@ref ! tokenize(.) return ($refs($ref),$ref)[1]}"
    >{for $child in$node/node() return local:dispatch($child)}</html:span>
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

declare function local:ghost-references($node as element(m:ghost-references)) as element()* {
    if (exists($node/*)) then
        (<html:div id="ghost-reference-title">
            <html:h2>Ghost references</html:h2>
            <html:div class="info">ⓘ
                <html:div class="tooltip">Click on ghost reference type to highlight instances</html:div>
            </html:div>
        </html:div>,
        <html:ul>{
            for $child in $node/node() 
            order by lower-case($child)
            return local:dispatch($child)
        }</html:ul>)
    else ()
};

declare function local:ghost-reference($node as element(m:ghost-reference)) as element(html:li) {
    <html:li>
        <html:label><html:input class="ghost-reference" type="checkbox" id="{
            substring-before($node, ' (') ! hoax:create-cuuid(.)
        }"/>{local:passthru($node)}</html:label>
    </html:li>
};

declare function local:places($node as element(m:places)) as element()* {
    if (exists($node/*)) then
    (<html:h2>Place references</html:h2>,
    <html:table>
        <html:tr>
            <html:th>Place name</html:th>
            <html:th>Type</html:th>
            <html:th>Coordinates</html:th>
            <html:th>Settlement</html:th>
            <html:th>Parent place</html:th>
        </html:tr>
      {
        for $child in $node/node() 
        order by lower-case($child)
        return local:dispatch($child)}  
    </html:table>)
    else ()
};
declare function local:people($node as element(m:people)) as element()* {
    if (exists($node/*)) then
    (<html:h2>Person references</html:h2>,
    <html:table>
        <html:tr>
            <html:th>Name</html:th>
            <html:th>Job</html:th>
            <html:th>Role</html:th>
            <html:th>Gender</html:th>
        </html:tr>
      {for $child in $node/node() 
      order by lower-case($child)
      return local:dispatch($child)}  
    </html:table>)
    else ()
};

declare function local:person($node as element(m:person)) as element(tei:tr) {
    <html:tr>{for $child in $node/(node() except m:about) return local:dispatch($child)}</html:tr>
};

declare function local:row ($node as element()) as element(html:tr){
    <html:tr>{local:passthru($node)}</html:tr>
};

declare function local:cell ($node as element()) as element(html:td){
    <html:td>{
        if (exists($node/node())) 
            then local:passthru($node)
            else "(None)"
    }</html:td>
};

declare function local:cap-cell ($node as element()) as element(html:td){
    (: Capitalize first letter of content:)
    <html:td>{
        if (exists($node/node())) 
            then hoax:initial-cap($node)
            else "(None)"
    }</html:td>
};

declare function local:name ($node as element(m:name)) as element(html:td){
    (: Capitalize first letter of content:)
    <html:td>{
        if (empty($node/node())) 
        then "(None)"
        else if (exists($node/following-sibling::m:link))
            then <html:a href="{$node/following-sibling::m:link ! string()}" target="_blank">{hoax:initial-cap($node)}</html:a>
            else hoax:initial-cap($node)
    }</html:td>
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

declare function local:gm($node as element(m:gm)) as element(html:td) {
    <html:td>{
        if (exists($node/node())) then $gms(string($node))
        else "&#xa0;"
    }</html:td>
};

local:dispatch($data)
