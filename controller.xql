xquery version "3.1";
declare namespace html="http://www.w3.org/1999/xhtml";

declare variable $exist:root external;
declare variable $exist:prefix external;
declare variable $exist:controller external;
declare variable $exist:path external;
declare variable $exist:resource external;

declare variable $uri as xs:anyURI := request:get-uri();
declare variable $context as xs:string := request:get-context-path();
declare variable $ftcontroller as xs:string := concat($context, $exist:prefix, $exist:controller, '/');

if ($exist:resource eq '') then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="index"/>
    </dispatch>
else
    if (not(contains($exist:resource, '.')))
    then
        <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
            <forward url="{concat($exist:controller, '/modules', $exist:path, '.xql')}">
                <add-parameter name="exist:controller" value="{$exist:controller}"/>
                <add-parameter name="exist:prefix" value="{$exist:prefix}"/>
            </forward>
            <view>
                (:transformation to html is different for different modules:)
                <forward url="{concat($exist:controller, '/views/', $exist:path, '-to-html.xql')}"/>
                <forward url="{concat($exist:controller, '/views/wrapper.xql')}"/>
            </view>
            <cache-control cache="no"/>
        </dispatch>
    else
        <ignore xmlns="http://exist.sourceforge.net/NS/exist">
            <cache-control cache="yes"/>
        </ignore>
