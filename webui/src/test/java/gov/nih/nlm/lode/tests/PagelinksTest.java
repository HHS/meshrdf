package gov.nih.nlm.lode.tests;

import java.util.List;
import java.util.ArrayList;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.By;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.testng.annotations.Test;

import static org.testng.Assert.*;
import static org.hamcrest.CoreMatchers.*;
import static org.hamcrest.MatcherAssert.assertThat;

import gov.nih.nlm.occs.selenium.SeleniumTest;

public class PagelinksTest extends LodeBaseTest {

  @Test(groups = "pagelinks")
  public void testHomeScriptTags() {
    openHomePage();
    List<WebElement> links = driver.findElements(By.xpath("//script[@src]"));
    shouldBeValidLinks(links);
  }

  @Test(groups = "pagelinks")
  public void testHomeLinkTags() {
    openHomePage();
    List<WebElement> links = driver.findElements(By.xpath("//head/link[@src]"));
    shouldBeValidLinks(links);
  }

  @Test(groups = "pagelinks")
  public void testHomeBodyLinks() {
    openHomePage();
    List<WebElement> links = driver.findElements(By.xpath("//a[@href!='#']"));
    shouldBeValidLinks(links);
  }

  @Test(groups="pagelinks")
  public void testExplorerScriptTags() {
    openExplorerPage(false);
    List<WebElement> links = driver.findElements(By.xpath("//script[@src]"));
    shouldBeValidLinks(links);
  }

  @Test(groups="pagelinks")
  public void testExplorerlinkTags() {
    openExplorerPage(false);
    List<WebElement> links = driver.findElements(By.xpath("//head/link[@src]"));
    shouldBeValidLinks(links);   
  }

  @Test(groups="pagelinks")
  public void testExplorerLodestarLinks() {
    openExplorerPage(false);

    wait.until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector("#lodestar-contents_lode_explore .topObjectDiv a")));
    wait.until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector("#lodestar-contents_lode_explore_relatedToObjects a")));
    wait.until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector("#lodestar-contents_lode_explore_relatedFromSubjects a")));

    List<WebElement> lodeExploreLinks = driver.findElements(By.cssSelector("#lodestar-contents_lode_explore a"));
    shouldBeValidLinks(lodeExploreLinks);
  }

  @Test(groups="pagelinks")
  public void testExplorer2015LodestarLinks() {
    openExplorerPage(true);

    wait.until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector("#lodestar-contents_lode_explore .topObjectDiv a")));
    wait.until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector("#lodestar-contents_lode_explore_relatedToObjects a")));
    wait.until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector("#lodestar-contents_lode_explore_relatedFromSubjects a")));

    List<WebElement> lodeExploreLinks = driver.findElements(By.cssSelector("#lodestar-contents_lode_explore a"));
    shouldBeValidLinks(lodeExploreLinks);
  }
}