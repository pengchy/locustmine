/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.testmine.web;

/**
 *
 * @author ThinkPad
 */

import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.Set;

import org.apache.log4j.Logger;
import org.intermine.api.profile.InterMineBag;
//import org.intermine.model.bio.ExonExpressionScore;
import org.intermine.model.bio.Gene;
import org.intermine.model.bio.RNASeqResult;
//import org.intermine.model.bio.Submission;

import org.intermine.objectstore.ObjectStore;
import org.intermine.objectstore.query.BagConstraint;
//import org.intermine.objectstore.query.ConstraintOp;
import org.intermine.metadata.ConstraintOp;
import org.intermine.objectstore.query.ConstraintSet;
import org.intermine.objectstore.query.Query;
import org.intermine.objectstore.query.QueryClass;
import org.intermine.objectstore.query.QueryField;
import org.intermine.objectstore.query.QueryFunction;
import org.intermine.objectstore.query.QueryNode;
import org.intermine.objectstore.query.Results;
import org.intermine.objectstore.query.ResultsRow;

/**
 * Utility methods for the modMine package.
 * Refer to BioUtil.
 *
 * @author Fengyuan Hu
 */
public final class TestMineUtil
{
    protected static final Logger LOG = Logger.getLogger(TestMineUtil.class);

    private static Double geneExpressionScoreMax = null; // 53808
    private static Double geneExpressionScoreMin = null; // 0


    private TestMineUtil() {
        super();
    }

    /**
     * Get the max value of gene expression scores.
     *
     * @param os the production objectStore
     * @return geneExpressionScoreMax
     */
    public static synchronized Double getMaxGeneExpressionScore(ObjectStore os) {
        if (geneExpressionScoreMax == null || geneExpressionScoreMin == null) {
            queryGeneExpressionScores(os);
        }

        return geneExpressionScoreMax;
    }

    /**
     * Get the min value of gene expression scores.
     *
     * @param os the production objectStore
     * @return geneExpressionScoreMin
     */
    public static synchronized Double getMinGeneExpressionScore(ObjectStore os) {
        if (geneExpressionScoreMax == null || geneExpressionScoreMin == null) {
            queryGeneExpressionScores(os);
        }

        return geneExpressionScoreMin;
    }


    /**
    * Query the max and min values of gene expression scores.
    *
    * @param os the production objectStore
    */
    private static void queryGeneExpressionScores(ObjectStore os) {
        Query q = new Query();

        QueryClass qcObject = new QueryClass(RNASeqResult.class);
        QueryField qfObjectScore = new QueryField(qcObject, "expressionScore");
        QueryNode max = new QueryFunction(qfObjectScore, QueryFunction.MAX);
        QueryNode min = new QueryFunction(qfObjectScore, QueryFunction.MIN);

        q.addFrom(qcObject);
        q.addToSelect(min);
        q.addToSelect(max);

        Results r = os.execute(q);

        @SuppressWarnings({ "rawtypes", "unchecked" })
        Iterator<ResultsRow> it = (Iterator) r.iterator();
        while (it.hasNext()) {
            @SuppressWarnings("rawtypes")
            ResultsRow rr = it.next();
            geneExpressionScoreMin =  (Double) rr.get(0);
            geneExpressionScoreMax =  (Double) rr.get(1);
        }
    }


    /**
     * Get a set of Gene primaryId from within a bag
     *
     * @param os the ObjectStore
     * @param bag a bag of Genes
     * @return a set of string as primaryId of the genes
     */
    public static Set<String> getGenes(ObjectStore os, InterMineBag bag) {

        Query q = new Query();

        QueryClass qcObject = new QueryClass(Gene.class);

        // InterMine id for any object
        QueryField qfObjectId = new QueryField(qcObject, "id");
        QueryField qfGenePID = new QueryField(qcObject, "primaryIdentifier");

        q.addFrom(qcObject);
        q.addToSelect(qfGenePID);

        ConstraintSet cs = new ConstraintSet(ConstraintOp.AND);
        BagConstraint bc = new BagConstraint(qfObjectId, ConstraintOp.IN, bag.getOsb());
        cs.addConstraint(bc);

        q.setConstraint(cs);

        Results r = os.execute(q);
        @SuppressWarnings({ "rawtypes", "unchecked" })
        Iterator<ResultsRow> it = (Iterator) r.iterator();

        Set<String> genePIds = new LinkedHashSet<String>();

        while (it.hasNext()) {
            @SuppressWarnings("rawtypes")
            ResultsRow rr = it.next();
            String genePId =  (String) rr.get(0);
            genePIds.add(genePId);
        }

        return genePIds;
    }
}
