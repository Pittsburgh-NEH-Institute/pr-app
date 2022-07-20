xquery version "3.1";
declare namespace html="http://www.w3.org/1999/xhtml";
declare namespace m="http://www.obdurodon.org/model";
declare namespace svg="http://www.w3.org/2000/svg";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "no";

declare variable $data as document-node() := request:get-data();

declare variable $article-count as xs:integer := $data//m:article => count();
declare variable $x-axis as xs:integer := ($article-count * 30) + 30;
declare variable $place-count-max as xs:double := $data/descendant::m:pc => max();

declare variable $word-count-max as xs:double := $data/descendant::m:wc => max();
declare variable $y-axis-height as xs:double := $word-count-max div 10; 

declare variable $y-scale-place as xs:double := $y-axis-height div $place-count-max;


<html:section>
<html:h2>Article length and place count</html:h2>
<svg:svg width="95%" viewBox="-100 -746 2150 796">
    <!-- draw x-axis -->
    <svg:line  x1="0" 
                    y1="0" 
                    x2="{$x-axis}" 
                    y2="0" 
                    stroke="black"/>
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
{let $decades as xs:integer+ := 
        $data/descendant::m:date ! 
        substring(., 3, 1) ! xs:integer(.) => 
        distinct-values() => sort()
    
    for $article at $pos in ($data//m:article =>
         sort((),function($a){$a/m:date}))
    let $title as xs:string := $article/m:title ! string(.)
    let $decade as xs:integer := $article/m:date ! substring(., 3, 1) ! xs:integer(.)
    let $year as xs:string := $article/m:date ! substring(., 3, 2)
    let $link as xs:string := ("read?id=" || $article/m:id)        
    let $word-count as xs:integer := $article/m:wc ! xs:integer(.)
    let $place-count as xs:integer := $article/m:pc ! xs:integer(.)  
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
</svg:svg>
</html:section>