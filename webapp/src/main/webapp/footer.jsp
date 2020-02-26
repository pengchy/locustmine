<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- footer.jsp -->
<br/>

<div class="body" align="center" style="clear:both">
    <!-- contact -->
		<c:if test="${pageName != 'contact'}">
			<div id="contactFormDivButton">
				<im:vspacer height="11" />
				<div class="contactButton">
					<a href="#" onclick="showContactForm();return false">
						<b><fmt:message key="feedback.title"/></b>
					</a>
				</div>
			</div>
			<div id="contactFormDiv" style="display:none;">
				<im:vspacer height="11" />
				<tiles:get name="contactForm" />
			</div>
		</c:if>
    <br/>

  <!-- powered -->
	<table>
	<tr>
	<td width=200px>
  <div class="powered-footer footer">
    <p>Powered by</p>
    <a target="new" href="http://intermine.org" title="InterMine">
      <img src="images/icons/intermine-footer-logo.png" alt="InterMine logo" />
    </a>
  </div>
	</td>
	<td width=400px>
	LocustMine is developed by <a href="http://www.ipm.ioz.cas.cn/kydw/yjz/kangle/">Eco-genomics and Adaptation Group</a> at <a href="http://english.biols.cas.cn/">Beijing Institues of Life Science</a>, Chinese Academy of Sciences
	</th>
	<td width=800px>
	<div class="cite-footer footer">
		<strong>Cite us:</strong>
			<cite>${WEB_PROPERTIES['project.citation']}</cite>
	</div>
	</td>
	</tr>
	</table>

</div>

<br/>
<br/>
