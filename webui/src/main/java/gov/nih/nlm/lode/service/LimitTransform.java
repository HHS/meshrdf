package gov.nih.nlm.lode.service;

import com.hp.hpl.jena.sparql.algebra.Op;
import com.hp.hpl.jena.sparql.algebra.TransformBase;
import com.hp.hpl.jena.sparql.algebra.op.OpProject;
import com.hp.hpl.jena.sparql.algebra.op.OpSlice;

public class LimitTransform extends TransformBase {
    private long offset;
    private long limit;

    public LimitTransform(long limit, long offset) {
        this.limit = limit;
        this.offset = offset;
    }
    public LimitTransform(long limit) {
        this(limit, 0);
    }

    @Override
    public Op transform(OpProject opProject, Op subOp) {
        return new OpSlice(opProject, offset, limit);
    }
}
