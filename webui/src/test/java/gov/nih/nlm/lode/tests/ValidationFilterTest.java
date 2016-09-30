package gov.nih.nlm.lode.tests;

import static org.hamcrest.CoreMatchers.*;
import static org.hamcrest.MatcherAssert.assertThat;

import java.io.IOException;

import javax.servlet.ServletException;

import org.springframework.mock.web.MockFilterChain;
import org.springframework.mock.web.MockFilterConfig;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

import gov.nih.nlm.lode.servlet.ValidationFilter;

@Test(groups="unit")
public class ValidationFilterTest {

    private MockFilterChain filterChain;
    private MockFilterConfig filterConfig;

    @BeforeClass(alwaysRun=true)
    public void setUp() {
        filterChain = new MockFilterChain();
        filterConfig = new MockFilterConfig();
    }

    @Test
    public void testOK() throws ServletException, IOException {
        ValidationFilter filter = new ValidationFilter();

        MockHttpServletRequest request = new MockHttpServletRequest();
        MockHttpServletResponse response = new MockHttpServletResponse();

        request.addParameter("resource_prefix", "../..");
        request.addParameter("uri", "http://id.nlm.nih.gov/mesh/2015/D999999");

        filter.init(filterConfig);
        filter.doFilter(request, response, filterChain);
        filter.destroy();

        assertThat(response.getStatus(), is(equalTo(200)));
    }

    @Test
    public void testBadPrefix() throws ServletException, IOException {
        ValidationFilter filter = new ValidationFilter();

        MockHttpServletRequest request = new MockHttpServletRequest();
        MockHttpServletResponse response = new MockHttpServletResponse();

        request.addParameter("resource_prefix", "../q.");
        request.addParameter("uri", "http://id.nlm.nih.gov/mesh/2015/D999999");

        filter.init(filterConfig);
        filter.doFilter(request, response, filterChain);
        filter.destroy();

        assertThat(response.getStatus(), is(equalTo(422)));
        assertThat(response.getErrorMessage(), containsString("resource_prefix"));
    }

    @Test
    public void testBadUri() throws ServletException, IOException {
        ValidationFilter filter = new ValidationFilter();

        MockHttpServletRequest request = new MockHttpServletRequest();
        MockHttpServletResponse response = new MockHttpServletResponse();

        request.addParameter("resource_prefix", "../..");
        request.addParameter("uri", "http://id.nlm.nih.gov/mesh/!letsdoit");

        filter.init(filterConfig);
        filter.doFilter(request, response, filterChain);
        filter.destroy();

        assertThat(response.getStatus(), is(equalTo(422)));
        assertThat(response.getErrorMessage(), containsString("uri"));

    }
}
