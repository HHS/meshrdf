package gov.nih.nlm.lode.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;

public class DiagnosticHttpServletResponseWrapper extends HttpServletResponseWrapper {

    private CountingServletOutputStream countingStream;
    private long startTime;

    public DiagnosticHttpServletResponseWrapper(HttpServletResponse response) {
        super(response);
        countingStream = null;
        startTime = System.currentTimeMillis();
    }

    public int getCount() {
        return (countingStream != null ? countingStream.getCount(): 0);
    }

    public long getResponseTime() {
        return System.currentTimeMillis() - startTime;
    }

    @Override
    public PrintWriter getWriter() throws IOException {
        return new PrintWriter(getOutputStream());
    }

    @Override
    public ServletOutputStream getOutputStream() throws IOException {
        if (countingStream == null) {
            countingStream = new CountingServletOutputStream(super.getOutputStream());
        }
        return countingStream;
    }
}
