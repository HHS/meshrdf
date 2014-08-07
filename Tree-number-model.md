Discussion on [#22](https://github.com/HHS/mesh-rdf/issues/22).

See this diagram, which illustrates the problem of tree numbers, that impose multiple overlapping trees

![](https://cloud.githubusercontent.com/assets/77226/3799017/0cfd2b52-1bea-11e4-8786-01e144579e85.png)

The decision, as of the time of this writing, is that transitive closure relations will be in a separate graph.  But I [klortho] still would like to push back, and suggest the following model instead.  By promoting tree numbers to first-class resources, we would allow queries to find "grandparent" and "great-grandparent" concepts within the same graph, without ambiguity.

![](https://cloud.githubusercontent.com/assets/77226/3817027/e4b8db10-1cd3-11e4-9065-d980c79b9e1d.png)

