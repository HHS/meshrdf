package gov.nih.nlm.lode.tests;

import java.io.IOException;
import java.util.List;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.testng.annotations.Test;


@Test(groups = "pagelinks")
public class PagelinksTest extends LodeBaseTest {

  @Test
  public void testHomeScriptTags() throws IOException {
      Document doc = Jsoup.connect(getLodeBaseUrl()).get();
      List<Element> links = doc.select("script[src]");
      shouldBeValidElements(links);
  }

  public void shouldBeValidElements(List<Element> links) {
      // Disabled to troubleshoot deployment issues
      LinkChecker linkcheck = new LinkChecker(getLodeBaseUrl());
      linkcheck.setConnectTimeout(5);
      linkcheck.setSocketTimeout(10);
      linkcheck.addRequestHeader("Accept", "text/html, text/plain, text/turtle");
      linkcheck.addRequestHeader("Upgrade-Insecure-Requests", "1");

      String lodebaseUrl = getLodeBaseUrl();
      for (Element link : links) {
        String tag = link.tagName();
        String href = (tag.equalsIgnoreCase("script") || tag.equalsIgnoreCase("img") ? link.attributes().get("src") : link.attributes().get("href"));
        if (href.startsWith(CANONICAL_PREFIX)) {
            href = href.replace(CANONICAL_PREFIX, lodebaseUrl);
        }
        linkcheck.add(href);
      }
      linkcheck.shouldBeValid();
  }


  @Test
  public void testHomeLinkTags() throws IOException {
      Document doc = Jsoup.connect(getLodeBaseUrl()).get();
      List<Element> links = doc.select("head > link[src]");
      shouldBeValidElements(links);
  }

  @Test
  public void testHomeBodyLinks() throws IOException {
      /* Hack to prevent problems when test is run by CI/CD */
      if (System.getProperty("os.name").equalsIgnoreCase("Linux")) {
          return;
      }
      Document doc = Jsoup.connect(getLodeBaseUrl()).get();
      List<Element> links = doc.select("a[href]").not("[href='#']");

      shouldBeValidElements(links);
  }

  @Test
  public void testExplorerScriptTags() throws IOException {
      Document doc = Jsoup.connect(getExplorerPageUrl(false)).get();
      List<Element> links = doc.select("script[src]");
      shouldBeValidElements(links);
  }

  @Test
  public void testExplorerlinkTags() throws IOException {
      Document doc = Jsoup.connect(getExplorerPageUrl(false)).get();
      List<Element> links = doc.select("head > link[src]");
      shouldBeValidElements(links);
  }

  @Test
  public void testExplorerLodestarLinks() throws IOException {
      Document doc = Jsoup.connect(getExplorerPageUrl(false)).get();
      List<Element> lodeExploreLinks = doc.select("#lodestar-contents_lode_explore a");
      shouldBeValidElements(lodeExploreLinks);
  }

  @Test
  public void testExplorer2015LodestarLinks() throws IOException {
      Document doc = Jsoup.connect(getExplorerPageUrl(true)).get();
      List<Element> lodeExploreLinks = doc.select("#lodestar-contents_lode_explore a");
      shouldBeValidElements(lodeExploreLinks);
  }
}
