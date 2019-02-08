package gov.nih.nlm.lode.tests;

import java.util.List;
import java.time.LocalDate;

import org.openqa.selenium.WebElement;
import org.openqa.selenium.By;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.Select;
import org.testng.annotations.Test;
import org.testng.annotations.BeforeTest;

import static org.testng.Assert.*;
import static org.hamcrest.CoreMatchers.*;
import static org.hamcrest.MatcherAssert.assertThat;


public class QueryTest extends LodeBaseTest {

    public static final String FOR_LODESTAR_RESULT_ROWS = "#lodestar-results-table > tr";

    public static final String FOR_LODESTAR_RESULT_LINKS = "#lodestar-results-table a";

    public static final String[] MESH_VOCAB_CLASSES = {
        "meshv:AllowedDescriptorQualifierPair",
        "meshv:CheckTag",
        "meshv:Concept",
        "meshv:DisallowedDescriptorQualifierPair",
        "meshv:GeographicalDescriptor",
        "meshv:PublicationType",
        "meshv:Qualifier",
        "meshv:SCR_Chemical",
        "meshv:SCR_Disease",
        "meshv:SCR_Organism",
        "meshv:SCR_Protocol",
        "meshv:Term",
        "meshv:TopicalDescriptor",
        "meshv:TreeNumber",
    };

    public static final String[][] EX1_CHECKED_RESULTS = {
        { "meshv:concept", "/describe?uri=http%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2Fvocab%23concept" },
        { "meshv:abbreviation", "/describe?uri=http%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2Fvocab%23abbreviation" },
        { "meshv:casn1_label", "/describe?uri=http%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2Fvocab%23casn1_label" },
        { "meshv:considerAlso", "/describe?uri=http%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2Fvocab%23considerAlso" },
        { "meshv:seeAlso", "/describe?uri=http%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2Fvocab%23seeAlso" },
        { "meshv:useInstead", "/describe?uri=http%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2Fvocab%23useInstead" },
        { "rdfs:label", "http://www.w3.org/2000/01/rdf-schema#label" },
    };

    public static final String[][] EX2_CHECKED_RESULTS = {
        { "mesh:D000892", "/D000892", "Anti-Infective Agents, Urinary" },
        { "mesh:D000900", "/D000900", "Anti-Bacterial Agents" },
        { "mesh:D059005", "/D059005", "Topoisomerase II Inhibitors" },
        { "mesh:D065609", "/D065609", "Cytochrome P-450 CYP1A2 Inhibitors" },
    };

    public String pastYear = "2015";

    public String[][] EX3_PAGE1_CHECKED_RESULTS = {
        { "mesh2015:D019813", "/2015/D019813", "1,2-Dimethylhydrazine" },
        { "mesh2015:D020001", "/2015/D020001", "1-Butanol" },
        { "mesh2015:D015068", "/2015/D015068", "17-Ketosteroids" },
    };

    public String[][] EX3_PAGE2_CHECKED_RESULTS = {
        { "mesh2015:D008456", "/2015/D008456", "2-Methyl-4-chlorophenoxyacetic Acid" },
        { "mesh2015:D019840", "/2015/D019840", "2-Propanol" },
    };

    public static final String[][] EX4_CHECKED_RESULTS = {
        { "mesh:D000151", "Acinetobacter Infections", "mesh:M0000230", "Acinetobacter Infections" },
        { "mesh:D000193", "Actinomycetales Infections", "mesh:M0000289", "Actinomycetales Infections" },
        { "mesh:D000258", "Adenovirus Infections, Human", "mesh:M0000406", "Pharyngo-Conjunctival Fever" },
        { "mesh:D002694", "Chlamydiaceae Infections", "mesh:M0004111", "Chlamydiaceae Infections" },
        { "mesh:D003015", "Clostridium Infections", "mesh:M000622571", "Clostridium sordellii Infection" },
    };

    @BeforeTest
    public void setUpPastYear() {
        /* This calculation works because if we have rolled it, then the year maybe 2019, but the Mesh Year is 2020,
         * so 2018 is the oldest can be counted on.   However, through most of the year of 2019, 2017 will be there
         * as well. What we want to assure is that we can select a past year and it appears in the form and works.
         */
        int thisYear = LocalDate.now().getYear();
        this.pastYear = Integer.toString(thisYear - 1);

        for (String[] result : this.EX3_PAGE1_CHECKED_RESULTS) {
            result[0] = result[0].replace("2015", this.pastYear);
            result[1] = result[1].replace("2015", this.pastYear);
        }

        for (String[] result : this.EX3_PAGE2_CHECKED_RESULTS) {
            result[0] = result[0].replace("2015", this.pastYear);
            result[1] = result[1].replace("2015", this.pastYear);
        }
    }

    public void clickSubmitQuery() {
        // submit the query form
        WebElement button = findElement(By.xpath("//input[@type='button'][@value='Submit Query']"));
        button.click();
    }

    public void clickResetQuery() {
        // submit the query form
        WebElement button = findElement(By.xpath("//input[@type='button'][@value='Reset']"));
        button.click();
    }

    public void clickOptionWithinSelect(String selectId, String optionValue) {
        Select dropdown = new Select(findElement(By.id(selectId)));
        dropdown.selectByValue(optionValue);
    }

    public void clickOnExampleQuery(int whichQuery) {
        WebElement queries = findElement(By.id("queries_list"));
        String expression = String.format("li/a[@id='%d']", whichQuery);
        WebElement example = queries.findElement(By.xpath(expression));
        example.click();
    }

    @Test(groups="query")
    public void testDefaults() {
        openQueryPage();
        clickSubmitQuery();

        List<WebElement> rows = findElements(By.cssSelector(FOR_LODESTAR_RESULT_ROWS));
        assertEquals(rows.size(), MESH_VOCAB_CLASSES.length);
        for (int i = 0; i < rows.size(); i++) {
            WebElement row = rows.get(i);
            WebElement link = row.findElement(By.xpath("td[1]/span/a"));
            String expectedEnding = MESH_VOCAB_CLASSES[i].replace("meshv:", "%2Fmesh%2Fvocab%23");

            assertThat(link.getText(), is(equalTo(MESH_VOCAB_CLASSES[i])));
            assertThat(link.getAttribute("href"), endsWith(expectedEnding));
        }

        shouldBeValidLinks(driver.findElements(By.cssSelector(FOR_LODESTAR_RESULT_LINKS)));
    }

    @Test(groups="query", dependsOnMethods={"testDefaults"})
    public void testExample0() {
        openQueryPage();
        clickOnExampleQuery(0);
        clickSubmitQuery();

        List<WebElement> rows = findElements(By.cssSelector(FOR_LODESTAR_RESULT_ROWS));
        assertEquals(rows.size(), MESH_VOCAB_CLASSES.length);
        for (int i = 0; i < rows.size(); i++) {
            WebElement row = rows.get(i);
            WebElement link = row.findElement(By.xpath("td[1]/span/a"));
            String expectedEnding = MESH_VOCAB_CLASSES[i].replace("meshv:", "%2Fmesh%2Fvocab%23");

            assertThat(link.getText(), is(equalTo(MESH_VOCAB_CLASSES[i])));
            assertThat(link.getAttribute("href"), endsWith(expectedEnding));
        }

        shouldBeValidLinks(driver.findElements(By.cssSelector(FOR_LODESTAR_RESULT_LINKS)));
        noPageErrors();
    }

    @Test(groups="query", dependsOnMethods={"testDefaults"})
    public void testExample1() {
        openQueryPage();
        clickOnExampleQuery(1);
        clickSubmitQuery();

        int numMatched = 0;
        List<WebElement> rows = findElements(By.cssSelector(FOR_LODESTAR_RESULT_ROWS));
        assertEquals(rows.size(), 49);
        for (WebElement row : rows) {
            WebElement link = row.findElement(By.xpath("td[1]/span/a"));
            String linktext = link.getText();

            for (String[] expected : EX1_CHECKED_RESULTS) {
                String expectedLinkText = expected[0];
                String expectedLinkEnding = expected[1];

                if (linktext.equals(expectedLinkText)) {
                    assertThat(link.getAttribute("href"), endsWith(expectedLinkEnding));
                    numMatched++;
                }
            }
        }
        assertEquals(numMatched, EX1_CHECKED_RESULTS.length);

        shouldBeValidLinks(driver.findElements(By.cssSelector(FOR_LODESTAR_RESULT_LINKS)));
        noPageErrors();
    }

    @Test(groups="query", dependsOnMethods={"testDefaults"})
    public void testExample2() {
        openQueryPage();

        // click on 2nd example query
        clickOnExampleQuery(2);

        // select options
        clickOptionWithinSelect("year", "current");
        clickOptionWithinSelect("format", "HTML");
        clickOptionWithinSelect("limit", "50");

        // submit the query form
        clickSubmitQuery();

        // verify selected results without depending on order
        int numMatched = 0;
        List<WebElement> rows = findElements(By.cssSelector(FOR_LODESTAR_RESULT_ROWS));
        assertEquals(rows.size(), 4);
        for (WebElement row : rows) {
            WebElement link = row.findElement(By.xpath("td[1]/span/a"));
            String linktext = link.getText();

            boolean amatch = false;
            for (String expected[] : EX2_CHECKED_RESULTS) {
                String expectedLinkText = expected[0];
                String expectedLinkEnding = expected[1];
                String expectedCol2Text = expected[2];

                if (linktext.equals(expectedLinkText)) {
                    assertThat(link.getAttribute("href"), endsWith(expectedLinkEnding));
                    assertEquals(row.findElement(By.xpath("td[2]")).getText(), expectedCol2Text);
                    numMatched++;
                    amatch = true;
                }
            }
            assertTrue(amatch, "Unexpected pharmalogical action on example query 2");
        }
        assertEquals(numMatched, EX2_CHECKED_RESULTS.length);

        shouldBeValidLinks(driver.findElements(By.cssSelector(FOR_LODESTAR_RESULT_LINKS)));
        noPageErrors();
    }

    @Test(groups="query", dependsOnMethods={"testDefaults"})
    public void testExample3withPastYear() {

        openQueryPage();

        clickOnExampleQuery(3);
        clickOptionWithinSelect("year", this.pastYear);
        clickOptionWithinSelect("format", "HTML");
        clickOptionWithinSelect("limit", "50");

        clickSubmitQuery();

        // verify results without depending on order
        wait.until(ExpectedConditions.numberOfElementsToBe(By.cssSelector(FOR_LODESTAR_RESULT_ROWS), 50));
        int numMatched = 0;

        List<WebElement> rows = findElements(By.cssSelector(FOR_LODESTAR_RESULT_ROWS));
        assertEquals(rows.size(), 50);
        for (WebElement row : rows) {
            WebElement desc = row.findElement(By.xpath("td[1]/span/a"));
            WebElement dlabel = row.findElement(By.xpath("td[2]"));
            String dtext = desc.getText();

            for (String expected[] : EX3_PAGE1_CHECKED_RESULTS) {
                String expectedLinkText = expected[0];
                String expectedLinkEnding = expected[1];
                String expectedCol2Text = expected[2];

                if (dtext.equals(expectedLinkText)) {
                    assertThat(desc.getAttribute("href"), endsWith(expectedLinkEnding));
                    assertEquals(dlabel.getText(), expectedCol2Text);
                    numMatched++;
                }
            }
        }
        assertEquals(numMatched, EX3_PAGE1_CHECKED_RESULTS.length);

        shouldBeValidLinks(driver.findElements(By.cssSelector(FOR_LODESTAR_RESULT_LINKS)));
        noPageErrors();
    }

    @Test(groups="query", dependsOnMethods={"testExample3withPastYear"})
    public void testPagination() {
        openQueryPage();

        clickOnExampleQuery(3);
        clickOptionWithinSelect("year", this.pastYear);
        clickOptionWithinSelect("format", "HTML");
        clickOptionWithinSelect("limit", "50");

        clickSubmitQuery();

        // make sure we have enough results
        wait.until(ExpectedConditions.numberOfElementsToBe(By.cssSelector(FOR_LODESTAR_RESULT_ROWS), 50));

        // Make sure next link also returns 50 results
        WebElement nextLink = findElement(By.xpath("//div[@id='pagination']/a[@class='pag next']"));
        nextLink.click();

        // should be showing offset 50
        WebElement pagemes = findElement(By.xpath("//div[@id='pagination']/span[@class='pag pagmes']"));
        assertEquals(pagemes.getText(), "50 results per page (offset 50)");

        // should again be 50 results (which we verify selectively)
        int page2matched = 0;
        List<WebElement> page2rows = findElements(By.cssSelector(FOR_LODESTAR_RESULT_ROWS));
        assertEquals(page2rows.size(), 50);
        for (WebElement row : page2rows) {
            WebElement desc = row.findElement(By.xpath("td[1]/span/a"));
            WebElement dlabel = row.findElement(By.xpath("td[2]"));
            String dtext = desc.getText();

            for (String expected[] : EX3_PAGE2_CHECKED_RESULTS) {
                String expectedLinkText = expected[0];
                String expectedLinkEnding = expected[1];
                String expectedCol2Text = expected[2];

                if (dtext.equals(expectedLinkText)) {
                    assertThat(desc.getAttribute("href"), endsWith(expectedLinkEnding));
                    assertEquals(dlabel.getText(), expectedCol2Text);
                    page2matched++;
                }
            }
        }
        assertEquals(page2matched, EX3_PAGE2_CHECKED_RESULTS.length);

        // Go to previous page
        WebElement prevLink = findElement(By.xpath("//div[@id='pagination']/a[@class='pag prev']"));
        prevLink.click();

        // should be showing offset 0
        int page1matched = 0;
        pagemes = findElement(By.xpath("//div[@id='pagination']/span[@class='pag pagmes']"));
        assertEquals(pagemes.getText(), "50 results per page (offset 0)");

        List<WebElement> page1rows = findElements(By.cssSelector(FOR_LODESTAR_RESULT_ROWS));
        assertEquals(page1rows.size(), 50);
        for (WebElement row : page1rows) {
            WebElement desc = row.findElement(By.xpath("td[1]/span/a"));
            WebElement dlabel = row.findElement(By.xpath("td[2]"));
            String dtext = desc.getText();

            for (String expected[] : EX3_PAGE1_CHECKED_RESULTS) {
                String expectedLinkText = expected[0];
                String expectedLinkEnding = expected[1];
                String expectedCol2Text = expected[2];

                if (dtext.equals(expectedLinkText)) {
                    assertThat(desc.getAttribute("href"), endsWith(expectedLinkEnding));
                    assertEquals(dlabel.getText(), expectedCol2Text);
                    page1matched++;
                }
            }
        }
        assertEquals(page1matched, EX3_PAGE1_CHECKED_RESULTS.length);
        noPageErrors();
    }

    @Test(groups="query", dependsOnMethods={"testExample3withPastYear"})
    public void testLimitRows() {
        openQueryPage();

        clickOnExampleQuery(3);
        clickOptionWithinSelect("year", this.pastYear);
        clickOptionWithinSelect("format", "HTML");
        clickOptionWithinSelect("limit", "25");

        clickSubmitQuery();

        // should be showing offset 0
        WebElement pagemes = findElement(By.xpath("//div[@id='pagination']/span[@class='pag pagmes']"));
        assertEquals(pagemes.getText(), "25 results per page (offset 0)");

        // verify results without depending on order
        int numMatched = 0;
        List<WebElement> rows = findElements(By.cssSelector(FOR_LODESTAR_RESULT_ROWS));
        assertEquals(rows.size(), 25);
        for (WebElement row : rows) {
            WebElement desc = row.findElement(By.xpath("td[1]/span/a"));
            WebElement dlabel = row.findElement(By.xpath("td[2]"));
            String dtext = desc.getText();

            for (String expected[] : EX3_PAGE1_CHECKED_RESULTS) {
                String expectedLinkText = expected[0];
                String expectedLinkEnding = expected[1];
                String expectedCol2Text = expected[2];

                if (dtext.equals(expectedLinkText)) {
                    assertThat(desc.getAttribute("href"), endsWith(expectedLinkEnding));
                    assertEquals(dlabel.getText(), expectedCol2Text);
                    numMatched++;
                }
            }
        }

        // NOTE: One of these checked results is passed row 25
        assertEquals(numMatched, EX3_PAGE1_CHECKED_RESULTS.length - 1);
        noPageErrors();
    }

    @Test(groups="query", dependsOnMethods={"testDefaults"})
    public void testExample4() {
        openQueryPage();
        clickOnExampleQuery(4);
        clickSubmitQuery();

        int numMatched = 0;
        List<WebElement> rows = findElements(By.cssSelector(FOR_LODESTAR_RESULT_ROWS));
        assertEquals(rows.size(), 50);
        for (WebElement row : rows) {
            WebElement col1 = row.findElement(By.xpath("td[1]/span/a"));
            WebElement col2 = row.findElement(By.xpath("td[2]"));
            WebElement col3 = row.findElement(By.xpath("td[3]/span/a"));
            WebElement col4 = row.findElement(By.xpath("td[4]"));
            String col3text = col3.getText();

            for (String[] expected : EX4_CHECKED_RESULTS) {
                String expectedCol1 = expected[0];
                String expectedCol1Link = expected[0].replace("mesh:", "/mesh/");
                String expectedCol2 = expected[1];
                String expectedCol3 = expected[2];
                String expectedCol3Link = expected[2].replace("mesh:", "/mesh/");
                String expectedCol4 = expected[3];

                if (col3text.equals(expectedCol3)) {
                    assertEquals(col1.getText(), expectedCol1);
                    assertThat(col1.getAttribute("href"), endsWith(expectedCol1Link));
                    assertEquals(col2.getText(), expectedCol2);
                    assertEquals(col3.getText(), expectedCol3);
                    assertThat(col3.getAttribute("href"), endsWith(expectedCol3Link));
                    assertEquals(col4.getText(), expectedCol4);
                    numMatched++;
                }
            }
        }
        assertEquals(numMatched, EX4_CHECKED_RESULTS.length);

        shouldBeValidLinks(driver.findElements(By.cssSelector(FOR_LODESTAR_RESULT_LINKS)));
        noPageErrors();
    }
}
