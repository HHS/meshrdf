/open DEFAULT
/open PRINTING

import org.apache.jena.graph.Graph;
import org.apache.jena.query.ParameterizedSparqlString;
import org.apache.jena.query.Query;
import org.apache.jena.query.QueryFactory;
import org.apache.jena.query.QuerySolutionMap;
import org.apache.jena.query.Syntax;
import org.apache.jena.vocabulary.*;

import org.yaml.snakeyaml.Yaml;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.jayway.jsonpath.JsonPath;
import org.apache.commons.io.IOUtils;

import uk.ac.ebi.fgpt.lode.impl.JenaVirtuosoConnectionPoolService;
import uk.ac.ebi.fgpt.lode.impl.JenaHttpExecutorService;
import uk.ac.ebi.fgpt.lode.service.JenaQueryExecutionService;
import uk.ac.ebi.fgpt.lode.utils.DatasourceProvider;
import uk.ac.ebi.fgpt.lode.utils.GraphQueryFormats;
import uk.ac.ebi.fgpt.lode.utils.TupleQueryFormats;

import gov.nih.nlm.lode.data.VirtuosoSimpleDatasourceProvider;

System.setProperty("catalina.base", "target");
new File("target/logs").mkdirs();

var yaml = new Yaml();
var mapper = new ObjectMapper();
var pretty = mapper.writerWithDefaultPrettyPrinter();


public DatasourceProvider getProvider(String hostname, String username, String password) {
    return new VirtuosoSimpleDatasourceProvider(hostname, username, password);
}

public JenaQueryExecutionService getExecutor(DatasourceProvider provider) {
    return new JenaVirtuosoConnectionPoolService(provider);
}

