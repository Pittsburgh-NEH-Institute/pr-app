(: =====
Synopsis: Render SVG visualization of data in visualize.xql

Input: Model (in model namespace) supplied by search.xql

Output: HTML <section> element with search results, to be wrapped by wrapper.xql

Notes:

1. Model has 37 article children:
     <m:article>
         <m:title>New Hammersmith Ghost, The</m:title>
         <m:id xml:id="GH-19CUK-18380114"/>
         <m:word-count>1100</m:word-count>
         <m:place-count>4</m:place-count>
         <m:rel-count>1</m:rel-count>
         <m:pol-count>0</m:pol-count>
         <m:ghost-count>9</m:ghost-count>
     </m:article>
===== :)

(: Declare namespaces :)
declare namespace html="http://www.w3.org/1999/xhtml";
declare namespace hoax ="http://obdurodon.org/hoax";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace m="http://www.obdurodon.org/model";
declare namespace svg="http://www.w3.org/2000/svg";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "no";

declare variable $data as document-node() := request:get-data();

declare variable $article-count as xs:integer := $data/descendant::m:article => count();
declare variable $word-count-max as xs:double := $data/descendant::m:word-count => max();
declare variable $word-count-min as xs:double := $data/descendant::m:word-count => min();
declare variable $place-count-max as xs:double := $data/descendant::m:place-count => max();
(:=====:)

<html:section>

<svg:svg height="300"
    viewBox="-10 -510 820 520">

    <!-- AXES -->
         <svg:line x1="0" y1="0" x2="{85 * 5}" y2="0" stroke="black"/>
            <!-- draws x-axis, using number of years in which a story appears -->
         <svg:line x1="0" y1="0" x2="0" y2="-{$word-count-max div 5}" stroke="black"/>
            <!-- draws left y-axis -->
         <svg:line x1="{85 * 5}" y1="0" x2="{85 * 5}" y2="-{$word-count-max div 5}" stroke="black"/>
            <!-- draws right y-axis -->
    <!-- ARTICLE SEGMENTS -->
        <svg:line x1="{38*5}" x2="{38*5}" y1="{-1100 div 10}" y2="{-4 *25}" stroke="black"/> 
        <!--draw the line to connect points(uses year, word count, and place count) -->
        <svg:circle cx="{38*5}" cy="{-1100 div 10}" r="2" fill="red"/>
            <!-- draws 1100 wordcount point for an article published in 1838 -->
        <svg:circle cx="{38*5}"  cy="{-4 * 25}" r="2" fill="blue"/>
            <!-- draws 4 placecount point for an article published in 1838 -->
    
</svg:svg>

</html:section>