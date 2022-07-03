xquery version "3.1";
(: =====
Declare namespaces
===== :)
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace m="http://www.obdurodon.org/model";
declare namespace html="http://www.w3.org/1999/xhtml";
declare namespace hoax ="http://obdurodon.org/hoax";
declare namespace exist="http://exist.sourceforge.net/NS/exist";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "no";

declare variable $data as document-node() := request:get-data();

declare function local:dispatch($node as node()) as item()* {
    typeswitch($node)
        case text() return $node
        (:if no valid ID is passed, return error:)
        case element(m:no-result) return local:no-result($node)
        (:if valid ID is passed, process node children:)
        case element(m:result) return local:TEI($node)
        (:process tei:body:)
            case element(tei:bibl) return local:bibl($node)
            case element(tei:p) return local:p($node)
            case element(tei:rs) return local:rs($node)
            case element(tei:q) return local:quote($node)
        (:process m:aux:)    
        case element(m:aux) return local:aux($node)
            case element (m:places) return local:places($node)
            case element (m:place) return local:row($node)
                case element (m:name) return local:link($node)
                case element (m:type) return local:cell($node)
                case element (m:geo) return local:cell($node)
                case element (m:parent) return local:cell($node)
                case element (m:link) return ()
        case element(exist:match) return local:match($node)
        default return local:passthru($node)
};

declare function local:no-result($node as element(m:no-result)) as element(html:section){
    <html:section>
        <html:p>No such document. This shouldn’t happen if you clicked on a link in the advanced search results.</html:p>
    </html:section>
};

declare function local:TEI($node as element(m:result)) as element(html:section){
    <html:section>
        <html:h2>{local:dispatch($node/descendant::tei:titleStmt/tei:title)}</html:h2>
        <html:h3>{"From " || local:dispatch($node/descendant::m:publisher) || ", " || local:dispatch($node/descendant::m:date)}</html:h3>
        <html:h4>{local:dispatch($node/descendant::m:word-count) || " words"}</html:h4>
        {local:dispatch($node/descendant::tei:body),
        <html:span class="ghost">Ghost descriptions</html:span>,
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

(:enhancements - use contains token and a map:)
declare function local:rs($node as element(tei:rs)) as element(html:span)* {
    for $child in $node/node()
    return
        if (contains($node/@ref, 'ghost'))
            then <html:span class="ghost">{local:passthru($node)}</html:span>
        else if (contains($node/@ref, 'rel'))
            then <html:span class="religion">{local:passthru($node)}</html:span>
        else if (contains($node/@ref, 'or'))
            then <html:span class="orientalism">{local:passthru($node)}</html:span>
        else if (contains($node/@ref, 'public'))
            then <html:span class="public">{local:passthru($node)}</html:span>
        else if (contains($node/@ref, 'mis'))
            then <html:span class="misinfo">{local:passthru($node)}</html:span>                   
        else <html:span>{local:passthru($node)}</html:span>
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
declare function local:aux($node as element(m:aux)) as element(html:section)? {
    if (empty($node/*/*))
    then ()
    else <html:section class="aux">
        <html:h2>References</html:h2>
        {local:passthru($node)}
    </html:section>
};
declare function local:places($node as element(m:places)) as element(html:table) {
    <html:table>
        <html:tr>
            <html:th>Place name</html:th>
            <html:th>Type/Settlement</html:th>
            <html:th>Geo</html:th>
            <html:th>Parent place</html:th>
        </html:tr>
      {local:passthru($node)}  
    </html:table>
};
declare function local:row ($node as element(m:place)) as element(html:tr){
    <html:tr>{local:passthru($node)}</html:tr>
};
declare function local:cell ($node as element()) as element(html:td){
    <html:td>{local:passthru($node)}</html:td>
};

declare function local:link ($node as element (m:name)) as element (html:td){
    <html:td>
    {if ($node/parent::m:place/m:link)
    then <html:a href='{$node/parent::m:place/m:link/string()}'>{local:passthru($node)}</html:a>
    else (local:passthru($node))}
    </html:td>
};

local:dispatch($data)

(:
DONE declare function local:TEI($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:ab($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:bibl($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:body($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:cit($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:closer($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:date($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:div($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:editorialDecl($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:emph($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:encodingDesc($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:fileDesc($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:head($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:idno($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:interp($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:lb($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:name($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:normalization($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:note($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:opener($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
DONE declare function local:p($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:pb($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:persName($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:placeName($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:projectDesc($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:publicationStmt($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:publisher($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:q($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:quotation($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:quote($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:ref($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:resp($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:respStmt($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:rs($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:salute($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:seriesStmt($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:sic($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:signed($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:soCalled($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:sourceDesc($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:teiHeader($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:text($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:title($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
}; 
declare function local:titleStmt($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
};
:)
