using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class SiteFunction_A607CG : System.Web.UI.Page
{
    public string PageName = "";
    public string strType = "1";
    protected void Page_Load(object sender, EventArgs e)
    {
        string str = Request.Path;
        //str= str.Replace("A607C.aspx","A607L.aspx?action=1");
        //Response.Redirect(str);


        PageName = PageBase.getPageName();

    }
}