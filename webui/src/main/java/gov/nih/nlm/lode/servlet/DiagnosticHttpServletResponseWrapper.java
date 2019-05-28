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
        /* NOTE: There seems to be a race condition here, and perhaps synchronized must be added.
         *       it seems possible that this will not be enough.   A better clue may be to use the
         *       servlet context in the logContextFilter and look for a variable that reflects the
         *       size of data logged on the way out.  This makes the filter somewhat Tomcat specific.
         */
        if (countingStream == null) {
            countingStream = new CountingServletOutputStream(super.getOutputStream());
        }
        return countingStream;
    }
}
