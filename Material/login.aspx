<%@ Page Language="C#" AutoEventWireup="true" CodeFile="login.aspx.cs" Inherits="login" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    
    <div style="text-align:center;width:800px;margin:300px auto;letter-spacing:2px;">
        <div style="font-size:20px;margin-bottom:30px;">物料管理系統</div>
        <div>帳號:<asp:TextBox ID="TextBox1" runat="server"></asp:TextBox></div>
        <div>密碼:<asp:TextBox ID="TextBox2" runat="server"></asp:TextBox></div><br>
        <div><asp:Button ID="Button1" runat="server" Text="登入" 
                onclick="Button1_Click" /></div>
        
    </div>
    </form>
</body>
</html>
