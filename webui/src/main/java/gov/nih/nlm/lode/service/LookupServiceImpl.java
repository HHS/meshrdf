package gov.nih.nlm.lode.service;

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

import gov.nih.nlm.lode.model.DescriptorParams;
import gov.nih.nlm.lode.model.ConfigService;
import gov.nih.nlm.lode.model.JenaResourceService;
import gov.nih.nlm.lode.model.LookupService;
import gov.nih.nlm.lode.model.PairParams;
import gov.nih.nlm.lode.model.ResourceResult;
import uk.ac.ebi.fgpt.lode.exception.LodeException;

/**
 * Responsible for looking up the URIs of descriptors, DQPairs, etc.
 *
 * @author davisda4
 */
@Service
public class LookupServiceImpl implements LookupService {

    private Logger log = LoggerFactory.getLogger(getClass());

    public static final String DESCRIPTOR_QUERY_PREFIX = "descriptor_";
    public static final String PAIR_QUERY_PREFIX = "pair_";
    public static final String TERM_QUERY_PREFIX = "term_";
    public static final String ALLOWED_QUALIFERS_ID = "allowed_qualifiers";
    public static final String RESOURCE_LABEL_ID = "label_for_resource";
    public static final String DESCRIPTOR_CONCEPTS_ID = "descriptor_concepts";
    public static final String DESCRIPTOR_SEEALSO_ID = "descriptor_seealso";
    public static final String DESCRIPTOR_TERMS_ID = "descriptor_terms";

    private Resource queryResource;
    private Map<String,Object> queryMap;

    private ConfigService configService;
    private JenaResourceService resourceService;

    @Override
    public Collection<ResourceResult> lookupDescriptors(DescriptorParams criteria) throws LodeException {
        String queryId = DESCRIPTOR_QUERY_PREFIX + criteria.getMatch().toString().toLowerCase();
        String graphUri = getGraphUri(criteria.getYear());
        String queryString = getQuery(queryId, graphUri);
        return getResourceService().getResources(
                queryString,
                criteria.getLabel(),
                criteria.getLimit()
        );
    }

    @Override
    public Collection<ResourceResult> lookupPairs(PairParams criteria) throws LodeException {
        String queryId = PAIR_QUERY_PREFIX + criteria.getMatch().toString().toLowerCase();
        return getResourceService().getResources(
                getQuery(queryId),
                criteria.getLabel(),
                criteria.getLimit(),
                criteria.getDescriptor()
        );
    }

    @Override
    public Collection<ResourceResult> lookupTerms(DescriptorParams criteria) throws LodeException {
        String queryId = TERM_QUERY_PREFIX + criteria.getMatch().toString().toLowerCase();
        return getResourceService().getResources(
                getQuery(queryId),
                criteria.getLabel(),
                criteria.getLimit()
        );
    }

    @Override
    public Collection<ResourceResult> allowedQualifiers(String descriptorUri) throws LodeException {
        return getResourceService().getChildResources(
                getQuery(ALLOWED_QUALIFERS_ID),
                descriptorUri
        );
    }

    @Override
    public Collection<String> lookupLabel(String resourceUri) throws LodeException {
        return getResourceService().getResourceLabels(
                getQuery(RESOURCE_LABEL_ID),
                resourceUri
        );
    }

    @Override
    public Collection<ResourceResult> lookupDescriptorConcepts(String descriptorUri) throws LodeException {
        return getResourceService().getChildResources(
                getQuery(DESCRIPTOR_CONCEPTS_ID),
                descriptorUri
        );
    }

    @Override
    public Collection<ResourceResult> lookupDescriptorTerms(String descriptorUri) throws LodeException {
        return getResourceService().getChildResources(
                getQuery(DESCRIPTOR_TERMS_ID),
                descriptorUri
        );
    }

    @Override
    public Collection<ResourceResult> lookupDescriptorSeeAlso(String descriptorUri) throws LodeException {
        return getResourceService().getChildResources(
                getQuery(DESCRIPTOR_SEEALSO_ID),
                descriptorUri
        );
    }

    public Resource getQueryResource() {
        return queryResource;
    }

    @Value("${lode.lookup.queries:classpath:lookup-queries.yaml}")
    public void setQueryResource(Resource resource) {
        this.queryResource = resource;
    }

    public String getGraphUri(final String year) {
        if (year.equals("current")) {
            return "http://id.nlm.nih.gov/mesh";
        } else if (year.equals("interim")) {
            Integer interim = configService.getValidYears().getInterim();
            if (interim == null) {
                throw new IllegalArgumentException(
                    String.format("mesh year `%s` is invalid", year)
                );
            }
            return String.format("http://id.nlm.nih.gov/mesh/%d", interim);
        } else if (year.matches("[0-9]+")) {
            return String.format("http://id.nlm.nih.gov/mesh/%s", year);
        } else {
            throw new IllegalArgumentException(
                String.format("mesh year `%s` is invalid", year)
            );
        }
    }

    public String getQuery(final String queryId) throws LodeException {
        return this.getQuery(queryId, null);
    }

    public synchronized String getQuery(final String queryId, final String graphUri) throws LodeException {
        String query = (String)getQueryMap().get(queryId);
        if (query == null) {
            throw new LodeException(String.format("%s: query not found", queryId));
        } else if (!(query instanceof String)) {
            throw new LodeException(String.format("%s: query not a String", queryId));
        }
        if (graphUri != null) {
            query = query.replace(
                    "FROM <http://id.nlm.nih.gov/mesh>",
                    String.format("FROM <%s>", graphUri)
            );
        }
        return query;
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
    public ConfigService getConfigService() {
        return configService;
    }
    @Autowired
    public void setConfigService(ConfigService configService) {
        this.configService = configService;
    }
 }
