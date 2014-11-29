using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
public partial class upload2 : System.Web.UI.Page
{
    public string UploadUrl = "";
    Cls_Request oValue = new Cls_Request();
    Cls_SQL Sql = new Cls_SQL();
    DataTable recordset = new DataTable();
    Cls_CodeTransfer Tran = new Cls_CodeTransfer();
    string PostUrl = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        oValue.setRequestGet("Type");
        string UploadType = oValue.Data("Type");

        switch (UploadType)
        {
            case "A":
                UploadUrl = Server.MapPath("~") + @"\upload\global\type02\";
                Label1.Text = "序號件";
                break;
            case "B":
                UploadUrl = Server.MapPath("~") + @"\upload\global\type04\";
                Label1.Text = "非序號件";
                break;            
            case "":
                UploadUrl = Server.MapPath("~") + @"\";
                break;

        }
        KeepType.Text = UploadType;
        string SQL = "";
        Sql.ClearQuery();
        SQL = "select A19I02UV0004,A19F01NV0032 from A19 where A19I03CV0001='B'";
        //Sql.sqlTransferColumn = "A12I03CV0001";
        recordset = Sql.selectTable(SQL, "A19");
        if (recordset != null)
        {
            for (int i = 0; i < recordset.Rows.Count; i++)
            {
                ListItem iTem = new ListItem();
                iTem.Text = recordset.Rows[i]["A19F01NV0032"].ToString();
                iTem.Value = recordset.Rows[i]["A19I02UV0004"].ToString();
                DropDownList1.Items.Add(iTem);
            }
        }
        else
        {
        }
        Sql.ClearQuery();
        SQL = "select A12I02UV0010,A12I03CV0001,A12F01NV0064 from A12 where A12I03CV0001='A'";
        Sql.sqlTransferColumn = "A12I03CV0001";
        recordset = Sql.selectTable(SQL, "A12");
        if (recordset != null)
        {
            for (int i = 0; i < recordset.Rows.Count; i++)
            {
                ListItem iTem = new ListItem();
                iTem.Text = recordset.Rows[i]["A12F01NV0064"].ToString();
                iTem.Value = recordset.Rows[i]["A12I02UV0010"].ToString();
                DropDownList2.Items.Add(iTem);
            }
        }
        else
        {
        }
    }

    protected void Button1_Click1(object sender, EventArgs e)
    {
        Label1.Text = "";
        //Files is folder Name
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