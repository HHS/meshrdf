package gov.nih.nlm.lode.tests;

import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.testng.annotations.Test;

public class ExplorerTest extends LodeBaseTest {

    @Test
    public void testTopicalDescriptor() {
        openExplorerPage("D000420");
        shouldBeExplorerPage();
        shouldBeAbout("Albuterol");
        shouldBeResourceType("MeSH TopicalDescriptor");

        /* First test - test navigation */
        WebElement navi = navigationShouldBeValid();
        shouldBeValidLinks(navi.findElements(By.tagName("a")));
        noPageErrors();
    }

    @Test
    public void testExplorerYearPage() {
        openExplorerPage(true);
        shouldBeExplorerPage();
        shouldBeAbout("Ofloxacin");
        shouldBeResourceType("MeSH TopicalDescriptor");

        /* Test again as this is a URI with a deeper URI */
        WebElement navi = navigationShouldBeValid();
        shouldBeValidLinks(navi.findElements(By.tagName("a")));
        noPageErrors();
    }

    @Test
    public void testPublicationType() {
        openExplorerPage("D000077825");
        shouldBeExplorerPage();
        shouldBeAbout("Dictionary, Pharmaceutic");
        shouldBeResourceType("MeSH PublicationType");
    }

    @Test
    public void testGeographicalDescriptor() {
        openExplorerPage("D008922");
        shouldBeExplorerPage();
        shouldBeAbout("Mississippi");
        shouldBeResourceType("MeSH GeographicalDescriptor");
    }

    @Test
    public void testCheckTag() {
        openExplorerPage("D005260");
        shouldBeExplorerPage();
        shouldBeAbout("Female");
        shouldBeResourceType("MeSH CheckTag");
    }

    @Test
    public void testSCRChemical() {
        openExplorerPage("C000621506");
        shouldBeExplorerPage();
        shouldBeAbout("cxxc5a protein, zebrafish");
        shouldBeResourceType("MeSH SCR Chemical");
    }

    @Test
    public void testSCRDisease() {
        openExplorerPage("C000598941");
        shouldBeExplorerPage();
        shouldBeAbout("Keratoactinomycosis");
        shouldBeResourceType("MeSH SCR Disease");
    }

    @Test
    public void testSCROrganism() {
        openExplorerPage("C000623735");
        shouldBeExplorerPage();
        shouldBeAbout("Rhinovirus B");
        shouldBeResourceType("MeSH SCR Organism");
    }
}
