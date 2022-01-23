# Sprint Rogue Pink Spruce - 2022-01-22
## Wins
- sent participants email regarding their standing acceptance
- ordered sushi
- understood how replace() works and learned something about functional programming
- wrote more facet and field examples

## Carryover
- distribute call for applications, which we will do at the next meeting (we need to verify dates)
- David to write to Bill Campbell
- Gabi continuing wireframe learning material based on our wireframe notecards
- Gabi continuing guide .xql modules and their accompanying views

## Backburner
- Reading API issue (we want to wait for more eyeballs, specifically Hugh's). Whether we should use stuff/read/hammersmith_times_1804 or stuff/read?title=hammersmith_times_1804
- we need to breakdown documentation writing into smaller tasks next time we meet (this should be its own independent meeting)
- Gabi to revisit the controller documentation ahead of next meeting, so we can actually break down our documentation writing like we said we want to (http://dh.obdurodon.org/eXist-app.xhtml)

## Concerns / Thrills!
- What are our short, mid, and long term goals? When should we aim to be "done" as it were with the application itself?

# Looking forward
- Sprint Bowling and Burch @ 2022-01-26 at 3pm - Planning Meeting + Call for Apps
- Gabi either address carryover or write the facet for decade sorting
- David track participant responses

# Notes

- distribute call for applications at the next meeting

- We want to know whether facets can be computed (fields definitely can)

Search interface
Facet vs field
Documentation could be more complete.
Configured with XPath expressions, and the selection is mapped to a name.

Facet returns name and count - they can also be used to filter searching
Ex: When you search "ghost" and you want to filter by decades, you can select a checkbox like
    [] 1800s (5)
    [] 1810s (3)

by using the first three digits of the date value to sort
AI: Gabi try to build this facet based on docs

Field allows computed values (ie, if else else \[unknown\]). Computes at indexing time.

Built a "theme" field to track "rs/@ref" attribute values and begin designing the search interface in dev/facet-field-example.xql

