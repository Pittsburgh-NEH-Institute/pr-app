xquery version "3.1";
declare variable $articles as document-node()+ := collection('/db/apps/pr-app/data/hoax_xml');
for $article in $articles
group by $id := $article/*/@xml:id
where count($article) gt 1
return string-join(($id ! string(.), ($article ! base-uri(.) ! tokenize(., '/')[last()] => string-join(', '))), ': ')