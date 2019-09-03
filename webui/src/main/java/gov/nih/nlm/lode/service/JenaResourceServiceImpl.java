package gov.nih.nlm.lode.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;

import org.apache.jena.graph.Graph;
import org.apache.jena.query.QueryExecution;
import org.apache.jena.query.QuerySolution;
import org.apache.jena.query.QuerySolutionMap;
import org.apache.jena.query.ResultSet;
import org.apache.jena.rdf.model.Literal;
import org.apache.jena.rdf.model.Resource;
import org.apache.jena.rdf.model.ResourceFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.ibm.icu.text.Transliterator;

import gov.nih.nlm.lode.model.JenaResourceService;
import gov.nih.nlm.lode.model.ResourceResult;
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
    private int fulltextMinLength = 4;

    public String buildContainsArg(String label) throws LodeException {
        StringBuffer termbuf = new StringBuffer();
        try {
            termbuf.append("'");
            for (String term : TextUtils.tokenize(label)) {
                if (term.length() >= fulltextMinLength) {
                    /* Transforms a label like "Chemi" to a literal like "'Chemi*'" for use with bif:contains */
                    termbuf.append(term);
                    termbuf.append("* ");
                } else {
                    termbuf.append(term);
                    termbuf.append(" ");
                }
            }
            termbuf.append("'");
        } catch (IOException ex) {
            log.error("unable to tokenize label", ex);
            throw new LodeException("unable to tokenize label", ex);
        }
        return termbuf.toString();
    }

    @Override
    public Collection<ResourceResult> getResources(String query, String label, int limit, String parentUri) throws LodeException {
        QuerySolutionMap initialBinding = new QuerySolutionMap();
        if (label != null) {
            Transliterator transformer = Transliterator.getInstance("Latin-ASCII");
            String bound = transformer.transform(label).toLowerCase();
            initialBinding.add("bound", ResourceFactory.createPlainLiteral(bound));
            String boundstar = buildContainsArg(bound);
            initialBinding.add("boundstar", ResourceFactory.createPlainLiteral(boundstar));
        }
        if (parentUri != null) {
            initialBinding.add("parent", ResourceFactory.createResource(parentUri));
        }
        if (limit > 0) {
            query += " LIMIT "+limit;
        }
        Graph g = getExecutionService().getDefaultGraph();
        QueryExecution endpoint = getExecutionService().getQueryExecution(g, query, initialBinding, true);

        ArrayList<ResourceResult> resultList = new ArrayList<ResourceResult>();
        try {
            ResultSet results = endpoint.execSelect();
            while (results.hasNext()) {
                QuerySolution solution = results.next();
                Resource rsuri = solution.getResource("resource");
                if (rsuri.isAnon()) {
                    continue;
                }
                Literal rslabel = solution.getLiteral("label");
                Literal preferred = solution.getLiteral("preferred");
                if (preferred != null) {
                    resultList.add(new ResourceResult(rsuri.getURI(), rslabel.getString(), preferred.getBoolean()));
                } else {
                    resultList.add(new ResourceResult(rsuri.getURI(), rslabel.getString()));
                }
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
    public Collection<ResourceResult> getResources(
            String query, String label, int limit) throws LodeException {
        return getResources(query, label, limit, null);
    }

    @Override
    public Collection<ResourceResult> getChildResources(String query, String parentUri)
            throws LodeException {
        return getResources(query, null, 0, parentUri);
    }

    @Override
    public Collection<String> getResourceLabels(String query, String resourceUri) throws LodeException {
        QuerySolutionMap initialBinding = new QuerySolutionMap();
        initialBinding.add("resource", ResourceFactory.createResource(resourceUri));

        Graph g = getExecutionService().getDefaultGraph();
        QueryExecution endpoint = getExecutionService().getQueryExecution(g, query, initialBinding, true);

        ArrayList<String> resultList = new ArrayList<String>();
        try {
            ResultSet results = endpoint.execSelect();
            while (results.hasNext()) {
                QuerySolution solution = results.next();
                Literal label = solution.getLiteral("label");
                resultList.add(label.getString());
            }
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

    public JenaQueryExecutionService getExecutionService() {
        return executionService;
    }

    @Autowired
    @Qualifier("jenaVirtuosoConnectionPoolService")
    public void setExecutionService(JenaQueryExecutionService executionService) {
        this.executionService = executionService;
    }

    public int getFulltextMinLength() {
        return fulltextMinLength;
    }

    @Value("${lode.fulltext.minlength:4}")
    public void setFulltextMinLength(int fulltextMinLength) {
        this.fulltextMinLength = fulltextMinLength;
    }

}
