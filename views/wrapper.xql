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
<!-- links for mapbox -->
    <!-- Remove Open+Sans to speed load time -->
    <!-- <link href="https://fonts.googleapis.com/css?family=Open+Sans" rel="stylesheet" type="text/css"/> -->
    <script src="https://api.tiles.mapbox.com/mapbox-gl-js/v2.8.1/mapbox-gl.js"></script>
    <link href="https://api.tiles.mapbox.com/mapbox-gl-js/v2.8.1/mapbox-gl.css" rel="stylesheet" type="text/css"/>
<!-- links for mapbox -->    
    </head>
    <body>
        <section class="nav-menu">
            <img src="resources/img/hoax-favicon.jpg" width="35" style="margin-right:1em;"/>                     
            <header>
                <h1><a href="index">Hoax: ghosts in 19th-c. British press</a></h1>
            </header>
            <nav>
                <ul>
                    <li><a href="search">Articles</a></li>
                    <li><a href="maps">Maps</a></li> 
                    <li><a href="visualize">Visualization</a></li>
                    <li><a href="places">Places</a></li>
                    <li><a href="persons">People</a></li>     
                </ul>
            </nav>
        </section> 
        <main>{$text}</main>
        <footer>
            <hr/>
            <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img 
                alt="Creative Commons License" 
                style="border-width:0" 
                src="resources/img/cc_license_88x31.png" height="15" width="45"
            /></a> This work is licensed under a 
                <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.</footer>
    </body>
</html>