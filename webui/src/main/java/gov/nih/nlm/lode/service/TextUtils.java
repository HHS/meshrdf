package gov.nih.nlm.lode.service;

import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.List;

import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.LowerCaseFilter;
import org.apache.lucene.analysis.TokenStream;
import org.apache.lucene.analysis.Tokenizer;
import org.apache.lucene.analysis.standard.StandardTokenizer;
import org.apache.lucene.analysis.tokenattributes.CharTermAttribute;

public class TextUtils {
    public static Analyzer createAnalyzer() {
        return new Analyzer() {
            @Override
            protected TokenStreamComponents createComponents(String fieldName) {
                Tokenizer tokenizer = new StandardTokenizer();
                TokenStream filter = new LowerCaseFilter(tokenizer);
                return new TokenStreamComponents(tokenizer, filter);
            }
        };
    }

    public static List<String> tokenize(String text, Analyzer analyzer) throws IOException {
        List<String> results = new ArrayList<String>();
        TokenStream stream = analyzer.tokenStream("fubar", new StringReader(text));
        CharTermAttribute attr = stream.addAttribute(CharTermAttribute.class);
        stream.reset();
        while (stream.incrementToken()) {
            results.add(attr.toString());
        }
        stream.end();
        stream.close();
        return results;
    }

    public static List<String> tokenize(String text) throws IOException {
        return tokenize(text, createAnalyzer());
    }
}
