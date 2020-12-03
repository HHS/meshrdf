package gov.nih.nlm.lode.model;

public interface ConfigService {
    public static final String MESHRDF_YEAR = "meshrdf.year";
    public static final String MESHRDF_INTERIM = "meshrdf.interim";
    public static final int MESHRDF_MINYEAR = 2015;

    public int getMeshYear();
    public Integer getInterimYear(int meshYear);
    public ValidYears getValidYears();
}
