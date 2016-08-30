package gov.nih.nlm.lode.tests;

import org.testng.annotations.Test;

import java.util.regex.*;

import static org.testng.Assert.*;
import static org.hamcrest.CoreMatchers.*;
import static org.hamcrest.MatcherAssert.assertThat;

public class LinkCheckerTest {

    public static final String NLM_NEWS_BASE_URI = "http://www.nlm.nih.gov/news/";

    public static final String BADLINK = "http://www.nlm.nih.gov/google11111111.html";

    @Test(groups = "linkcheck") 
    public void testBasicAbsURL() {
        LinkChecker links = new LinkChecker();
        links.add(NLM_NEWS_BASE_URI + "newsevents.html");
        links.shouldBeValid();
    }

    @Test(groups = "linkcheck")
    public void testBasicURLWithContext() {
        LinkChecker links = new LinkChecker();
        links.add(NLM_NEWS_BASE_URI, "newsevents.html");
        links.shouldBeValid();
    }


    @Test(groups = "linkcheck")
    public void testBasicLinkCheckerContext() {
        LinkChecker links = new LinkChecker(NLM_NEWS_BASE_URI);
        links.add("/about");
        links.shouldBeValid();
    }

    @Test(groups = "linkcheck")
    public void testMultipleLinks() {
        LinkChecker links = new LinkChecker(NLM_NEWS_BASE_URI);
        links.add("/about");
        links.add("newsevents.html");   
        links.add("2015.html");
        links.shouldBeValid();
    }

    @Test(groups = "linkcheck")
    public void testBadLink() {
        LinkChecker links = new LinkChecker();
        links.add(BADLINK);

        String message = null;
        try {
          links.shouldBeValid(); 
      } catch (AssertionError e) {
          message = e.getMessage();
      }
      assertNotNull(message);
      assertThat(message, endsWith(BADLINK));
    }

    @Test(groups = "linkcheck")
    public void testSkipsFtpLinks() {
        LinkChecker links = new LinkChecker(NLM_NEWS_BASE_URI);
        links.add("ftp://ftp.nlm.nih.gov/online/mesh");
        links.shouldBeValid(); 
    }
}
