import module namespace cmark = "http://example.com/#cm_dispatch";
declare variable $src external;

try {
let $scheme := 'http://'
let $dbPath :=   $src =>  replace('.md','') => substring-after('/data/')
let $dbPathTokens := $dbPath => tokenize('/')
let $dbPathTokensCount := $dbPathTokens => count()
let $dbcollection := $dbPathTokens => remove($dbPathTokensCount ) => string-join('/')
let $dbDomain := $dbPathTokens => subsequence(1,1)
let $dbItem := $dbPathTokens => subsequence($dbPathTokensCount)
let $xBody := db:get( $scheme || $dbPath )
let $fmData := $xBody => cmark:frontmatter()
let $hContent :=  map:entry( 'content', cmark:dispatch( $xBody ))
let $layout := db:get( "http://example.com/docs/" || $fmData?layout )
let $htm := map:merge(($fmData  ,$hContent)) => $layout() => serialize(map{"method": "html"})
let $dir := file:create-dir("priv/static/assets/" || $dbcollection )
let $file := "priv/static/assets/" || $dbPath || ".html"
let $wrt := file:write-text( $file, $htm )
return (
$file
)} catch * { "failed: documentation" }
