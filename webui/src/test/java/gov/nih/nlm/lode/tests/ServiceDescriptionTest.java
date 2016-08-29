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

public class ServiceDescriptionTest extends LodeBaseTest {
  
  public String getEndpoint() {
    return getLodeBaseUrl()+"/sparql";
  }

  @Test
  public void testDefaultServiceDescription() {
    LinkChecker vocablink = new LinkChecker();
    vocablink.add(getEndpoint());
    vocablink.shouldMatchContentType("^text/plain;charset=utf-8");
    vocablink.shouldBeValid();
  }
  
  @Test
  public void testTurtleServiceDescription() {
    LinkChecker vocablink = new LinkChecker();
    vocablink.add(getEndpoint());
    vocablink.addRequestHeader("Accept", "text/turtle");
    vocablink.shouldMatchContentType("^text/turtle;charset=utf-8");
    vocablink.shouldBeValid();
  }
  
  @Test
  public void testJSONLDServiceDescription() {
    LinkChecker vocablink = new LinkChecker();
    vocablink.add(getEndpoint());
    vocablink.addRequestHeader("Accept", "application/rdf+json");
    vocablink.shouldMatchContentType("^application/rdf\\+json;charset=utf-8");
    vocablink.shouldBeValid();
  }
  
  @Test
  public void testServiceDescriptionByFormat() {
    LinkChecker vocablink = new LinkChecker();
    vocablink.add(getEndpoint()+"?format=TURTLE");
    vocablink.shouldMatchContentType("^text/turtle;charset=utf-8");
    vocablink.shouldBeValid();
  }
}