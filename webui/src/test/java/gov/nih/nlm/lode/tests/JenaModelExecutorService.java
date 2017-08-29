package gov.nih.nlm.lode.tests;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.hp.hpl.jena.graph.Graph;
import com.hp.hpl.jena.query.Query;
import com.hp.hpl.jena.query.QueryExecution;
import com.hp.hpl.jena.query.QueryExecutionFactory;
import com.hp.hpl.jena.query.QuerySolutionMap;
import com.hp.hpl.jena.rdf.model.Model;
import com.hp.hpl.jena.query.Dataset;

import uk.ac.ebi.fgpt.lode.exception.LodeException;
import uk.ac.ebi.fgpt.lode.service.JenaQueryExecutionService;

public class JenaModelExecutorService implements JenaQueryExecutionService {
	
	private Logger log = LoggerFactory.getLogger(getClass());	
	private Model model;
	
	public JenaModelExecutorService(Model model) {
		this.model = model;
	}
	
	public JenaModelExecutorService() {
		this(null);
	}
	
	public Model getModel() {
		return model;
	}
	
	public void setModel(Model model) {
		this.model = model;;
	}

	@Override
	public Graph getDefaultGraph() {
		return null;
	}

	@Override
	public Graph getNamedGraph(String graphName) {
		return null;
	}

	@Override
	public QueryExecution getQueryExecution(Graph g, Query query, boolean withInference) throws LodeException {
        if (model == null) {
            throw new LodeException("You must associate a model");
        }
		return QueryExecutionFactory.create(query, model);
	}

	@Override
	public QueryExecution getQueryExecution(Graph g, String query, QuerySolutionMap initialBinding, boolean withInference)
			throws LodeException {
		
		/** 
		 * "withInference" allows Lodestar to pass the desire for interface to Virtuoso,
		 * but does not really turn inference on or off.
		 */
		if (model == null) {
            throw new LodeException("You must associate a model");
        }
		return QueryExecutionFactory.create(query, model, initialBinding);
	}
}
