package gov.nih.nlm.lode.tests;

import java.util.List;
import java.util.ArrayList;
import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;
import java.net.URL;
import java.net.URI;
import java.net.MalformedURLException;
import java.net.URISyntaxException;
import java.io.IOException;

import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.Header;
import org.apache.http.HttpRequest;
import org.apache.http.HttpResponse;
import org.apache.http.message.BasicHeader;

import org.testng.Reporter;
import static org.testng.Assert.*;


public class LinkChecker {

    public interface RequestCallback {
        public void withRequest(HttpRequest request);
    }

    public interface ResponseCallback {
        public void withResponse(HttpResponse response);
    }

    private URL context;
    private boolean followRedirects;
    private long delay;
    private static long defaultDelay = -1;
    private Integer connectTimeout;
    private Integer socketTimeout;

    private List<URI> links = new ArrayList<URI>();
    private List<LinkChecker.RequestCallback> requestCallbacks = new ArrayList<LinkChecker.RequestCallback>();
    private List<LinkChecker.ResponseCallback> responseCallbacks = new ArrayList<LinkChecker.ResponseCallback>();

    public LinkChecker() {
        this(null, true);
    }

    public LinkChecker(String context) {
        this(context, true);
    }

    public LinkChecker(boolean followRedirects) {
        this(null, followRedirects);
    }

    public LinkChecker(String context, boolean followRedirects) {
        this.followRedirects = followRedirects;
        if (context == null) {
            this.context = null;
        } else {
            try {
                this.context = new URL(context);
            } catch (MalformedURLException e) {
                fail("context '"+context+"' is not a valid URL");
            }
        }
        this.delay = getDefaultDelay();
    }

    public static long getDefaultDelay() {
        if (defaultDelay < 0) {
            String delay = System.getenv("LINKCHECK_DELAY");
            if (delay != null) {
                try {
                    defaultDelay = Long.parseLong(delay);
                } catch (NumberFormatException e) {
                    System.err.println("warning: LINKCHECK_DELAY should be a positive, long integer\n");
                }
                if (defaultDelay < 0) {
                    System.err.println("warning: LINKCHECK_DELAY should be a positive, long integer\n");
                    defaultDelay = 0;
                }
            }
        }
        return defaultDelay;
    }

    public void setDelay(long milliseconds) {
        delay = milliseconds;
    }

    public long getDelay() {
        return delay;
    }

    public void setConnectTimeout(Integer seconds) {
        this.connectTimeout = seconds;
    }

    public Integer getConnectTimeout() {
        return connectTimeout;
    }

    public void setSocketTimeout(Integer seconds) {
        this.socketTimeout = seconds;
    }

    public Integer getSocketTimeout() {
        return socketTimeout;
    }

    public void addRequestCallback(LinkChecker.RequestCallback callback) {
        requestCallbacks.add(callback);
    }

    public void addResponseCallback(LinkChecker.ResponseCallback callback) {
        responseCallbacks.add(callback);
    }

    public void addRequestHeader(String name, String value) {
        addRequestHeader(new BasicHeader(name, value));
    }

    public void addRequestHeader(final Header header) {
        addRequestCallback(new LinkChecker.RequestCallback() {
            @Override
            public void withRequest(HttpRequest request) {
                request.setHeader(header);
            }
        });
    }

    public void shouldMatchContentType(String contentTypeExpr) {
        shouldMatchResponseHeader("Content-Type", contentTypeExpr);
    }

    public void shouldMatchResponseHeader(final String name, final String valueExpr) {
        try {
            final Pattern pattern = Pattern.compile(valueExpr);
            addResponseCallback(new LinkChecker.ResponseCallback() {
                @Override
                public void withResponse(HttpResponse response) {
                    Header header = response.getFirstHeader(name);
                    assertNotNull(header);
                    assertTrue( pattern.matcher( header.getValue() ).matches(),
                        String.format("%s response header '%s' should match '%s'", name, header.getValue(), valueExpr));
                }
            });
        } catch (PatternSyntaxException e) {
            fail(String.format("shouldMatchResponseHeader('%s', '%s')Z regex syntax error", name, valueExpr));
        }
    }

    public void add(URL url) {
        String protocol = url.getProtocol();
        if (protocol.equals("http") || protocol.equals("https")) {
            try {
                links.add(url.toURI());
            } catch(URISyntaxException e) {
                fail("url '"+url.toString()+"' is not valid");
            }
        } else {
            Reporter.log(String.format("<b>warning:</b> cannot check %s<br>", url.toString()));
        }
    }

    public void add(String urlspec) {
        try {
            URL url = (this.context != null ? new URL(this.context, urlspec) : new URL(urlspec));
            add(url);
        } catch (MalformedURLException e) {
            fail("url specification '"+urlspec+"' is not valid");
        }
    }

    public void add(String contextspec, String urlspec) {
        URL localContext = null;
        try {
            localContext = new URL(contextspec);
        } catch (MalformedURLException e) {
            fail("context "+contextspec+" is not a valid URL");
        }
        try {
            URL fullurl = new URL(localContext, urlspec);
            add(fullurl);
        } catch (MalformedURLException e) {
            fail("url specification '"+urlspec+"' is not valid");
        }
    }

    public void shouldBeValid() {
        URI lastbadlink = null;
        RequestConfig.Builder config = RequestConfig.custom();
        if (connectTimeout != null)
            config.setConnectTimeout(connectTimeout * 1000);
        if (socketTimeout != null)
            config.setSocketTimeout(socketTimeout * 1000);
        HttpClientBuilder builder = HttpClients.custom();
        builder.setDefaultRequestConfig(config.build());
        if (!followRedirects)
            builder.disableRedirectHandling();
        CloseableHttpClient client = builder.build();
        for (URI link : links) {
            HttpGet request = new HttpGet(link);
            // set any request headers
            for (LinkChecker.RequestCallback callback : requestCallbacks) {
                callback.withRequest(request);
            }
            CloseableHttpResponse response = null;
            try {
                response = client.execute(request);
            } catch (ClientProtocolException e) {
                Reporter.log(String.format("%s: ClientProtocolException: %s<br>", link, e.getMessage()));
                lastbadlink = link;
            } catch (IOException e) {
                Reporter.log(link.toString()+": IOException "+e.getMessage()+"<br>");
                lastbadlink = link;
            }
            if (response != null) {
                // must be a "successful" response code
                int code = response.getStatusLine().getStatusCode();
                if (code < 200 || code >= 300) {
                    Reporter.log(String.format("%s: status code %d, not successful<br>", link, code));
                    lastbadlink = link;
                } else {
                    // should have correct values for expected response headers
                    for (LinkChecker.ResponseCallback callback : responseCallbacks) {
                        callback.withResponse(response);
                    }
                }
                try {
                    response.close();
                } catch (IOException e) {
                    // DO NOTHING
                }
            }

            // sleep for a minimal delay to avoid server throttle
            long millis = delay;
            while (millis > 0) {
                long deadline = System.currentTimeMillis() + millis;
                try {
                    Thread.sleep(millis);
                } catch (InterruptedException e) {
                    millis = deadline - System.currentTimeMillis();
                }
            }
        }
        if (null != lastbadlink) {
            fail(String.format("one or more bad links, last bad link %s", lastbadlink));
        }
        try {
            client.close();
        } catch (IOException e) {
            // DO NOTHING
        }
    }
}
