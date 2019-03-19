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
import com.hp.hpl.jena.rdf.model.Literal;
import com.hp.hpl.jena.rdf.model.Resource;
import com.hp.hpl.jena.rdf.model.ResourceFactory;

import gov.nih.nlm.lode.model.JenaResourceService;
import gov.nih.nlm.lode.model.ResourceAndLabel;
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
    public Collection<ResourceAndLabel> getResources(String query, String label, int limit, String parentUri) throws LodeException {
        QuerySolutionMap initialBinding = new QuerySolutionMap();
        initialBinding.add("bound", ResourceFactory.createLangLiteral(label, "en"));
        if (parentUri != null) {
            initialBinding.add("parent", ResourceFactory.createResource(parentUri));
        }
        if (limit > 0) {
            query += " LIMIT "+limit;
        }
        Graph g = getExecutionService().getDefaultGraph();
        QueryExecution endpoint = getExecutionService().getQueryExecution(g, query, initialBinding, true);

        ArrayList<ResourceAndLabel> resultList = new ArrayList<ResourceAndLabel>();
        try {
            ResultSet results = endpoint.execSelect();
            while (results.hasNext()) {
                QuerySolution solution = results.next();
                Resource rsuri = solution.getResource("resource");
                if (rsuri.isAnon()) {
                    continue;
                }
                Literal rslabel = solution.getLiteral("label");
                resultList.add(new ResourceAndLabel(rsuri.getURI(), rslabel.getString()));
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
    public Collection<ResourceAndLabel> getResources(
            String query, String label, int limit) throws LodeException {
        return getResources(query, label, limit, null);
    }

    @Override
    public Collection<ResourceAndLabel> getLabelsFromResource(String query, String resourceUri) {
        return Arrays.asList(new ResourceAndLabel[] {});
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
