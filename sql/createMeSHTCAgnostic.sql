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
