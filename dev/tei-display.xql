xquery version "3.1";

(:original (wrong) approach
let's use CDATA (opposite of parsed character "PCDATA" data)
we want to treat TEI like it is literal data, do not parse angle brackets
thinking - we want to put TEI elements inside CDATA. Whatever you put in there will not be parsed,
though, so you end up returning a literal '$doc' string.

correct approach
serialize() replaces all markup with character entities, which is what we want (yay!). It has the added benefit
of being simple.


output namespace and option declarations
browsers have expectations about what HTML should look like, the more you declare, the more control you have
about what will appear and how it is validated

namespace is required because it allows the browser to know how to validate as XML. This will become important when
we want to use other XML technologies like SVG to display things. If we didn't use namespaces, the browser could display these incorrectly.

MIME type or media-type tells the browser we're giving it HTML 5 with XML syntax. Some browsers don't care, but if you are always standards
conformant, you know your site will work even if the browser changes something with their next release.
:)

import module namespace hoax ="http://obdurodon.org/hoax" at "../modules/functions.xqm";

declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace html="http://www.w3.org/1999/xhtml";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare option output:method "xhtml";
declare option output:media-type "application/xhtml+xml";
declare option output:omit-xml-declaration "no";
declare option output:html-version "5.0";
(:declare option output:cdata-section-elements "html:pre";:)

declare variable $doc as document-node():= doc('/db/apps/pr-app/data/hoax_xml/aghost_age_1832.xml');

let $x := 1

return 
<html xmlns='http://www.w3.org/1999/xhtml'>
<head><title>test tei doc</title></head>
<body>
    <h1>hello!</h1>
        <pre>
        <code>{serialize($doc)}</code>
        </pre>
</body>
</html>