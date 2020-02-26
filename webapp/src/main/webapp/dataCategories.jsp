<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="im" %>


<!-- /errorMessagesContainers.jsp -->
<!-- contextHelp.jsp -->
<!-- dataCategories -->
<div class="plainbox" style="" >
  <dl>
    <dt>
        
        <h1 id="">
      
        
        
          Data
        
      
    </h1></dt>
    <dd>
      <p>LocustMine integrates multiple data types mainly collected manuualy from our laboratory and the Locust Genome Project. This page provides a list of the data and data sources loaded into LocustMine. </p>
    </dd>
  </dl>
</div>
<table cellpadding="0" cellspacing="0" border="0" class="dbsources">
  <tr>
    <th>Data Category</th>
    <th>Data</th>
    <th>Source or methods</th>
  </tr>
  <tr>
    <td class="leftcol"><h2>
      <p>Genome</p>
    </h2></td>
    <td>Genome annotation for<em> Locusta migratoria </em>.  Data loaded includes:
      <ul>
          <li>PrimaryIdentifier </li>
        <li>SecondaryIdentifier </li>
        <li>Symbol </li>
        <li>Name </li>
        <li>Length </li>
        <li>Description </li>
        <li>Feature type </li>
        <li>Locations </li>
        <li>Sequences </li>
      </ul></td>
    <td><a href="http://locustmine.org/" target="_new">LocustBase</a></td>
  </tr>
  <tr>
    <td rowspan="2" class="leftcol"><h2>
      <p>Homology</p>
    </h2></td>
    <td>Homologs for <i>Locusta migratoria </i>. Produced using InParanoid version 4.1 for the following species:<em>Anopheles gambiae</em>(AgamP4), <em>Caenorhabditis elegans</em> (WBcel235), <em>Drosophila melanogaster</em> (r5.27), <em>Tribolium castaneum</em> (OGS3),<em>Homo sapiens</em> (GRCh38), <em>Mus musculus</em> (GRCm38), <em>Rattus norvegicus</em> (Rnor_6.0), <em>Saccharomyces cerevisiae</em> (R64), <em>Danio rerio</em> (GRCz11)</td>
    <td><p><a href="http://software.sbc.su.se/cgi-bin/request.cgi?project=inparanoid" target="_new">InParanoid</a> <a href="https://www.ensembl.org/" target="_new">Ensembl</a><br />
        <a href="http://beetlebase.org/">BeetleBase</a></p></td>
  </tr>
  <tr></tr>
  <tr>
    <td class="leftcol"><p> </p>
        <h2>Proteins</h2>
      <p></p></td>
    <td>Protein annotations</td>
    <td><a href="http://locustmine.org/" target="_new">LocustBase</a><a href="http://www.yeastgenome.org" target="_new"></a> </td>
  </tr>
  <tr>
    <td class="leftcol"><p> </p>
        <h2>Function</h2>
      <p></p></td>
    <td>Gene Ontology, Pathways and Protein domains </td>
    <td>Locust Genome Project </td>
  </tr>
  <tr>
    <td class="leftcol"><p> </p>
        <h2>Interactions</h2>
      <p></p></td>
    <td>Protein-protein interaction (PPI) relationship was derived using Interolog methods. PPI data was downloaded from iRefIndex. Co-expression network was constructed using WGCNA data for the Development, tissues and phase transition time course data sets, respectiviely.</td>
    <td><p><a href="http://software.sbc.su.se/cgi-bin/request.cgi?project=inparanoid" target="_new">iRefIndex</a> <a href="https://horvath.genetics.ucla.edu/html/CoexpressionNetwork/Rpackages/WGCNA/" target="_new">WGCNA</a></p></td>
  </tr>
  <tr>
    <td rowspan="2" class="leftcol"><h2>
      <p>Expression</p>
    </h2></td>
  </tr>
  <tr>
    <td>RNA-seq expression data from development, tissues and phase transition time course data sets. </td>
	<td>&nbsp;</td>
  </tr>
  <tr>
    <td class="leftcol"><p></p>
        <h2> Regulation</h2>
      <p></p></td>
    <td>Transcriptional regulatory network constructed through aggregating eight TRN reconstruction methods. </td>
    <td><br /></td>
  </tr>
</table>
</div>
