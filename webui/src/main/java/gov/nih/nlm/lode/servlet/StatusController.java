package gov.nih.nlm.lode.servlet;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import uk.ac.ebi.fgpt.lode.utils.DatasourceProvider;


/**
 * A servlet that can be embedded within your web application and simply returns the string "OK" if it could be
 * accessed.  This can be used to allow load balancers in the production environment to detect when a web application
 * has crashed and send a notification to the mailing lists.
 */
@Controller
@RequestMapping("/status")
public class StatusController {

    @Autowired
    DatasourceProvider datasourceProvider;

    @Value("${meshrdf.update.path}")
    String updatesPath;

    @Value("${meshrdf.update.maxseconds}")
    long updateMaxSeconds;

    @RequestMapping
    public @ResponseBody
    MeshStatus checkStatus() {
        MeshStatus status = new MeshStatus(datasourceProvider, updatesPath, updateMaxSeconds);
        status.check();
        return status;
    }

}
