This page will be a survey of all of the URLs that will be handled by our deployed application, and what you can expect, from each.

| URL Pattern                          | Accept header |            Result                        | 
|--------------------------------------|---------------|------------------------------------------|
| http://id.nlm.nih.gov/               |  *any*        | A picture of a cute kitten.              |
| http://id.nlm.nih.gov/mesh           |  *any*        | Something informative.                   |
| http://id.nlm.nih.gov/mesh/{id}      | text/html     | 303 Redirect to {$1}.html                |
| http://id.nlm.nih.gov/mesh/{id}.html | text/html     | HTML page with info about the resource {id} |

