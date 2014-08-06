## Create a new graph

***Note that these require administrator privileges, so can only be executed through the
interactive SQL interface (see the link in the upper left of the Virtuoso Conductor screen).***

This SPARQL query generates a new graph of transitive skos:broader relations, using
the tree numbers.

```
SPARQL

PREFIX mesh: <http://id.nlm.nih.gov/mesh/>
PREFIX meshv: <http://id.nlm.nih.gov/mesh/vocab#>
PREFIX purl: <http://purl.org/dc/terms/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

INSERT INTO <http://mor.nlm.nih.gov/mesh2014-tc>
{ ?child skos:broader ?parent }
WHERE
{
  {
    select distinct ?child ?upper
    from <http://mor.nlm.nih.gov/mesh2014>
    {
      ?parent meshv:treeNumber ?upper .
      ?child meshv:treeNumber ?lower .
      FILTER (?upper = fn:substring(?lower, 1, (fn:string-length(?lower) - 4)))
    }
  }
}
;
checkpoint;
```

