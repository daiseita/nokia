<%@ Page Language="C#" AutoEventWireup="true" CodeFile="A31.aspx.cs" Inherits="SiteFunction_A31" %>
<%@ Register TagPrefix="wuc" TagName="LeftMenu" Src="~/template/ascx/LeftMenu.ascx" %>
<%@ Register TagPrefix="wuc" TagName="graph1" Src="~/template/ascx/graph.ascx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml"  lang="en" ng-app>
<head id="Head1" runat="server">        
		<title>物料管理系統</title>
		<meta name="keywords" content="" />
		<meta name="description" content="" />
        <meta http-equiv="x-ua-compatible" content="ie=9" />
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <meta http-equiv="cache-control" content="no-cache" />
        <meta http-equiv="pragma" content="no-cache" />
        <meta http-equiv="expires" content="0" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<!-- basic styles -->
        <link rel="stylesheet" href="<%= ResolveUrl("~/assets/css/basic.css") %>" media="screen" type="text/css" >
        <link rel="stylesheet" href="<%= ResolveUrl("~/assets/css/bootstrap.min.css") %>" media="screen" type="text/css" > 
        <link rel="stylesheet" href="<%= ResolveUrl("~/assets/css/font-awesome.min.css") %>" media="screen" type="text/css" > 
        <link rel="stylesheet" href="<%= ResolveUrl("~/assets/css/chosen.css") %>" media="screen" type="text/css" > 
        <link rel="stylesheet" href="<%= ResolveUrl("~/assets/css/datepicker.css") %>" media="screen" type="text/css" > 
        <link rel="stylesheet" href="<%= ResolveUrl("~/assets/css/bootstrap-timepicker.css") %>" media="screen" type="text/css" > 
		
		<!--[if IE 7]>		  
          <link rel="stylesheet" href="<%= ResolveUrl("~/assets/css/font-awesome-ie7.min.css") %>" media="screen" type="text/css" >
		<![endif]-->
		<!-- page specific plugin styles -->
		<!-- fonts -->		
        <link rel="stylesheet" href="<%= ResolveUrl("~/assets/css/font.css") %>" media="screen" type="text/css" > 
		<!-- ace styles -->		       
        <link rel="stylesheet" href="<%= ResolveUrl("~/assets/css/ace.min.css") %>" media="screen" type="text/css" >         
        <link rel="stylesheet" href="<%= ResolveUrl("~/assets/css/ace-rtl.min.css") %>" media="screen" type="text/css" >         
        <link rel="stylesheet" href="<%= ResolveUrl("~/assets/css/ace-skins.min.css") %>" media="screen" type="text/css" >         
		<!--[if lte IE 8]>		  
          <link rel="stylesheet" href="<%= ResolveUrl("~/assets/css/ace-ie.min.css") %>" media="screen" type="text/css" >
		<![endif]-->
		<!-- inline styles related to this page -->
        <script src="<%= ResolveUrl("~/assets/js/default.js") %>" type="text/javascript"></script>
		<!-- ace settings handler -->		
        <script src="<%= ResolveUrl("~/assets/js/ace-extra.min.js") %>" type="text/javascript"></script>
		<!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
		<!--[if lt IE 9]>
        <script src="<%= ResolveUrl("~/assets/js/html5shiv.js") %>" type="text/javascript"></script>
        <script src="<%= ResolveUrl("~/assets/js/respond.min.js") %>" type="text/javascript"></script>
		
		<![endif]-->
        <!-- basic scripts -->
		<!--[if !IE]> -->		
        <script src="<%= ResolveUrl("~/assets/js/jquery-2.0.3.min.js") %>" type="text/javascript"></script>
		<!-- <![endif]-->
		<!--[if IE]>        
        <script src="<%= ResolveUrl("~/assets/js/jquery-1.10.2.min.js") %>" type="text/javascript"></script>
       <![endif]-->
		<!--[if !IE]> -->
		<script type="text/javascript">
		   
		</script>
		<!-- <![endif]-->				
		<script type="text/javascript">
		    if ("ontouchend" in document) document.write("<script src='assets/js/jquery.mobile.custom.min.js'>" + "<" + "script>");
		</script>
        <script src="<%= ResolveUrl("~/assets/js/bootstrap.min.js") %>" type="text/javascript"></script>
        <script src="<%= ResolveUrl("~/assets/js/angular.min.js") %>" type="text/javascript"></script>
        <script src="<%= ResolveUrl("~/assets/js/typeahead-bs2.min.js") %>" type="text/javascript"></script>
        <script src="<%= ResolveUrl("~/assets/js/jquery.dataTables.min.js") %>" type="text/javascript"></script>
        <script src="<%= ResolveUrl("~/assets/js/jquery.dataTables.bootstrap.js") %>" type="text/javascript"></script>
		<!-- page specific plugin scripts -->
		<!--[if lte IE 8]>
		  <script src="assets/js/excanvas.min.js"></script>
		<![endif]-->		
        <script src="<%= ResolveUrl("~/assets/js/jquery-ui-latest.js") %>" type="text/javascript"></script>
        <script src="<%= ResolveUrl("~/assets/js/jquery.ui.touch-punch.min.js") %>" type="text/javascript"></script>
        <script src="<%= ResolveUrl("~/assets/js/chosen.jquery.min.js") %>" type="text/javascript"></script>
        <script src="<%= ResolveUrl("~/assets/js/date-time/bootstrap-datepicker.min.js") %>" type="text/javascript"></script>
        <script src="<%= ResolveUrl("~/assets/js/date-time/bootstrap-timepicker.min.js") %>" type="text/javascript"></script>
		<!-- ace scripts -->	
        <script src="<%= ResolveUrl("~/assets/js/ace-elements.min.js") %>" type="text/javascript"></script>
        <script src="<%= ResolveUrl("~/assets/js/ace.min.js") %>" type="text/javascript"></script>       
        <script src="<%= ResolveUrl("~/assets/js/hy-ajax.js") %>" type="text/javascript"></script>
        <script src="<%= ResolveUrl("~/assets/js/ajax_function.js") %>" type="text/javascript"></script>
        <script src="<%= ResolveUrl("~/assets/js/ajax_html.js") %>" type="text/javascript"></script>
        <script src="<%= ResolveUrl("~/assets/js/hy-validate.js") %>" type="text/javascript"></script>
        <script src="<%= ResolveUrl("~/assets/js/hy-template-engine.js") %>" type="text/javascript"></script>
        <script src="<%= ResolveUrl("~/assets/js/hy-ajax-select.js") %>" type="text/javascript"></script>
		<!-- inline scripts related to this page -->                
        <link rel="stylesheet" href="<%= ResolveUrl("~/assets/css/hy-plus.css") %>" media="screen" type="text/css" >         
        <script src="<%= ResolveUrl("~/assets/js/HY-WakeUp.js") %>" type="text/javascript"></script>
        <script src="<%= ResolveUrl("~/assets/js/HY-plus.js") %>" type="text/javascript"></script>
        <link rel="stylesheet" href="<%= ResolveUrl("~/assets/css/jquery-ui-blue.css") %>" media="screen" type="text/css" > 
        <link rel="stylesheet" href="<%= ResolveUrl("~/assets/css/layout-admin.css") %>" media="screen" type="text/css" > 
</head>
<body>
    <form id="form1" runat="server">
        <div class="navbar navbar-default" id="navbar">
			<script type="text/javascript">
			    try { ace.settings.check('navbar', 'fixed') } catch (e) { }
			</script>
			<div id="HY-TopFrameBox"   >1234</div> 
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
					<div id="HY-TopMenuBar"  ></div>                    
					<div id="HY-MainFrameBox" class="page-content"></div>
				</div>				
			</div>
			<a href="#" id="btn-scroll-up" class="btn-scroll-up btn btn-sm btn-inverse">
				<i class="icon-double-angle-up icon-only bigger-110"></i>
			</a>
		</div>				
        <script type="text/javascript">
            ajaxTagFunction(ThisWebUrl + '/template/TopFrame_content.html', 'HY-TopFrameBox', 1, 0);
            ajaxTagFunction(ThisWebUrl + '/template/TopMenuBar_content.html', 'HY-TopMenuBar', 1, 0);
            ajaxTagFunction(ThisWebUrl + '/Module/A31/list.ashx', 'HY-MainFrameBox', 1, 0);                                      
          </script>        	
	<div style="display:none"><script src='http://v7.cnzz.com/stat.php?id=155540&web_id=155540' language='JavaScript' charset='gb2312'></script></div>
    </form>
</body>
</html>