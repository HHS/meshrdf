package gov.nih.nlm.lode.servlet;

import java.io.IOException;
import java.util.Collection;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import org.yaml.snakeyaml.Yaml;

import gov.nih.nlm.lode.model.DescriptorCriteria;
import gov.nih.nlm.lode.model.JenaResourceService;
import gov.nih.nlm.lode.model.LookupService;
import gov.nih.nlm.lode.model.PairCriteria;
import gov.nih.nlm.lode.model.ResourceAndLabel;
import uk.ac.ebi.fgpt.lode.exception.LodeException;


/**
 * Responsible for looking up the URIs of descriptors, DQPairs, etc.
 *
 * @author davisda4
 */
@Service
public class LookupServiceImpl implements LookupService {

    private Logger log = LoggerFactory.getLogger(getClass());

    public static final String DESCRIPTOR_QUERY_PREFIX = "descriptor.";
    public static final String PAIR_QUERY_PREFIX = "pair.";
    public static final String ALLOWED_QUALIFERS_ID = "allowed.qualifiers";
    public static final String RESOURCE_LABEL_ID = "label.for.resource";

    private Resource queryResource;
    private Map<String,Object> queryMap;
    private JenaResourceService resourceService;


    @Override
    public Collection<ResourceAndLabel> lookupDescriptors(DescriptorCriteria criteria) throws LodeException {
        String queryId = DESCRIPTOR_QUERY_PREFIX + criteria.getRelation().toString().toLowerCase();
        return getResourceService().getResources(getQuery(queryId), criteria.getLabel(), criteria.getLimit());
    }

    @Override
    public Collection<ResourceAndLabel> lookupPairs(PairCriteria criteria) throws LodeException {
        String queryId = PAIR_QUERY_PREFIX + criteria.getRelation().toString().toLowerCase();
        return getResourceService().getResources(getQuery(queryId), criteria.getLabel(), criteria.getLimit(), criteria.getDescriptor());
    }

    @Override
    public Collection<ResourceAndLabel> allowedQualifiers(String descriptorUri) throws LodeException {
        return getResourceService().getResources(getQuery(ALLOWED_QUALIFERS_ID), null, 0, descriptorUri);
    }

    @Override
    public Collection<String> lookupLabel(String resourceUri) throws LodeException {
        return getResourceService().getResourceLabels(getQuery(RESOURCE_LABEL_ID), resourceUri);
    }

    public Resource getQueryResource() {
        return queryResource;
    }

    @Value("${lode.lookup.queries:classpath:lookup-queries.yaml}")
    public void setQueryResource(Resource resource) {
        this.queryResource = resource;
    }

    public synchronized String getQuery(final String queryId) throws LodeException {
        Object query = getQueryMap().get(queryId);
        if (query == null) {
            throw new LodeException(String.format("%s: query not found", queryId));
        } else if (!(query instanceof String)) {
            throw new LodeException(String.format("%s: query not a String", queryId));
        }
        return (String) query;
    }

    public synchronized final Map<String,Object> getQueryMap() throws LodeException {
        if (queryMap == null) {
            Yaml yaml = new Yaml();
            try {
                queryMap = yaml.load(getQueryResource().getInputStream());
            } catch (IOException ex) {
                log.error("Unable to load lookup queries from queryResource", ex);
                throw new LodeException("Unable to load lookup queries from queryReource");
            }
        }
        return queryMap;
    }

    public JenaResourceService getResourceService() {
        return resourceService;
    }

    @Autowired
    public void setResourceService(JenaResourceService resourceService) {
        this.resourceService = resourceService;
    }
 }
