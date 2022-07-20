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

declare variable $word-count-max as xs:double := $data/descendant::m:wc => max();
declare variable $y-axis-height as xs:double := $word-count-max div 10; 
<html:section>
{$y-axis-height}
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

for $article at $pos in ($data/descendant::m:by-article/m:article =>
         sort((),function($a){$a/m:date}))
    return
        <svg:rect
            x="45" 
            y="{-$y-axis-height}" 
            width="30" 
            height="{$y-axis-height}"/>
        <svg:text>{pos}</svg:text>                                       

</svg:svg>
</html:section>