<%@ Page Language="C#" AutoEventWireup="true" CodeFile="upload2.aspx.cs" Inherits="upload2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
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
        <script src="<%= ResolveUrl("~/assets/js/jquery-autocomplete.js") %>" type="text/javascript"></script>
		<!-- inline scripts related to this page -->                
        <link rel="stylesheet" href="<%= ResolveUrl("~/assets/css/hy-plus.css") %>" media="screen" type="text/css" >         
        <script src="<%= ResolveUrl("~/assets/js/HY-WakeUp.js") %>" type="text/javascript"></script>
        <script src="<%= ResolveUrl("~/assets/js/HY-plus.js") %>" type="text/javascript"></script>
        <link rel="stylesheet" href="<%= ResolveUrl("~/assets/css/jquery-ui-blue.css") %>" media="screen" type="text/css" > 
        <link rel="stylesheet" href="<%= ResolveUrl("~/assets/css/layout-admin.css") %>" media="screen" type="text/css" > 
</head>
<body>
    <form id="form1" runat="server">
    <div id="AjaxUploadBox">
        <div style="margin:20px 0px 5px 15px;width:90%;"class="HYclearfix">
             <asp:FileUpload ID="FileUpload1"  class="btn btn-xs btn-danger setCol_20" runat="server" />   
             <asp:Button ID="Button1" runat="server" Text="上傳Excel&啟動" class="btn btn-xs btn-info setCol_10" style="height:30px;" onclick="Button1_Click1" />            
        </div>
        <div style="margin:0px 0px 5px 15px;width:90%;">
            供應商:<asp:DropDownList ID="DropDownList2" style="font-size:12px;" runat="server"></asp:DropDownList> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            入料貨倉:<asp:DropDownList ID="DropDownList1" style="font-size:12px;" runat="server"></asp:DropDownList><br> &nbsp;&nbsp;
            日期:<asp:TextBox ID="A66D01" class="A66D01" name="A66D01" runat="server"></asp:TextBox>
        </div>
        <div style="margin:20px 0px 5px 15px;width:90%;height:80px;text-align:center;">
            <img src="" alt="" id="ProcessIMG" height="80" width="80" style="display:none;">
        </div> 
     
        <div style="margin:10px 0px 5px 15px;font-size:15px;width:90%;text-align:center;">
            <asp:Label ID="Label1" runat="server" Text=""></asp:Label>
        </div> 
         <div style="margin:0px 0px 5px 15px;font-size:15px;width:90%;text-align:center;">
            <input type="text" name="FileName"  class="FileName" id="FileName" style="display:none;">
            <textarea id="A67F02NV0128" name="A67F02NV0128" style="width:360px;" rows="2" cols="20"></textarea>
         </div>
        <asp:Label ID="KeepType" runat="server" Text="" style="display:none;"></asp:Label>
    </div>
    <script type="text/javascript">
        var wParent = window.parent;

        $('#A66D01').datepicker({
            format: "yyyymmdd",
            todayHighlight: true
        });     

        $("#ProcessIMG").attr("src", ThisWebUrl + "/assets/images/loadering.gif");
        function hideFlash() {
            $("#ProcessIMG").css("display", "none");
            $("#Label1").html("");
            wParent.LoaOrderList();
            wParent.LoadAjaxList();
        }
        function showFlash() {
            $("#ProcessIMG").css("display", "");

        }


        function goUploadSQL(strType, strFileUrl, strFileName) {
            //alert(strType + "--" + strFileUrl + "--" + strFileName);
            $(".FileName").val(strFileName);
            switch (strType) {
                case "A":
                    ajaxTagSubmit(ThisWebUrl + "/action/Webservice/global/ExeceltoDB_02.ashx", "AjaxUploadBox", 1);
                    break;
                case "B":
                    ajaxTagSubmit(ThisWebUrl + "/action/Webservice/global/ExeceltoDB_04.ashx", "AjaxUploadBox", 1);
                    break;

            }

        }

    </script> 
    </form>
</body>
</html>
