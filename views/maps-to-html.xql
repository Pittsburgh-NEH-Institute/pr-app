(: =====
Synopsis: Render map visualization of data in map.xql

Input: Model (in model namespace) supplied by map.xql

Output: HTML <section> element with js map embedded, to be wrapped by wrapper.xql

Notes:

1. Model has 37 article children:
      <m:place>
        <m:name>The Lord Mayor's Mansion House</m:name>
        <m:geo>
            <m:lat>51.513027</m:lat>
            <m:long>-0.089498</m:long>
        </m:geo>
    </m:place>
===== :)

(: Declare namespaces :)
declare namespace html="http://www.w3.org/1999/xhtml";
declare namespace hoax ="http://www.obdurodon.org/hoax";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace m="http://www.obdurodon.org/hoax/model";
declare namespace console="http://existdb.org/xquery/console";
declare namespace xi="http://www.w3.org/2001/XInclude";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "no";

declare variable $exist:root as xs:string := request:get-parameter("exist:root", "xmldb:exist:///db/apps");
declare variable $exist:controller as xs:string := request:get-parameter("exist:controller", "/pr-app");

declare variable $data as document-node() := request:get-data();

declare variable $js-front as xs:string := "mapboxgl.accessToken = 'pk.eyJ1IjoiZ2FiaWtlYW5lIiwiYSI6ImNqdWlzYWwxcTFlMjg0ZnBnM21kem9xZm4ifQ.CQ5LDwZO32ryoGVb-QQwCg';
const map = new mapboxgl.Map({
  container: 'map',
  style: 'mapbox://styles/mapbox/light-v10',
  center: [-0.131719, 51.501029],
  zoom: 12
});

";
declare variable $js-marker-data as xs:string := "const geojson = {
  type: 'FeatureCollection',
  features: [
    {
      type: 'Feature',
      geometry: {
        type: 'Point',
        coordinates: [-77.032, 38.913]
      },
      properties: {
        title: 'Mapbox',
        description: 'Washington, D.C.'
      }
    },
    {
      type: 'Feature',
      geometry: {
        type: 'Point',
        coordinates: [-122.414, 37.776]
      },
      properties: {
        title: 'Mapbox',
        description: 'San Francisco, California'
      }
    }
  ]
};";

declare variable $js-back as xs:string := "// add markers to map
for (const feature of geojson.features) {
  // create a HTML element for each feature
  const el = document.createElement('div');
  el.className = 'marker';

  // make a marker for each feature and add to the map
  new mapboxgl.Marker(el)
  .setLngLat(feature.geometry.coordinates)
  .setPopup(
    new mapboxgl.Popup({ offset: 25 }) // add popups
      .setHTML(
       `<h3>${feature.properties.name}</h3>
        <p>${feature.properties.appears}</p>`
      )
  )
  .addTo(map);;
};";

declare variable $map as element(fn:map) := <fn:map>
    <fn:string
        key='type'>FeatureCollection</fn:string>
    <fn:array
        key='features'>
        {
            for $place in $data/descendant::m:geo-places/m:place
            let $name := $place/m:name ! string(.)
            let $lat as xs:double := $place/descendant::m:lat ! number(.)
            let $long as xs:double := $place/descendant::m:long ! number(.)
            let $titles as xs:string* :=$place/descendant::m:article ! string(.)
            let $print-titles as xs:string := string-join($titles, ', ')
           (: let $links as xs:string* := $place/descendant::m:article/@xml:id ! ('read?id=' || .) :)
            return
                <fn:map>
                    <fn:string
                        key='type'>Feature</fn:string>
                    <fn:map
                        key='geometry'>
                        <fn:string
                            key='type'>Point</fn:string>
                        <fn:array
                            key='coordinates'>
                            <fn:number>{$long}</fn:number>
                            <fn:number>{$lat}</fn:number>             
                        </fn:array>
                    </fn:map>
                    <fn:map
                        key='properties'>
                      <fn:string
                            key='name'>{$name}</fn:string>
                      <fn:string
                            key="appears">Appears in {$print-titles}</fn:string>     
                      <!-- <fn:array key="links">     
                        {for-each-pair(
                          $titles, $links, 
                          function($title as xs:string, $link as xs:string)
                          {  <fn:map key='article'>
                              <fn:string key='title'>{$title}</fn:string>    
                              <fn:string key='URL'>{$link}</fn:string>
                              </fn:map>
                           })} 
                           </fn:array> --> 
                    </fn:map>
                </fn:map>
        }
    </fn:array>
</fn:map>;

declare variable $geojson as xs:string := concat('const geojson = ', xml-to-json($map), ';') ;

<html:section id="map-viz"> 

<html:div id="map"></html:div>

<html:div id="drawingPara">

<html:div id="drawing">
<html:figure>
<html:img src="resources/img/stjames.jpg"></html:img>
</html:figure>
</html:div>

<html:script>
{concat($js-front, $geojson, $js-back)}
</html:script>
<xi:include href="/db/apps/pr-app/resources/includes/maps.xhtml"/>

</html:div>

</html:section>
