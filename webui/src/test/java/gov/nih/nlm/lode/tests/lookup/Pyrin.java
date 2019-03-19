package gov.nih.nlm.lode.tests.lookup;

public class Pyrin {
    public static String DESCRIPTOR_LABEL = "Pyrin";

    public static String[] EXACT_MATCH_URIS = new String[] {
            "http://id.nlm.nih.gov/mesh/D000071198",
    };

    public static String[] CONTAINS_MATCH_URIS = new String[] {
            "http://id.nlm.nih.gov/mesh/D000071199",
            "http://id.nlm.nih.gov/mesh/D000071198",
            "http://id.nlm.nih.gov/mesh/D000071196",
    };

    public static String[] STARTSWITH_MATCH_URIS = new String[] {
            "http://id.nlm.nih.gov/mesh/D000071198",
            "http://id.nlm.nih.gov/mesh/D000071196",
    };
}
