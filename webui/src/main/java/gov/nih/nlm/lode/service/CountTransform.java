package gov.nih.nlm.lode.service;

import com.hp.hpl.jena.sparql.algebra.Op;
import com.hp.hpl.jena.sparql.algebra.TransformBase;
import com.hp.hpl.jena.sparql.algebra.op.OpProject;

public class CountTransform extends TransformBase {

    @Override
    public Op transform(OpProject opProject, Op subOp) {
        return opProject;
    }
}
