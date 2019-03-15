package gov.nih.nlm.lode.servlet;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.hp.hpl.jena.graph.Graph;
import com.hp.hpl.jena.query.QueryExecution;
import com.hp.hpl.jena.query.QuerySolution;
import com.hp.hpl.jena.query.QuerySolutionMap;
import com.hp.hpl.jena.query.ResultSet;
import com.hp.hpl.jena.rdf.model.Resource;
import com.hp.hpl.jena.rdf.model.ResourceFactory;

import gov.nih.nlm.lode.model.JenaResourceService;
import uk.ac.ebi.fgpt.lode.exception.LodeException;
import uk.ac.ebi.fgpt.lode.service.JenaQueryExecutionService;


/**
 * Given a SPARQL query and variables to bind, translates them into resulting resources or labels
 *
 * @author davisda4
 */
@Service
public class JenaResourceServiceImpl implements JenaResourceService {

    private Logger log = LoggerFactory.getLogger(getClass());
    private JenaQueryExecutionService executionService;

    @Override
    public Collection<String> getResourcesFromLabel(String query, String label, int limit) throws LodeException {
        QuerySolutionMap initialBinding = new QuerySolutionMap();
        initialBinding.add("bound", ResourceFactory.createLangLiteral(label, "en"));

        Graph g = getExecutionService().getDefaultGraph();
        QueryExecution endpoint = getExecutionService().getQueryExecution(g, query, initialBinding, true);

        ArrayList<String> resultList = new ArrayList<String>();
        try {
            ResultSet results = endpoint.execSelect();
            while (results.hasNext()) {
                QuerySolution solution = results.next();
                Resource res = solution.getResource("resource");
                if (res.isAnon()) {
                    continue;
                }
                resultList.add(res.getURI());
            }
        } catch (Exception ex) {
            log.error("Error retrieving results for " + query, ex);
        } finally {
            if (endpoint != null) {
                endpoint.close();
            }
            if (g != null) {
                g.close();
            }
        }
        return resultList;
    }

    @Override
    public Collection<String> getLabelsFromResource(String query, String resourceUri) {
        return Arrays.asList(new String[] {});
    }

    public JenaQueryExecutionService getExecutionService() {
        return executionService;
    }

    @Autowired
    @Qualifier("jenaVirtuosoConnectionPoolService")
    public void setExecutionService(JenaQueryExecutionService executionService) {
        this.executionService = executionService;
    }
}
