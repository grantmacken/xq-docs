 <!--
 title: xqerl documentation
 layout: docs_tpl
-->

To use [xqerl](https://zadean.github.io/xqerl) you don't need to learn erlang, however since
xqerl is a xQuery 3.1 application server you do need to know a bit about xQuery.

TODO: point to resources 

## Getting started

In our examples we are going to use podman instead of docker,
however you can use docker instead by replacing the word podman with docker.
since podman and docker commands a pretty much the same.

If you want to install podman [follow these instructions](https://podman.io/getting-started/installation)


```
podman pull ghcr.io/grantmacken/xqerl:0.0.23
podman run --rm --name xq \
		--publish 8081:8081 \
    --detach \
    ghcr.io/grantmacken/xqerl:0.0.23
```



## storing data from sources

1. Source structured markup data like XML and JSON can be parsed and stored in the xqerl databased as XDM items as defined in
the [XQuery and XPath Data Model](https://www.w3.org/TR/xpath-datamodel-31)

2. If the data source is not marked up then the this data can be stored as unparsed text. 

3. If the data source is binary then a link item pointing to the file location can be stored in the database.

4. Finally the xqerl database can store XDM items like maps and arrays functions


Xqerl is a xQuery 3.1 application server, with a built in database that
can store any XDM item. These XDM database items include document-nodes, maps, arrays, and even functions

# data sources

The xQuery 3.1 Processor for xqerl is 
* a **well tested** xQuery 3.1 Processor
* built for xQuery 3.1, with **no prior baggage** making it more lean.
* built with erlang, compiled to run as a **reliable** OTP beam application


