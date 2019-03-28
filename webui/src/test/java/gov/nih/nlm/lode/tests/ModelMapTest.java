package gov.nih.nlm.lode.tests;

import static org.hamcrest.CoreMatchers.anyOf;
import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.CoreMatchers.notNullValue;
import static org.hamcrest.MatcherAssert.assertThat;

import java.io.ByteArrayOutputStream;
import java.net.URL;

import org.apache.jena.rdf.model.Model;
import org.apache.jena.rdf.model.Resource;
import org.apache.jena.rdf.model.StmtIterator;
import org.apache.jena.riot.RDFDataMgr;
import org.testng.annotations.Test;

import uk.ac.ebi.fgpt.lode.exception.LodeException;
import uk.ac.ebi.fgpt.lode.impl.JenaSparqlService;


@Test(groups = "unit")
public class ModelMapTest {

	private Model model;

	private static final String SAMPLES_FILE = "samples.nt";
	private static final String CONCEPT_URI = "http://id.nlm.nih.gov/mesh/C012734";

	public ModelMapTest() {
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		URL url = loader.getResource(SAMPLES_FILE);
		this.model = RDFDataMgr.loadModel(url.toString());
	}

	@Test(description="Verify model loaded successfully")
	public void testAllStatements() {
        StmtIterator iterator = model.listStatements();
        int count = 0;
		while (iterator.hasNext()) {
			iterator.nextStatement();
            count++;
        }
		assertThat(count, is(equalTo(7001)));
	}

	@Test(description="Verify URI is present in model")
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

	@Test(description="Verify that we can use unit tests")
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
        assertThat(buffer.size(), is(anyOf(equalTo(1672), equalTo(1647), equalTo(1612), equalTo(1585))));

        buffer.reset();
        service.query(describeQuery, "TURTLE", false,  buffer);
        assertThat(buffer.size(), is(equalTo(1594)));
	}
}
