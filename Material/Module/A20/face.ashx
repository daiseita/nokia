<%@ WebHandler Language="C#" Class="A20_face" %>

using System;
using System.Web;
using System.Data;
public class A20_face : IHttpHandler {
   
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
    string TableName = "A20";
    public void ProcessRequest(HttpContext context)
    {
        Language_TF TF = new Language_TF();
        oValue.setRequestPost("Action,A20I01XA,A20I02UV0010,A20I03CV0001,A20I05CV0001,A20I06CV0001,A20I07CV0001,A20I08CV0001,A20I09JJA13I02,A20I10JJA12I02,A20I11JJA11I02,A20I12JJA10I02,A20I13JJA02I02,A20I14JJA03I02,A20I15JJA19I02,A20F01NV0006,A20F02NV0006,A20F03NV0008,A20F04CV0004,A20F05CV0004,A20F06CV0032,A20F07CV0032,A20F08CV0128,A20F09NT");
        oValue.setRequestGet("Del");
        string A20I01XA = oValue.Data("A20I01XA").ToString();
        if (A20I01XA == "") { oValue.setRequestGet("A20I01XA"); A20I01XA = oValue.Data("A20I01XA"); }

        string A20I06CV0009 = "";
        SQL = "Select A20I01XA,A20I02UV0010,A20I03CV0001,A20I05CV0001,A20I06CV0001,A20I07CV0001,A20I08CV0001,A20I09JJA13I02,A20I10JJA12I02,A20I11JJA11I02,A20I12JJA10I02,A20I13JJA02I02,A20I14JJA03I02,A20I15JJA19I02,A20F01NV0006,A20F02NV0006,A20F03NV0008,A20F04CV0004,A20F05CV0004,A20F06CV0032,A20F07CV0032,A20F08CV0128,A20F09NT,A20IND,A20INT,A20INA,A20INU,A20UPD,A20UPT,A20UPA,A20UPU,A20UPC from A20 where A20I01XA='" + oValue.Data("A20I01XA") + "'";
        recordset = Sql.selectTable(SQL, "A20");
        /* 新增編輯邏輯 */
        if (oValue.Data("Action") == "Add" || oValue.Data("Action") == "Upd") { InsertUpdate(context); return; }
        /* 刪除邏輯 */
        if (oValue.Data("Del") == "Del") { Delete(context); return; }

        oTemplate.SetTemplatesDir(pb.SiteFunctionTemplateName );
        oTemplate.SetTemplateFileCharset(pb.FaceTemplateName , "UTF-8");
        string A20I13JJA02I02 = "";
        string A20I09JJA13I02 = "";
        string A20I10JJA12I02 = "";
        string A20I15JJA19I02 = "";
        if (recordset != null)
        {
            //編輯
            DataSet DataSet1 = new DataSet();
            DataSet1.Tables.Add(recordset);
            foreach (DataColumn columename in DataSet1.Tables["A20"].Columns)
            {
                string pRName = columename.ToString();
                string pRValue = DataSet1.Tables["A20"].Rows[0][columename].ToString();
                oTemplate.SetVariable_HTML(pRName, pRValue, saFiled.GetColumeLength(pRName));
            }
            oTemplate.SetVariable_HTML_RADIO("A20I03CV0001", TF.Msg01, DataSet1.Tables["A20"].Rows[0]["A20I03CV0001"].ToString(), "B");
            oTemplate.SetVariable_HTML_RADIO("A20I03CV0001", TF.Msg02, DataSet1.Tables["A20"].Rows[0]["A20I03CV0001"].ToString(), "S");


            A20I13JJA02I02 = recordset.Rows[0]["A20I13JJA02I02"].ToString();
            A20I09JJA13I02 = recordset.Rows[0]["A20I09JJA13I02"].ToString();
            A20I10JJA12I02 = recordset.Rows[0]["A20I10JJA12I02"].ToString();
            A20I15JJA19I02 = recordset.Rows[0]["A20I15JJA19I02"].ToString();
            oTemplate.SetVariable("Action", "Upd");

            recordset.Dispose();
        }
        else
        {
            //新增
            try
            {
                string columnString = "A20I01XA,A20I02UV0010,A20I03CV0001,A20I05CV0001,A20I06CV0001,A20I07CV0001,A20I08CV0001,A20I09JJA13I02,A20I10JJA12I02,A20I11JJA11I02,A20I12JJA10I02,A20I13JJA02I02,A20I14JJA03I02,A20F01NV0006,A20F02NV0006,A20F03NV0008,A20F04CV0004,A20F05CV0004,A20F06CV0032,A20F07CV0032,A20F08CV0128,A20F09NT";
                string[] Column = columnString.Split(',');
                for (int i = 0; i < Column.Length ; i++)
                {
                    var pRName = Column[i];
                    string pRValue = "";
                    oTemplate.SetVariable_HTML(pRName, pRValue, saFiled.GetColumeLength(pRName));
                }                               
            }
            catch { }
            oTemplate.SetVariable_HTML_RADIO("A20I03CV0001", TF.Msg01, "B", "B");
            oTemplate.SetVariable_HTML_RADIO("A20I03CV0001", TF.Msg02, "", "S");
            oTemplate.SetVariable("Action", "Add");
        }

        /* 下拉式選單 */        
        DataTable select = new DataTable();
        Sql.ClearQuery();
        SQL = "Select A02I02UV0002,A02F01NV0016 From A02 ";     
        select = Sql.selectTable(SQL, "A02");
        if (select != null)
        {
            for (int i = 0; i < select.Rows.Count; i++)
            {
                oTemplate.SetVariable_HTML_OPTION("A20I13JJA02I02", select.Rows[i][1].ToString(), A20I13JJA02I02, select.Rows[i][0].ToString());
            }
        }
        oTemplate.SetVariable_HTML_SELECT("A20I13JJA02I02");
        oTemplate.SetVariable_HTML_SELECT("A20I14JJA03I02");

        Sql.ClearQuery();
        SQL = "Select A13I02UV0010,A13F01NV0064 From A13 ";        
        select = Sql.selectTable(SQL, "A13");
        if (select != null)
        {
            for (int i = 0; i < select.Rows.Count; i++)
            {
                oTemplate.SetVariable_HTML_OPTION("A20I09JJA13I02", select.Rows[i][1].ToString(), A20I09JJA13I02, select.Rows[i][0].ToString());
            }
        }
        oTemplate.SetVariable_HTML_SELECT("A20I09JJA13I02");
        Sql.ClearQuery();
        SQL = "Select A12I02UV0010,A12F01NV0064 From A12 ";
        select = Sql.selectTable(SQL, "A12");
        if (select != null)
        {
            for (int i = 0; i < select.Rows.Count; i++)
            {
                oTemplate.SetVariable_HTML_OPTION("A20I10JJA12I02", select.Rows[i][1].ToString(), A20I10JJA12I02, select.Rows[i][0].ToString());
            }
        }
        oTemplate.SetVariable_HTML_SELECT("A20I10JJA12I02");
        select = null;
        SQL = "Select A19I02UV0004,A19F01NV0032 From A19 ";
        select = Sql.selectTable(SQL, "A19");
        if (select != null)
        {
            for (int i = 0; i < select.Rows.Count; i++)
            {
                oTemplate.SetVariable_HTML_OPTION("A20I15JJA19I02", select.Rows[i][1].ToString(), A20I15JJA19I02, select.Rows[i][0].ToString());
            }
        }
        oTemplate.SetVariable_HTML_SELECT("A20I15JJA19I02");
        
        
        string Rtn = oTemplate.GetOutput();
        context.Response.ContentType = "text/plain";
        context.Response.Write(Rtn);

    }
    public void InsertUpdate(HttpContext context)
    {
        Language_Msg Ms = new Language_Msg();

        string A20I01XA = oValue.Data("A20I01XA");
        string A20I02UV0010 = "";
        /* 空白檢查*/
        if (oValue.EmptyCheck("A20F01NV0006") == false)
        {
            context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg01 + "');");
            return;
        }
        if (oValue.Data("A20I06CV0001") == "V" && oValue.EmptyCheck("A20I09JJA13I02") == false)
        {
            context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg01 + "');");
            return;
        }
        if (oValue.Data("A20I07CV0001") == "V" && oValue.EmptyCheck("A20I10JJA12I02") == false)
        {
            context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg01 + "');");
            return;
        }
        if (oValue.Data("A20I08CV0001") == "V" && oValue.EmptyCheck("A20I15JJA19I02") == false)
        {
            context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg01 + "');");
            return;
        }
        /* 長度檢查*/
        //if (oValue.Data("A20I02UV0010").Length < 6)
        //{
        //   context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg18 + "');");
        //    return;
        //}
        ///* 欄位檢查 */
        //if (oValue.ColumnNoChines("A20I02UV0010,A20F01NV0006") == false)
        //{
        //    context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg14 + "');");
        //    return;
        //}
        /* 欄位重覆檢查 */
        if(dt!=null){ dt.Dispose();}
        Sql.ClearQuery();
        SQL = "Select A20F01NV0006 from A20 where A20F01NV0006='" + oValue.Data("A20F01NV0006") + "'";
        if (oValue.Data("Action") == "Upd") { SQL += " and A20I01XA <> '" + A20I01XA + "'"; }
        dt = Sql.selectTable(SQL, "A20e");
        if (dt !=null)
        {
            context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg02 + "');");
            return;
        }
        //if(dt!=null){ dt.Dispose();}
        //Sql.ClearQuery();
        //SQL = "Select A20I02UV0010 from A20 where A20I02UV0010='" + oValue.Data("A20I02UV0010") + "'";
        //if (oValue.Data("Action") == "Upd") { SQL += " and A20I01XA <> '" + A20I01XA + "'"; }
        //dt = Sql.selectTable(SQL, "A20e");
        //if (dt !=null)
        //{
        //    context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg07 + "');");
        //    return;
        //}
        /* 層級變更檢查 */
        if (oValue.Data("Action") == "Upd")
        {
            ////if (oValue.Data("A20I06CV0009") != recordset.Rows[0]["A20I06CV0009"].ToString())
            ////{
            ////    if(dt!=null){ dt.Dispose();}
            ////    Sql.ClearQuery();
            ////    SQL = "Select A20I06CV0009 from A20 where A20I06CV0009='" + recordset.Rows[0]["A20I02UV0010"].ToString() + "'";
            ////    dt = Sql.selectTable(SQL, "A20c");
            ////    if (dt !=null)
            ////    {
            ////        context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg04 + "');");
            ////        return;
            ////    }

            ////}
        }

        /* A20代碼產生*/
        if (oValue.Data("Action") == "Add")
        {
            Sql.ClearQuery();
            A20I02UV0010 = Sql.Top1Query("A20", "A20I02UV0010", true);
            if (A20I02UV0010 == "")
            {
                A20I02UV0010 = "X000000001";
            }
            else
            {
                A20I02UV0010 = Cls_Rule.I02creater(A20I02UV0010, "X", 9);
            }
        }
        else
        {
            A20I02UV0010 = recordset.Rows[0]["A20I02UV0010"].ToString();
        }
       

        oDate.RecordNow();
        Sql.ClearQuery();
        string A20I03CV0001 = oValue.Data("A20I03CV0001");
        string A20I05CV0001 = oValue.Data("A20I05CV0001");
        string A20I06CV0001 = oValue.Data("A20I06CV0001");
        string A20I07CV0001 = oValue.Data("A20I07CV0001");
        string A20I08CV0001 = oValue.Data("A20I08CV0001");
        string A20I09JJA13I02 = oValue.Data("A20I09JJA13I02");
        string A20I10JJA12I02 = oValue.Data("A20I10JJA12I02");
        string A20I11JJA11I02 = oValue.Data("A20I11JJA11I02");
        string A20I12JJA10I02 = oValue.Data("A20I12JJA10I02");
        string A20I13JJA02I02 = oValue.Data("A20I13JJA02I02");
        string A20I14JJA03I02 = oValue.Data("A20I14JJA03I02");
        string A20F01NV0006 = oValue.Data("A20F01NV0006");
        string A20F02NV0006 = oValue.Data("A20F02NV0006");
        string A20F03NV0008 = oValue.Data("A20F03NV0008");
        string A20F04CV0004 = oValue.Data("A20F04CV0004");
        string A20F05CV0004 = oValue.Data("A20F05CV0004");
        string A20F06CV0032 = oValue.Data("A20F06CV0032");
        string A20F07CV0032 = oValue.Data("A20F07CV0032");
        string A20F08CV0128 = oValue.Data("A20F08CV0128");
        string A20F09NT = oValue.Data("A20F09NT");
        string A20I15JJA19I02 = oValue.Data("A20I15JJA19I02");
        if (A20I06CV0001 == "") { A20I09JJA13I02 = ""; }
        if (A20I07CV0001 == "") { A20I10JJA12I02 = ""; }
        if (A20I08CV0001 == "") { A20I15JJA19I02 = ""; }
        string strSQL = "";
        string Error = "";
        //Sql.transBegin();
        Sql.SetData("A20I02UV0010", A20I02UV0010);
        Sql.SetData("A20I03CV0001", A20I03CV0001);
        Sql.SetData("A20I05CV0001", A20I05CV0001);
        Sql.SetData("A20I06CV0001", A20I06CV0001);
        Sql.SetData("A20I07CV0001", A20I07CV0001);
        Sql.SetData("A20I08CV0001", A20I08CV0001);
        Sql.SetData("A20I09JJA13I02", A20I09JJA13I02);
        Sql.SetData("A20I10JJA12I02", A20I10JJA12I02);
        Sql.SetData("A20I11JJA11I02", A20I11JJA11I02);
        Sql.SetData("A20I12JJA10I02", A20I12JJA10I02);
        Sql.SetData("A20I13JJA02I02", A20I13JJA02I02);
        Sql.SetData("A20I14JJA03I02", A20I14JJA03I02);
        Sql.SetData("A20I15JJA19I02", A20I15JJA19I02);
        Sql.SetData("A20F01NV0006", A20F01NV0006);
        Sql.SetData("A20F02NV0006", A20F02NV0006);
        Sql.SetData("A20F03NV0008", A20F03NV0008);
        Sql.SetData("A20F04CV0004", A20F04CV0004);
        Sql.SetData("A20F05CV0004", A20F05CV0004);
        Sql.SetData("A20F06CV0032", A20F06CV0032);
        Sql.SetData("A20F07CV0032", A20F07CV0032);
        Sql.SetData("A20F08CV0128", A20F08CV0128);
        Sql.SetData("A20F09NT", A20F09NT); 
        Sql.SetData("A20IND", oDate.IND);
        Sql.SetData("A20INT", oDate.INT);
        Sql.SetData("A20INA", oDate.INA);
        Sql.SetData("A20UPD", oDate.IND);
        Sql.SetData("A20UPT", oDate.INT);
        Sql.SetData("A20UPA", oDate.INA);        
        if (oValue.Data("Action") == "Add")
        {
            strSQL += Sql.getInserSQL("A20") + "\r\n";
        }
        else
        {
            Sql.SetWhere("And", "A20I01XA", "=", A20I01XA, false);
            strSQL += Sql.getUpdateSQL("A20") + "\r\n";
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
        string A20I02UV0010 = recordset.Rows[0]["A20I02UV0010"].ToString();
        string A20I01XA = recordset.Rows[0]["A20I01XA"].ToString();
        /* 刪除檢查 */
        ////recordset.Dispose();
        ////Sql.ClearQuery();
        ////SQL = "Select A20I02UV0010 from A20 where A20I06CV0009='" + A20I02UV0010 + "'";
        ////recordset = Sql.selectTable(SQL, "Check");
        ////if (recordset !=null)
        ////{
        ////    context.Response.Write("alert('" + Ms.Msg04 + "')");
        ////    return;
        ////}
        string strSQL = "";
        Sql.SetWhere("And", "A20I01XA", "=", A20I01XA, false);
        strSQL += Sql.getDelteSQL("A20") + "\r\n";
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