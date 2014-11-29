<%@ WebHandler Language="C#" Class="A10_face" %>

using System;
using System.Web;
using System.Data;
public class A10_face : IHttpHandler {
   
    Cls_Request oValue = new Cls_Request();
    Cls_Template oTemplate = new Cls_Template();
    Cls_SQL Sql = new Cls_SQL();
    DataTable recordset = new DataTable();
    DataTable dt = new DataTable();
    Cls_SA_Fields saFiled = new Cls_SA_Fields();
    Cls_Date oDate = new Cls_Date();
    Cls_Rule oRule = new Cls_Rule();
    string SQL;
    PageBase pb = new PageBase();
    string tClientIP = PageBase.strIP;
    string TableName = "A10";
    public void ProcessRequest(HttpContext context)
    {
        Language_TF TF = new Language_TF();
        oValue.setRequestPost("Action,A10I01XA,A10I02UV0064,A10I03JJA20I02,A10I04CV0001,A10F01CV0032,A10F02NV0032");
        oValue.setRequestGet("Del");
        string A10I01XA = oValue.Data("A10I01XA").ToString();
        if (A10I01XA == "") { oValue.setRequestGet("A10I01XA"); A10I01XA = oValue.Data("A10I01XA"); }

        string A10I06CV0009 = "";
        SQL = "Select A10I01XA,A10I02UV0064,A10I03JJA20I02,A10I04CV0001,A10F01CV0032,A10F02NV0032 from A10 where A10I01XA='" + oValue.Data("A10I01XA") + "'";
        recordset = Sql.selectTable(SQL, "A10");
        /* 新增編輯邏輯 */
        if (oValue.Data("Action") == "Add" || oValue.Data("Action") == "Upd") { InsertUpdate(context); return; }
        /* 刪除邏輯 */
        if (oValue.Data("Del") == "Del") { Delete(context); return; }

        oTemplate.SetTemplatesDir(pb.SiteFunctionTemplateName );
        oTemplate.SetTemplateFileCharset(pb.FaceTemplateName , "UTF-8");          
        string A10I03JJA20I02 ="";                                    
        if (recordset != null)
        {
            //編輯
            DataSet DataSet1 = new DataSet();
            DataSet1.Tables.Add(recordset);
            foreach (DataColumn columename in DataSet1.Tables["A10"].Columns)
            {
                string pRName = columename.ToString();
                string pRValue = DataSet1.Tables["A10"].Rows[0][columename].ToString();
                oTemplate.SetVariable_HTML(pRName, pRValue, saFiled.GetColumeLength(pRName));
            }
            oTemplate.SetVariable_HTML_RADIO("A10I04CV0001", TF.Msg01, DataSet1.Tables["A10"].Rows[0]["A10I04CV0001"].ToString(), "B");
            oTemplate.SetVariable_HTML_RADIO("A10I04CV0001", TF.Msg02, DataSet1.Tables["A10"].Rows[0]["A10I04CV0001"].ToString(), "S");

            A10I03JJA20I02 = recordset.Rows[0]["A10I03JJA20I02"].ToString();
            oTemplate.SetVariable("Action", "Upd");

            recordset.Dispose();
        }
        else
        {
            //新增
            try
            {
                string columnString = "A10I01XA,A10I02UV0064,A10I03JJA20I02,A10I04CV0001,A10F01CV0032,A10F02NV0032";
                string[] Column = columnString.Split(',');
                for (int i = 0; i < Column.Length ; i++)
                {
                    var pRName = Column[i];
                    string pRValue = "";
                    oTemplate.SetVariable_HTML(pRName, pRValue, saFiled.GetColumeLength(pRName));
                }                               
            }
            catch { }
            oTemplate.SetVariable_HTML_RADIO("A10I04CV0001", TF.Msg01, "B", "B");
            oTemplate.SetVariable_HTML_RADIO("A10I04CV0001", TF.Msg02, "", "S");
            oTemplate.SetVariable("Action", "Add");
        }

        /* 下拉式選單 */

        /* 下拉式選單 */
        DataTable select = new DataTable();
        Sql.ClearQuery();
        SQL = "Select A20I02UV0010,A20F01NV0006,A20I05CV0001,A20I06CV0001,A20I07CV0001,A20I08CV0001 From A20 where A20I03CV0001='B'";
       Cls_CodeTransfer oCode = new Cls_CodeTransfer();
        select = Sql.selectTable(SQL, "A20");
        if (select != null)
        {
            for (int i = 0; i < select.Rows.Count; i++)
            {
                string strTitle="";
                string A20I05CV0001 = oCode.ExportData("A20I05CV0001", select.Rows[i][2].ToString()).ToString();
                string A20I06CV0001 = oCode.ExportData("A20I06CV0001", select.Rows[i][3].ToString()).ToString();
                string A20I07CV0001 = oCode.ExportData("A20I07CV0001", select.Rows[i][4].ToString()).ToString();
                string A20I08CV0001 = oCode.ExportData("A20I08CV0001", select.Rows[i][5].ToString()).ToString();
                if (A20I05CV0001 != "") { strTitle += A20I05CV0001; }
                if (A20I06CV0001 != "") { strTitle += A20I05CV0001; }
                if (A20I07CV0001 != "") { strTitle += A20I05CV0001; }
                if (A20I08CV0001 != "") { strTitle += A20I05CV0001; }
                oTemplate.SetVariable_HTML_OPTION("A10I03JJA20I02", select.Rows[i][1].ToString() + "_" + strTitle, A10I03JJA20I02, select.Rows[i][0].ToString());
            }
        }
        oTemplate.SetVariable_HTML_SELECT("A10I03JJA20I02");
        string Rtn = oTemplate.GetOutput();
        context.Response.ContentType = "text/plain";
        context.Response.Write(Rtn);

    }
    public void InsertUpdate(HttpContext context)
    {
        Language_Msg Ms = new Language_Msg();

        string A10I01XA = oValue.Data("A10I01XA");
        string A10I02UV0064 = "";
        /* 空白檢查*/
        if (oValue.EmptyCheck("A10I02UV0064,A10I03JJA20I02,A10I04CV0001,A10F01CV0032,A10F02NV0032") == false)
        {
            context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg01 + "');");
            return;
        }
        /* 長度檢查*/
        if (oValue.Data("A10I02UV0064").Length < 6)
        {
           context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg18 + "');");
            return;
        }
        /* 欄位檢查 */
        if (oValue.ColumnNoChines("A10I02UV0064,A10F01CV0032") == false)
        {
            context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg14 + "');");
            return;
        }
        /* 欄位重覆檢查 */
        if(dt!=null){ dt.Dispose();}
        Sql.ClearQuery();
        SQL = "Select A10F01CV0032 from A10 where A10F01CV0032='" + oValue.Data("A10F01CV0032") + "'";
        if (oValue.Data("Action") == "Upd") { SQL += " and A10I01XA <> '" + A10I01XA + "'"; }
        dt = Sql.selectTable(SQL, "A10e");
        if (dt !=null)
        {
            context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg02 + "');");
            return;
        }
        if(dt!=null){ dt.Dispose();}
        Sql.ClearQuery();
        SQL = "Select A10I02UV0064 from A10 where A10I02UV0064='" + oValue.Data("A10I02UV0064") + "'";
        if (oValue.Data("Action") == "Upd") { SQL += " and A10I01XA <> '" + A10I01XA + "'"; }
        dt = Sql.selectTable(SQL, "A10e");
        if (dt !=null)
        {
            context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg07 + "');");
            return;
        }
        /* 層級變更檢查 */
        if (oValue.Data("Action") == "Upd")
        {
            ////if (oValue.Data("A10I06CV0009") != recordset.Rows[0]["A10I06CV0009"].ToString())
            ////{
            ////    if(dt!=null){ dt.Dispose();}
            ////    Sql.ClearQuery();
            ////    SQL = "Select A10I06CV0009 from A10 where A10I06CV0009='" + recordset.Rows[0]["A10I02UV0064"].ToString() + "'";
            ////    dt = Sql.selectTable(SQL, "A10c");
            ////    if (dt !=null)
            ////    {
            ////        context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg04 + "');");
            ////        return;
            ////    }

            ////}
        }

        /* A10代碼產生*/
        ////if (oValue.Data("Action") == "Add")
        ////{
        ////    Sql.ClearQuery();
        ////    A10I02UV0064 = Sql.Top1Query("A10", "A10I02UV0064", true);
        ////    if (A10I02UV0064 == "")
        ////    {
        ////        A10I02UV0064 = "A00000001";
        ////    }
        ////    else
        ////    {
        ////        A10I02UV0064 = Cls_Rule.I02creater(A10I02UV0064, "A", 8);
        ////    }
        ////}
        ////else
        ////{
        ////    A10I02UV0064 = recordset.Rows[0]["A10I02UV0064"].ToString();
        ////}
       

        oDate.RecordNow();
        Sql.ClearQuery();
        A10I02UV0064 = oValue.Data("A10I02UV0064");
        string A10I03JJA20I02 = oValue.Data("A10I03JJA20I02");
        string A10I04CV0001 = oValue.Data("A10I04CV0001");
        string A10F01CV0032 = oValue.Data("A10F01CV0032");
        string A10F02NV0032 = oValue.Data("A10F02NV0032");
       

        string strSQL = "";
        string Error = "";
        //Sql.transBegin();
        Sql.SetData("A10I02UV0064", A10I02UV0064);
        Sql.SetData("A10I03JJA20I02", A10I03JJA20I02);
        Sql.SetData("A10I04CV0001", A10I04CV0001);
        Sql.SetNData("A10F01CV0032", A10F01CV0032);
        Sql.SetData("A10F02NV0032", A10F02NV0032);       
        Sql.SetData("A10IND", oDate.IND);
        Sql.SetData("A10INT", oDate.INT);
        Sql.SetData("A10INA", oDate.INA);
        Sql.SetData("A10UPD", oDate.IND);
        Sql.SetData("A10UPT", oDate.INT);
        Sql.SetData("A10UPA", oDate.INA);
        Sql.SetData("A10F03CV0015", tClientIP);
        if (oValue.Data("Action") == "Add")
        {
            strSQL += Sql.getInserSQL("A10") + "\r\n";
        }
        else
        {
            Sql.SetWhere("And", "A10I01XA", "=", A10I01XA, false);
            strSQL += Sql.getUpdateSQL("A10") + "\r\n";
        }
        if (Sql.errorMessage != "") { Error = Sql.errorMessage; }
                
        ////string GUID = Pub_Function.SqlRequest(strSQL);
        ////string RtnMsg = Pub_Function.SqlResponse(GUID);

        string RtnMsg = Pub_Function.executeSQL(strSQL);
        switch (RtnMsg)
        {
            case "":
                context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg13 + "');");
                break;
            case "success":
                context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg06 + "');");
                break;
            case "fail":
                context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg05 + "');");
                break;
            default:
                break;
        }
    }
    public void Delete(HttpContext context)
    {
        Language_Msg Ms = new Language_Msg();
        string A10I02UV0064 = recordset.Rows[0]["A10I02UV0064"].ToString();
        string A10I01XA = recordset.Rows[0]["A10I01XA"].ToString();
        /* 刪除檢查 */
        ////recordset.Dispose();
        ////Sql.ClearQuery();
        ////SQL = "Select A10I02UV0064 from A10 where A10I06CV0009='" + A10I02UV0064 + "'";
        ////recordset = Sql.selectTable(SQL, "Check");
        ////if (recordset !=null)
        ////{
        ////    context.Response.Write("alert('" + Ms.Msg04 + "')");
        ////    return;
        ////}
        string strSQL = "";
        Sql.SetWhere("And", "A10I01XA", "=", A10I01XA, false);
        strSQL += Sql.getDelteSQL("A10") + "\r\n";
        ////string GUID = Pub_Function.SqlRequest(strSQL);
        ////string RtnMsg = Pub_Function.SqlResponse(GUID);
        string RtnMsg = Pub_Function.executeSQL(strSQL);
        switch (RtnMsg)
        {
            case "":
                context.Response.Write("alert('" + Ms.Msg13 + "')");
                break;
            case "success":
                context.Response.Write("alert('" + Ms.Msg06 + "')");
                break;
            case "fail":
                context.Response.Write("alert('" + Ms.Msg05 + "')");
                break;
            default:
                break;
        }
    }
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }


}