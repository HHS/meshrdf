log_enable(2);

SPARQL

PREFIX mesh: <http://nlm.nih.gov#MeSH:>
PREFIX purl: <http://purl.org/dc/terms/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

INSERT INTO <http://mor.nlm.nih.gov/mesh2014-v1>
 { ?child skos:broader ?parent }
WHERE
{
    {
  	  select distinct ?child ?parent
  	  from <http://mor.nlm.nih.gov/mesh2014-v1>
	  {
		?parent mesh:treeNumber ?upper .
		?parent purl:identifier ?id .
		?child mesh:treeNumber ?lower .
		#FILTER REGEX(?lower, concat(?upper,".[0-9]*$$"))
		FILTER (?upper = fn:substring(?lower,1,(fn:string-length(?lower)-4))) 
	  }
    }
}
;
checkpoint;
