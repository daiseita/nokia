<%@ Page Language="C#" AutoEventWireup="true" CodeFile="angular.aspx.cs" Inherits="angular" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" lang="en" ng-app >
<head runat="server">
    <title></title>
    <script src="<%= ResolveUrl("~/assets/js/jquery-latest.js") %>" type="text/javascript"></script>
    <script src="<%= ResolveUrl("~/assets/js/angular.min.js") %>" type="text/javascript"></script>
    <script src="<%= ResolveUrl("~/assets/js/controler.js") %>" type="text/javascript"></script>
    
</head>
<body>
    <form id="form1" runat="server">
    <div>
       <div  ng-controller="TodoCrtl"   ng-include="'/Material/template/TopMenuBar_content.html'" class="well"></div>
       <div>112</div> 
       <div>112</div> 
    </div>
    </form>
</body>
</html>
