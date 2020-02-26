<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page import="java.net.URLEncoder" language="java" %>

<!-- heatMap.jsp -->

<html:xhtml />

<tiles:importAttribute />

<!--[if IE]><script type="text/javascript" src="model/canvasXpress/js/excanvas.js"></script><![endif]-->
<script type="text/javascript" src="model/canvasXpress/js/canvasXpress.min.js"></script>

<div class="body" id="expression_div">

    <script type="text/javascript" charset="utf-8">
        jQuery(document).ready(function () {
            var feature_count = parseInt(${FeatureCount});
            if (feature_count > 100) {
                jQuery("#heatmapGraph").hide();
            } else {
                jQuery("#heatmapGraph").show();
            }
            jQuery("#bro").click(function () {
                if (jQuery("#heatmapGraph").is(":hidden")) {
                    jQuery("#oc").attr("src", "images/disclosed.gif");
                } else {
                    jQuery("#oc").attr("src", "images/undisclosed.gif");
                }
                jQuery("#heatmapGraph").toggle("slow");
            });
        })
    </script>

    <c:set var="MAX_CLUSTER" value="250" />
    <c:set var="MAX_MAP" value="600" />
    <c:set var="MAX_DEFAULT_OPEN" value="100" />

    <%--
    <hr>
    ${expressionScoreJSONCellLine}
    <hr>
    --%>
    <div id="heatmap_div">
        <p>
        <h2>
            <c:choose>
                <c:when test="${ExpressionType == 'gene'}">
                    ${WEB_PROPERTIES['heatmap.expressionScoreTitle']}
                </c:when>
                <c:otherwise>
                    ${ExpressionType}
                </c:otherwise>
            </c:choose>
        </h2>
        </p>
        <p>
            <i>
                ${WEB_PROPERTIES['heatmap.expressionScoreSummary']}
                <br>Heatmap visualization powered by
                <a href="http://www.canvasxpress.org">canvasXpress</a>, learn more about the <a href="http://www.canvasxpress.org/html/heatmap.html">display options</a>.
            </i>
        </p>
        <br/>

        <html:link linkName="#" styleId="bro" style="cursor:pointer">
            <h3>
                <c:if test="${FeatureCount > MAX_DEFAULT_OPEN}">
                    Your list is big and there could be issues with the display:
                </c:if>
                <b>Click to see/hide</b> the expression maps<img src="images/undisclosed.gif" id="oc"></h3>
            </html:link>


        <div id="heatmapGraph" style="display: block">

            <c:if test="${FeatureCount > MAX_CLUSTER}">
                Please note that clustering functions are not available for lists with more than ${MAX_CLUSTER} elements.
                <br>
            </c:if>

            <div id="heatmapContainer">
                <table>
                    <tr>
                        <td>
                            <div style="padding: 0px 0px 5px 30px;">
                                <span>Developmental Stages Clustering - Hierarchical:</span>
                                <select id="ds-hc">
                                    <option value="single" selected="selected">Single</option>
                                    <option value="complete">Complete</option>
                                    <option value="average">Average</option>
                                </select>
                                <span> and K-means:</span>
                                <select id="ds-km">
                                    <option value="3" selected="selected">3</option>
                                </select>
                            </div>
                            <canvas id="canvas_ds" width="550" height="550"></canvas>
                        </td>
                        <td>
                            <div style="padding: 0px 0px 5px 30px;">
                                <span>Tissues Clustering - Hierarchical:</span>
                                <select id="ts-hc">
                                    <option value="single" selected="selected">Single</option>
                                    <option value="complete">Complete</option>
                                    <option value="average">Average</option>
                                </select>
                                <span> and K-means:</span>
                                <select id="ts-km">
                                    <option value="3" selected="selected">3</option>
                                </select>
                            </div>
                            <canvas id="canvas_ts" width="600" height="550"></canvas>
                        </td>
                    </tr>

										<tr>
                        <td>
                            <div style="padding: 0px 0px 5px 30px;">
                                <span>Phase transition process Clustering - Hierarchical:</span>
                                <select id="pt-hc">
                                    <option value="single" selected="selected">Single</option>
                                    <option value="complete">Complete</option>
                                    <option value="average">Average</option>
                                </select>
                                <span> and K-means:</span>
                                <select id="pt-km">
                                    <option value="3" selected="selected">3</option>
                                </select>
                            </div>
                            <canvas id="canvas_pt" width="700" height="550"></canvas>
                        </td>

										</tr>
                </table>
            </div>
            <div id="description_div">
                <table border="0">
                    <tr>
                        <td ><h3 style="font-weight: bold; background: black; color: white;">More Information</h3></td>
                        <td ><h3 style="background: white;"><img src="images/disclosed.gif" id="co"></h3></td>
                    </tr>
                </table>
            </div>
            <div id="description" style="padding: 5px">
                <i>
                    <c:choose>
                        <c:when test="${ExpressionType == 'gene'}">
                            ${WEB_PROPERTIES['heatmap.expressionScoreDescription']}
                        </c:when>
                        <c:otherwise>
                            ${ExpressionType}
                        </c:otherwise>
                    </c:choose>
                </i>
            </div>
        </div>
    </div>
</div>


<script type="text/javascript">
    var feature_count = parseInt(${FeatureCount});
    var max_cluster = parseInt(${MAX_CLUSTER});
    var max_map = parseInt(${MAX_MAP});
    if ('${fn:length(expressionScoreJSONDevelopmentalStage)}' < 10) {
        jQuery('#heatmap_div').remove();
        jQuery('#expression_div').html('<i>Expression scores are not available</i>');
    } else {
        if (feature_count > max_map) {
            jQuery('#heatmap_div').remove();
            jQuery('#expression_div').html('<i>Too many elements, please select a subset to see the heat maps.</i>');
        }
        jQuery("#description").hide();
        jQuery("#description_div").click(function () {
            if (jQuery("#description").is(":hidden")) {
                jQuery("#co").attr("src", "images/disclosed.gif");
            } else {
                jQuery("#co").attr("src", "images/undisclosed.gif");
            }
            jQuery("#description").toggle("slow");
        });
        
        // hm - heatmap; ts - tissue; ds - developmentalstage; pt - phasetransition; hc - hierarchical clustering; km - kmeans

        var hm_ds = new CanvasXpress('canvas_ds',
    ${expressionScoreJSONDevelopmentalStage},
                {graphType: 'Heatmap',
                    title: 'Developmental Stage',
                    // heatmapType: 'yellow-purple',
                    dendrogramSpace: 6,
                    smpDendrogramPosition: 'right',
                    setMin: ${minExpressionScore},
                    setMax: ${maxExpressionScore},
                    varLabelRotate: 45,
                    centerData: false,
                    autoExtend: true},
                {click: function (o) {
                        var featureId = o.y.smps;
                        var condition = o.y.vars;
                        if ("${ExpressionType}" == "gene") {
                            var query = '<query name="" model="genomic" view="RNASeqResult.expressionScore RNASeqResult.sample.primaryIdentifier RNASeqResult.gene.primaryIdentifier RNASeqResult.gene.symbol RNASeqResult.organism.shortName" sortOrder="RNASeqResult.expressionScore asc" constraintLogic="A and B"><constraint path="RNASeqResult.gene" code="B" op="LOOKUP" value="' + featureId + '" extraValue=""/><constraint path="RNASeqResult.sample" code="A" op="LOOKUP" value="' + condition + '"/></query>';
                            var encodedQuery = encodeURIComponent(query);
                            encodedQuery = encodedQuery.replace("%20", "+");
                            window.open("/${WEB_PROPERTIES['webapp.path']}/loadQuery.do?skipBuilder=true&query=" + encodedQuery + "%0A++++++++++++&trail=|query&method=xml");
                        } else {
                            alert("${ExpressionType}");
                        }
                        // window.open('/${WEB_PROPERTIES['webapp.path']}/portal.do?class=Gene&externalids=' + o.y.smps);
                    }}
        );
        if (feature_count > max_cluster) {
            jQuery("#ds-hc").attr('disabled', true);
        }
        if (feature_count > 3 && feature_count <= max_cluster) {
            hm_ds.clusterSamples();
            hm_ds.kmeansSamples();
            for (var i = 4; i < feature_count; ++i) {
                jQuery('#ds-km').
                        append(jQuery("<option></option>").
                                attr("value", i).
                                text(i));
            }
        } else {
            jQuery("#ds-km").attr('disabled', true);
        }       
        hm_ds.draw();
        
                var hm_ts = new CanvasXpress('canvas_ts',
    ${expressionScoreJSONTissue},
                {graphType: 'Heatmap',
                    title: 'Tissue',
                    // heatmapType: 'yellow-purple',
                    dendrogramSpace: 6,
                    smpDendrogramPosition: 'right',
                    varDendrogramPosition: 'bottom',
                    setMin: ${minExpressionScore},
                    setMax: ${maxExpressionScore},
                    varLabelRotate: 45,
                    centerData: false,
                    autoExtend: true},
                {click: function (o) {
                        var featureId = o.y.smps;
                        var condition = o.y.vars;
                        if ("${ExpressionType}" == "gene") {
                            var query = '<query name="" model="genomic" view="RNASeqResult.expressionScore RNASeqResult.sample.primaryIdentifier RNASeqResult.gene.primaryIdentifier RNASeqResult.gene.symbol RNASeqResult.organism.shortName" sortOrder="RNASeqResult.expressionScore asc" constraintLogic="A and B"><constraint path="RNASeqResult.gene" code="B" op="LOOKUP" value="' + featureId + '" extraValue=""/><constraint path="RNASeqResult.sample" code="A" op="LOOKUP" value="' + condition + '"/></query>';
                            var encodedQuery = encodeURIComponent(query);
                            encodedQuery = encodedQuery.replace("%20", "+");
                            window.open("/${WEB_PROPERTIES['webapp.path']}/loadQuery.do?skipBuilder=true&query=" + encodedQuery + "%0A++++++++++++&trail=|query&method=xml");
                        } else {
                            alert("${ExpressionType}");
                        }
                        // window.open('/${WEB_PROPERTIES['webapp.path']}/portal.do?class=Gene&externalids=' + o.y.smps);
                    }}
        );
        // cluster on gene/exons
        if (feature_count > max_cluster) {
            jQuery("#ts-hc").attr('disabled', true);
        }
        if (feature_count > 3 && feature_count <= max_cluster) {
            hm_ts.clusterSamples();
            hm_ts.kmeansSamples();
            for (var i = 4; i < feature_count; ++i) {
                jQuery('#ts-km').
                        append(jQuery("<option></option>").
                                attr("value", i).
                                text(i));
            }
        } else {
            jQuery("#ts-km").attr('disabled', true);
        }
        // cluster on conditions
        if (feature_count <= max_cluster) {
            hm_ts.clusterVariables(); // clustering method will call draw action within it.
            hm_ts.draw();
        }
        // cx_cellline.kmeansVariables();
//            hm_cl.draw();

        var hm_pt = new CanvasXpress('canvas_pt',
    ${expressionScoreJSONPhaseTransition},
                {graphType: 'Heatmap',
                    title:  'Phase transition',
                    // heatmapType: 'yellow-purple',
                    dendrogramSpace: 6,
                    smpDendrogramPosition: 'right',
                    varDendrogramPosition: 'bottom',
                    setMin: ${minExpressionScore},
                    setMax: ${maxExpressionScore},
                    varLabelRotate: 45,
                    centerData: false,
                    autoExtend: true},
                {click: function (o) {
                        var featureId = o.y.smps;
                        var condition = o.y.vars;
                        if ("${ExpressionType}" == "gene") {
                            var query = '<query name="" model="genomic" view="RNASeqResult.expressionScore RNASeqResult.sample.primaryIdentifier RNASeqResult.gene.primaryIdentifier RNASeqResult.gene.symbol RNASeqResult.organism.shortName" sortOrder="RNASeqResult.expressionScore asc" constraintLogic="A and B"><constraint path="RNASeqResult.gene" code="B" op="LOOKUP" value="' + featureId + '" extraValue=""/><constraint path="RNASeqResult.sample" code="A" op="LOOKUP" value="' + condition + '"/></query>';
                            var encodedQuery = encodeURIComponent(query);
                            encodedQuery = encodedQuery.replace("%20", "+");
                            window.open("/${WEB_PROPERTIES['webapp.path']}/loadQuery.do?skipBuilder=true&query=" + encodedQuery + "%0A++++++++++++&trail=|query&method=xml");
                        } else {
                            alert("${ExpressionType}");
                        }
                        // window.open('/${WEB_PROPERTIES['webapp.path']}/portal.do?class=Gene&externalids=' + o.y.smps);
                    }}
        );
        // cluster on gene/exons
        if (feature_count > max_cluster) {
            jQuery("#pt-hc").attr('disabled', true);
        }
        if (feature_count > 3 && feature_count <= max_cluster) {
            hm_pt.clusterSamples();
            hm_pt.kmeansSamples();
            for (var i = 4; i < feature_count; ++i) {
                jQuery('#pt-km').
                        append(jQuery("<option></option>").
                                attr("value", i).
                                text(i));
            }
        } else {
            jQuery("#pt-km").attr('disabled', true);
        }
        // cluster on conditions
        if (feature_count <= max_cluster) {
            hm_pt.clusterVariables(); // clustering method will call draw action within it.
            hm_pt.draw();
        }
        // cx_cellline.kmeansVariables();
//            hm_cl.draw();



        
        jQuery('#ds-hc').change(function () {
            hm_ds.linkage = this.value;
            hm_ds.clusterSamples();
            hm_ds.draw();
        });
        jQuery('#ds-km').change(function () {
            hm_ds.kmeansClusters = parseInt(this.value);
            hm_ds.kmeansSamples();
            hm_ds.draw();
        });
        
        jQuery('#ts-hc').change(function () {
            hm_ts.linkage = this.value;
            hm_ts.clusterSamples();
            hm_ts.draw();
        });
        jQuery('#ts-km').change(function () {
            hm_ts.kmeansClusters = parseInt(this.value);
            hm_ts.kmeansSamples();
            hm_ts.draw();
        });
        
        jQuery('#pt-hc').change(function () {
            hm_pt.linkage = this.value;
            if (feature_count >= 3) {
                hm_pt.clusterSamples();
            }
            hm_pt.clusterVariables();
            hm_pt.draw();
        });
        jQuery('#pt-km').change(function () {
            hm_pt.kmeansClusters = parseInt(this.value);
            hm_pt.kmeansSamples();
            // hm_cl.kmeansVariables();
            hm_pt.draw();
        });
        
    }
</script>

<!-- /heatMap.jsp -->
