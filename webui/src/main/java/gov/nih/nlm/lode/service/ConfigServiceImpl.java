package gov.nih.nlm.lode.service;

import java.time.LocalDate;

import javax.servlet.ServletContext;

import org.apache.commons.lang3.BooleanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import gov.nih.nlm.lode.model.ConfigService;
import gov.nih.nlm.lode.model.ValidYears;
import gov.nih.nlm.lode.servlet.ServletUtils;

@Service
public class ConfigServiceImpl implements ConfigService {

    private ServletContext servletContext;

    @Autowired
    public ConfigServiceImpl(ServletContext servletContext) {
        this.servletContext = servletContext;
    }

    @Override
    public int getMeshYear() {
        // check whether there is a container parameter
        Object value = ServletUtils.getParameter(servletContext, MESHRDF_YEAR);
        if (value != null) {
            return Integer.parseInt((String) value);
        }

        // default to the current year
        LocalDate now = LocalDate.now();
        return now.getYear();
    }

    @Override
    public Integer getInterimYear() {
        // check whether there is a container parameter
        int meshYear = getMeshYear();
        Object value = ServletUtils.getParameter(servletContext, MESHRDF_INTERIM);
        if (value != null && BooleanUtils.toBoolean((String) value)) {
            return meshYear+1;
        }
        return null;
    }

    @Override
    public ValidYears getValidYears() {
        int current = getMeshYear();
        Integer interim = this.getInterimYear();
        ValidYears validYears = new ValidYears(current, interim);
        if (interim != null) {
            validYears.setYears(new Integer[] {
                interim, current, current - 1, current - 2
            });
        } else {
            validYears.setYears(new Integer[] {
                current, current - 1, current - 2
            });
        }
        return validYears;
    }
}
