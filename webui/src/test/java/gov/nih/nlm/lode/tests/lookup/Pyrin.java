package gov.nih.nlm.lode.tests.lookup;

/**
 * This is supporting software that holds constants for testing of matches
 * on the string "Pyrin" for descriptor matching by Exact match,
 * Contains match, and Starts with matching.
 *
 * @author davisda4
 */
public class Pyrin {
    public static String DESCRIPTOR_LABEL = "Pyrin";
    public static String IDENTIFIER = "D000071198";
    public static String DESCRIPTOR_URI = "http://id.nlm.nih.gov/mesh/"+IDENTIFIER;
    public static String DESCRIPTOR_YEAR_URI = "http://id.nlm.nih.gov/mesh/2021/"+IDENTIFIER;

    public static String[] EXACT_MATCH_URIS = new String[] { DESCRIPTOR_URI };

    public static String[] CONTAINS_MATCH_URIS = new String[] {
            "http://id.nlm.nih.gov/mesh/D000071199",
            "http://id.nlm.nih.gov/mesh/D000071198",
            "http://id.nlm.nih.gov/mesh/D000071196",
    };

    public static String[] STARTSWITH_MATCH_URIS = new String[] {
            "http://id.nlm.nih.gov/mesh/D000071198",
            "http://id.nlm.nih.gov/mesh/D000071196",
    };

    public static String[] CHEMI_QUALIFIER_LABELS = new String[] {
            "Pyrin/chemical synthesis",
            "Pyrin/chemistry",
    };
    public static String[] CHEMI_QUALIFIER_URIS = new String[] {
            "http://id.nlm.nih.gov/mesh/D000071198Q000138",
            "http://id.nlm.nih.gov/mesh/D000071198Q000737",
    };
}
