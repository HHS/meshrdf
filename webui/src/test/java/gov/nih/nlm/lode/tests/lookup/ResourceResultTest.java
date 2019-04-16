package gov.nih.nlm.lode.tests.lookup;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.CoreMatchers.nullValue;
import static org.hamcrest.MatcherAssert.assertThat;

import org.testng.annotations.Test;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import gov.nih.nlm.lode.model.ResourceResult;


@Test(groups="unit")
public class ResourceResultTest {

    @Test
    public void testConstructor() {
        ResourceResult obj = new ResourceResult();
        assertThat(obj.getResource(), nullValue());
        assertThat(obj.getLabel(), nullValue());
        assertThat(obj.getPreferred(), nullValue());
    }

    @Test
    public void testConstructorWithResource() {
        ResourceResult obj = new ResourceResult("abc", "def");
        assertThat(obj.getResource(), equalTo("abc"));
        assertThat(obj.getLabel(), equalTo("def"));
        assertThat(obj.getPreferred(), nullValue());
    }

    @Test
    public void testConstructorPreferred() {
        ResourceResult obj = new ResourceResult("abc", "def", true);
        assertThat(obj.getResource(), equalTo("abc"));
        assertThat(obj.getLabel(), equalTo("def"));
        assertThat(obj.getPreferred(), equalTo(true));
    }

    @Test
    public void testEqualsWithoutPreferred() {
        ResourceResult lhs = new ResourceResult("abc", "def");
        ResourceResult rhs = new ResourceResult("abc", "def");
        assert(lhs.equals(rhs));
    }

    @Test
    public void testEqualsWithPreferred() {
        ResourceResult lhs = new ResourceResult("abc", "def", true);
        ResourceResult rhs = new ResourceResult("abc", "def", true);
        assert(lhs.equals(rhs));
    }

    @Test
    public void testSerialize() throws JsonProcessingException {
        ResourceResult obj = new ResourceResult();
        obj.setResource("abc");
        obj.setLabel("def");
        ObjectMapper mapper = new ObjectMapper();
        String jsonString = mapper.writeValueAsString(obj);
        assertThat(jsonString, equalTo("{\"resource\":\"abc\",\"label\":\"def\"}"));
    }

    @Test
    public void testSerializeWithPreferred() throws JsonProcessingException {
        ResourceResult obj = new ResourceResult();
        obj.setResource("abc");
        obj.setLabel("def");
        obj.setPreferred(false);
        ObjectMapper mapper = new ObjectMapper();
        String jsonString = mapper.writeValueAsString(obj);
        assertThat(jsonString, equalTo("{\"resource\":\"abc\",\"label\":\"def\",\"preferred\":false}"));
    }
}
