package gov.nih.nlm.lode.tests;

import java.util.List;
import java.util.ArrayList;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.By;
import org.testng.annotations.Test;

import static org.testng.Assert.*;
import static org.hamcrest.CoreMatchers.*;
import static org.hamcrest.MatcherAssert.assertThat;

import gov.nih.nlm.occs.selenium.SeleniumTest;

public class BasicsTest extends LodeBaseTest {

  @Test(groups = "basics")
  public void testHomePage() {
    openHomePage();
    titleShouldBe("MeSH Linked Data (beta)");
    elementShouldContain(By.cssSelector("#home > h1"), "Linked Data (beta)");
    WebElement navi = navigationShouldBeValid();
    shouldBeValidLinks(navi.findElements(By.tagName("a")));
  }

  @Test(groups = "basics")
  public void testQueryPagce() {
    openQueryPage();
    titleShouldBe("MeSH SPARQL Explorer (beta)");
    elementShouldContain(By.cssSelector("#home > h1"), "Linked Data (beta)");
    WebElement navi = navigationShouldBeValid();
    shouldBeValidLinks(navi.findElements(By.tagName("a")));
  }

  @Test(groups = "basics")
  public void testExplorerPage() {
    openExplorerPage(false);
    titleShouldBe("MeSH RDF Explorer (beta)");
    elementShouldContain(By.cssSelector("#home > h1"), "Linked Data (beta)");
    WebElement navi = navigationShouldBeValid();
    shouldBeValidLinks(navi.findElements(By.tagName("a")));
  }

  @Test(groups = "basics")
  public void testExplorerYearPage() {
    openExplorerPage(true);
    titleShouldBe("MeSH RDF Explorer (beta)");
    elementShouldContain(By.cssSelector("#home > h1"), "Linked Data (beta)");
    WebElement navi = navigationShouldBeValid();
    shouldBeValidLinks(navi.findElements(By.tagName("a")));
  }

  @Test(groups = "basics")
  public void testVocabularyFile() {
    LinkChecker vocablink = new LinkChecker();
    vocablink.add(getLodeBaseUrl()+"/vocabulary.ttl");
    vocablink.shouldMatchContentType("^text/turtle");
    vocablink.shouldBeValid();
  }

  @Test(groups = "basics")
  public void testVocabularyRedirect() {
    LinkChecker vocablink = new LinkChecker();
    vocablink.add(getLodeBaseUrl()+"/vocab#CheckTag");
    vocablink.shouldMatchContentType("^text/turtle");
    vocablink.shouldBeValid();
  }


}