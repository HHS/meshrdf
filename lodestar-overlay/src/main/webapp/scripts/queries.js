/*
 * Copyright (c) 2013 EMBL - European Bioinformatics Institute
 * Licensed under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software distributed under the
 * License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied. See the License for the specific language governing permissions
 * and limitations under the License.
 */

var exampleQueries = [

    {
        shortname : "MeSH Linked Data Classes",
        description: "Retrieve the list of distinct classes in MeSH RDF.",
        query: 	"SELECT DISTINCT ?class\n" +
		"FROM <http://id.nlm.nih.gov/mesh>\n" +
		"WHERE { [] a ?class . }\n"+
		"ORDER BY ?class\n"
    },

    {
        shortname : "MeSH Linked Data Predicates",
        description: "Retrieve the list of distinct predicates in MeSH RDF.",
        query: 	"SELECT DISTINCT ?p\n" +
		"FROM <http://id.nlm.nih.gov/mesh>\n" +
		"WHERE {\n" +
		"  ?s ?p ?o .\n" +
		"} \n"+
		"ORDER BY ?p \n"
    },
	
    {
        shortname : "Ofloxacin Pharmacological Actions",
        description: "The Pharmacological Actions of Ofloxacin and their labels.",
        query:	"SELECT * \n" +
		"FROM <http://id.nlm.nih.gov/mesh>\n" +
		"WHERE {\n" +    		
		"  mesh:D015242 meshv:pharmacologicalAction ?pa .\n" +
		"  ?pa rdfs:label ?paLabel .\n" +
		"} \n"
    },

    {
        shortname : "Allowable Qualifiers",
        description: "Any MeSH descriptor that has an allowable qualifier of 'adverse effects'.",
        query:	"SELECT distinct ?d ?dLabel \n" +
		"FROM <http://id.nlm.nih.gov/mesh>\n" +
		"WHERE {\n" +
		"  ?d meshv:allowableQualifier ?q .\n" +
		"  ?q rdfs:label 'adverse effects'@en . \n" +
		"  ?d rdfs:label ?dLabel . \n" +
		"} \n" +
		"ORDER BY ?dLabel \n"
    },
	
    {
        shortname : "String search on 'infection'",
        description: "Any MeSH term ('D' or 'M') that has 'infection' as part of its name. (inference required)",
        query:	"SELECT ?d ?dName ?c ?cName \n" +
		"FROM <http://id.nlm.nih.gov/mesh>\n" +
		"WHERE {\n" +
		"  ?d a meshv:Descriptor .\n" +
		"  ?d meshv:concept ?c .\n" +
		"  ?d rdfs:label ?dName .\n" +
		"  ?c rdfs:label ?cName\n" +
		"  FILTER(REGEX(?dName,'infection','i') || REGEX(?cName,'infection','i')) \n"+
		"} \n" +
		"ORDER BY ?d \n",
        inferencing: true
    }

];
