xquery version "3.1";
(: =====
Declare namespaces
===== :)
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace m="http://www.obdurodon.org/model";
declare namespace html="http://www.w3.org/1999/xhtml";
declare namespace hoax ="http://obdurodon.org/hoax";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "no";

declare variable $data as document-node() := request:get-data();

declare function local:dispatch($node as node()) as item()* {
    typeswitch($node)
        case text() return $node
        case element(m:result) return local:result($node)
        case element(tei:TEI) return local:TEI($node)
        case element(tei:p) return local:p($node)
        default return local:passthru($node)
};

declare function local:result($node as element(m:result)) as element(html:section){
    <html:section>
        <html:p>No such document. This shouldn’t happen if you clicked on a link in the advanced search results.</html:p>
    </html:section>
};

declare function local:TEI($node as element(tei:TEI)) as element(html:section){
    <html:section>
        <html:h2>{local:dispatch($node/descendant::tei:titleStmt/tei:title)}</html:h2>
        {local:dispatch($node/descendant::tei:body)}
    </html:section>
};

declare function local:p($node as element(tei:p)) as element(html:p){
    <html:p>{for $child in $node/node() return local:dispatch($child)}</html:p>
};

declare function local:passthru($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
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
