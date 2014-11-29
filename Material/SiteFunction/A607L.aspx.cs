using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class SiteFunction_A607L : System.Web.UI.Page
{
    Cls_Request oValue = new Cls_Request();
    public string strType = "";    
    protected void Page_Load(object sender, EventArgs e)
    {

        oValue.setRequestGet("Action");
        strType = oValue.Data("Action");
        

    }
}