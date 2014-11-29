<%@ WebHandler Language="C#" Class="A11_face" %>

using System;
using System.Web;
using System.Data;
public class A11_face : IHttpHandler {
   
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
    string TableName = "A11";
    public void ProcessRequest(HttpContext context)
    {
        Language_TF TF = new Language_TF();
        oValue.setRequestPost("Action,A11I01XA,A11I02UV0006,A11I03CV0001,A11F01NV0032,A11F02NV0256");
        oValue.setRequestGet("Del");
        string A11I01XA = oValue.Data("A11I01XA").ToString();
        if (A11I01XA == "") { oValue.setRequestGet("A11I01XA"); A11I01XA = oValue.Data("A11I01XA"); }

        string A11I06CV0009 = "";
        SQL = "Select A11I01XA,A11I02UV0006,A11I03CV0001,A11F01NV0032,A11F02NV0256,A11IND,A11INT,A11INA,A11INU,A11UPD,A11UPT,A11UPA,A11UPU,A11UPC from A11 where A11I01XA='" + oValue.Data("A11I01XA") + "'";
        recordset = Sql.selectTable(SQL, "A11");
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
            foreach (DataColumn columename in DataSet1.Tables["A11"].Columns)
            {
                string pRName = columename.ToString();
                string pRValue = DataSet1.Tables["A11"].Rows[0][columename].ToString();
                oTemplate.SetVariable_HTML(pRName, pRValue, saFiled.GetColumeLength(pRName));
            }
            oTemplate.SetVariable_HTML_RADIO("A11I03CV0001", TF.Msg01, DataSet1.Tables["A11"].Rows[0]["A11I03CV0001"].ToString(), "B");
            oTemplate.SetVariable_HTML_RADIO("A11I03CV0001", TF.Msg02, DataSet1.Tables["A11"].Rows[0]["A11I03CV0001"].ToString(), "S");

            //A11I06CV0009 = recordset.Rows[0]["A11I06CV0009"].ToString();
            oTemplate.SetVariable("Action", "Upd");

            recordset.Dispose();
        }
        else
        {
            //新增
            try
            {
                string columnString = "A11I01XA,A11I02UV0006,A11I03CV0001,A11F01NV0032,A11F02NV0256";
                string[] Column = columnString.Split(',');
                for (int i = 0; i < Column.Length ; i++)
                {
                    var pRName = Column[i];
                    string pRValue = "";
                    oTemplate.SetVariable_HTML(pRName, pRValue, saFiled.GetColumeLength(pRName));
                }                               
            }
            catch { }
            oTemplate.SetVariable_HTML_RADIO("A11I03CV0001", TF.Msg01, "B", "B");
            oTemplate.SetVariable_HTML_RADIO("A11I03CV0001", TF.Msg02, "", "S");
            oTemplate.SetVariable("Action", "Add");
        }

        /* 下拉式選單 */

        ////Sql.ClearQuery();
        ////SQL = "Select A11I02UV0006,A11F01NV0256 From A11 ";
        ////if (recordset != null)
        ////{
        ////    SQL += "where A11I02UV0006 <> '" + recordset.Rows[0]["A11I02UV0006"].ToString() + "'";
        ////}
        ////recordset = Sql.selectTable(SQL, "A11");
        ////if (recordset != null)
        ////{
        ////    for (int i = 0; i < recordset.Rows.Count; i++)
        ////    {
        ////        oTemplate.SetVariable_HTML_OPTION("A11I06CV0009", recordset.Rows[i][1].ToString(), A11I06CV0009, recordset.Rows[i][0].ToString());
        ////    }
        ////}
        ////oTemplate.SetVariable_HTML_SELECT("A11I06CV0009");
        string Rtn = oTemplate.GetOutput();
        context.Response.ContentType = "text/plain";
        context.Response.Write(Rtn);

    }
    public void InsertUpdate(HttpContext context)
    {
        Language_Msg Ms = new Language_Msg();

        string A11I01XA = oValue.Data("A11I01XA");
        string A11I02UV0006 = "";
        /* 空白檢查*/
        if (oValue.EmptyCheck("A11F01NV0032") == false)
        {
            context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg01 + "');");
            return;
        }
        /* 長度檢查*/
        //if (oValue.Data("A11I02UV0006").Length < 6)
        //{
        //   context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg18 + "');");
        //    return;
        //}
        ///* 欄位檢查 */
        //if (oValue.ColumnNoChines("A11I02UV0006,A11F01NV0032") == false)
        //{
        //    context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg14 + "');");
        //    return;
        //}
        /* 欄位重覆檢查 */
        if(dt!=null){ dt.Dispose();}
        Sql.ClearQuery();
        SQL = "Select A11F01NV0032 from A11 where A11F01NV0032='" + oValue.Data("A11F01NV0032") + "'";
        if (oValue.Data("Action") == "Upd") { SQL += " and A11I01XA <> '" + A11I01XA + "'"; }
        dt = Sql.selectTable(SQL, "A11e");
        if (dt !=null)
        {
            context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg02 + "');");
            return;
        }
        //if(dt!=null){ dt.Dispose();}
        //Sql.ClearQuery();
        //SQL = "Select A11I02UV0006 from A11 where A11I02UV0006='" + oValue.Data("A11I02UV0006") + "'";
        //if (oValue.Data("Action") == "Upd") { SQL += " and A11I01XA <> '" + A11I01XA + "'"; }
        //dt = Sql.selectTable(SQL, "A11e");
        //if (dt !=null)
        //{
        //    context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg07 + "');");
        //    return;
        //}
        /* 層級變更檢查 */
        if (oValue.Data("Action") == "Upd")
        {
            ////if (oValue.Data("A11I06CV0009") != recordset.Rows[0]["A11I06CV0009"].ToString())
            ////{
            ////    if(dt!=null){ dt.Dispose();}
            ////    Sql.ClearQuery();
            ////    SQL = "Select A11I06CV0009 from A11 where A11I06CV0009='" + recordset.Rows[0]["A11I02UV0006"].ToString() + "'";
            ////    dt = Sql.selectTable(SQL, "A11c");
            ////    if (dt !=null)
            ////    {
            ////        context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg04 + "');");
            ////        return;
            ////    }

            ////}
        }

        /* A11代碼產生*/
        if (oValue.Data("Action") == "Add")
        {
            Sql.ClearQuery();
            A11I02UV0006 = Sql.Top1Query("A11", "A11I02UV0006", true);
            if (A11I02UV0006 == "")
            {
                A11I02UV0006 = "G00001";
            }
            else
            {
                A11I02UV0006 = Cls_Rule.I02creater(A11I02UV0006, "G", 5);
            }
        }
        else
        {
            A11I02UV0006 = recordset.Rows[0]["A11I02UV0006"].ToString();
        }
       

        oDate.RecordNow();
        Sql.ClearQuery();           
        string A11I03CV0001 = oValue.Data("A11I03CV0001");
        string A11F01NV0032 = oValue.Data("A11F01NV0032");
        string A11F02NV0256 = oValue.Data("A11F02NV0256");
       

        string strSQL = "";
        string Error = "";
        //Sql.transBegin();
        Sql.SetData("A11I02UV0006", A11I02UV0006);        
        Sql.SetData("A11I03CV0001", A11I03CV0001);
        Sql.SetNData("A11F01NV0032", A11F01NV0032);
        Sql.SetData("A11F02NV0256", A11F02NV0256);       
        Sql.SetData("A11IND", oDate.IND);
        Sql.SetData("A11INT", oDate.INT);
        Sql.SetData("A11INA", oDate.INA);
        Sql.SetData("A11UPD", oDate.IND);
        Sql.SetData("A11UPT", oDate.INT);
        Sql.SetData("A11UPA", oDate.INA);        
        if (oValue.Data("Action") == "Add")
        {
            strSQL += Sql.getInserSQL("A11") + "\r\n";
        }
        else
        {
            Sql.SetWhere("And", "A11I01XA", "=", A11I01XA, false);
            strSQL += Sql.getUpdateSQL("A11") + "\r\n";
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
        string A11I02UV0006 = recordset.Rows[0]["A11I02UV0006"].ToString();
        string A11I01XA = recordset.Rows[0]["A11I01XA"].ToString();
        /* 刪除檢查 */
        ////recordset.Dispose();
        ////Sql.ClearQuery();
        ////SQL = "Select A11I02UV0006 from A11 where A11I06CV0009='" + A11I02UV0006 + "'";
        ////recordset = Sql.selectTable(SQL, "Check");
        ////if (recordset !=null)
        ////{
        ////    context.Response.Write("alert('" + Ms.Msg04 + "')");
        ////    return;
        ////}
        string strSQL = "";
        Sql.SetWhere("And", "A11I01XA", "=", A11I01XA, false);
        strSQL += Sql.getDelteSQL("A11") + "\r\n";
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