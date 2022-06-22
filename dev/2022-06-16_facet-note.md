# Search result possibilities

## 2022-06-17 Shea 

Update on every click
Total number of hits at top
All facet possibilities visible at all times, even with 0 values
Count shows number that matches the other facet

Results depend on a combination of search term plus publisher facets plus date facets.

____

## Older method

### Normally the search returns results (DONE)

For both publishers and dates, whether a value has been selected or not, show:

1. Checked values, which can be unchecked to exclude those results.
2. Unchecked value, which can be checked to broaden results.

**Issue:** Select no dates and publisher with just one article. Search returns a single unchecked date facet, as if for further selection, but checking or not makes no difference because there is only one result. Yet the presence of a box suggests that checking or unchecking it should change the results.

This is a specialized case of a more general contradition in the interface: choosing no values for a facet category is equivalent to choosing all value. Perhaps for that reason we don’t care.

### If no results, there are three options

Options depend on whether there is or is not a query term and, if there is, whether it appears nowhere in the corpus, or just not in the documents that match selected facets.

#### No query term and no results for facet combinations

Selected facet values would not normally be returned because they have no hits. Currently the return is publishers that match the selected dates, but the selected dates are not shown because they have zero hits, and vice versa. Therefore:

1. Report that the combination of publishers and dates yields no intersection.
2. Report selected values on right side in lists.
3. Explain that left side can be used to select publishers that match the chosen dates and vice versa.
4. Show default facet choices, which are not intuitive, but we’ve added the explanation.

#### Query string not found anywhere in corpus, with or without facet selection

Facets selections don’t matter if query string is nowhere in corpus because no broadening will help. Create an entirely new search, but show error report in article column instead of all articles. This means:

1. Report that the term does not occur anywhere in the corpus.
2. Clear the term input box in the widgets.
3. Show all facets.

#### Query string occurs in other documents, but not in facet selection

1. Run query just on query string without including facets. 
2. Report that facets didn’t match, followed by all articles that do match query string without regard to facet selections.
3. Show facets that are relevant for unfaceted query-string search.