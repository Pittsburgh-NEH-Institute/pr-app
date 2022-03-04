# 2022-03-03 Planning meeting notes + task chunking
## To-do before planning meeting
- NEH report (done)
- process applications (not yet completed)
- follow up with accepted participants (not yet completed)

## David - to do (urgently)
- process applications
- follow up with accepted participants

## agenda for planning meeting
- define and chunk development tasks (done)
- talk about how to manage releases and versions as a pedagogical tool (ongoing)

## admin to-do
- review applications + refer to Ronald
- write to Hugh about API structure + releases, talk to Ronald too
- define and chunk documentation tasks (cont.)
- Talk about XQuery lessons w Emma (and Cliff)

## development work chunks
- style the app with CSS 
    - foundation flexbox (https://css-tricks.com/snippets/css/a-guide-to-flexbox/)
    - baby styling, colors, fonts, sizes, layout
    - each page layout + uniform look and feel
    - banner, header, nav bar for wrapper
    - out of scope: page specific CSS, JS, images
    - result: one CSS file linked from the wrapper HTML. CSS file will live in a new directory called assets/ with subdirectories called css/ js/ img/ inc/

- navigation bar and header
    - wrapper html file must include links to the .xql files that create each landing page. ie titles.xql + placeholders (people.xql, places.xql, about.xql)
    - out of scope: building out submenus, linking out of read/ article views, adding .xml files to titles.xql listings
    - result: changes to wrapper html and create placeholder .xql modules

- 'complete' first 'release'
    - learn something about software versioning, semantic version major.minor.patch
    - don't actually change anything, because this release should be 1.0.0
    - in the future, this will be updated in expath-pkg.xml and via GitHub

- read.xql and typeswitch
    - create typeswitch rules for informational markup to lay groundwork for presenting material
    - out of scope: styling or linking to other pages
    - result: changes to read.xql

- tei.xql returns xql file in the browser or via curl
    - tei?titlename_year.xml will return titlename_year.xml in the browser when the full path is provided in the URL bar
    - create a controller rule to handle this
    - out of scope: wrappers, CSS
    - result: users can view TEI XML files

- places.xql and persons.xql
    - each of these files should return a list of their respective content
    - return the XML inside wrapper with universal CSS (persons-to-html.xql, places-to-html.xql, etc)
    - controller rules to handle these
    - out of scope: no links, no styling, no tables
    - result: personography and placeography returned as lists

- implement TF/IDF (not part of release/app yet)
    - David to implement
    - goal: generate keywords for documents, to be used when we implement search/display/cluster later on