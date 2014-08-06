# Create a new graph

This SPARQL query generates a new graph of transitive skos:broader relations, using
the tree numbers.

```sparql
log_enable(2);

SPARQL

PREFIX mesh: <http://id.nlm.nih.gov/mesh/>
PREFIX meshv: <http://id.nlm.nih.gov/mesh/vocab#>
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
      ?parent meshv:treeNumber ?upper .
      ?parent purl:identifier ?id .
      ?child meshv:treeNumber ?lower .
      #FILTER REGEX(?lower, concat(?upper,".[0-9]*$$"))
      FILTER (?upper = fn:substring(?lower,1,(fn:string-length(?lower)-4)))
    }
  }
}
;
checkpoint;
```

This example had the label "Create MeSH Transitive Closure Agnostic".  Not sure what it does.

```sparql
log_enable(2);

SPARQL

PREFIX mesh: <http://nlm.nih.gov#MeSH:>
PREFIX purl: <http://purl.org/dc/terms/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

INSERT INTO <http://mor.nlm.nih.gov/mesh_tci_2014-v1>
{ 
	?child skos:broader ?parent 
}

WHERE
{
	{

		SELECT distinct ?child ?parent 

		from <http://mor.nlm.nih.gov/mesh2014-v1>

		WHERE
  		{
    			{
				SELECT ?child ?parent
      
				from <http://mor.nlm.nih.gov/mesh2014-v1>
      
				WHERE
				{
					?child skos:broader ?parent .
        			}
    			}
			OPTION ( transitive, t_in (?child), t_out (?parent), t_distinct, t_min (0) ) .

			#the following two lines implement the constraint that 
			#only the mesh tree number hierarchy is followed (not total TC)
			?parent mesh:treeNumber ?upper .
                        #?child mesh:treeNumber ?lower FILTER ( contains(?lower, ?upper) ).     
		} 
	}
}
;

checkpoint;
```



