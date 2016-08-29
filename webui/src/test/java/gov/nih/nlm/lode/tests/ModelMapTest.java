package gov.nih.nlm.lode.tests;

import java.io.ByteArrayOutputStream;
import java.net.URL;

import org.testng.annotations.Test;

import static org.hamcrest.CoreMatchers.*;
import static org.hamcrest.MatcherAssert.assertThat;

import org.apache.jena.riot.RDFDataMgr;
import com.hp.hpl.jena.rdf.model.Model;
import com.hp.hpl.jena.rdf.model.Resource;
import com.hp.hpl.jena.rdf.model.Statement;
import com.hp.hpl.jena.rdf.model.StmtIterator;

import uk.ac.ebi.fgpt.lode.impl.JenaSparqlService;
import uk.ac.ebi.fgpt.lode.exception.LodeException;


public class ModelMapTest {
	
	private Model model;
	
	private static final String SAMPLES_FILE = "samples.nt";
	private static final String CONCEPT_URI = "http://id.nlm.nih.gov/mesh/C012734";
	
	public ModelMapTest() {
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		URL url = loader.getResource(SAMPLES_FILE);
		this.model = RDFDataMgr.loadModel(url.toString());
	}
	
	@Test(groups={"unit"}, description="Verify model loaded successfully")
	public void testAllStatements() {
        StmtIterator iterator = model.listStatements();
        int count = 0;
		while (iterator.hasNext()) {
			iterator.nextStatement();
            count++;
        }
		assertThat(count, is(equalTo(7001)));
	}
	
	@Test(groups={"unit"}, description="Verify URI is present in model")
	public void testConceptPresent() {
        Resource resource = model.getResource(CONCEPT_URI);
        assertThat(resource, is(notNullValue()));       
        StmtIterator iterator = resource.listProperties();
        int count = 0;
        while (iterator.hasNext()) {
        	iterator.nextStatement();
        	count++;
        }
        assertThat(count, is(equalTo(18)));
	}
	
	@Test(groups={"unit"}, description="Verify that we can use unit tests")
	public void testDescribeQueries() throws LodeException {
		JenaSparqlService service = new JenaSparqlService();
		service.setQueryExecutionService(new JenaModelExecutorService(model));
		String describeQuery = String.format("DESCRIBE <%s>", CONCEPT_URI);
		try {
			service.query(describeQuery, "", 0, -1, false, System.out);
		} catch (LodeException e) {
			assertThat(e.getMessage(), is(equalTo("You must specify a SPARQL endpoint URL")));			
		}
		
		ByteArrayOutputStream buffer = new ByteArrayOutputStream();		
        service.query(describeQuery, "RDF/XML", false, buffer);
        assertThat(buffer.size(), is(equalTo(1672)));
        
        buffer.reset();
        service.query(describeQuery, "TURTLE", false,  buffer);
        assertThat(buffer.size(), is(equalTo(1594)));        
	}
}
