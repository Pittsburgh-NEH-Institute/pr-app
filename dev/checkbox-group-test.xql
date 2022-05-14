declare variable $checkboxes as xs:string* := request:get-parameter('publishers[]', ());
(: parameter name must end in [] if it can contain multiple values :)
<stuff>{
    for $value in $checkboxes
    return <value>{$value}</value>
}</stuff>