<%@ Page Language="C#" AutoEventWireup="true" CodeFile="form.aspx.cs" Inherits="form" %>
<%@ Register TagPrefix="wuc" TagName="LeftMenu" Src="~/template/ascx/LeftMenu.ascx" %>
<%@ Register TagPrefix="wuc" TagName="graph1" Src="~/template/ascx/graph.ascx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml"  lang="en" ng-app>
<head runat="server">
        <meta charset="utf-8" />
		<title></title>
		<meta name="keywords" content="" />
		<meta name="description" content="" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<!-- basic styles -->
		<link href="assets/css/bootstrap.min.css" rel="stylesheet" />
		<link rel="stylesheet" href="assets/css/font-awesome.min.css" />
        <link rel="stylesheet" href="assets/css/chosen.css" />             
        <link rel="stylesheet" href="assets/css/datepicker.css" />
		<link rel="stylesheet" href="assets/css/bootstrap-timepicker.css" />
		<!--[if IE 7]>
		  <link rel="stylesheet" href="assets/css/font-awesome-ie7.min.css" />
		<![endif]-->
		<!-- page specific plugin styles -->
		<!-- fonts -->
		<link rel="stylesheet" href="http://fonts.googleapis.com/css?family=Open+Sans:400,300" />
		<!-- ace styles -->
		<link rel="stylesheet" href="assets/css/ace.min.css" />
		<link rel="stylesheet" href="assets/css/ace-rtl.min.css" />
		<link rel="stylesheet" href="assets/css/ace-skins.min.css" />
        
		<!--[if lte IE 8]>
		  <link rel="stylesheet" href="assets/css/ace-ie.min.css" />
		<![endif]-->
		<!-- inline styles related to this page -->
		<!-- ace settings handler -->
		<script src="assets/js/ace-extra.min.js"></script>
		<!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
		<!--[if lt IE 9]>
		<script src="assets/js/html5shiv.js"></script>
		<script src="assets/js/respond.min.js"></script>
		<![endif]-->
        <!-- basic scripts -->
		<!--[if !IE]> -->
		<script src="http://ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min.js"></script>
		<!-- <![endif]-->
		<!--[if IE]>
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
       <![endif]-->
		<!--[if !IE]> -->
		<script type="text/javascript">
		    window.jQuery || document.write("<script src='assets/js/jquery-2.0.3.min.js'>" + "<" + "/script>");
		</script>
		<!-- <![endif]-->				
		<script type="text/javascript">
		    if ("ontouchend" in document) document.write("<script src='assets/js/jquery.mobile.custom.min.js'>" + "<" + "script>");
		</script>
		<script src="assets/js/bootstrap.min.js"></script>
        <script src="assets/js/angular.min.js"></script>
		<script src="assets/js/typeahead-bs2.min.js"></script>

        <script src="assets/js/jquery.dataTables.min.js"></script>
		<script src="assets/js/jquery.dataTables.bootstrap.js"></script>
		<!-- page specific plugin scripts -->
		<!--[if lte IE 8]>
		  <script src="assets/js/excanvas.min.js"></script>
		<![endif]-->
		<script src="assets/js/jquery-ui-1.10.3.custom.min.js"></script>
		<script src="assets/js/jquery.ui.touch-punch.min.js"></script>		
        <script src="assets/js/chosen.jquery.min.js"></script>
        <script src="assets/js/date-time/bootstrap-datepicker.min.js"></script>
		<script src="assets/js/date-time/bootstrap-timepicker.min.js"></script>


		<!-- ace scripts -->
		<script src="assets/js/ace-elements.min.js"></script>
		<script src="assets/js/ace.min.js"></script>
        
		<!-- inline scripts related to this page -->
        <link rel="stylesheet" href="assets/css/hy-plus.css" />
        <script src="assets/js/HY-WakeUp.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="navbar navbar-default" id="navbar">
			<script type="text/javascript">
			    try { ace.settings.check('navbar', 'fixed') } catch (e) { }
			</script>
			<div id="HY-TopFrameBox" ng-include="'/Material/template/TopFrame_content.html'"  >1234</div> 
		</div>
		<div class="main-container" id="main-container">
			<script type="text/javascript">
			    try { ace.settings.check('main-container', 'fixed') } catch (e) { }
			</script>
			<div class="main-container-inner">
				<a class="menu-toggler" id="menu-toggler" href="#">
					<span class="menu-text"></span>
				</a>
                <wuc:LeftMenu ID="LeftMenu" runat="server" /> 			
				<div class="main-content">
					<div id="HY-TopMenuBar" ng-include="'/Material/template/TopMenuBar_content.html'" ></div>                    
					<div id="HY-MainFrameBox" ng-include="'/Material/template/Form_content.html'" class="page-content"></div>
				</div>				
			</div>
			<a href="#" id="btn-scroll-up" class="btn-scroll-up btn btn-sm btn-inverse">
				<i class="icon-double-angle-up icon-only bigger-110"></i>
			</a>
		</div>				
	<div style="display:none"><script src='http://v7.cnzz.com/stat.php?id=155540&web_id=155540' language='JavaScript' charset='gb2312'></script></div>
    </form>
</body>
</html>
