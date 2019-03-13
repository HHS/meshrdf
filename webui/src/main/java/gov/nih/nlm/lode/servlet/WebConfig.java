package gov.nih.nlm.lode.servlet;

import org.springframework.context.annotation.Configuration;
import org.springframework.format.FormatterRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

import gov.nih.nlm.lode.model.StringToEnumConverterFactory;

/**
 * Note that WebMvcConfigureAdapter should be replaced with WebMvcConfigurer in Spring 5
 */
@Configuration
public class WebConfig extends WebMvcConfigurerAdapter {

    @Override
    public void addFormatters(FormatterRegistry registry) {
        registry.addConverterFactory(new StringToEnumConverterFactory());
    }
}
