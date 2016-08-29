package gov.nih.nlm.lode.servlet;

/*
 * Licensed under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software distributed under the
 * License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied. See the License for the specific language governing permissions
 * and limitations under the License.
 */


import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Daniel A. Davis
 * @date 06/11/2015
 * U.S.National Library of Medicine
 *
 * Validate request parameters such as uri, resource_prefix, etc.
 */
public class ValidationFilter extends OncePerRequestFilter {

    private Logger log = LoggerFactory.getLogger(getClass());
    private static Pattern _uri_pattern = null; 

    private synchronized Pattern getPatternForUri() {
        if (null == _uri_pattern ) {
            try {
                _uri_pattern = Pattern.compile("^http://id.nlm.nih.gov/mesh/(\\d{4,4}/)?[DQMC\\d]+$");
            } catch (PatternSyntaxException e) {
                log.error("regex syntax", e);
            }
        }
        return _uri_pattern;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        String rp = request.getParameter("resource_prefix");
        if (rp != null) {
            for (int i = 0; i < rp.length(); i++) {
                char c = rp.charAt(i);
                if (c != '.' && c != '/') {
                    response.sendError(422, "resource_prefix is not in expected format");
                    return;
                }
            }
        }

        String uri = request.getParameter("uri");
        if (uri != null) {
            Pattern p = getPatternForUri();
            if (!p.matcher(uri).matches()) {
                response.sendError(422, "uri is not in expected format");
                return;
            }
        }
        filterChain.doFilter(request, response);
    }
}
