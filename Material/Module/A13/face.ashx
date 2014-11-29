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
        oValue.setRequestPost("Action,A13I01XA,A13I02UV0010,A13I03CV0001,A13I04JJA13I02,A13I05FD0400,A13I06II,A13I07JJA02I02,A13I08JJA03I02,A13F01NV0064,A13F02CV0016,A13F03CV0016,A13F04CV0016,A13F05NV0256,A13F06NV0064,A13F07NV0012");
        oValue.setRequestGet("Del");
        string A13I01XA = oValue.Data("A13I01XA").ToString();
        if (A13I01XA == "") { oValue.setRequestGet("A13I01XA"); A13I01XA = oValue.Data("A13I01XA"); }

        SQL = "select A13I01XA,A13I02UV0010,A13I03CV0001,A13I04JJA13I02,A13I05FD0400,A13I06II,A13I07JJA02I02,A13I08JJA03I02,A13F01NV0064,A13F02CV0016,A13F03CV0016,A13F04CV0016,A13F05NV0256,A13F06NV0064,A13F07NV0012,A02F01NV0016,A03F01NV0016  from A13 left join A02 on A13I07JJA02I02 = A02I02UV0002 left join A03 on A13I08JJA03I02 = A03I02UV0003 where A13I01XA='" + oValue.Data("A13I01XA") + "'";
        recordset = Sql.selectTable(SQL, "A13");
        /* 新增編輯邏輯 */
        if (oValue.Data("Action") == "Add" || oValue.Data("Action") == "Upd") { InsertUpdate(context); return; }
        /* 刪除邏輯 */
        if (oValue.Data("Del") == "Del") { Delete(context); return; }

        oTemplate.SetTemplatesDir(pb.SiteFunctionTemplateName );
        oTemplate.SetTemplateFileCharset(pb.FaceTemplateName , "UTF-8");
        string A13I07JJA02I02 = "";                                        
        if (recordset != null)
        {
            //編輯
            DataSet DataSet1 = new DataSet();
            DataSet1.Tables.Add(recordset);
            foreach (DataColumn columename in DataSet1.Tables["A13"].Columns)
            {
                string pRName = columename.ToString();
                string pRValue = DataSet1.Tables["A13"].Rows[0][columename].ToString();
                oTemplate.SetVariable_HTML(pRName, pRValue, saFiled.GetColumeLength(pRName));
            }
            oTemplate.SetVariable_HTML_RADIO("A13I03CV0001", TF.Msg01, DataSet1.Tables["A13"].Rows[0]["A13I03CV0001"].ToString(), "B");
            oTemplate.SetVariable_HTML_RADIO("A13I03CV0001", TF.Msg02, DataSet1.Tables["A13"].Rows[0]["A13I03CV0001"].ToString(), "S");
            
            oTemplate.SetVariable("Action", "Upd");
            A13I07JJA02I02 = DataSet1.Tables["A13"].Rows[0]["A13I07JJA02I02"].ToString();
            A13I01XA = DataSet1.Tables["A13"].Rows[0]["A13I01XA"].ToString();
            recordset.Dispose();
        }
        else
        {
            //新增
            try
            {
                string columnString = "A13I02UV0010,A13I03CV0001,A13I04JJA13I02,A13I05FD0400,A13I06II,A13I07JJA02I02,A13I08JJA03I02,A13F01NV0064,A13F02CV0016,A13F03CV0016,A13F04CV0016,A13F05NV0256,A13F06NV0064,A13F07NV0012";
                string[] Column = columnString.Split(',');
                for (int i = 0; i < Column.Length ; i++)
                {
                    var pRName = Column[i];
                    string pRValue = "";
                    oTemplate.SetVariable_HTML(pRName, pRValue, saFiled.GetColumeLength(pRName));
                }                               
            }
            catch { }
            oTemplate.SetVariable_HTML_RADIO("A13I03CV0001", TF.Msg01, "B", "B");
            oTemplate.SetVariable_HTML_RADIO("A13I03CV0001", TF.Msg02, "", "S");
            oTemplate.SetVariable("Action", "Add");
        }

        /* 下拉式選單 */
        DataTable select = new DataTable();
        Sql.ClearQuery();
        SQL = "Select A02I02UV0002,A02F01NV0016 From A02 ";
        //if (recordset != null)
        //{
        //    SQL += "where A13I02UV0010 <> '" + recordset.Rows[0]["A13I02UV0010"].ToString() + "'";
        //}
        select = Sql.selectTable(SQL, "A02");
        if (select != null)
        {
            for (int i = 0; i < select.Rows.Count; i++)
            {
                oTemplate.SetVariable_HTML_OPTION("A13I07JJA02I02", select.Rows[i][1].ToString(), A13I07JJA02I02, select.Rows[i][0].ToString());
            }
        }        
        oTemplate.SetVariable_HTML_SELECT("A13I07JJA02I02");
        oTemplate.SetVariable_HTML_SELECT("A13I08JJA03I02");
        string Rtn = oTemplate.GetOutput();
        context.Response.ContentType = "text/plain";
        context.Response.Write(Rtn);

    }
    public void InsertUpdate(HttpContext context)
    {
        Language_Msg Ms = new Language_Msg();

        string A13I01XA = oValue.Data("A13I01XA");
        string A13I02UV0010 = "";
        /* 空白檢查*/
        if (oValue.EmptyCheck("A13F01NV0064") == false)
        {
            context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg01 + "');");
            return;
        }
        /* 長度檢查*/
        //if(oValue.Data("Action").Length < 6){
        //   context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg18 + "');");
        //    return;
        //}
        /* 欄位檢查 */
        //if (oValue.ColumnNoChines("A13I02UV0010,A10F01CV0032") == false)
        //{
        //    context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg14 + "');");
        //    return;
        //}
        /* 欄位重覆檢查 */
        if(dt!=null){ dt.Dispose();}
        Sql.ClearQuery();
        SQL = "Select A13F01NV0064 from A13 where A13F01NV0064='" + oValue.Data("A13F01NV0064") + "'";
        if (oValue.Data("Action") == "Upd") { SQL += " and A13I01XA <> '" + A13I01XA + "'"; }
        dt = Sql.selectTable(SQL, "A13e");
        if (dt !=null)
        {
            context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg02 + "');");
            return;
        }
        ////if(dt!=null){ dt.Dispose();}
        ////Sql.ClearQuery();
        ////SQL = "Select A13I02UV0064 from A13 where A13I02UV0064='" + oValue.Data("A13I02UV0064") + "'";
        ////if (oValue.Data("Action") == "Upd") { SQL += " and A13I01XA <> '" + A13I01XA + "'"; }
        ////dt = Sql.selectTable(SQL, "A13e");
        ////if (dt !=null)
        ////{
        ////    context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg07 + "');");
        ////    return;
        ////}
        /* 層級變更檢查 */
        if (oValue.Data("Action") == "Upd")
        {
            ////if (oValue.Data("A10I06CV0009") != recordset.Rows[0]["A10I06CV0009"].ToString())
            ////{
            ////    if(dt!=null){ dt.Dispose();}
            ////    Sql.ClearQuery();
            ////    SQL = "Select A10I06CV0009 from A10 where A10I06CV0009='" + recordset.Rows[0]["A13I02UV0010"].ToString() + "'";
            ////    dt = Sql.selectTable(SQL, "A10c");
            ////    if (dt !=null)
            ////    {
            ////        context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg04 + "');");
            ////        return;
            ////    }

            ////}
        }

        /* A10代碼產生*/
        if (oValue.Data("Action") == "Add")
        {
            Sql.ClearQuery();
            A13I02UV0010 = Sql.Top1Query("A13", "A13I02UV0010", true);
            if (A13I02UV0010 == "")
            {
                A13I02UV0010 = "A000000001";
            }
            else
            {
                A13I02UV0010 = Cls_Rule.I02creater(A13I02UV0010, "A", 9);
            }
        }
        else
        {
            A13I02UV0010 = recordset.Rows[0]["A13I02UV0010"].ToString();
        }
       

        oDate.RecordNow();
        Sql.ClearQuery();        
        string A13I03CV0001 = oValue.Data("A13I03CV0001");
        string A13I04JJA13I02 = oValue.Data("A13I04JJA13I02");
        //string A13I05FD0400 = oValue.Data("A13I05FD0400");
        //string A13I06II = oValue.Data("A13I06II");
        string A13I07JJA02I02 = oValue.Data("A13I07JJA02I02");
        string A13I08JJA03I02 = oValue.Data("A13I08JJA03I02");
        string A13F01NV0064 = oValue.Data("A13F01NV0064");
        string A13F02CV0016 = oValue.Data("A13F02CV0016");
        string A13F03CV0016 = oValue.Data("A13F03CV0016");
        string A13F04CV0016 = oValue.Data("A13F04CV0016");
        string A13F05NV0256 = oValue.Data("A13F05NV0256");
        string A13F06NV0064 = oValue.Data("A13F06NV0064");
        string A13F07NV0012 = oValue.Data("A13F07NV0012");

       

        string strSQL = "";
        string Error = "";
        //Sql.transBegin();
        Sql.SetData("A13I02UV0010",A13I02UV0010);
        Sql.SetData("A13I03CV0001",A13I03CV0001);
        Sql.SetData("A13I04JJA13I02",A13I04JJA13I02);
        //Sql.SetData("A13I05FD0400",A13I05FD0400);
        //Sql.SetData("A13I06II", A13I06II);
        Sql.SetData("A13I07JJA02I02", A13I07JJA02I02);
        Sql.SetData("A13I08JJA03I02", A13I08JJA03I02);
        Sql.SetData("A13F01NV0064", A13F01NV0064);
        Sql.SetData("A13F02CV0016", A13F02CV0016);
        Sql.SetData("A13F03CV0016", A13F03CV0016);
        Sql.SetData("A13F04CV0016", A13F04CV0016);
        Sql.SetData("A13F05NV0256", A13F05NV0256);
        Sql.SetData("A13F06NV0064", A13F06NV0064);
        Sql.SetData("A13F07NV0012", A13F07NV0012);   
     
        Sql.SetData("A13IND", oDate.IND);
        Sql.SetData("A13INT", oDate.INT);
        Sql.SetData("A13INA", oDate.INA);
        Sql.SetData("A13UPD", oDate.IND);
        Sql.SetData("A13UPT", oDate.INT);
        Sql.SetData("A13UPA", oDate.INA);
        
        if (oValue.Data("Action") == "Add")
        {
            strSQL += Sql.getInserSQL("A13") + "\r\n";
        }
        else
        {
            Sql.SetWhere("And", "A13I01XA", "=", A13I01XA, false);
            strSQL += Sql.getUpdateSQL("A13") + "\r\n";
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
        string A13I02UV0010 = recordset.Rows[0]["A13I02UV0010"].ToString();
        string A13I01XA = recordset.Rows[0]["A13I01XA"].ToString();
        /* 刪除檢查 */
        ////recordset.Dispose();
        ////Sql.ClearQuery();
        ////SQL = "Select A13I02UV0010 from A13 where A13I06CV0009='" + A13I02UV0010 + "'";
        ////recordset = Sql.selectTable(SQL, "Check");
        ////if (recordset !=null)
        ////{
        ////    context.Response.Write("alert('" + Ms.Msg04 + "')");
        ////    return;
        ////}
        string strSQL = "";
        Sql.SetWhere("And", "A13I01XA", "=", A13I01XA, false);
        strSQL += Sql.getDelteSQL("A13") + "\r\n";
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