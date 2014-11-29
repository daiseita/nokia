<%@ WebHandler Language="C#" Class="A30_face" %>

using System;
using System.Web;
using System.Data;
public class A30_face : IHttpHandler {
   
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
    string TableName = "A30";
    public void ProcessRequest(HttpContext context)
    {
        Language_TF TF = new Language_TF();
        oValue.setRequestPost("Action,A30I01XA,A30I02UV0004,A30I03CV0001,A30F01NV0064,A30F02NV0512");
        oValue.setRequestGet("Del");
        string A30I01XA = oValue.Data("A30I01XA").ToString();
        if (A30I01XA == "") { oValue.setRequestGet("A30I01XA"); A30I01XA = oValue.Data("A30I01XA"); }

        string A30I06CV0009 = "";
        SQL = "Select A30I01XA,A30I02UV0004,A30I03CV0001,A30F01NV0064,A30F02NV0512,A30IND,A30INT,A30INA,A30INU,A30UPD,A30UPT,A30UPA,A30UPU,A30UPC from A30 where A30I01XA='" + oValue.Data("A30I01XA") + "'";
        recordset = Sql.selectTable(SQL, "A30");
        /* 新增編輯邏輯 */
        if (oValue.Data("Action") == "Add" || oValue.Data("Action") == "Upd") { InsertUpdate(context); return; }
        /* 刪除邏輯 */
        if (oValue.Data("Del") == "Del") { Delete(context); return; }

        oTemplate.SetTemplatesDir(pb.SiteFunctionTemplateName );
        oTemplate.SetTemplateFileCharset(pb.FaceTemplateName , "UTF-8");                                              
        if (recordset != null)
        {
            //編輯
            DataSet DataSet1 = new DataSet();
            DataSet1.Tables.Add(recordset);
            foreach (DataColumn columename in DataSet1.Tables["A30"].Columns)
            {
                string pRName = columename.ToString();
                string pRValue = DataSet1.Tables["A30"].Rows[0][columename].ToString();
                oTemplate.SetVariable_HTML(pRName, pRValue, saFiled.GetColumeLength(pRName));
            }
            oTemplate.SetVariable_HTML_RADIO("A30I03CV0001", TF.Msg01, DataSet1.Tables["A30"].Rows[0]["A30I03CV0001"].ToString(), "B");
            oTemplate.SetVariable_HTML_RADIO("A30I03CV0001", TF.Msg02, DataSet1.Tables["A30"].Rows[0]["A30I03CV0001"].ToString(), "S");

            //A30I06CV0009 = recordset.Rows[0]["A30I06CV0009"].ToString();
            oTemplate.SetVariable("Action", "Upd");

            recordset.Dispose();
        }
        else
        {
            //新增
            try
            {
                string columnString = "A30I01XA,A30I02UV0004,A30I03CV0001,A30F01NV0064,A30F02NV0512";
                string[] Column = columnString.Split(',');
                for (int i = 0; i < Column.Length ; i++)
                {
                    var pRName = Column[i];
                    string pRValue = "";
                    oTemplate.SetVariable_HTML(pRName, pRValue, saFiled.GetColumeLength(pRName));
                }                               
            }
            catch { }
            oTemplate.SetVariable_HTML_RADIO("A30I03CV0001", TF.Msg01, "B", "B");
            oTemplate.SetVariable_HTML_RADIO("A30I03CV0001", TF.Msg02, "", "S");
            oTemplate.SetVariable("Action", "Add");
        }

        /* 下拉式選單 */

        ////Sql.ClearQuery();
        ////SQL = "Select A30I02UV0004,A30F01NV0256 From A30 ";
        ////if (recordset != null)
        ////{
        ////    SQL += "where A30I02UV0004 <> '" + recordset.Rows[0]["A30I02UV0004"].ToString() + "'";
        ////}
        ////recordset = Sql.selectTable(SQL, "A30");
        ////if (recordset != null)
        ////{
        ////    for (int i = 0; i < recordset.Rows.Count; i++)
        ////    {
        ////        oTemplate.SetVariable_HTML_OPTION("A30I06CV0009", recordset.Rows[i][1].ToString(), A30I06CV0009, recordset.Rows[i][0].ToString());
        ////    }
        ////}
        ////oTemplate.SetVariable_HTML_SELECT("A30I06CV0009");
        string Rtn = oTemplate.GetOutput();
        context.Response.ContentType = "text/plain";
        context.Response.Write(Rtn);

    }
    public void InsertUpdate(HttpContext context)
    {
        Language_Msg Ms = new Language_Msg();

        string A30I01XA = oValue.Data("A30I01XA");
        string A30I02UV0004 = "";
        /* 空白檢查*/
        if (oValue.EmptyCheck("A30F01NV0064") == false)
        {
            context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg01 + "');");
            return;
        }
        /* 長度檢查*/
        //if (oValue.Data("A30I02UV0004").Length < 6)
        //{
        //   context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg18 + "');");
        //    return;
        //}
        ///* 欄位檢查 */
        //if (oValue.ColumnNoChines("A30I02UV0004,A30F01NV0064") == false)
        //{
        //    context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg14 + "');");
        //    return;
        //}
        /* 欄位重覆檢查 */
        if(dt!=null){ dt.Dispose();}
        Sql.ClearQuery();
        SQL = "Select A30F01NV0064 from A30 where A30F01NV0064='" + oValue.Data("A30F01NV0064") + "'";
        if (oValue.Data("Action") == "Upd") { SQL += " and A30I01XA <> '" + A30I01XA + "'"; }
        dt = Sql.selectTable(SQL, "A30e");
        if (dt !=null)
        {
            context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg02 + "');");
            return;
        }
        //if(dt!=null){ dt.Dispose();}
        //Sql.ClearQuery();
        //SQL = "Select A30I02UV0004 from A30 where A30I02UV0004='" + oValue.Data("A30I02UV0004") + "'";
        //if (oValue.Data("Action") == "Upd") { SQL += " and A30I01XA <> '" + A30I01XA + "'"; }
        //dt = Sql.selectTable(SQL, "A30e");
        //if (dt !=null)
        //{
        //    context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg07 + "');");
        //    return;
        //}
        /* 層級變更檢查 */
        if (oValue.Data("Action") == "Upd")
        {
            ////if (oValue.Data("A30I06CV0009") != recordset.Rows[0]["A30I06CV0009"].ToString())
            ////{
            ////    if(dt!=null){ dt.Dispose();}
            ////    Sql.ClearQuery();
            ////    SQL = "Select A30I06CV0009 from A30 where A30I06CV0009='" + recordset.Rows[0]["A30I02UV0004"].ToString() + "'";
            ////    dt = Sql.selectTable(SQL, "A30c");
            ////    if (dt !=null)
            ////    {
            ////        context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg04 + "');");
            ////        return;
            ////    }

            ////}
        }

        /* A30代碼產生*/
        if (oValue.Data("Action") == "Add")
        {
            Sql.ClearQuery();
            A30I02UV0004 = Sql.Top1Query("A30", "A30I02UV0004", true);
            if (A30I02UV0004 == "")
            {
                A30I02UV0004 = "S001";
            }
            else
            {
                A30I02UV0004 = Cls_Rule.I02creater(A30I02UV0004, "S", 3);
            }
        }
        else
        {
            A30I02UV0004 = recordset.Rows[0]["A30I02UV0004"].ToString();
        }
       

        oDate.RecordNow();
        Sql.ClearQuery();           
        string A30I03CV0001 = oValue.Data("A30I03CV0001");
        string A30F01NV0064 = oValue.Data("A30F01NV0064");
        string A30F02NV0512 = oValue.Data("A30F02NV0512");
       

        string strSQL = "";
        string Error = "";
        //Sql.transBegin();
        Sql.SetData("A30I02UV0004", A30I02UV0004);        
        Sql.SetData("A30I03CV0001", A30I03CV0001);
        Sql.SetNData("A30F01NV0064", A30F01NV0064);
        Sql.SetData("A30F02NV0512", A30F02NV0512);       
        Sql.SetData("A30IND", oDate.IND);
        Sql.SetData("A30INT", oDate.INT);
        Sql.SetData("A30INA", oDate.INA);
        Sql.SetData("A30UPD", oDate.IND);
        Sql.SetData("A30UPT", oDate.INT);
        Sql.SetData("A30UPA", oDate.INA);        
        if (oValue.Data("Action") == "Add")
        {
            strSQL += Sql.getInserSQL("A30") + "\r\n";
        }
        else
        {
            Sql.SetWhere("And", "A30I01XA", "=", A30I01XA, false);
            strSQL += Sql.getUpdateSQL("A30") + "\r\n";
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
        string A30I02UV0004 = recordset.Rows[0]["A30I02UV0004"].ToString();
        string A30I01XA = recordset.Rows[0]["A30I01XA"].ToString();
        /* 刪除檢查 */
        ////recordset.Dispose();
        ////Sql.ClearQuery();
        ////SQL = "Select A30I02UV0004 from A30 where A30I06CV0009='" + A30I02UV0004 + "'";
        ////recordset = Sql.selectTable(SQL, "Check");
        ////if (recordset !=null)
        ////{
        ////    context.Response.Write("alert('" + Ms.Msg04 + "')");
        ////    return;
        ////}
        string strSQL = "";
        Sql.SetWhere("And", "A30I01XA", "=", A30I01XA, false);
        strSQL += Sql.getDelteSQL("A30") + "\r\n";
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