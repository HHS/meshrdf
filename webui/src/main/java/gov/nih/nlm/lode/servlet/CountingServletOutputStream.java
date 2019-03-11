package gov.nih.nlm.lode.servlet;

import java.io.IOException;

import javax.servlet.ServletOutputStream;
import javax.servlet.WriteListener;


public class CountingServletOutputStream extends ServletOutputStream {
    private ServletOutputStream originalStream;
    private int count = 0;

    public CountingServletOutputStream(ServletOutputStream wrappedStream) {
        this.originalStream = wrappedStream;
    }

    @Override
    public boolean isReady() {
        return originalStream.isReady();
    }

    @Override
    public void setWriteListener(WriteListener writeListener) {
        originalStream.setWriteListener(writeListener);
    }

    @Override
    public void write(int b) throws IOException {
        count += 1;
        originalStream.write(b);
    }

    @Override
    public void close() throws IOException {
        originalStream.close();
    }

    public int getCount() {
        return count;
    }

    public void resetCount() {
        count = 0;
    }
}
