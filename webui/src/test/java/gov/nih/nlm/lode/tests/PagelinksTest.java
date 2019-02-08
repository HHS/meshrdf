package gov.nih.nlm.lode.tests;

import java.util.List;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.By;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.testng.annotations.Test;


@Test(groups = "pagelinks")
public class PagelinksTest extends LodeBaseTest {

  @Test
  public void testHomeScriptTags() {
    openHomePage();
    List<WebElement> links = driver.findElements(By.xpath("//script[@src]"));
    shouldBeValidLinks(links);
    noPageErrors();
  }

  @Test
  public void testHomeLinkTags() {
    openHomePage();
    List<WebElement> links = driver.findElements(By.xpath("//head/link[@src]"));
    shouldBeValidLinks(links);
    noPageErrors();
  }

  @Test
  public void testHomeBodyLinks() {
    /* Hack to prevent problems when test is run by CI/CD */
    if (System.getProperty("os.name").equalsIgnoreCase("Linux")) {
      return;
    }

    openHomePage();
    List<WebElement> links = driver.findElements(By.xpath("//a[@href!='#']"));
    shouldBeValidLinks(links);
  }

  @Test
  public void testExplorerScriptTags() {
    openExplorerPage(false);
    List<WebElement> links = driver.findElements(By.xpath("//script[@src]"));
    shouldBeValidLinks(links);
  }

  @Test
  public void testExplorerlinkTags() {
    openExplorerPage(false);
    List<WebElement> links = driver.findElements(By.xpath("//head/link[@src]"));
    shouldBeValidLinks(links);
  }

  @Test
  public void testExplorerLodestarLinks() {
    openExplorerPage(false);

    wait.until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector("#lodestar-contents_lode_explore .topObjectDiv a")));
    wait.until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector("#lodestar-contents_lode_explore_relatedToObjects a")));
    wait.until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector("#lodestar-contents_lode_explore_relatedFromSubjects a")));

    List<WebElement> lodeExploreLinks = driver.findElements(By.cssSelector("#lodestar-contents_lode_explore a"));
    shouldBeValidLinks(lodeExploreLinks);
    noPageErrors();
  }

  @Test
  public void testExplorer2015LodestarLinks() {
    openExplorerPage(true);

    wait.until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector("#lodestar-contents_lode_explore .topObjectDiv a")));
    wait.until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector("#lodestar-contents_lode_explore_relatedToObjects a")));
    wait.until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector("#lodestar-contents_lode_explore_relatedFromSubjects a")));

    List<WebElement> lodeExploreLinks = driver.findElements(By.cssSelector("#lodestar-contents_lode_explore a"));
    shouldBeValidLinks(lodeExploreLinks);
    noPageErrors();
  }
}
