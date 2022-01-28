# Facets and fields in eXist-db

## About this document

*Facets* and *fields* are part of the *full-text indexing* feature of eXist-db, which is documented at <http://exist-db.org/exist/apps/doc/lucene>. As the name implies, full-text indexing provides a mechanism for retrieving documents according to the words they contain, e.g., “Find all articles that contain the word ‘ghost’.” Developers specify full-text indexing for specific elements, so for a TEI document you can, for example, distinguish whether you want to retrieve documents that contain ‘ghost’ anywhere (that is, in the root `<TEI>` element), just in the main title, in the text but not in the metadata, etc. 

The official eXist-db documentation for full-text indexing is clear, but we find the documentation for facets and fields less clear. The purpose of this document is to provide useful basic examples of how to use facets and fields in an eXist-db app.

## Facets

Facets serve two basic purposes in eXist-db: they provide quick access to counts and they support incremental queries. 

### Configuring facets

The following eXist-db *collection.xconf* index files constructs a facet for the publisher of the document:

```xml
<collection xmlns="http://exist-db.org/collection-config/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0">
    <index xmlns:xs="http://www.w3.org/2001/XMLSchema">
        <!-- Configure lucene full text index -->
        <lucene>
            <analyzer class="org.apache.lucene.analysis.standard.StandardAnalyzer"/>
            <analyzer id="ws" class="org.apache.lucene.analysis.core.WhitespaceAnalyzer"/>
            <text qname="tei:body"/>
            <text qname="tei:placeName"/>
            <text qname="tei:TEI">
                <facet dimension="publisher" expression="descendant::tei:publicationStmt/tei:publisher"/>
            </text>
        </lucene>
    </index>
</collection>%
```

The `<text>` elements support full-text indexing for `<body>`, `<placeName>`, and the root `<TEI>` element, and the `<facet>` child of the configuration the `<TEI>` element says that documents should be retrievable with a facet called `publisher` (the value of the `@dimension` attribute) that refers to the `<publisher>` child of the `<publicationStmt>` element. 

### Why use facets to count

When we run the following query against our corpus:

```xquery
xquery version "3.1";
declare namespace tei="http://www.tei-c.org/ns/1.0";
let $hits as element(tei:TEI)+ := collection('/db/apps/pr-app/data/hoax_xml')/tei:TEI[ft:query(., 'ghost')]
let $facets := ft:facets($hits, "publisher", 100)
return 
    <facet_test>{
        let $facet-elements := 
            map:for-each($facets, function($label, $count) {
                <facet>
                    <label>{$label}</label>
                    <count>{$count}</count>
            </facet>})
        for $facet-element in $facet-elements
        order by $facet-element/count descending,
            $facet-element/label
        return $facet-element
    }</facet_test>
```

it returns a list of all publishers with the numbers of times their publications occur in the corpus. The output is sorted in descending order by frequency, and then subsorted alphabetically by publisher name:

```xml
<facet_test>
    <facet>
        <label>The Times</label>
        <count>8</count>
    </facet>
    <facet>
        <label>The Leader</label>
        <count>3</count>
    </facet>
    <facet>
        <label>The Penny Satirist</label>
        <count>3</count>
    </facet>
    <facet>
        <label>John Bull</label>
        <count>2</count>
    </facet>
    <facet>
        <label>The Age</label>
        <count>2</count>
    </facet>
    <facet>
        <label>Altrincham Guardian</label>
        <count>1</count>
    </facet>
    <facet>
        <label>Bell's Life in London and Sporting Chronicle</label>
        <count>1</count>
    </facet>
    <facet>
        <label>Bell’s Life in London and Sporting Chronicle</label>
        <count>1</count>
    </facet>
    <facet>
        <label>Chambers's Journal</label>
        <count>1</count>
    </facet>
    <facet>
        <label>Cleave's Weekly Police Gazette</label>
        <count>1</count>
    </facet>
    <facet>
        <label>Douglas Jerrold's Weekly Newspaper</label>
        <count>1</count>
    </facet>
    <facet>
        <label>Household Words</label>
        <count>1</count>
    </facet>
    <facet>
        <label>Morning Chronicle</label>
        <count>1</count>
    </facet>
    <facet>
        <label>Sunderland Herald</label>
        <count>1</count>
    </facet>
    <facet>
        <label>The Cabinet Newspaper</label>
        <count>1</count>
    </facet>
    <facet>
        <label>The English Leader</label>
        <count>1</count>
    </facet>
    <facet>
        <label>The London Reader</label>
        <count>1</count>
    </facet>
    <facet>
        <label>The Morning Post</label>
        <count>1</count>
    </facet>
    <facet>
        <label>The Odd Fellow</label>
        <count>1</count>
    </facet>
    <facet>
        <label>The People’s Advocate</label>
        <count>1</count>
    </facet>
    <facet>
        <label>The Satirist; or Censor of the Times</label>
        <count>1</count>
    </facet>
    <facet>
        <label>The Weekly Times</label>
        <count>1</count>
    </facet>
    <facet>
        <label>Weekly Times</label>
        <count>1</count>
    </facet>
    <facet>
        <label>Weekly True Sun</label>
        <count>1</count>
    </facet>
    <facet>
        <label>Yankee Notions</label>
        <count>1</count>
    </facet>
</facet_test>
```

We could have written a regular FLWOR expression to return essentially the same results:

```xquery
xquery version "3.1";
declare namespace tei="http://www.tei-c.org/ns/1.0";
let $hits as element(tei:TEI)+ := collection('/db/apps/pr-app/data/hoax_xml')/tei:TEI[ft:query(., 'ghost')]
return 
    <facet_test>{
        for $hit in $hits
        group by $publisher := $hit//tei:publicationStmt/tei:publisher[1]
        let $count := count($hit)
        order by $count descending, $publisher
        return <facet>
            <label>{$publisher ! string(.)}</label>
            <count>{$count}</count>
        </facet>
    }</facet_test>
```

One reason to prefer facets to the regular XQuery FLWOR strategy is that with facets the counts are computed at index time, while with FLWOR they are computed at query time. With a small amount of data the difference will not be noticeable, but computing counts at index time has the same advantage as indexing in general: a precomputed value can be retrieved more quickly.

**Note:** XQuery FLWOR expressions since version 3.0 support a `count` clause that can be used for counting members of a group, but that feature is not supported by eXist-db.

Here’s how the facet strategy works:

We can ask about facets only if we first do a full-text query using `ft:query()`. In this case we ask for all documents that contain the word ‘ghost’ anywhere at all (metadata or content). Since our index (above) constructs a full-text index on the root `<TEI>` element, we can retrieve all of the documents by selecting a collection of all `<TEI>` elements in the corpus and using `ft:query()` in a predicate to ask for documents in that collection that contain ‘ghost’. We save the result of this query to a variable we call `$hits`.

**Note:** Because of the way that eXist-db indexed retrieval works, we must specify the documents and the predicate in the same statement. The following, although the XPath within it is informationally identical to that of the version above, will not reliably produce correct results in eXist-db because it selects the documents on one line and applies the predicate on a different line:

```xquery
let $articles as element(tei:TEI)+ := 
    collection('/db/apps/pr-app/data/hoax_xml')/tei:TEI
let $hits as element(tei:TEI)+ := $articles[ft:query(., 'ghost')]
```

One we have bound the variable `$hits` to the `<TEI>` elements that contain ‘ghost’ we then use the `ft:facets()` function to return the values (publisher names) with their frequencies. The first argument to the function `ft:facets()` is the result of `ft:query()` (in this case the `$hits` variable), the second argument is the name of the `@dimension` we declared for the publisher facet in the index (in this case the string `"publisher"`), and the third argument (which is optional) is the maximum number of results to return (in this case, we ask for the first 100 publishers, or all results if there are fewer than 100). 

The `ft:facets()` function returns a *map*, which is a structure that contains *key:value* pairs. In this case each unique `<publisher>` element in the corpus is a *key* and the associated *value* is the number of documents included in our `$hits` collection that has that specific `<publisher>` value. Maps cannot easily be serialized (rendered, printed) directly, and we want to convert the map structure into XML anyway because our target output format is HTML with XML syntax. Furthermore, the map returned by `ft:facets()` is automatically sorted from highest to lowest counts, which is part of what we want, but the keys with the same count come back in an unpredictable order, and we want to alphabetize them in our output, which means that we need to sort them. We deal with these properties of maps by using the `map:for-each()` function to say:

1. Take each *key: value* pair.
2. Bind the variable name `$label` to the key (the name of the publisher) and the variable name `$count` to the count (the number of times that publisher appears in the collection of documents bound for `$hits`).
3. Create an XML `<facet>` element (you can call it whatever you want) with two children and write the label and count values into the children.
4. Bind that sequence of `<facet>` elements to a variable called `$facet-elements`, and use a FLWOR to traverse over the values (`for`), sort them the way we want (`order by`), and output them in the new order.

### Incremental faceted searching

Do stuff 

## Fields

Do stuff
