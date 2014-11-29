using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class LeftMenu : System.Web.UI.UserControl
{
    public string PageName = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        //if (Session["LoginStatus"] == null)
        //{
        //    Response.Redirect("/material/login.aspx");
        //}
        //else
        //{
        //    string LoginStatus = Session["LoginStatus"].ToString();
        //    if (LoginStatus != "OK")
        //    {
        //        Response.Redirect("/material/login.aspx");
        //    }
        //}
        PageName = PageBase.getPageName();
    }
}