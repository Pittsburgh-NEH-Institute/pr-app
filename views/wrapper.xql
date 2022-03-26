xquery version "3.1";

import module namespace hoax ="http://obdurodon.org/hoax" at "../modules/functions.xqm";
declare namespace tei="http://www.tei-c.org/ns/1.0"; 
declare default element namespace "http://www.w3.org/1999/xhtml";

declare variable $text := request:get-data(); (:this variable allows the pipeline to work:)
     
     <html>
            <head>
                <title>Hoax</title>
                
                <meta charset="UTF-8"/>
                <!-- <link rel="stylesheet" type="text/css" href="CSS/hoax.css"/> -->
                <link rel="icon" href="typewriter.jpg"/>
            </head>
            <body>
            <section class="container">    
                <header id="head">
                    <h1>
                        <a href="index">GHOST HOAXES in 19th-C. BRITISH NEWS MEDIA - A PRACTICE APPLICATION IN DEVELOPMENT</a>
                    </h1>
            
        </header>
           <nav>
           <ul>
                <li>
                            <a href="index">Home</a>
                        </li> 
                <li>
                            <a href="titles">Articles guide</a>
                        </li>
                <li>
                            <a href="maps">Maps</a>
                        </li> 
                <li>
                            <a href="places">Places</a>
                        </li>
                <li>
                            <a href="persons">People</a>
                        </li>          
            </ul>  
            <form action="xquery/search.xql" method="get">
      <input type="search" placeholder="search term" aria-label="Search"/>
      <button type="submit">Search</button>
    </form>
        </nav>
       </section> 

       {
           $text
       }
       
    <section class="container">
    <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">
                        <img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" height="50px" width="150px"/>
                    </a>
                    <br/>This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.
    </section>
            </body>
        </html>