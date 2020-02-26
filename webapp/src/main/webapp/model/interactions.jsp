<%@ taglib tagdir="/WEB-INF/tags" prefix="im" %>
<!-- interactions.jsp -->
<table width="100%">
  <tr>
    <td valign="top">
      <div class="heading2">
        Current data
      </div>
      <div class="body">
        <h4>
          <a href="javascript:toggleDiv('hiddenDiv1');">
            <img id='hiddenDiv1Toggle' src="images/disclosed.gif"/>
            Interactions datasets ...
          </a>
        </h4>

        <div id="hiddenDiv1" class="dataSetDescription">

          <ul><li><dt>Protein interactions have been loaded for <i>D. melanogaster</i>, <i>C. elegans</i> and <i>S. cerevisiae</i> from <a href="http://www.ebi.ac.uk/intact/" target="_new">IntAct</a>.</dt></li></ul>

          <ul><li><dt>Genetic and protein interaction data for <i>D. melanogaster</i>, <i>C. elegans</i> and <i>S. cerevisiae</i> have been loaded from the <a href="http://www.thebiogrid.org/" target="_new">BioGRID</a>. These data include both high-throughput studies and conventional focused studies and have been curated from the literature.</dt></li></ul>

        </div>

    </td>

    <td width="40%" valign="top">
      <div class="heading2">
        Bulk download
      </div>
      <div class="body">
        <ul>

          <li>
            <im:querylink text="All Locusta migratoria interactions " skipBuilder="true">
<query name="" model="genomic" view="Interaction.participant1.primaryIdentifier Interaction.participant2.primaryIdentifier Interaction.details.type" sortOrder="Interaction.participant1.primaryIdentifier asc">
</query>
            </im:querylink>
    </li>

        </ul>
      </div>
    </td>
  </tr>
</table>
<!-- /interactions.jsp -->
