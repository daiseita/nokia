<%@ WebHandler Language="C#" Class="A10_face" %>

using System;
using System.Web;
using System.Data;
public class A10_face : IHttpHandler {

    Cls_Request oValue = new Cls_Request();
    Cls_SQL Sql = new Cls_SQL();
    Cls_Date oDate = new Cls_Date();
    DataTable recordset = new DataTable();
    DataTable dt = new DataTable();
    Cls_SA_Fields saFiled = new Cls_SA_Fields();
    Language_Msg Ms = new Language_Msg();
    public void ProcessRequest(HttpContext context)
    {       
        string Rtn = "";
        oValue.setRequestGet("Action,Del,A31I01XA,A31I02UV0010,A31I11JJA31I02,A31F01NV0064");
        if (oValue.Data("A31I01XA") == "") { oValue.setRequestPost("Action,A31I01XA,A31I02UV0010,A31I11JJA31I02,A31F01NV0064"); }        
        string SQL = "select A31I01XA,A31I02UV0010,A31I11JJA31I02,A31I12FD0200 from A31 where A31I01XA='" + oValue.Data("A31I01XA") + "'";
        recordset = Sql.selectTable(SQL, "A31");
        if (recordset != null) {
            /* 刪除邏輯 */
            if (oValue.Data("Del") == "Del") { Delete(context); return; }
            DataSet DataSet1 = new DataSet();
            DataSet1.Tables.Add(dt);

            for (int i = 0; i < DataSet1.Tables["A31"].Rows.Count; i++)
            {
                string pRValue = DataSet1.Tables["A31"].Rows[i]["A31I11JJA31I02"].ToString();
                if (Rtn != "") { Rtn += ","; }
                Rtn += pRValue;
            }
        }
        /* 新增 */
        if (oValue.Data("A31I11JJA31I02") != "" && oValue.Data("A31F01NV0064") != "") {
            DataTable dt = new DataTable();
            /* 欄位重覆檢查 */
            if (dt != null) { dt.Dispose(); }
            Sql.ClearQuery();
            SQL = "Select A31F01NV0064 from A31 where A31F01NV0064='" + oValue.Data("A31F01NV0064") + "'";            
            dt = Sql.selectTable(SQL, "A31e");
            if (dt != null)
            {
                context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg02 + "');");
                return;
            }
            
            
            SQL = "select A31I02UV0010,A31I03CV0001,A31I04JJA30I02,A31I05CV0001,A31I06CV0001,A31I07CV0001,A31I14CV0024,A31F04FD0300 from A31 where A31I02UV0010='" + oValue.Data("A31I11JJA31I02") + "'";
            recordset = Sql.selectTable(SQL, "A31n");
            if (recordset != null) {               
                string strSQL ="";
                string A31I03CV0001 = recordset.Rows[0]["A31I03CV0001"].ToString();
                string A31I04JJA30I02 = recordset.Rows[0]["A31I04JJA30I02"].ToString();
                string A31I05CV0001 = recordset.Rows[0]["A31I05CV0001"].ToString();
                string A31I06CV0001 = recordset.Rows[0]["A31I06CV0001"].ToString();
                string A31I07CV0001 = recordset.Rows[0]["A31I07CV0001"].ToString();
                string A31I14CV0024 = recordset.Rows[0]["A31I14CV0024"].ToString();
                string A31I12FD0200 = (Convert.ToInt32(recordset.Rows[0]["A31F04FD0300"]) +1 ).ToString();
                string A31I02UV0010 = "";
                Sql.ClearQuery();
                A31I02UV0010 = Sql.Top1Query("A31", "A31I02UV0010", true);
                if (A31I02UV0010 == "")
                {
                    A31I02UV0010 = "P000000001";
                }
                else
                {
                    A31I02UV0010 = Cls_Rule.I02creater(A31I02UV0010, "P", 9);
                }
                oDate.RecordNow();
                Sql.SetData("A31I02UV0010", A31I02UV0010);
                Sql.SetData("A31I03CV0001", A31I03CV0001);
                Sql.SetData("A31I04JJA30I02", A31I04JJA30I02);
                Sql.SetData("A31I05CV0001", A31I05CV0001);
                Sql.SetData("A31I06CV0001", A31I06CV0001);
                Sql.SetData("A31I07CV0001", A31I07CV0001);                
                Sql.SetData("A31I10CV0001", "V");
                Sql.SetData("A31I11JJA31I02", oValue.Data("A31I11JJA31I02"));                
                //Sql.SetData("A31I13II", A31I13II);
                Sql.SetData("A31I14CV0024", A31I14CV0024);
                Sql.SetData("A31I12FD0200", A31I12FD0200);
                Sql.SetData("A31F01NV0064", oValue.Data("A31F01NV0064"));           
                Sql.SetData("A31IND", oDate.IND);
                Sql.SetData("A31INT", oDate.INT);
                Sql.SetData("A31INA", oDate.INA);
                Sql.SetData("A31UPD", oDate.IND);
                Sql.SetData("A31UPT", oDate.INT);
                Sql.SetData("A31UPA", oDate.INA);
                strSQL += Sql.getInserSQL("A31") + "\r\n";
                strSQL += "Update A31 set A31F04FD0300 = A31F04FD0300 + 1 where A31I02UV0010='" + oValue.Data("A31I11JJA31I02") + "'";
                string RtnMsg = Pub_Function.executeSQL(strSQL);
                switch (RtnMsg)
                {
                    case "":
                        context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg13 + "');");
                        break;
                    case "success":
                        context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg06 + "');ReloadAjaxDialog2('" + oValue.Data("A31I11JJA31I02") + "')");
                        break;
                    case "fail":
                        context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg05 + "');");
                        break;
                    default:
                        break;
                }                
            }        
        }
        context.Response.ContentType = "text/plain";
        context.Response.Write(Rtn);

    }
    public void Delete( HttpContext context)
    {
        Language_Msg Ms = new Language_Msg();
        string A31I01XA = recordset.Rows[0]["A31I01XA"].ToString();
        string A31I02UV0010 = recordset.Rows[0]["A31I02UV0010"].ToString();
        string A31I11JJA31I02 = recordset.Rows[0]["A31I11JJA31I02"].ToString();
        string A31I12FD0200 = recordset.Rows[0]["A31I12FD0200"].ToString();
        /* 刪除檢查 */
        //recordset.Dispose();
        //Sql.ClearQuery();
        //SQL = "Select A31I02UV0010 from A31 where A31I05JJA31I02='" + A31I02UV0010 + "'";
        //recordset = Sql.selectTable(SQL, "Check");
        //if (recordset !=null)
        //{
        //    context.Response.Write("alert('" + Ms.Msg04 + "')");
        //    return;
        //}
        string strSQL = "";
        Sql.SetWhere("And", "A31I01XA", "=", A31I01XA, false);
        strSQL += Sql.getDelteSQL("A31") + "; \r\n";
        ////string GUID = Pub_Function.SqlRequest(strSQL);
        ////string RtnMsg = Pub_Function.SqlResponse(GUID);
        strSQL += RelatedSQL();        
        string RtnMsg = Pub_Function.executeSQL(strSQL);
        switch (RtnMsg)
        {
            case "":
                context.Response.Write("alert('" + Ms.Msg13 + "')");
                break;
            case "success":
                context.Response.Write("alert('" + Ms.Msg06 + "');ReloadAjaxDialog2('" + A31I11JJA31I02 + "')");
                break;
            case "fail":
                context.Response.Write("alert('" + Ms.Msg05 + "')");
                break;
            default:
                break;
        }
    }
    public string RelatedSQL()
    {
        string Sqlstring = "";
        string A31I01XA = recordset.Rows[0]["A31I01XA"].ToString();
        string A31I02UV0010 = recordset.Rows[0]["A31I02UV0010"].ToString();
        string A31I11JJA31I02 = recordset.Rows[0]["A31I11JJA31I02"].ToString();
        string A31I12FD0200 = recordset.Rows[0]["A31I12FD0200"].ToString();
        string SQL = "select count(A31I11JJA31I02)cnt from A31 where A31I11JJA31I02='" + A31I11JJA31I02 + "'";
        DataTable dt = new DataTable();
        Sql.ClearQuery();
        dt = Sql.selectTable(SQL, "A31a");
        if (A31I11JJA31I02 != "" && dt != null) {
            Sqlstring += "Update A31 set A31I12FD0200= A31I12FD0200-1 where A31I11JJA31I02='" + A31I11JJA31I02 + "' and A31I12FD0200 >" + A31I12FD0200  +" ;";
            Sqlstring += "Update A31 set A31F04FD0300=" + (Convert.ToInt32( dt.Rows[0]["cnt"].ToString())-1).ToString() + " where A31I02UV0010='" +  A31I11JJA31I02 + "';";
        }        
        return Sqlstring;
    }
    
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }


}
