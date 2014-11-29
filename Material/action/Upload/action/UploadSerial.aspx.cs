using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
public partial class action_Upload_action_UploadSerial : System.Web.UI.Page
{
    public string UploadUrl = "";
    Cls_Request oValue = new Cls_Request();
    Cls_SQL Sql = new Cls_SQL();
    DataTable recordset = new DataTable();
    Cls_CodeTransfer Tran = new Cls_CodeTransfer();
    string PostUrl = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        oValue.setRequestGet("A68I03JJA67I02,A68I04JJA31I02,A68I13JJA12I02");


        UploadUrl = Server.MapPath("~") + @"\upload\local\SerialImort\";
        A68I03JJA67I02.Text = oValue.Data("A68I03JJA67I02");
        A68I04JJA31I02.Text = oValue.Data("A68I04JJA31I02");
        A68I13JJA12I02.Text = oValue.Data("A68I13JJA12I02");

       
        string SQL = "";
        
    }

    protected void Button1_Click1(object sender, EventArgs e)
    {
        Label1.Text = "";
        //Files is folder Name
        string A68I03 = A68I03JJA67I02.Text;
        string A68I04 = A68I04JJA31I02.Text;
        string A68I13 = A68I13JJA12I02.Text;
        try
        {
            string str = UploadUrl + FileUpload1.FileName;
            FileUpload1.SaveAs(str);
            Label1.Text = "上傳成功!!  資料處理中.....請稍候";

            Page.RegisterStartupScript("up", "<script language=\"JavaScript\">goUploadSQL('" + KeepType.Text + "', '@" + 123 + "','" + FileUpload1.FileName + "');showFlash();</script>");


        }
        catch
        {
            Response.Write("<script language='JavaScript'>alert('上傳失敗');</script>");
        }
    }
   
}