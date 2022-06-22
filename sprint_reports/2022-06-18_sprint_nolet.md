# Sprint Nolet 2022-06-18 (whoops, we have been bad at meeting notes recently)
## Wins
- visualization is on its way!
- In Progress: merge title / search interfaces into one useful view
- Gabi relearned SVG (and viewBox which is camelCase for no good reason)

## Gabi to-do
- [] map all articles
	- create XQuery that pulls all the data in the format you want
	- add features
	- figure out how to do this without putting the API keys in Git (hosted vs distributed application)
- distill https://github.com/Pittsburgh-NEH-Institute/pr-app/issues/12 into a tutorial + resources
- [] visualization
    - set more constants
    - draw points within a `for` loop, set local variables each time
        ```
        for $article in $articles
            let $word-count := word-count()
            let $place-count: = place-count()
            return
                <line $word-count $place-count/>
                <circle $word-count/>
                <circle $place-count/>
        ``` 
    - refine x-axis approach based on how bad that ends up looking       
- [] ODD work and schema generation
	- Read materials from Elli
	- start with TEI bare and then add on, since there's not that much to add
	- Roma
	- confer with Elli on outcome
- [] CSS + read.xql		
- [] start working with Chelcie on project management
- [] make ghost tags more consistent
- [] write guide article

## David to-do
- Learn CSS tabs (in progress)
- Implement Shea's suggestions around faceted searching
- Match instructors to sessions

## Emma to-do
- Canny Scot article transcription + markup (Gabi to email)

## Sprint Meeting Filliers @ 2022-06-25
- Code Review, new markup review + administrative tasks