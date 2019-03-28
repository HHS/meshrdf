package gov.nih.nlm.lode.tests;

import org.openqa.selenium.WebElement;
import org.openqa.selenium.By;
import org.testng.annotations.Test;


@Test(groups = "basics")
public class BasicsTest extends LodeBaseTest {

  @Test
  public void testHomePage() {
    openHomePage();
    titleShouldBe("Medical Subject Headings RDF");
    elementShouldContain(By.cssSelector(".meshrdf-heading > h1"), "Medical Subject Headings");
    WebElement navi = navigationShouldBeValid();
    shouldBeValidLinks(navi.findElements(By.tagName("a")));
    noPageErrors();
  }

  @Test
  public void testQueryPage() {
    openQueryPage();
    titleShouldBe("MeSH SPARQL Explorer");
    elementShouldContain(By.cssSelector(".meshrdf-heading > h1"), "Medical Subject Headings");
    WebElement navi = navigationShouldBeValid();
    shouldBeValidLinks(navi.findElements(By.tagName("a")));
    noPageErrors();
  }

  @Test
  public void testExplorerPage() {
    openExplorerPage();
    titleShouldBe("MeSH RDF Explorer");
    elementShouldContain(By.cssSelector(".meshrdf-heading > h1"), "Medical Subject Headings");
    WebElement navi = navigationShouldBeValid();
    shouldBeValidLinks(navi.findElements(By.tagName("a")));
    noPageErrors();
  }

  @Test
  public void testVocabularyTurtle() {
    LinkChecker vocablink = new LinkChecker();
    vocablink.add(getLodeBaseUrl()+"/vocabulary.ttl");
    vocablink.shouldMatchContentType("^text/turtle");
    vocablink.shouldBeValid();
  }

  @Test
  public void testVoidTurtle() {
      LinkChecker vocablink = new LinkChecker();
      vocablink.add(getLodeBaseUrl()+"/void.ttl");
      vocablink.shouldMatchContentType("^text/turtle");
      vocablink.shouldBeValid();
  }

  @Test
  public void testVocabularyOwl() {
    LinkChecker vocablink = new LinkChecker();
    vocablink.add(getLodeBaseUrl()+"/vocabulary.owl");
    vocablink.shouldMatchContentType("^application/rdf\\+xml");
    vocablink.shouldBeValid();
  }

  @Test
  public void testVocabularyRedirect() {
    LinkChecker vocablink = new LinkChecker();
    vocablink.add(getLodeBaseUrl()+"/vocab#CheckTag");
    vocablink.shouldMatchContentType("^application/rdf\\+xml");
    vocablink.shouldBeValid();
  }

  @Test
  public void testVoidRedirect() {
    LinkChecker voidlink = new LinkChecker();
    voidlink.add(getLodeBaseUrl()+"/void#MeSHRDF");
    voidlink.add(getLodeBaseUrl()+"/void");
    voidlink.shouldMatchContentType("^text/turtle");
    voidlink.shouldBeValid();
  }
}
