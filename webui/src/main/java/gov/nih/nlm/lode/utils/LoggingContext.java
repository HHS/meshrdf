package gov.nih.nlm.lode.utils;

import org.slf4j.MDC;

public class LoggingContext {

    public static void clear() {
        MDC.clear();
    }

    public static void put(String key, boolean val) {
        MDC.put(key, Boolean.toString(val));
    }

    public static void put(String key, long val) {
        MDC.put(key, Long.toString(val));
    }

    public static void put(String key, int val) {
        MDC.put(key, Integer.toString(val));
    }

    public static void put(String key, Object val) {
        MDC.put(key, val.toString());
    }
}
