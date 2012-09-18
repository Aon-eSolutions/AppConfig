<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<head>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<link href="<c:url value="/static/css/bootstrap.min.css" />" rel="stylesheet">
		<style type="text/css">
	      body {
	        padding-top: 60px;
	        padding-bottom: 40px;
	      }
	      .sidebar-nav {
	        padding: 9px 0;
	      }
	    </style>
    	<link href="<c:url value="/static/css/bootstrap-responsive.min.css" />" rel="stylesheet">
    	
    	<script type="text/javascript">
    		var contextRoot = '<%= request.getContextPath() %>/';
    	</script>
    	
		<script src="<c:url value="/static/js/jquery-1.8.1.min.js" />"></script>
		<script src="<c:url value="/static/js/bootstrap.min.js" />"></script>
		<script src="<c:url value="/static/js/application.js" />" ></script>
		<title>Application Configuration</title>
	</head>
	<body>
		<jsp:include page="includes/header.jsp" />
	    
	    <div class="container-fluid">
      		<div class="row-fluid">
	
				<!-- Side Navigation - The Applications -->
        		<div class="span3">
          			<div class="well sidebar-nav">
            			<ul class="nav nav-list">
              				<li class="nav-header">Applications</li>
              				<c:forEach items="${applicationList}" var="application">
              					<li><a href="#" class="application-selectable" applicationName="${application.name}" applicationId="${application.id}">${application.name}</a></li>
              				</c:forEach>
              				<li>
              					<a href="#">Test App</a>
              					<ul>
              						<li><a href="#asdf">Test Env</a></li>
              					</ul>
              				</li>
              			</ul>
              		</div>
              		
              		<a href="#addApplicationModal" role="button" class="btn" data-toggle="modal">Add Application</a>
              	</div><!-- End Sidebar -->
              	
              	<div class="span9">
              		<div class="tabbable tabs-top">
              			<ul class="nav nav-tabs">
              				<li><a href="#settings" data-toggle="tab">Settings</a></li>
              				<li class="active"><a href="<c:url value="/application/${applicationList[0].name}/environment/Default"/>">Default</a></li>
              				<li><a href="#tab2" data-toggle="tab">Development</a></li>
              				<li class="pull-right"><a href="#addEnvironmentModal" data-toggle="modal">Add +</a></li>
              			</ul>
              			
              			<div class="tab-content">
              				<div class="tab-pane active" id="tab1">
	              				<table class="table table-hover">
			              			<thead>
				              			<tr>
				              				<th>Key</th>
				              				<th>Value</th>
				              				<th width="30" class="tooltip-holder" rel="tooltip" data-placement="left" title="Indication if this value is inherited from a parent environment"><i class="icon-arrow-up"></i> ?</th>
				              			</tr>
				              		</thead>
				              		<tbody>
					              		<tr>
					              			<td>application.setting.1</td>
					              			<td>Hello</td>
					              			<td>&nbsp;</td>
					              		</tr>
					              		<tr>
					              			<td>application.setting.2</td>
					              			<td>World</td>
					              			<td>&nbsp;</td>
					              		</tr>
				              		</tbody>
								</table>
								
								<button class="btn">Add Property</button>
								<button class="btn btn-danger">Delete Environment</button>
              				</div>
              				
              				<div class="tab-pane" id="tab2">
              					<p>Inherits from <a href="#tab1" data-toggle="tab">Default</a></p>
              					<table class="table table-hover">
			              			<thead>
				              			<tr>
				              				<th>Key</th>
				              				<th>Value</th>
				              				<th width="30" class="tooltip-holder" rel="tooltip" data-placement="left" title="Indication if this value is inherited from a parent environment"><i class="icon-arrow-up"></i> ?</th>
				              			</tr>
				              		</thead>
				              		<tbody>
					              		<tr>
					              			<td>application.setting.1</td>
					              			<td>Hello</td>
					              			<td><i class="icon-arrow-up tooltip-holder" rel="tooltip" data-placement="left" title="Inherits from Default"></i></td>
					              		</tr>
					              		<tr>
					              			<td>application.setting.2</td>
					              			<td>World</td>
					              			<td><i class="icon-arrow-up tooltip-holder" rel="tooltip" data-placement="left" title="Inherits from Default"></i></td>
					              		</tr>
					              		<tr>
					              			<td>application.setting.3</td>
					              			<td>I'm New!</td>
					              			<td>&nbsp;</td>
					              		</tr>
				              		</tbody>
								</table>
								
								<button class="btn">Add Property</button>
								<button class="btn btn-danger">Delete Environment</button>
              				</div>
              				
              				<div class="tab-pane" id="settings">
              					<form>
              						<legend id="settings-label">iVOS Settings</legend>
              						<label>Application Name</label>
              						<input type="text" name="settings-name" id="settings-name" value="iVOS"/>
              						
              						<label>Application Owner</label>
              						<select>
              							<option>jcrygier</option>
              						</select>
              						
              						<label>---- Private Key ----</label>
              						<pre id="settings-privateKey"></pre>
              						
              						<label>---- Public Key ----</label>
              						<pre id="settings-publicKey"></pre>
              						<br>
              						<button type="submit" class="btn btn-primary">Save</button>
              						<button type="submit" class="btn btn-warning">Regenerate Keys</button>
              					</form>
              				</div>
              				
              			</div>
              		</div>
              	</div>
              	
			</div>
		</div>
		
		<!-- Add application modal dialog -->
		<div class="modal hide fadein" id="addApplicationModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		  <div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">�</button>
		    <h3 id="myModalLabel">Add Application</h3>
		  </div>
		  <div class="modal-body">
		    <form>
		    	<label>Application Name</label>
		    	<input id="addApplicationName" type="text" />
		    </form>
		  </div>
		  <div class="modal-footer">
		    <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
		    <button class="btn btn-primary">Save changes</button>
		  </div>
		</div>
		
		<!-- Add application modal dialog -->
		<div class="modal hide fadein" id="addEnvironmentModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		  <div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">�</button>
		    <h3 id="myModalLabel">Add Environment</h3>
		  </div>
		  <div class="modal-body">
		    <form>
		    	<label>Environment Name</label>
		    	<input id="addApplicationName" type="text" />
		    	
		    	<label>Extends</label>
		    	<select>
		    		<option value="">None</option>
		    	</select>
		    </form>
		  </div>
		  <div class="modal-footer">
		    <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
		    <button class="btn btn-primary">Save changes</button>
		  </div>
		</div>
		              
	</body>
</html>