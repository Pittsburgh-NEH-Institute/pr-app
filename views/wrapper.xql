xquery version "3.1";

import module namespace hoax ="http://obdurodon.org/hoax" at "../modules/functions.xqm";
declare namespace tei="http://www.tei-c.org/ns/1.0"; 
declare default element namespace "http://www.w3.org/1999/xhtml";

declare variable $text := request:get-data(); (:this variable allows the pipeline to work:)
     
     <html>
            <head>
                <title>Hoax</title>
                
                <meta charset="UTF-8"/>
                <!-- <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous"/>
                 <link rel="stylesheet" href="https://unpkg.com/leaflet@1.4.0/dist/leaflet.css" integrity="sha512-puBpdR0798OZvTTbP4A8Ix/l+A4dHDD0DGqYW6RQ+9jxkRFclaxxQb/SJAWZfWAkuyeQUytO7+7N4QKrDh+drA==" crossorigin=""/>
   <script src="https://unpkg.com/leaflet@1.4.0/dist/leaflet.js" integrity="sha512-QVftwZFqvtRNi0ZyCtsznlKSWOStnDORoefr1enyq5mVL4tmKB3S/EnC3rRJcxCPavG10IcrVGSmPh6Qw5lwrg==" crossorigin="">/**/</script>
                <link rel="stylesheet" type="text/css" href="CSS/hoax.css"/> -->
                <link rel="icon" href="typewriter.jpg"/>
            </head>
            <body>
            <section class="container">    
                <header id="head">
                    <h1>
                        <a href="link">GHOST HOAXES in 19th-C. BRITISH NEWS MEDIA - A PRACTICE APPLICATION IN DEVELOPMENT</a>
                    </h1>
            
        </header>
           <nav class="navbar navbar-expand-lg navbar-light">
           <ul class="navbar-nav mr-auto">
                <li class="nav-item">
                            <a class="nav-link" href="link">title</a>
                        </li> 
                <li class="nav-item">
                            <a class="nav-link" href="link">title</a>
                        </li>
                <li class="nav-item">
                            <a class="nav-link" href="link">title</a>
                        </li> 
                <li class="nav-item">
                            <a class="nav-link" href="link">title</a>
                        </li> 
            </ul>  
            <form action="xquery/search.xql" method="get" class="form-inline my-2 my-lg-0">
      <input class="form-control mr-sm-2" type="search" placeholder="search term" aria-label="Search"/>
      <button class="btn btn-outline-secondary my-2 my-sm-0" type="submit">Search</button>
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