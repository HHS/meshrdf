package gov.nih.nlm.lode.tests;

import java.util.List;

import org.openqa.selenium.WebElement;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.By;

import static org.hamcrest.CoreMatchers.*;
import static org.hamcrest.MatcherAssert.assertThat;

import gov.nih.nlm.occs.selenium.SeleniumTest;

/**
 * Having our own base class limits dependence on SeleniumTest,
 * and allows us to find elements after opening a page.
 */
public class LodeBaseTest extends SeleniumTest {

  public static final String OFLAXIN_RELURI = "/D015242";
  public static final String YEAR_PREFIX = "/2015";
  public static final String CANONICAL_PREFIX = "http://id.nlm.nih.gov/mesh";

  public String getLodeBaseUrl() {
    if (baseUrl == null || baseUrl.equals("")) {
      return "https://iddev.nlm.nih.gov/mesh";
    } else {
      return baseUrl;
    }
  }

  public String getCurrentBaseUrl() {
    String href = null;
    try {
      WebElement basetag = driver.findElement(By.xpath("//head/base"));
      if (null != basetag) {
        href = basetag.getAttribute("href");
      }
    } catch (NoSuchElementException e) {
      // DO NOTHiNG
    }
    if (null == href) {
      href = driver.getCurrentUrl();
    }
    return href;
  }

  public WebElement navigationShouldBeValid() {

    WebElement navi = findElement(By.cssSelector("#home > .navi ul"));
    elementShouldBeEnabled(navi);

    WebElement rdfhome  = navi.findElement(By.xpath("li[1]/a"));
    elementTextShouldBe(rdfhome, "Home");
    assertThat(rdfhome.getAttribute("href"), startsWith(getLodeBaseUrl()));

    WebElement query = navi.findElement(By.xpath("li[2]/a"));
    elementTextShouldBe(query, "SPARQL Query Editor");
    assertThat(query.getAttribute("href"), endsWith("/query"));
    assertThat(query.getAttribute("href"), startsWith(getLodeBaseUrl()));

    WebElement techdocs = navi.findElement(By.xpath("li[3]/a"));
    elementTextShouldBe(techdocs, "Documentation");

    WebElement samples = navi.findElement(By.xpath("li[4]/a"));
    elementTextShouldBe(samples, "Sample Queries");

    WebElement download = navi.findElement(By.xpath("li[5]/a"));
    elementTextShouldBe(download, "Download");

    WebElement apidoc = navi.findElement(By.xpath("li[6]/a"));
    elementTextShouldBe(apidoc, "API");

    WebElement meshhome = navi.findElement(By.xpath("li[7]/a"));
    elementTextShouldBe(meshhome, "MeSH Home");
    assertThat(meshhome.getAttribute("href"), endsWith("://www.nlm.nih.gov/mesh/"));

    return navi;
  }

  public void shouldBeValidLinks(List<WebElement> links) {
    LinkChecker linkcheck = new LinkChecker(getCurrentBaseUrl());
    linkcheck.setConnectTimeout(5);
    linkcheck.setSocketTimeout(10);
    linkcheck.addRequestHeader("Accept", "text/html, text/plain, text/turtle");
    linkcheck.addRequestHeader("Upgrade-Insecure-Requests", "1");

    String lodebaseUrl = getLodeBaseUrl();
    for (WebElement link : links) {
      String tag = link.getTagName();
      String href = (tag.equalsIgnoreCase("script") || tag.equalsIgnoreCase("img") ? link.getAttribute("src") : link.getAttribute("href"));
      if (href.startsWith(CANONICAL_PREFIX)) {
          href = href.replace(CANONICAL_PREFIX, lodebaseUrl);
      }
      linkcheck.add(href);
    }
    linkcheck.shouldBeValid();
  }

  public void shouldBeExplorerPage() {
      titleShouldBe("MeSH RDF Explorer");
      elementShouldContain(By.cssSelector(".meshrdf-heading > h1"), "Medical Subject Headings");
  }

  public void shouldBeResourceType(String expectedTypeLabel) {
      WebElement typeElement = findElement(By.cssSelector("#lodestar-contents_lode_explore_resourceType a.graph-link"));
      assertThat(typeElement, not(nullValue()));
      String actualTypeLabel = typeElement.getText().trim();
      assertThat(actualTypeLabel, equalTo(expectedTypeLabel));
  }

  public void shouldBeAbout(String expectedAboutLabel) {
      WebElement aboutElement = findElement(By.cssSelector("#lodestar-contents_lode_explore_resourceTopObject a.graph-link"));
      assertThat(aboutElement, not(nullValue()));
      String actualAboutLabel = aboutElement.getText().trim();
      assertThat(actualAboutLabel, equalTo(expectedAboutLabel));
  }

  public void openHomePage() {
    driver.get(getLodeBaseUrl());
  }

  public void openQueryPage() {
    driver.get(getLodeBaseUrl() + "/query");
  }

  public void openExplorerPage(String relativeUri, boolean usePrefix) {
      if (relativeUri == null || relativeUri.length() == 0) {
          relativeUri = OFLAXIN_RELURI;
      }
      if (relativeUri.charAt(0) != '/') {
          relativeUri = '/'+relativeUri;
      }
      String prefix = (usePrefix ? YEAR_PREFIX : "");
      String uri = getLodeBaseUrl() + prefix + relativeUri;
      driver.get(uri);
  }
  public void openExplorerPage(String relativeUri) {
      openExplorerPage(relativeUri, false);
  }
  public void openExplorerPage(Boolean usePrefix) {
      openExplorerPage(null, usePrefix);
  }
  public void openExplorerPage() {
      openExplorerPage(null, false);
  }

  public void noPageErrors() {
      WebElement javascriptErrorPre = driver.findElement(By.cssSelector("#jserr pre"));
      assertThat(javascriptErrorPre, not(nullValue()));

      String javascriptErrorText = javascriptErrorPre.getText().trim();
      assertThat(javascriptErrorText, equalTo(""));
  }

}