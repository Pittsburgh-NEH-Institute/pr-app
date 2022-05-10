declare namespace html="http://www.w3.org/1999/xhtml";
declare namespace hoax ="http://obdurodon.org/hoax";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace m="http://www.obdurodon.org/model";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "no";

declare variable $data as document-node() := request:get-data();

declare function local:dispatch($node as node()) as item()* {
    typeswitch($node)
        (: General :)
        case text() return $node
        case element(m:count) return local:count($node)
        (: Publishers :)
        case element(m:publishers) return local:publishers($node)
        case element(m:publisher) return local:publisher($node)
        (: Dates :)
        case element(m:data) return local:data($node)
        case element(m:decades) return local:decades($node)
        case element(m:decade) return local:decade($node)
        case element(m:years) return local:years($node)
        case element(m:year) return local:year($node)
        (: Articles:)
        case element(m:articles) return local:articles($node)
        case element(m:article) return local:article($node)
        (: Default :)
        default return local:passthru($node)
};
(: General functions:)
declare function local:data($node as element(m:data)) as element(html:section) {
    <html:section id="advanced-search">
        <html:section id="search-widgets">{
            for $search-area in $node/*[position() lt 3]
            return local:dispatch($search-area)
            }
            <html:script type="text/javascript" src="resources/js/search.js"></html:script>
        </html:section>
        <html:section id="search-results">
            <html:h2>Stories</html:h2>
            {if ($node/m:articles/m:article )
            then local:dispatch($node/m:articles)
            else <html:p>No matching articles found</html:p>
            }
        </html:section>
    </html:section>
};
declare function local:count($node as element(m:count)) as item()+ {
    ' (', <html:span class="current-count">{string($node)}</html:span>, concat('/', $node, ')')
};
declare function local:passthru($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
};
(: =====
Publisher functions
===== :)
declare function local:publishers($node as element(m:publishers)) as element()+ {
    <html:h2>Publishers</html:h2>,
    <html:ul>{local:passthru($node)}</html:ul>
};
declare function local:publisher($node as element(m:publisher)) as element(html:li) {
    <html:li><html:input type="checkbox"/> {local:passthru($node)}</html:li>
};
(:=====
Date functions
=====:)
declare function local:decades($node as element(m:decades)) as element()+ {
    <html:h2>Date</html:h2>,
    <html:ul>{local:passthru($node)}</html:ul>
};
declare function local:decade($node as element(m:decade)) as element(html:li) {
    <html:li>
        <html:details>
            <html:summary><html:input type="checkbox"/> {for $child in $node/(m:label | m:count) return local:dispatch($child)}</html:summary>
            {local:dispatch($node/m:years)}
        </html:details>
    </html:li>
};
declare function local:years($node as element(m:years)) as element(html:ul) {
    <html:ul>{local:passthru($node)}</html:ul>
};
declare function local:year($node as element(m:year)) as element(html:li) {
    <html:li><html:input type="checkbox"/> {
        format-date($node/m:label || '-01', '[MNn] [Y] '), 
        local:count($node/m:count)
    }</html:li>
};
(: =====
Article list functions
===== :)
declare function local:articles($node as element(m:articles)) as element(html:ul) {
    <html:ul>{local:passthru($node)}</html:ul>
};
declare function local:article($node as element(m:article)) as element(html:li) {
    <html:li>
        <html:a href="read?title={$node/m:id}"><html:q>{$node/m:title ! string()}</html:q></html:a>
        (<html:cite> {$node/m:publisher ! string()}</html:cite>,
        {format-date($node/m:date, '[MNn] [D], [Y]')})      
    </html:li>
};
(:=====
Main
=====:)
local:dispatch($data)