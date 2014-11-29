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
    string TableName = "A31";
    public void ProcessRequest(HttpContext context)
    {
        Language_TF TF = new Language_TF();
        oValue.setRequestPost("Action,A31I01XA,A31I02UV0010,A31I03CV0001,A31I04JJA30I02,A31I05CV0001,A31I06CV0001,A31I07CV0001,A31I08CV0001,A31I09CV0001,A31I10CV0001,A31I11JJA31I02,A31I12FD0200,A31I13II,A31I14CV0024,A31I15FD0600,A31F01NV0064,A31F02NV0256,A31F03NV0004,A31F04FD0300,A31F05NV0256,A31F06NV0032");
        oValue.setRequestGet("Del");
        string A31I01XA = oValue.Data("A31I01XA").ToString();
        if (A31I01XA == "") { oValue.setRequestGet("A31I01XA"); A31I01XA = oValue.Data("A31I01XA"); }

        SQL = "select A31I01XA,A31I02UV0010,A31I03CV0001,A31I04JJA30I02,A31I05CV0001,A31I06CV0001,A31I07CV0001,A31I08CV0001,A31I09CV0001,A31I10CV0001,A31I11JJA31I02,A31I12FD0200,A31I13II,A31I14CV0024,A31I15FD0600,A31F01NV0064,A31F02NV0256,A31F03NV0004,A31F04FD0300,A31F05NV0256,A31F06NV0032  from A31 where A31I01XA='" + oValue.Data("A31I01XA") + "'";
        recordset = Sql.selectTable(SQL, "A31");
        /* 新增編輯邏輯 */
        if (oValue.Data("Action") == "Add" || oValue.Data("Action") == "Upd") { InsertUpdate(context); return; }
        /* 刪除邏輯 */
        if (oValue.Data("Del") == "Del") { Delete(context); return; }

        oTemplate.SetTemplatesDir(pb.SiteFunctionTemplateName );
        oTemplate.SetTemplateFileCharset(pb.FaceTemplateName , "UTF-8");
        string A31I04JJA30I02 = "";
        string A31I05JJA31I02 = "";                                      
        if (recordset != null)
        {
            //編輯
            DataSet DataSet1 = new DataSet();
            DataSet1.Tables.Add(recordset);
            foreach (DataColumn columename in DataSet1.Tables["A31"].Columns)
            {
                string pRName = columename.ToString();
                string pRValue = DataSet1.Tables["A31"].Rows[0][columename].ToString();
                oTemplate.SetVariable_HTML(pRName, pRValue, saFiled.GetColumeLength(pRName));
            }
            oTemplate.SetVariable_HTML_RADIO("A31I03CV0001", TF.Msg01, DataSet1.Tables["A31"].Rows[0]["A31I03CV0001"].ToString(), "B");
            oTemplate.SetVariable_HTML_RADIO("A31I03CV0001", TF.Msg02, DataSet1.Tables["A31"].Rows[0]["A31I03CV0001"].ToString(), "S");

            oTemplate.SetVariable_HTML_RADIO("A31I05CV0001", TF.Msg03, DataSet1.Tables["A31"].Rows[0]["A31I05CV0001"].ToString(), "L");
            oTemplate.SetVariable_HTML_RADIO("A31I05CV0001", TF.Msg04, DataSet1.Tables["A31"].Rows[0]["A31I05CV0001"].ToString(), "G");
            
            
            oTemplate.SetVariable("Action", "Upd");
            A31I04JJA30I02 = DataSet1.Tables["A31"].Rows[0]["A31I04JJA30I02"].ToString();
            
            A31I01XA = DataSet1.Tables["A31"].Rows[0]["A31I01XA"].ToString();
            recordset.Dispose();
        }
        else
        {
            //新增
            try
            {
                string columnString = "A31I01XA,A31I02UV0010,A31I03CV0001,A31I04JJA30I02,A31I05CV0001,A31I06CV0001,A31I07CV0001,A31I08CV0001,A31I09CV0001,A31I10CV0001,A31I11JJA31I02,A31I12FD0200,A31I13II,A31I14CV0024,A31I15FD0600,A31F01NV0064,A31F02NV0256,A31F03NV0004,A31F04FD0300,A31F05NV0256,A31F06NV0032";
                string[] Column = columnString.Split(',');
                for (int i = 0; i < Column.Length ; i++)
                {
                    var pRName = Column[i];
                    string pRValue = "";
                    oTemplate.SetVariable_HTML(pRName, pRValue, saFiled.GetColumeLength(pRName));
                }                               
            }
            catch { }
            oTemplate.SetVariable_HTML_RADIO("A31I03CV0001", TF.Msg01, "B", "B");
            oTemplate.SetVariable_HTML_RADIO("A31I03CV0001", TF.Msg02, "", "S");
            oTemplate.SetVariable_HTML_RADIO("A31I05CV0001", TF.Msg06, "", "L");
            oTemplate.SetVariable_HTML_RADIO("A31I05CV0001", TF.Msg07, "", "G");
            oTemplate.SetVariable("Action", "Add");
        }

        /* 下拉式選單 */
        DataTable select = new DataTable();
        Sql.ClearQuery();
        SQL = "Select A30I02UV0004,A30F01NV0064 From A30 ";
        //if (recordset != null)
        //{
        //    SQL += "where A31I02UV0010 <> '" + recordset.Rows[0]["A31I02UV0010"].ToString() + "'";
        //}
        select = Sql.selectTable(SQL, "A30");
        if (select != null)
        {
            for (int i = 0; i < select.Rows.Count; i++)
            {
                oTemplate.SetVariable_HTML_OPTION("A31I04JJA30I02", select.Rows[i][1].ToString(), A31I04JJA30I02, select.Rows[i][0].ToString());
            }
        }
        oTemplate.SetVariable_HTML_SELECT("A31I04JJA30I02");                
        string Rtn = oTemplate.GetOutput();
        context.Response.ContentType = "text/plain";
        context.Response.Write(Rtn);

    }
    public void InsertUpdate(HttpContext context)
    {
        Language_Msg Ms = new Language_Msg();

        string A31I01XA = oValue.Data("A31I01XA");
        string A31I02UV0010 = "";
        /* 空白檢查*/
        if (oValue.EmptyCheck("A31F01NV0064,A31I14CV0024") == false)
        {
            context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg01 + "');");
            return;
        }
        if (oValue.Data("A31I06CV0001") == "" && oValue.Data("A31I07CV0001") == "")
        {
            context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg20 + "');");
            return;
        }
        /* 長度檢查*/
        //if(oValue.Data("Action").Length < 6){
        //   context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg18 + "');");
        //    return;
        //}
        /* 欄位檢查 */
        //if (oValue.ColumnNoChines("A31I02UV0010,A10F01CV0032") == false)
        //{
        //    context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg14 + "');");
        //    return;
        //}
        /* 欄位重覆檢查 */
        if(dt!=null){ dt.Dispose();}
        Sql.ClearQuery();
        SQL = "Select A31F01NV0064 from A31 where A31F01NV0064='" + oValue.Data("A31F01NV0064") + "'";
        if (oValue.Data("Action") == "Upd") { SQL += " and A31I01XA <> '" + A31I01XA + "'"; }
        dt = Sql.selectTable(SQL, "A31e");
        if (dt !=null)
        {
            context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg02 + "');");
            return;
        }
        if (dt != null) { dt.Dispose(); }
        Sql.ClearQuery();
        SQL = "Select A31I14CV0024 from A31 where A31I14CV0024='" + oValue.Data("A31I14CV0024") + "' and A31I10CV0001<>'V'";
        if (oValue.Data("Action") == "Upd") { SQL += " and A31I01XA <> '" + A31I01XA + "'"; }
        dt = Sql.selectTable(SQL, "A31e");
        if (dt != null)
        {
            context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg21 + "');");
            return;
        }
        /* 層級變更檢查 */
        if (oValue.Data("Action") == "Upd")
        {
            ////if (oValue.Data("A10I06CV0009") != recordset.Rows[0]["A10I06CV0009"].ToString())
            ////{
            ////    if(dt!=null){ dt.Dispose();}
            ////    Sql.ClearQuery();
            ////    SQL = "Select A10I06CV0009 from A10 where A10I06CV0009='" + recordset.Rows[0]["A31I02UV0010"].ToString() + "'";
            ////    dt = Sql.selectTable(SQL, "A10c");
            ////    if (dt !=null)
            ////    {
            ////        context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg04 + "');");
            ////        return;
            ////    }

            ////}
        }

        /* A31代碼產生*/
        if (oValue.Data("Action") == "Add")
        {
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
        }
        else
        {
            A31I02UV0010 = recordset.Rows[0]["A31I02UV0010"].ToString();
        }
       

        oDate.RecordNow();
        Sql.ClearQuery();
        string A31I03CV0001 = oValue.Data("A31I03CV0001");
        string A31I04JJA30I02 = oValue.Data("A31I04JJA30I02");
        string A31I05CV0001 = oValue.Data("A31I05CV0001");
        string A31I06CV0001 = oValue.Data("A31I06CV0001");
        string A31I07CV0001 = oValue.Data("A31I07CV0001");
        string A31I08CV0001 = oValue.Data("A31I08CV0001");
        string A31I09CV0001 = oValue.Data("A31I09CV0001");
        string A31I10CV0001 = oValue.Data("A31I10CV0001");
        string A31I11JJA31I02 = oValue.Data("A31I11JJA31I02");
        string A31I12FD0200 = oValue.Data("A31I12FD0200");
        string A31I13II = oValue.Data("A31I13II");
        string A31I14CV0024 = oValue.Data("A31I14CV0024");
        string A31F01NV0064 = oValue.Data("A31F01NV0064");
        string A31F02NV0256 = oValue.Data("A31F02NV0256");
        string A31F03NV0004 = oValue.Data("A31F03NV0004");
        string A31F04FD0300 = oValue.Data("A31F04FD0300");
        string A31F05NV0256 = oValue.Data("A31F05NV0256");
        string A31F06NV0032 = oValue.Data("A31F06NV0032");
        string A31I15FD0600 = oValue.Data("A31I15FD0600");

        if (A31F05NV0256 != "")
        {
            string[] Cs = A31F05NV0256.Split(',');
            A31F04FD0300 = Cs.Length.ToString();
        }
        else {
            A31F04FD0300 = "0";
        }
        string strSQL = "";
        string Error = "";
        //Sql.transBegin();
        Sql.SetData("A31I02UV0010", A31I02UV0010);
        Sql.SetData("A31I03CV0001", A31I03CV0001);
        Sql.SetData("A31I04JJA30I02", A31I04JJA30I02);
        Sql.SetData("A31I05CV0001", A31I05CV0001);
        Sql.SetData("A31I06CV0001", A31I06CV0001);
        Sql.SetData("A31I07CV0001", A31I07CV0001);
        Sql.SetData("A31I08CV0001", A31I08CV0001);
        Sql.SetData("A31I09CV0001", A31I09CV0001);
        Sql.SetData("A31I10CV0001", A31I10CV0001);
        Sql.SetData("A31I11JJA31I02", A31I11JJA31I02);
        //Sql.SetData("A31I12FD0200", A31I12FD0200);
        //Sql.SetData("A31I13II", A31I13II);
        Sql.SetData("A31I14CV0024", A31I14CV0024);
        Sql.SetData("A31I15FD0600", A31I15FD0600);
        Sql.SetData("A31F01NV0064", A31F01NV0064);
        Sql.SetData("A31F02NV0256", A31F02NV0256);
        Sql.SetData("A31F03NV0004", A31F03NV0004);
        Sql.SetData("A31F04FD0300", A31F04FD0300);
        Sql.SetData("A31F05NV0256", A31F05NV0256);
        Sql.SetData("A31F06NV0032", A31F06NV0032); 
        Sql.SetData("A31IND", oDate.IND);
        Sql.SetData("A31INT", oDate.INT);
        Sql.SetData("A31INA", oDate.INA);
        Sql.SetData("A31UPD", oDate.IND);
        Sql.SetData("A31UPT", oDate.INT);
        Sql.SetData("A31UPA", oDate.INA);
        
        if (oValue.Data("Action") == "Add")
        {
            strSQL += Sql.getInserSQL("A31") + "\r\n";
            if (A31F05NV0256 != "") {
              string[] Child = A31F05NV0256.Split(',');
                for (int n = 0; n < Child.Length; n++) {
                    string ChildSQL = getChildSQL_Add(n+1, Child[n], A31I04JJA30I02, A31I05CV0001, A31I06CV0001, A31I07CV0001, A31I08CV0001, A31I10CV0001, A31I02UV0010, A31I14CV0024, A31F01NV0064);
                    strSQL += ";" + ChildSQL;
                }
            }
        }
        else
        {
            Sql.SetWhere("And", "A31I01XA", "=", A31I01XA, false);
            strSQL += Sql.getUpdateSQL("A31") + ";" + "\r\n";
            
            strSQL +=  getChildSQL_Upd( A31I02UV0010,  A31I03CV0001,  A31I04JJA30I02,  A31I05CV0001,  A31I06CV0001,  A31I07CV0001);
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
    public string getChildSQL_Upd(string A31I02UV0010, string A31I03CV0001, string A31I04JJA30I02, string A31I05CV0001, string A31I06CV0001, string A31I07CV0001)
    {
        string SqlString = "";
        oDate.RecordNow();
        Sql.ClearQuery();
        Sql.SetData("A31I03CV0001", A31I03CV0001);
        Sql.SetData("A31I04JJA30I02", A31I04JJA30I02);
        Sql.SetData("A31I05CV0001", A31I05CV0001);
        Sql.SetData("A31I06CV0001", A31I06CV0001);
        Sql.SetData("A31I07CV0001", A31I07CV0001);
        Sql.SetData("A31UPD", oDate.IND);
        Sql.SetData("A31UPT", oDate.INT);
        Sql.SetData("A31UPA", oDate.INA);
        Sql.SetWhere("And", "A31I11JJA31I02", "=", A31I02UV0010, true);
        SqlString += Sql.getUpdateSQL("A31") + "\r\n";
        
        return  SqlString ;
    }
    
    public string getChildSQL_Add(int Num,string name, string A31I04JJA30I02, string A31I05CV0001, string A31I06CV0001, string A31I07CV0001, string A31I08CV0001, string A31I10CV0001, string A31I02UV0010, string A31I14CV0024, string A31F01NV0064)
    {
        string SqlString = "";
        string NewI02;
        int pLength = A31I02UV0010.Length - 1;
        string str = A31I02UV0010.Substring(1, 9);
        int pCounter = Convert.ToInt32(str) + Num;
        str = Convert.ToString(pCounter);
        string pRturn = "P" + str.PadLeft(9, Convert.ToChar("0"));

        NewI02 = pRturn;
        
        
        oDate.RecordNow();
        Sql.ClearQuery();
        Sql.SetData("A31I03CV0001", "B");
        Sql.SetData("A31I02UV0010", NewI02);
        
        Sql.SetData("A31I04JJA30I02", A31I04JJA30I02);
        Sql.SetData("A31I05CV0001", A31I05CV0001);
        Sql.SetData("A31I06CV0001", A31I06CV0001);
        Sql.SetData("A31I07CV0001", A31I07CV0001);
        Sql.SetData("A31I08CV0001", A31I08CV0001);        
        Sql.SetData("A31I10CV0001", "V");
        Sql.SetData("A31I11JJA31I02", A31I02UV0010);        
        Sql.SetData("A31I14CV0024", A31I14CV0024);
        Sql.SetData("A31F01NV0064", name);

        Sql.SetData("A31I12FD0200", Num.ToString());

        Sql.SetData("A31IND", oDate.IND);
        Sql.SetData("A31INT", oDate.INT);
        Sql.SetData("A31INA", oDate.INA);
        Sql.SetData("A31UPD", oDate.IND);
        Sql.SetData("A31UPT", oDate.INT);
        Sql.SetData("A31UPA", oDate.INA);
        SqlString += Sql.getInserSQL("A31") + "\r\n";
        
        
        return SqlString;
    }
    
    public void Delete(HttpContext context)
    {
        Language_Msg Ms = new Language_Msg();
        string A31I02UV0010 = recordset.Rows[0]["A31I02UV0010"].ToString();
        string A31I01XA = recordset.Rows[0]["A31I01XA"].ToString();
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
        strSQL += Sql.getDelteSQL("A31") + "\r\n";
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