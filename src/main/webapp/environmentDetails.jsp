<%@page import="org.aon.esolutions.appconfig.model.Environment"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="tabbable tabs-top">
	<ul class="nav nav-tabs">
		<li><a href="#settings" data-toggle="tab">Settings</a></li>
		<li class="active"><a href="#properties" data-toggle="tab" id="environmentTab">${environment.name}</a></li>
	</ul>

	<div class="tab-content">
		<div class="tab-pane active" id="properties">
			<c:if test="${environment.parent != null}">
				<p>Inherits From ${environment.parent.name}</p>
			</c:if>
			<table class="table table-hover">
				<thead>
					<tr>
						<th width="30%">Key</th>
						<th width="66%">Value</th>
						<th width="2%" class="tooltip-holder" rel="tooltip" data-placement="left" title="Indicates if this property is overridden or inherited"><i class="icon-info-sign"></i></th>
						<th width="2%" class="tooltip-holder" rel="tooltip" data-placement="left" title="Delete this property (if overridden, you will revert)"><i class="icon-trash"></i></th>
						<th width="2%" class="tooltip-holder" rel="tooltip" data-placement="left" title="Encrypt / Decrypt this key"><i class="icon-lock"></i></th>
					</tr>
				</thead>
				<tbody id="properties-body">
					<c:forEach items="${allVariables}" var="aVariable">
						<tr class="property-row">
							<td class="property-key">${aVariable.key}</td>
							<td class="property-value">${aVariable.valueDisplay}</td>
							
							<%-- Inherited / Overrides Column (Can't be both)  --%>
							<c:if test="${aVariable.inherited}"> <%-- Inherited --%>
								<td><i class="icon-arrow-up tooltip-holder" rel="tooltip" data-placement="left" title="Inherits from ${aVariable.inheritedFrom.name}"></i></td>
							</c:if>
							<c:if test="${aVariable.overridden}"> <%-- Overridden --%>
								<td><i class="icon-share-alt tooltip-holder" rel="tooltip" data-placement="left" title="Overrides original value '${aVariable.overrideValueDisplay}' from ${aVariable.overrides.name}"></i></td>
							</c:if>
							<c:if test="${aVariable.ownedProperty}"> <%-- Neither Inherited or Overridden - so it's our own  --%>
								<td></td>
							</c:if>
							
							<%-- Delete Column --%>
							<c:if test="${aVariable.overridden}">
								<td class="tooltip-holder property-delete" rel="tooltip" data-placement="left" title="Reverts property to original value from ${aVariable.overrides.name}: ${aVariable.overrideValueDisplay}"><i class="icon-trash"></i></td>
							</c:if>
							<c:if test="${aVariable.ownedProperty}">
								<td class="tooltip-holder property-delete" rel="tooltip" data-placement="left" title="Deletes property permanantly"><i class="icon-trash"></i></td>
							</c:if>
							<c:if test="${aVariable.inherited}">
								<td></td>
							</c:if>
							
							<%-- Encrypt Column --%>
							<c:if test="${aVariable.encrypted == false && aVariable.inherited == false}">
								<td class="tooltip-holder property-encrypt" rel="tooltip" data-placement="left" title="Encrypts this property using the public key"><i class="icon-lock"></i></td>
							</c:if>
							<c:if test="${aVariable.encrypted && aVariable.inherited == false}">
								<td class="tooltip-holder property-decrypt" rel="tooltip" data-placement="left" title="Decrypts this property using the private key"><i class="icon-ok-sign"></i></td>
							</c:if>
							<c:if test="${aVariable.inherited}">
								<td></td>
							</c:if>
						</tr>
					</c:forEach>
				</tbody>
			</table>

			<button class="btn" id="addProperty">Add Property</button>
			<a href="#confirmDelete" role="button" class="btn btn-danger" data-toggle="modal">Delete Environment</a>
		</div>

		<div class="tab-pane" id="settings">
			<form id="environmentDetails-form" action="<c:url value="/application/${applicationName}/environment/${environment.name}"/>" method="POST">
				<legend id="settings-label">${environment.name} Settings</legend>
				<label>Environment Name</label> 
				<form:input path="environment.name"  />
				
				<div class="row-fluid">
					<div class="span3">
						<label>Permitted Users</label>
						<form:select cssStyle="width: 100%" size="6" path="environment.permittedUsers" items="${availableUsers}" multiple="multiple" />
					</div>
					
					<div class="span3">
						<label>Permitted Roles</label>
						<form:select cssStyle="width: 100%" size="6" path="environment.permittedRoles" items="${availableRoles}" multiple="multiple" />
					</div>
					
					<div class="span3 manual-list">
						<label>Permitted Machines</label>
						<div class="input-append">
							<input type="text" style="width: 94%"/><a class="add-on add-manual-list" href="#"><i class="icon-plus"></i></a>
						</div>
						<div class="input-append">
							<form:select cssStyle="width: 100%" size="4" path="environment.permittedMachines" items="${environment.permittedMachines}" multiple="multiple" />
							<a class="add-on remove-manual-list" href="#"><i class="icon-trash"></i></a>
						</div>
					</div>
				</div>
				
				<label class="checkbox">
					<form:checkbox path="environment.visibleToAll"/> Visible to All
				</label>
				
				<label>---- Private Key ----</label>
				<pre id="settings-privateKey">${environment.privateKeyHolder.privateKey}</pre>

				<label>---- Public Key ----</label>
				<pre id="settings-publicKey">${environment.publicKey}</pre>
				<br>
				<button type="submit" class="btn btn-primary">Save</button>
				<a href="#confirmChangeKeys" role="button" class="btn btn-warning" data-toggle="modal">Regenerate Keys</a>
			</form>
		</div>
	</div>
</div>