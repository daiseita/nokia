using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        string strAccount = TextBox1.Text;
        string strCode = TextBox2.Text;
        if (strAccount == "nokiauser" && strCode == "!QAZ2wsx") {
            Session["LoginStatus"] = "OK";
            Response.Redirect("/material/sitefunction/A601L.aspx");

        }        

    }
}