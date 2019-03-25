package gov.nih.nlm.lode.service;

import org.apache.jena.sparql.algebra.Op;
import org.apache.jena.sparql.algebra.TransformBase;
import org.apache.jena.sparql.algebra.op.OpProject;
import org.apache.jena.sparql.algebra.op.OpSlice;

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
