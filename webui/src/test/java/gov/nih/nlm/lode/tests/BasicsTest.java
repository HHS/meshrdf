package gov.nih.nlm.lode.tests;

import java.util.List;
import java.util.ArrayList;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.By;
import org.testng.annotations.Test;

import static org.testng.Assert.*;
import static org.hamcrest.CoreMatchers.*;
import static org.hamcrest.MatcherAssert.assertThat;

@Test(groups = "basics")
public class BasicsTest extends LodeBaseTest {

  @Test
  public void testHomePage() {
    openHomePage();
    titleShouldBe("MeSH Linked Data");
    elementShouldContain(By.cssSelector("#home > h1"), "Linked Data");
    WebElement navi = navigationShouldBeValid();
    shouldBeValidLinks(navi.findElements(By.tagName("a")));
  }

  @Test
  public void testQueryPagce() {
    openQueryPage();
    titleShouldBe("MeSH SPARQL Explorer");
    elementShouldContain(By.cssSelector("#home > h1"), "Linked Data");
    WebElement navi = navigationShouldBeValid();
    shouldBeValidLinks(navi.findElements(By.tagName("a")));
  }

  @Test
  public void testExplorerPage() {
    openExplorerPage(false);
    titleShouldBe("MeSH RDF Explorer");
    elementShouldContain(By.cssSelector("#home > h1"), "Linked Data");
    WebElement navi = navigationShouldBeValid();
    shouldBeValidLinks(navi.findElements(By.tagName("a")));
  }

  @Test
  public void testExplorerYearPage() {
    openExplorerPage(true);
    titleShouldBe("MeSH RDF Explorer");
    elementShouldContain(By.cssSelector("#home > h1"), "Linked Data");
    WebElement navi = navigationShouldBeValid();
    shouldBeValidLinks(navi.findElements(By.tagName("a")));
  }

  @Test
  public void testVocabularyFile() {
    LinkChecker vocablink = new LinkChecker();
    vocablink.add(getLodeBaseUrl()+"/vocabulary.ttl");
    vocablink.shouldMatchContentType("^text/turtle");
    vocablink.shouldBeValid();
  }

  @Test
  public void testVocabularyRedirect() {
    LinkChecker vocablink = new LinkChecker();
    vocablink.add(getLodeBaseUrl()+"/vocab#CheckTag");
    vocablink.shouldMatchContentType("^text/turtle");
    vocablink.shouldBeValid();
  }


}
