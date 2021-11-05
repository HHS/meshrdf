package gov.nih.nlm.lode.utils;

import java.util.Map;
import java.util.List;

public class SwaggerUtil {

    public static Object 
            getPath(final Map<String, Object> spec, String path) {
        Map<String, Object> curspec = spec;
        Object thing = null;
        for (String key : path.split(",")) {
            thing = curspec.get(key);
            if (thing == null)
                return null;
            if (thing instanceof Map)
                curspec = (Map<String, Object>) thing;
        }
        return thing;
    }

    public static Map<String, Object>
            getParameter(final Map<String, Object> spec, String path, String method, String name) {
        String pathToParameters = String.format("paths,%s,%s,parameters", path, method);
        Object rawParams = getPath(spec, pathToParameters);
        if (rawParams instanceof List) {
            List<Map<String,Object>> paramList = (List<Map<String,Object>>) rawParams;
            for (Map <String, Object> param : paramList) {
                if (param.get("name").equals(name))
                    return param;
            }
        }
        return null;
    }
}
