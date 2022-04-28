declare namespace html="http://www.w3.org/1999/xhtml";
declare namespace hoax ="http://obdurodon.org/hoax";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace m="http://www.obdurodon.org/model";
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
        (: Default :)
        default return local:passthru($node)
};
(: General functtions:)
declare function local:data($node as element(m:data)) as element(html:section) {
    <html:section id="search">{local:passthru($node)}
    <html:script type="text/javascript" src="resources/js/search.js"></html:script>
    </html:section>
};
declare function local:count($node as element(m:count)) as xs:string {
    concat(' (', $node, ')')
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
    <html:li><html:input type="checkbox"/> {local:passthru($node)}</html:li>
};
(:=====
Main
=====:)
local:dispatch($data)