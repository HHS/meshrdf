package gov.nih.nlm.lode.tests.lookup;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.CoreMatchers.nullValue;
import static org.hamcrest.MatcherAssert.assertThat;

import org.testng.annotations.Test;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import gov.nih.nlm.lode.model.ResourceAndLabel;

public class ResourceAndLabelTest {

    @Test
    public void noArgumentConstructor() {
        ResourceAndLabel obj = new ResourceAndLabel();
        assertThat(obj.getResource(), nullValue());
        assertThat(obj.getLabel(), nullValue());
    }

    @Test
    public void propertyConstructor() {
        ResourceAndLabel obj = new ResourceAndLabel("abc", "def");
        assertThat(obj.getResource(), equalTo("abc"));
        assertThat(obj.getLabel(), equalTo("def"));
    }

    @Test
    public void serialize() throws JsonProcessingException {
        ResourceAndLabel obj = new ResourceAndLabel();
        obj.setResource("abc");
        obj.setLabel("def");
        ObjectMapper mapper = new ObjectMapper();
        String jsonString = mapper.writeValueAsString(obj);
        assertThat(jsonString, equalTo("{\"resource\":\"abc\",\"label\":\"def\"}"));
    }
}
