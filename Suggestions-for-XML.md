Here we can gather suggestions, based on our experience with the MeSH RDF effort, for how the MeSH XML
might be improved.


* In RegistryNumber and RelatedRegistryNumber, explicitly specifying the type of the identifier.  This would mean that any application reading the data wouldn't have to try to match each value against a (possibly ever-changing) list of id types.  See issue #32.