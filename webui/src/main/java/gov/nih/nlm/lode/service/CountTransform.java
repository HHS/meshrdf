package gov.nih.nlm.lode.service;

import org.apache.jena.sparql.algebra.Op;
import org.apache.jena.sparql.algebra.TransformBase;
import org.apache.jena.sparql.algebra.op.OpProject;

public class CountTransform extends TransformBase {

    @Override
    public Op transform(OpProject opProject, Op subOp) {
        return opProject;
    }
}
