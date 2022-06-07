xquery version "3.1";

import module namespace hoax ="http://obdurodon.org/hoax" at "../modules/functions.xqm";
declare namespace tei="http://www.tei-c.org/ns/1.0"; 
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare default element namespace "http://www.w3.org/1999/xhtml";


declare option output:method "xhtml";
declare option output:media-type "application/xhtml+xml";
declare option output:omit-xml-declaration "no";
declare option output:html-version "5.0";
declare option output:indent "no";
declare option output:include-content-type "no";

declare variable $text := request:get-data(); (:this variable allows the pipeline to work:)
     
<html>
    <head>
        <title>Hoax</title>
        <link rel="stylesheet" media="screen" type="text/css" href="resources/css/hoax.css"/>
        <link rel="icon" type="image/jpg" href="resources/img/typewriter.jpg"/>
    </head>
    <body>
        <section class="nav-menu">    
            <header >
                <h1><a href="index">Hoax: ghosts in 19th-c. British press</a></h1>
            </header>
            <nav>
                <ul>
                    <li><a href="index">Home</a></li> 
                    <li><a href="titles">Articles guide</a></li>
                    <li><a href="maps">Maps</a></li> 
                    <li><a href="places">Places</a></li>
                    <li><a href="persons">People</a></li>  
                    <li><a href="search">Advanced search</a></li>        
                </ul>  
                <form action="xquery/search.xql" method="get">
                    <input type="search" placeholder="search term" aria-label="Search"/>
                    <button type="submit">Search</button>
                </form>
            </nav>
        </section> 
        <main>{$text}</main>
        <footer>
            <hr/>
            <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img 
                alt="Creative Commons License" 
                style="border-width:0" 
                src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" height="20" width="60"
            /></a> This work is licensed under a 
                <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.</footer>
    </body>
</html>