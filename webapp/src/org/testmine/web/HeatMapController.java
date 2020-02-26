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

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.tiles.ComponentContext;
import org.apache.struts.tiles.actions.TilesAction;
import org.intermine.api.InterMineAPI;
import org.intermine.api.profile.InterMineBag;
import org.intermine.api.profile.BagValue;
import org.intermine.api.profile.Profile;
import org.intermine.api.query.PathQueryExecutor;
import org.intermine.api.results.ExportResultsIterator;
import org.intermine.api.results.ResultElement;
import org.intermine.metadata.Model;
import org.intermine.objectstore.ObjectStore;
import org.intermine.objectstore.ObjectStoreException;
import org.intermine.pathquery.Constraints;
import org.intermine.pathquery.OrderDirection;
import org.intermine.pathquery.PathQuery;
import org.intermine.web.logic.session.SessionMethods;
import org.json.JSONObject;
import org.testmine.web.TestMineUtil;

public class HeatMapController extends TilesAction
{

    protected static final Logger LOG = Logger.getLogger(HeatMapController.class);
// TO be visualised in the Tissues heatmap
    private static final String[] EXPRESSION_ORDERED_CONDITION_TISSUE = {
        "Fat body_G","Fat body_S","Hemocyte_G","Hemocyte_S","Brain_G","Brain_S","Ganglia_G","Ganglia_S",
        "Antenna4_G","Antenna4_S","AntennaA_G","AntennaA_S","Wing_G","Wing_S","Pronotum_G",
        "Pronotum_S"};

    // TO be visualised in the DevelopmentalStage heatmap
    private static final String[] EXPRESSION_ORDERED_CONDITION_DEVELOPMENTALSTAGE = {
      "Gegg","G1+2","G3","G4","G5","Gadult","Segg","S1+2","S3","S4","S5","Sadult"};
  
      // TO be visualised in the Time course heatmap
    private static final String[] EXPRESSION_ORDERED_CONDITION_PHASETRANSITION = {
      "B-IG-C","B-IG-4h","B-IG-8h","B-IG-16h","B-IG-32h","B-IG-64h","T-IG-C","T-IG-4h",
      "T-IG-8h","T-IG-16h","T-IG-32h","T-IG-64h","B-CS-C","B-CS-4h","B-CS-8h","B-CS-16h",
      "B-CS-32h","B-CS-64h","T-CS-C","T-CS-4h","T-CS-8h","T-CS-16h","T-CS-32h","T-CS-64h"};
    
       // Separate THREE sets of conditions
    private static final List<String> EXPRESSION_CONDITION_LIST_DEVELOPMENTALSTAGE = Arrays
    .asList(EXPRESSION_ORDERED_CONDITION_DEVELOPMENTALSTAGE);
    private static final List<String> EXPRESSION_CONDITION_LIST_TISSUE = Arrays
    .asList(EXPRESSION_ORDERED_CONDITION_TISSUE);
    private static final List<String> EXPRESSION_CONDITION_LIST_PHASETRANSITION = Arrays
    .asList(EXPRESSION_ORDERED_CONDITION_PHASETRANSITION);
    
    private static final String TISSUE = "tissue";
    private static final String DEVSTAGE = "developmentalStage";
    private static final String PHASETRAN = "phaseTransition";

    private static final String GENE = "gene";


        /**
     * {@inheritDoc}
     */
    @Override
    public ActionForward execute(ComponentContext context,
            ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response) {

        HttpSession session = request.getSession();
        final InterMineAPI im = SessionMethods.getInterMineAPI(session);
        ObjectStore os = im.getObjectStore();
        InterMineBag bag = (InterMineBag) request.getAttribute("bag");


				List<BagValue> bagValues = bag.getContents();
				//System.out.println("bagValues: " + bagValues.toString());
				System.out.println("Number of genes is: " + bag.getContents().size());
				/*
				for(BagValue bag1 : bagValues){
					System.out.println("bagValue is: " + bag1.getValue());
				}
				*/


        Model model = im.getModel();

				//System.out.println("Model name: " + model.getName()); 
				//System.out.println("Model string: " + model.toString());

        Profile profile = SessionMethods.getProfile(session);
        PathQueryExecutor executor = im.getPathQueryExecutor(profile);

        try {
            findExpression(request, model, bag, executor, os);
        } catch (ObjectStoreException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

        return null;
    }
    
    private void findExpression(HttpServletRequest request, Model model,
            InterMineBag bag, PathQueryExecutor executor,
            ObjectStore os) throws ObjectStoreException {

        DecimalFormat df = new DecimalFormat("#.##");

        String expressionType = bag.getType().toLowerCase();
				System.out.println("expressionType: " + expressionType);
				System.out.println("bag Name: " + bag.getName());

        // get the 2 JSON strings
        String expressionScoreJSONTissue =
            getJSONString(model, bag, executor, expressionType, TISSUE);

        String expressionScoreJSONDevelopmentalStage =
            getJSONString(model, bag, executor, expressionType, DEVSTAGE);
        String expressionScoreJSONPhaseTransition =
            getJSONString(model, bag, executor, expressionType, PHASETRAN);

        // set the attributes
        request.setAttribute("expressionScoreJSONTissue",
                expressionScoreJSONTissue);
        request.setAttribute("expressionScoreJSONDevelopmentalStage",
                expressionScoreJSONDevelopmentalStage);
        request.setAttribute("expressionScoreJSONPhaseTransition",
                expressionScoreJSONPhaseTransition);

        // To make a legend for the heat map
        Double logExpressionScoreMin = 0.0;
        Double logExpressionScoreMax = 0.0;

        if (expressionType.equals(GENE)) {
            logExpressionScoreMin =
                Math.log(TestMineUtil.getMinGeneExpressionScore(os) + 1) / Math.log(2);
            logExpressionScoreMax =
                Math.log(TestMineUtil.getMaxGeneExpressionScore(os) + 1) / Math.log(2);
						//System.out.println("logExpressionScoreMin: " + logExpressionScoreMin);
					//	System.out.println("logExpressionScoreMax: " +  logExpressionScoreMax);
						//System.out.println("bag size: " +  bag.getSize());
        }

        request.setAttribute("minExpressionScore", df.format(logExpressionScoreMin));
        request.setAttribute("maxExpressionScore", df.format(logExpressionScoreMax));
        request.setAttribute("maxExpressionScoreCeiling", Math.ceil(logExpressionScoreMax));
        request.setAttribute("ExpressionType", expressionType);
        request.setAttribute("FeatureCount", bag.getSize());
        // request.setAttribute("FeatureCount", geneExpressionScoreMapDevelopmentalStage.size());
    }
    private List<String> getConditionsList(String conditionType) {
        if (conditionType.equalsIgnoreCase(TISSUE)) {
            return EXPRESSION_CONDITION_LIST_TISSUE;
        }
        if (conditionType.equalsIgnoreCase(DEVSTAGE)) {
            return EXPRESSION_CONDITION_LIST_DEVELOPMENTALSTAGE;
        }
        
        if (conditionType.equalsIgnoreCase(PHASETRAN)) {
            return EXPRESSION_CONDITION_LIST_PHASETRANSITION;
        }
        return null;
    }

		private String getDataSet(String conditionType) {
			if(conditionType.equalsIgnoreCase(TISSUE)) {
				return "Tissues";
			}
			if(conditionType.equalsIgnoreCase(DEVSTAGE)){
				return "Development stages";
			}
			if(conditionType.equalsIgnoreCase(PHASETRAN)){
				return "Phase transition";
			}
			return null;
		}


    private String getJSONString (Model model,
            InterMineBag bag, PathQueryExecutor executor,
            String expressionType, String conditionType) {

        String expressionScoreJSON = null;

        // Key: gene symbol or PID - Value: list of ExpressionScore objs
        Map<String, List<ExpressionResults>> expressionScoreMap =
            new LinkedHashMap<String, List<ExpressionResults>>();

        PathQuery query = new PathQuery(model);
				String dataSet = getDataSet(conditionType);
        query = queryExpressionScore(bag, dataSet, query);

        ExportResultsIterator result;
        try {
            result = executor.execute(query);
        } catch (ObjectStoreException e) {
            throw new RuntimeException("Error retrieving data.", e);
        }
        LOG.debug("GGS QUERY: -->" + query + "<--");

        List<String> conditions = getConditionsList(conditionType);
				System.out.println(conditionType + " Samples: " + conditions);

        while (result.hasNext()) {
            List<ResultElement> row = result.next();

            String id = (String) row.get(0).getField();
            String symbol = (String) row.get(1).getField();
            Double score = (Double) row.get(2).getField();
            String condition = (String) row.get(3).getField();
						if(!conditions.contains(condition)){
							System.out.println(condition + " is not in dataset " + conditionType);
							continue;
						}


//            String dCCid = (String) row.get(4).getField();

            if (symbol == null) {
                symbol = id;
            }
// should be fine with release 4.2 of canvasxpress
//            symbol = fixSymbol(symbol);

            if (!expressionScoreMap.containsKey(id)) {
                // Create a list with space for n (size of conditions) ExpressionScore
                List<ExpressionResults> expressionScoreList = new ArrayList<ExpressionResults>(
                        Collections.nCopies(conditions.size(),
                                new ExpressionResults()));
                ExpressionResults aScore = new ExpressionResults(condition,
                        score, id, symbol);

                expressionScoreList.set(conditions.indexOf(condition), aScore);
                expressionScoreMap.put(id, expressionScoreList);

            } else {
                ExpressionResults aScore = new ExpressionResults(
                        condition, score, id, symbol);
                expressionScoreMap
                .get(id).set(conditions.indexOf(condition), aScore);
            }
        }

				System.out.println("DataSets: " + conditionType);
				System.out.println("Size of the expression: " + expressionScoreMap.size());

        expressionScoreJSON = parseToJSON(StringUtils.capitalize(conditionType),
                expressionScoreMap);
				System.out.println("Data set " + dataSet + " expressionScoreJSON: " + expressionScoreJSON);

        return expressionScoreJSON;

    }
    
    private PathQuery queryExpressionScore(InterMineBag bag, String dataSet,
            PathQuery query) {

        String bagType = bag.getType();
        String type = bagType.toLowerCase();

        // Add views
        query.addViews(
                "RNASeqResult." + type + ".primaryIdentifier",
                "RNASeqResult." + type + ".symbol",
                "RNASeqResult.expressionScore",
                "RNASeqResult.sample.primaryIdentifier"
//                ,bagType + "ExpressionScore.submission.DCCid"
        );

        // Add orderby
        query.addOrderBy("RNASeqResult." + type
                + ".primaryIdentifier", OrderDirection.ASC);


        // Add constraints and you can edit the constraint values below
        query.addConstraint(Constraints.in("RNASeqResult." + type,
                bag.getName()));

				query.addConstraint(Constraints.equalsExactly("RNASeqResult.sample.dataSets.name",dataSet));

        return query;
    }
    
    /**
     * Parse expressionScoreMap to JSON string
     *
     * @param conditionType CellLine or DevelopmentalStage
     * @param geneExpressionScoreMap
     * @return json string
     */
    private String parseToJSON(String conditionType,
            Map<String, List<ExpressionResults>> expressionScoreMap) {

        // if no scores returns an empty JSON string
        if (expressionScoreMap.size() == 0) {
            return "{}";
        }

        // vars - conditions
        // smps - genes/exons
        List<String> vars =  new ArrayList<String>();
        if ("Tissue".equalsIgnoreCase(conditionType)) {
            vars = EXPRESSION_CONDITION_LIST_TISSUE;
        } else if ("DevelopmentalStage".equalsIgnoreCase(conditionType)) {
            vars = EXPRESSION_CONDITION_LIST_DEVELOPMENTALSTAGE;
        } else if("PhaseTransition".equalsIgnoreCase(conditionType)){
						vars = EXPRESSION_CONDITION_LIST_PHASETRANSITION;
				} else {
            String msg = "Wrong argument: " + conditionType
                    + ". Should be 'Tissue' or 'DevelopmentalStage' or 'PhaseTransition'";
            throw new RuntimeException(msg);
        }

        Map<String, Object> heatmapData = new LinkedHashMap<String, Object>();
        Map<String, Object> yInHeatmapData =  new LinkedHashMap<String, Object>();

        List<String> smps =  new ArrayList<String>(expressionScoreMap.keySet());

        List<String> desc =  new ArrayList<String>();
        desc.add("Intensity");

        //        List<ArrayList<Double>> data =  new ArrayList<ArrayList<Double>>();

        //      for (String seqenceFeature : expressionScoreMap.keySet()) {
        //      ArrayList<Double> dataLine = new ArrayList<Double>();
        //      for (ExpressionScore es : expressionScoreMap.get(seqenceFeature)) {
        //          dataLine.add(es.getLogScore());
        //      }
        //      data.add(dataLine);
        //  }
        double[][] data = new double[smps.size()][vars.size()];

        for (int i = 0; i < smps.size(); i++) {
            String seqenceFeature = smps.get(i);
            for (int j = 0; j < vars.size(); j++) {
                data[i][j] = expressionScoreMap.get(seqenceFeature).get(j).getLogScore();
            }
        }

        // Rotate data
        double[][] rotatedData = new double[vars.size()][smps.size()];

        int ii = 0;
        for (int i = 0; i < vars.size(); i++) {
            int jj = 0;
            for (int j = 0; j < smps.size(); j++) {
                rotatedData[ii][jj] = data[j][i];
                jj++;
            }
            ii++;
        }

        yInHeatmapData.put("vars", vars);
        yInHeatmapData.put("smps", smps);
        yInHeatmapData.put("desc", desc);
        yInHeatmapData.put("data", rotatedData);
        heatmapData.put("y", yInHeatmapData);
        JSONObject jo = new JSONObject(heatmapData);

        return jo.toString();
    }
    
}
