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
declare variable $y-axis-height as xs:double := $word-count-max div 10;
declare variable $y-scale-place as xs:double := $y-axis-height div $place-count-max;
declare variable $x-axis as xs:integer := ($article-count * 30) + 30;
(:=====:)

<html:section>

<svg:svg width="1000"
    viewBox="-100 -{$y-axis-height + 150} 2150 {$y-axis-height + 200}">

<!-- AXES -->
        <!-- X-axis, using number of years in which a story appears -->
         <svg:line  x1="0" 
                    y1="0" 
                    x2="{$x-axis}" 
                    y2="0" 
                    stroke="black"/>
         <svg:text  x="{$x-axis div 2}"
                    y="35"
                    text-anchor="middle"
                    dominant-baseline="middle"
                    >Year in 1800s</svg:text>           
        <!-- draws left y-axis -->            
         <svg:line  x1="0"
                    y1="0" 
                    x2="0" 
                    y2="-{$y-axis-height + 20}" 
                    stroke="black"/>
        <!-- draws right y-axis -->
         <svg:line  x1="{$x-axis}"
                    y1="0" 
                    x2="{$x-axis}" 
                    y2="-{$y-axis-height + 20}" 
                    stroke="black"/>
        <!-- Y-Axis Labels -->
        <!-- word count axis label -->
        <svg:g class="wc">
        <!-- top label -->
        <svg:text   x="0" 
                    y="-{$y-axis-height + 30}" 
                    text-anchor="middle"
                    dominant-baseline="middle" 
                    fill="red"
                    >Word-count</svg:text>
        <!-- middle (div 2) label -->            
        <svg:line   x1="-5" 
                    y1="-{$y-axis-height div 2}" 
                    x2="5" 
                    y2="-{$y-axis-height div 2}" 
                    stroke="black"/>
        <svg:text   x="-30" 
                    y="-{$y-axis-height div 2}" 
                    text-anchor="middle"
                    stroke="red"
                    dominant-baseline="middle"
                    >{$word-count-max div 2}</svg:text>
        <!-- 3/4 label -->            
        <svg:line   x1="-5" 
                    y1="-{($y-axis-height div 4)*3}" 
                    x2="5" 
                    y2="-{($y-axis-height div 4)*3}" 
                    stroke="black"/>
        <svg:text   x="-30" 
                    y="-{($y-axis-height div 4)*3}" 
                    text-anchor="middle"
                    stroke="red"
                    dominant-baseline="middle"
                    >{($word-count-max div 4) *3}</svg:text>
        <!-- max number label -->             
        <svg:line   x1="-5" 
                    y1="-{$y-axis-height}" 
                    x2="5" 
                    y2="-{$y-axis-height}" 
                    stroke="black"/>
        <svg:text   x="-30" 
                    y="-{$y-axis-height}" 
                    text-anchor="middle"
                    stroke="red"
                    dominant-baseline="middle"
                    >{$word-count-max}</svg:text>
        <!-- 1/4 label -->            
        <svg:line   x1="-5" 
                    y1="-{($y-axis-height div 4)}" 
                    x2="5" 
                    y2="-{($y-axis-height div 4)}" 
                    stroke="black"/>
        <svg:text   x="-30" 
                    y="-{($y-axis-height div 4)}" 
                    text-anchor="middle"
                    stroke="red"
                    dominant-baseline="middle"
                    >{($word-count-max div 4)}</svg:text>                                   
        </svg:g>
        <!-- draws place count label axis-->
       <svg:g class="pc">
        <svg:text   x="{$x-axis}" 
                    y="-{$y-axis-height + 30}" 
                    text-anchor="middle"
                    dominant-baseline="middle"
                    stroke="blue"
                    >Place-count</svg:text>
        <!-- 1/4 label -->            
        <svg:line   x1="{$x-axis - 5}" 
                    y1="-{($y-axis-height div 4)}" 
                    x2="{$x-axis + 5}" 
                    y2="-{($y-axis-height div 4)}" 
                    stroke="black"/>
        <svg:text   x="{$x-axis + 30}" 
                    y="-{($y-axis-height div 4)}" 
                    text-anchor="middle"
                    stroke="blue"
                    dominant-baseline="middle"
                    >{($place-count-max div 4)}</svg:text> 
        <!-- 1/2 label -->            
        <svg:line   x1="{$x-axis - 5}" 
                    y1="-{($y-axis-height div 2)}" 
                    x2="{$x-axis + 5}" 
                    y2="-{($y-axis-height div 2)}" 
                    stroke="black"/>
        <svg:text   x="{$x-axis + 30}" 
                    y="-{($y-axis-height div 2)}" 
                    text-anchor="middle"
                    stroke="blue"
                    dominant-baseline="middle"
                    >{($place-count-max div 2)}</svg:text>
        <!-- 3/4 label -->
        <svg:line   x1="{$x-axis - 5}" 
                    y1="-{($y-axis-height div 4)*3}" 
                    x2="{$x-axis + 5}" 
                    y2="-{($y-axis-height div 4)*3}" 
                    stroke="black"/>
        <svg:text   x="{$x-axis + 30}" 
                    y="-{($y-axis-height div 4)*3}" 
                    text-anchor="middle"
                    stroke="blue"
                    dominant-baseline="middle"
                    >{($place-count-max div 4)*3}</svg:text>
        <!-- max label -->
        <svg:line   x1="{$x-axis - 5}" 
                    y1="-{$y-axis-height}" 
                    x2="{$x-axis + 5}" 
                    y2="-{$y-axis-height}" 
                    stroke="black"/>
        <svg:text   x="{$x-axis + 30}" 
                    y="-{$y-axis-height}" 
                    text-anchor="middle"
                    stroke="blue"
                    dominant-baseline="middle"
                    >{$place-count-max}</svg:text>                                                 
        </svg:g>
                               
<!-- ARTICLE SEGMENTS -->
 {let $decades as xs:integer+ := 
        $data/descendant::m:date ! 
        substring(., 3, 1) ! xs:integer(.) => 
        distinct-values() => sort()

   for $article at $pos in ($data/descendant::m:by-article/m:article =>
         sort((),function($a){$a/m:date}))
        let $title as xs:string := $article/m:title ! string(.)
        let $decade as xs:integer := $article/m:date ! substring(., 3, 1) ! xs:integer(.)
        let $year as xs:string := $article/m:date ! substring(., 3, 2)
        let $link as xs:string := ("read?id=" || $article/m:id)        
        let $word-count as xs:integer := $article/m:word-count ! xs:integer(.)
        let $place-count as xs:integer := $article/m:place-count ! xs:integer(.)  
        let $x-pos as xs:integer := $pos * 30
        
    return
    <svg:g>
        <svg:a href="{$link}">
        <svg:rect   x="{$x-pos - 15}" 
                    y="{-$y-axis-height}" 
                    width="30" 
                    height="{$y-axis-height}" 
                    fill="{if (index-of($decades, $decade) mod 2 eq 0)
                            then '#ceded6'
                            else '#D5DDEC'}"/>
          <svg:line x1="{$x-pos}" 
                    x2="{$x-pos}" 
                    y1="{-$word-count div 10}" 
                    y2="{-$place-count * $y-scale-place}" 
                    stroke="black" stroke-width="2"/>
          <svg:circle   class="wc"
                        cx="{$x-pos}" 
                        cy="{-$word-count div 10}" 
                        r="7" 
                        fill="red"/>
          <svg:circle   class="pc"
                        cx="{$x-pos}"  
                        cy="{-$place-count * $y-scale-place}" 
                        r="7" 
                        fill="blue"/>
          <svg:text     x="{$x-pos}" 
                        y="15" 
                        text-anchor="middle"
                        dominant-baseline="middle" 
                        stroke="black"
                        >{$year}</svg:text>  
          <svg:title>
            <svg:tspan class="article_title">{$title}</svg:tspan>
            <svg:tspan class="word-count">{'Word count: ' || $word-count}</svg:tspan>
            <svg:tspan class="place-count">{'Place count: '|| $place-count}</svg:tspan>
          </svg:title>
        </svg:a>
    </svg:g>    
                
}
<!-- draw what you think a segment should look like:
        <svg:line x1="{38*5}" x2="{38*5}" y1="{-1100 div 10}" y2="{-4 *25}" stroke="black"/> 
        draw the line to connect points(uses year, word count, and place count) 
        <svg:circle cx="{38*5}" cy="{-1100 div 10}" r="2" fill="red"/>
            draws 1100 wordcount point for an article published in 1838 
        <svg:circle cx="{38*5}"  cy="{-4 * 25}" r="2" fill="blue"/>
            draws 4 placecount point for an article published in 1838 
            
            -->
</svg:svg>

</html:section>