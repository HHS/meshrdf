package gov.nih.nlm.lode.servlet;

import java.util.Arrays;
import java.util.Collection;

import org.springframework.stereotype.Service;

import gov.nih.nlm.lode.model.LookupCriteria;
import gov.nih.nlm.lode.model.LookupService;


@Service
public class LookupServiceImpl implements LookupService {

    @Override
    public Collection<String> lookupDescriptors(LookupCriteria criteria) {
        return Arrays.asList(new String[] {
            "http://id.nlm.nih.gov/mesh/D01882",
            "http://id.nlm.nih.gov/mesh/D01883",
        });
    }

    @Override
    public Collection<String> lookupPairs(LookupCriteria criteria) {
        return Arrays.asList(new String[] {
            "http://id.nlm.nih.gov/mesh/Q01882",
            "http://id.nlm.nih.gov/mesh/Q01883",
        });
    }
}
