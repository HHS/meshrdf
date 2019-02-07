package gov.nih.nlm.lode.servlet;

import java.util.regex.Matcher;
import java.util.regex.Pattern;


/**
 * SafeProperty sanitizes system properties and environment variables to make sure they match expected patterns.
 */
public class SafeProperty {
    /**
     * Internal function used to implement getProperty and getEnv below.
     *
     * @param rawValue - the value of a system property or environment variable
     * @param pattern - an unanchored regular expression that will be matched against the entire string
     * @return validated value or null
     */
    private static String validateString(String rawValue, String pattern) {
        String checkedValue = null;
        if (null != rawValue && rawValue.length() != 0) {
            Pattern expr = Pattern.compile(String.format("^%s$", pattern));
            Matcher idm = expr.matcher(rawValue);
            if (idm.matches()) {
                checkedValue = idm.group();
            }
        }
        return checkedValue;
    }

    /**
     * This is a careful wrapping of a system property, just in case some administrator
     * is using a system property to inject JavaScript or something.
     *
     * @param name - the name of the system property
     * @param pattern - an unanchored regular expression which must match the entire property
     * @return - validated property or null
     */
    public static String getProperty(String name, String pattern) {
        return validateString(System.getProperty(name), pattern);
    }

    /**
     * This is a careful wrapping of a system property, just in case some administrator
     * is using a system property to inject JavaScript or something.  The system property
     * is validated against an alphanumeric string.
     *
     * @param name - the name of the system property
     * @return - validated property or null
     */
    public static String getProperty(String name) {
        return getProperty(name, "[a-zA-Z0-9]");
    }

    /**
     * This is a careful wrapping of an environment variable, just in case some administrator
     * is using an environment variable to inject JavaScript or something.
     *
     * @param name - the name of the environment variable
     * @param pattern - an unanchored regular expression which must match the entire value
     * @return - validated value or null
     */
    public static String getEnv(String name, String pattern) {
        return validateString(System.getenv(name), pattern);
    }

    /**
     * This is a careful wrapping of an environment variable, just in case some administrator
     * is using an environment variable to inject JavaScript or something. Validates that the environment
     * variable is an alphanumeric string.
     *
     * @param name - the name of the environment variable
     * @return - validated value or null
     */
    public static String getEnv(String name) {
        return getEnv(name, "[a-zA-Z0-9]");
    }
}
