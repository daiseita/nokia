<%@ WebHandler Language="C#" Class="A60_face" %>

using System;
using System.Web;
using System.Data;
using System.Collections;
using System.Collections.Generic;
public class A60_face : IHttpHandler {
   
    Cls_Request oValue = new Cls_Request();
    Cls_Template oTemplate = new Cls_Template();
    Cls_SQL Sql = new Cls_SQL();
    DataTable recordset = new DataTable();
    DataTable dt = new DataTable();
    Cls_SA_Fields saFiled = new Cls_SA_Fields();
    Cls_Date oDate = new Cls_Date();
    Cls_Rule oRule = new Cls_Rule();
    Dictionary<string, int> codeArray = new Dictionary<string, int>();
    string SQL;
    PageBase pb = new PageBase();
    string tClientIP = PageBase.strIP;
    string TableName = "A60";
    string Sort = "L";
    public void ProcessRequest(HttpContext context)
    {
        Language_TF TF = new Language_TF();
        oValue.setRequestPost("Action,OrderDataString,A65I01XA,A65F02NV0128,A61I05JJA19I02,A60F02NV0128");
        oValue.setRequestGet("Del");
        string A65I01XA = oValue.Data("A65I01XA").ToString();
        if (A65I01XA == "") { oValue.setRequestGet("A65I01XA"); A65I01XA = oValue.Data("A65I01XA"); }
        if (oValue.Data("OrderDataString") != "") { OrderDataOperate(context); return; }
        string A67I06CV0009 = "";
        SQL = "Select A65I01XA,A65I02UV0012,A65I03CV0001,A65F01NV0064,A65F02NV0128 from A65 where A65I01XA='" + oValue.Data("A65I01XA") + "'";
        recordset = Sql.selectTable(SQL, "A65");
        /* 新增編輯邏輯 */
        if (oValue.Data("Action") == "Add" || oValue.Data("Action") == "Upd") { InsertUpdate(context); return; }
        /* 刪除邏輯 */
        if (oValue.Data("Del") == "Del") { Delete(context); return; }

        oTemplate.SetTemplatesDir(pb.SiteFunctionTemplateName );
        oTemplate.SetTemplateFileCharset(pb.FaceTemplateName , "UTF-8");                                              
        if (recordset != null)
        {
            ////編輯
            //DataSet DataSet1 = new DataSet();
            //DataSet1.Tables.Add(recordset);
            //foreach (DataColumn columename in DataSet1.Tables["A60"].Columns)
            //{
            //    string pRName = columename.ToString();
            //    string pRValue = DataSet1.Tables["A60"].Rows[0][columename].ToString();
            //    oTemplate.SetVariable_HTML(pRName, pRValue, saFiled.GetColumeLength(pRName));
            //}
            //oTemplate.SetVariable_HTML_RADIO("A60I03CV0001", TF.Msg01, DataSet1.Tables["A60"].Rows[0]["A60I03CV0001"].ToString(), "B");
            //oTemplate.SetVariable_HTML_RADIO("A60I03CV0001", TF.Msg02, DataSet1.Tables["A60"].Rows[0]["A60I03CV0001"].ToString(), "S");

            ////A60I06CV0009 = recordset.Rows[0]["A60I06CV0009"].ToString();
            //oTemplate.SetVariable("Action", "Upd");

            //recordset.Dispose();
        }
        else
        {
            //新增
            try
            {
                string columnString = "A60I01XA,A60I02UV0012,A60I03CV0001,A60F01NV0064,A60F02NV0128";
                string[] Column = columnString.Split(',');
                for (int i = 0; i < Column.Length ; i++)
                {
                    var pRName = Column[i];
                    string pRValue = "";
                    oTemplate.SetVariable_HTML(pRName, pRValue, saFiled.GetColumeLength(pRName));
                }                               
            }
            catch { }
            //oTemplate.SetVariable_HTML_RADIO("A61I08CV0001", TF.Msg08, "B", "B");
            //oTemplate.SetVariable_HTML_RADIO("A61I08CV0001", TF.Msg09, "", "S");

            oTemplate.SetVariable_HTML_RADIO("UploadSort", TF.Msg10, "A", "A");
            oTemplate.SetVariable_HTML_RADIO("UploadSort", TF.Msg11, "", "B");
            oTemplate.SetVariable_HTML_RADIO("UploadSort", TF.Msg12, "", "C");
            oTemplate.SetVariable_HTML_RADIO("UploadSort", TF.Msg13, "", "D");
            
            oTemplate.SetVariable("Action", "Add");
        }

        ///* 下拉式選單 */

        Sql.ClearQuery();
        SQL = "select DISTINCT A61I04JJA31I02,A31F01NV0064,A31F06NV0032 from A61 left join A60 on A61I03JJA60I02 = A60I02UV0012 left join A31 on A61I04JJA31I02 = A31I02UV0010   where A60I04CV0001='' and A61I09CV0001 <>'V' and A61I07CV0001='L' ";
        //Sql.sqlTransferColumn = "A31I06CV0001,A31I07CV0001,A31I08CV0001";
        recordset = Sql.selectTable(SQL, "A31");
        string pHtml = "";
        if (recordset != null)
        {
            for (int i = 0; i < recordset.Rows.Count; i++)
            {
                string str = recordset.Rows[i]["A31F06NV0032"].ToString();
                str = str.Replace("_", ""); str = str.Replace("'", ""); str = str.Replace("(", ""); str = str.Replace(")", ""); str = str.Replace(" ", ""); str = str.Replace(".", ""); str = str.Replace("=", "");
                pHtml += "<option class='" + str + "' value='" + recordset.Rows[i]["A61I04JJA31I02"].ToString() + "'>" +
                   "<span>" + recordset.Rows[i]["A31F06NV0032"].ToString() + "</span>" +
                    //recordset.Rows[i]["A31I06CV0001_NAME"].ToString() +
                    //recordset.Rows[i]["A31I07CV0001_NAME"].ToString() +
                    //recordset.Rows[i]["A31I08CV0001_NAME"].ToString() +"&nbsp;&nbsp;"+                   
                   "</option>";
            }
        }
        oTemplate.SetVariable("option", pHtml);

        Sql.ClearQuery();
        SQL = "select A19I02UV0004,A19F01NV0032 from A19 where A19I03CV0001='B'";
        //Sql.sqlTransferColumn = "A12I03CV0001";
        recordset = Sql.selectTable(SQL, "A12");
        if (recordset != null)
        {
            for (int i = 0; i < recordset.Rows.Count; i++)
            {
                oTemplate.SetVariable_HTML_OPTION("A61I05JJA19I02", recordset.Rows[i][1].ToString(), "", recordset.Rows[i][0].ToString());
                oTemplate.SetVariable_HTML_OPTION("A61I05JJA19I02_New", recordset.Rows[i][1].ToString(), "", recordset.Rows[i][0].ToString());
            }
        }
        oTemplate.SetVariable_HTML_SELECT("A61I05JJA19I02");
        oTemplate.SetVariable_HTML_SELECT("A61I05JJA19I02_New");
        recordset = null;
        
        Sql.ClearQuery();
        SQL = "select A12I02UV0010,A12F01NV0064 from A12 where A12I04CV0001='B' and A12I03CV0001='A' ";
        //Sql.sqlTransferColumn = "A12I03CV0001";
        recordset = Sql.selectTable(SQL, "A12");
        if (recordset != null)
        {
            for (int i = 0; i < recordset.Rows.Count; i++)
            {
                oTemplate.SetVariable_HTML_OPTION("A66I12JJA12I02", recordset.Rows[i][1].ToString(), "", recordset.Rows[i][0].ToString());
            }
        }
        oTemplate.SetVariable_HTML_SELECT("A66I12JJA12I02");
        
        string Rtn = oTemplate.GetOutput();
        context.Response.ContentType = "text/plain";
        context.Response.Write(Rtn);

    }
    public void InsertUpdate(HttpContext context)
    {
        Language_Msg Ms = new Language_Msg();

        string A60I01XA = oValue.Data("A60I01XA");
        string A60I02UV0004 = "";
        /* 空白檢查*/
        if (oValue.EmptyCheck("A60F01NV0064") == false)
        {
            context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg01 + "');");
            return;
        }
        /* 長度檢查*/
        //if (oValue.Data("A60I02UV0004").Length < 6)
        //{
        //   context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg18 + "');");
        //    return;
        //}
        ///* 欄位檢查 */
        //if (oValue.ColumnNoChines("A60I02UV0004,A60F01NV0064") == false)
        //{
        //    context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg14 + "');");
        //    return;
        //}
        /* 欄位重覆檢查 */
        if(dt!=null){ dt.Dispose();}
        Sql.ClearQuery();
        SQL = "Select A60F01NV0064 from A60 where A60F01NV0064='" + oValue.Data("A60F01NV0064") + "'";
        if (oValue.Data("Action") == "Upd") { SQL += " and A60I01XA <> '" + A60I01XA + "'"; }
        dt = Sql.selectTable(SQL, "A60e");
        if (dt !=null)
        {
            context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg02 + "');");
            return;
        }
        //if(dt!=null){ dt.Dispose();}
        //Sql.ClearQuery();
        //SQL = "Select A60I02UV0004 from A60 where A60I02UV0004='" + oValue.Data("A60I02UV0004") + "'";
        //if (oValue.Data("Action") == "Upd") { SQL += " and A60I01XA <> '" + A60I01XA + "'"; }
        //dt = Sql.selectTable(SQL, "A60e");
        //if (dt !=null)
        //{
        //    context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg07 + "');");
        //    return;
        //}
        /* 層級變更檢查 */
        if (oValue.Data("Action") == "Upd")
        {
            ////if (oValue.Data("A60I06CV0009") != recordset.Rows[0]["A60I06CV0009"].ToString())
            ////{
            ////    if(dt!=null){ dt.Dispose();}
            ////    Sql.ClearQuery();
            ////    SQL = "Select A60I06CV0009 from A60 where A60I06CV0009='" + recordset.Rows[0]["A60I02UV0004"].ToString() + "'";
            ////    dt = Sql.selectTable(SQL, "A60c");
            ////    if (dt !=null)
            ////    {
            ////        context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg04 + "');");
            ////        return;
            ////    }

            ////}
        }

        /* A60代碼產生*/
        if (oValue.Data("Action") == "Add")
        {
            Sql.ClearQuery();
            A60I02UV0004 = Sql.Top1Query("A60", "A60I02UV0004", true);
            if (A60I02UV0004 == "")
            {
                A60I02UV0004 = "S001";
            }
            else
            {
                A60I02UV0004 = Cls_Rule.I02creater(A60I02UV0004, "S", 3);
            }
        }
        else
        {
            A60I02UV0004 = recordset.Rows[0]["A60I02UV0004"].ToString();
        }
       

        oDate.RecordNow();
        Sql.ClearQuery();           
        string A60I03CV0001 = oValue.Data("A60I03CV0001");
        string A60F01NV0064 = oValue.Data("A60F01NV0064");
        string A60F02NV0512 = oValue.Data("A60F02NV0512");
       

        string strSQL = "";
        string Error = "";
        //Sql.transBegin();
        Sql.SetData("A60I02UV0004", A60I02UV0004);        
        Sql.SetData("A60I03CV0001", A60I03CV0001);
        Sql.SetNData("A60F01NV0064", A60F01NV0064);
        Sql.SetData("A60F02NV0512", A60F02NV0512);       
        Sql.SetData("A60IND", oDate.IND);
        Sql.SetData("A60INT", oDate.INT);
        Sql.SetData("A60INA", oDate.INA);
        Sql.SetData("A60UPD", oDate.IND);
        Sql.SetData("A60UPT", oDate.INT);
        Sql.SetData("A60UPA", oDate.INA);        
        if (oValue.Data("Action") == "Add")
        {
            strSQL += Sql.getInserSQL("A60") + "\r\n";
        }
        else
        {
            Sql.SetWhere("And", "A60I01XA", "=", A60I01XA, false);
            strSQL += Sql.getUpdateSQL("A60") + "\r\n";
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
        string A65I02UV0012 = recordset.Rows[0]["A65I02UV0012"].ToString();
        string A65I01XA = recordset.Rows[0]["A65I01XA"].ToString();
        /* 刪除檢查 */
        recordset.Dispose();
        Sql.ClearQuery();
        SQL = "Select A66I03JJA65I02 from A66 where A66I03JJA65I02='" + A65I02UV0012 + "' and A66I11CV0001 <>'A'";
        recordset = Sql.selectTable(SQL, "Check");
        if (recordset != null)
        {
            context.Response.Write("alert('" + Ms.Msg26 + "')");
            return;
        }
        string strSQL = "";
        Sql.SetWhere("And", "A65I01XA", "=", A65I01XA, false);
        strSQL += Sql.getDelteSQL("A65") + "\r\n";
        string SQL2 = "select A66I02UV0019 from A66 where A66I03JJA65I02='" + A65I02UV0012 + "'";
        DataTable dt = new DataTable();
        Sql.ClearQuery();
        dt = Sql.selectTable(SQL2, "A65d");
        if (dt != null)
        {
            Sql.SetData("A61I05JJA19I02", "");
            Sql.SetData("A61I11CV0001", "");
            Sql.SetData("A61I12JJA12I02", "");
            for (int x = 0; x < dt.Rows.Count; x++)
            {
                Sql.SetWhere("or", "A61I02UV0019", "=", dt.Rows[x]["A66I02UV0019"].ToString(), true);
                Sql.SetWhere("or", "A61I10JJA61I02", "=", dt.Rows[x]["A66I02UV0019"].ToString(), true);                
            }
            strSQL += Sql.getUpdateSQL("A61") + "\r\n";

            Sql.ClearQuery();
            for (int y = 0; y < dt.Rows.Count; y++)
            {
                Sql.SetWhere("or", "A62I02JJA61I02", "=", dt.Rows[y]["A66I02UV0019"].ToString(), true);
            }
            strSQL += Sql.getDelteSQL("A62") + "\r\n";

            Sql.ClearQuery();
            for (int e = 0; e < dt.Rows.Count; e++)
            {
                Sql.SetWhere("or", "A63I02JJA61I02", "=", dt.Rows[e]["A66I02UV0019"].ToString(), true);
            }
            strSQL += Sql.getDelteSQL("A63") + "\r\n";

            Sql.ClearQuery();
            for (int h = 0; h < dt.Rows.Count; h++)
            {
                Sql.SetWhere("or", "A66I10JJA66I02", "=", dt.Rows[h]["A66I02UV0019"].ToString(), true);
            }
            strSQL += Sql.getDelteSQL("A66") + "\r\n";
        }
        Sql.ClearQuery();
        Sql.SetWhere("And", "A66I03JJA65I02", "=", A65I02UV0012, true);
        strSQL += Sql.getDelteSQL("A66") + "\r\n";

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
    public int A70I02 = 1;
    string ParentID = "";
    string A61I05JJA19I02 = "";
    string A69I02UV0010 = "";
    public void OrderDataOperate(HttpContext context)
    {
        Language_Msg Ms = new Language_Msg(); 
        oDate.RecordNow();
        //A61I05JJA19I02 = oValue.Data("A61I05JJA19I02");
        oDate.RecordNow();
        /* A69代碼產生*/
         Sql.ClearQuery();
        A69I02UV0010 = Sql.Top1Query("A69", "A69I02UV0010", true);
        if (A69I02UV0010 == "")
        {
            A69I02UV0010 = "X000000001";
        }
        else
        {
            A69I02UV0010 = Cls_Rule.I02creater(A69I02UV0010, "X", 9);
        }
       
        //A70I02代碼
        recordset = null;
        Sql.ClearQuery();        
        string pStr;
        pStr = Sql.Top1Query("A70", "A70I02UV0010", true);
        if (pStr == "")
        {
            A70I02 = 1;
        }
        else
        {
            A70I02 = Convert.ToInt32(pStr.Substring(1, 9)) + 1;
        }                              
        string pContent = oValue.Data("OrderDataString"); 
        string strSQL = "";
        strSQL += OrderSQL_InsertA69(A69I02UV0010);
        DataSet OrderDataSst = new DataSet ();
        DataTable dt = new DataTable();
                                                 
        if (pContent != "")
        {
            /*在庫餘料檢查*/
            string[] OrderItem = pContent.Split(',');
            for (int i = 0; i < OrderItem.Length; i++) {
                string[] ItemData = OrderItem[i].Split('-');
                string strA31I02 = ItemData[0].Substring(0, 10);
                string strA19I02 = ItemData[0].Substring(10, 4);
                string strA19I02_New = ItemData[0].Substring(14, 4);
                string strNum = ItemData[1];

                if (codeArray.ContainsKey(strA31I02 + strA19I02))
                {
                    codeArray[strA31I02 + strA19I02] += Convert.ToInt32(strNum);
                }
                else {
                    codeArray.Add(strA31I02 + strA19I02, Convert.ToInt32(strNum));
                }
                string pSum = codeArray[strA31I02 + strA19I02].ToString();
                               
            }
            foreach (KeyValuePair<string, int> item in codeArray)
            {
                string cA31I02 = item.Key.Substring(0, 10);
                string cA19I20 = item.Key.Substring(10, 4);
                Sql.ClearQuery();
                SQL = "select top " + item.Value.ToString() + " A66I02UV0019,A66I04JJA31I02,A66I05JJA19I02 from A66 where A66I04JJA31I02='" + cA31I02 + "' and A66I05JJA19I02='" + cA19I20 + "' and A66I11CV0001='A' order by A66INA,A66I02UV0019";
                dt = Sql.selectTable(SQL, item.Key.ToString());
                if (dt == null || dt.Rows.Count < Convert.ToInt32(item.Value))
                {                    
                    context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg23 + "');");
                    return;
                }
                else {
                    OrderDataSst.Tables.Add(dt);
                    OrderDataSst.Tables[item.Key].Columns.Add("A66I05JJA19I02_New");
                    
                }                
                dt = null;
            }
            for (int i = 0; i < OrderItem.Length; i++)
            {
                string[] ItemData = OrderItem[i].Split('-');
                string strA31I02 = ItemData[0].Substring(0, 10);
                string strA19I02 = ItemData[0].Substring(10, 4);
                string strA19I02_New = ItemData[0].Substring(14, 4);
                string strNum = ItemData[1];
                int couter = Convert.ToInt32(strNum);
                for (int x = 0; x < OrderDataSst.Tables[strA31I02 + strA19I02].Rows.Count; x++)
                {
                    if (OrderDataSst.Tables[strA31I02 + strA19I02].Rows[x]["A66I05JJA19I02_New"] == "" || OrderDataSst.Tables[strA31I02 + strA19I02].Rows[x]["A66I05JJA19I02_New"] ==DBNull.Value  )
                    {
                        OrderDataSst.Tables[strA31I02 + strA19I02].Rows[x]["A66I05JJA19I02_New"] = strA19I02_New;                        
                        couter = couter - 1;
                        if (couter == 0) { break; }
                    }
                }
            }                                    
        }else{
            return;
        }
        for (int p = 0; p < OrderDataSst.Tables.Count; p++)
        {
            string A31Nmae = OrderDataSst.Tables[p].TableName.ToString();
            for (int r = 0; r < OrderDataSst.Tables[p].Rows.Count; r++)
            {                
                /* A61b資料填入 */
                strSQL += setDataA61(OrderDataSst.Tables[p].Rows[r]["A66I02UV0019"].ToString(), OrderDataSst.Tables[p].Rows[r]["A66I05JJA19I02_New"].ToString());
                strSQL += setDataA66(OrderDataSst.Tables[p].Rows[r]["A66I02UV0019"].ToString(), OrderDataSst.Tables[p].Rows[r]["A66I05JJA19I02_New"].ToString());
                strSQL += OrderItemAdd(OrderDataSst.Tables[p].Rows[r]["A66I02UV0019"].ToString(), OrderDataSst.Tables[p].Rows[r]["A66I05JJA19I02"].ToString(), OrderDataSst.Tables[p].Rows[r]["A66I05JJA19I02_New"].ToString(), OrderDataSst.Tables[p].Rows[r]["A66I04JJA31I02"].ToString());
                A70I02 += 1;
            }
        }
                
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
    public string setDataA61(string A61I02UV0019, string A61I05JJA19I02)
    {
        string strSQL = "";
        Sql.ClearQuery();
        Sql.SetData("A61I11CV0001", "A");
        Sql.SetData("A61I05JJA19I02", A61I05JJA19I02);       
        Sql.SetWhere("or", "A61I02UV0019", "=", A61I02UV0019, true);
        Sql.SetWhere("or", "A61I10JJA61I02", "=", A61I02UV0019, true);
        strSQL += Sql.getUpdateSQL("A61") + "\r\n";
        return strSQL;
    }
    public string setDataA66(string A66I02UV0019, string A66I05JJA19I02)
    {
        string strSQL = "";
        Sql.ClearQuery();
        Sql.SetData("A66I11CV0001", "A");
        Sql.SetData("A66I05JJA19I02", A66I05JJA19I02);
        Sql.SetWhere("or", "A66I02UV0019", "=", A66I02UV0019, true);
        Sql.SetWhere("or", "A66I10JJA66I02", "=", A66I02UV0019, true);
        strSQL += Sql.getUpdateSQL("A66") + "\r\n";
        return strSQL;
    }

    public string OrderItemAdd(string A70I03CV0019, string A70I05JJA19I02, string A70I06JJA19I02,string A70I08JJA31I02) 
    {
        DataTable dt = new DataTable();
        bool IsChild = false;
        string strSQL = "";
        string A70I02UV0010 = "";

        A70I02UV0010 = A70I02.ToString();
        A70I02UV0010 = "C" + A70I02UV0010.PadLeft(9, '0');                
        Sql.ClearQuery();
        Sql.SetData("A70I02UV0010", A70I02UV0010);
        Sql.SetData("A70I03CV0019", A70I03CV0019);
        Sql.SetData("A70I05JJA19I02", A70I05JJA19I02);
        Sql.SetData("A70I06JJA19I02", A70I06JJA19I02);
        Sql.SetData("A70I07JJA69I02", A69I02UV0010);
        Sql.SetData("A70I08JJA31I02", A70I08JJA31I02);
        Sql.SetData("A70D01", oDate.IND);
        Sql.SetData("A70IND", oDate.IND);
        Sql.SetData("A70INT", oDate.INT);
        Sql.SetData("A70INA", oDate.INA);
        Sql.SetData("A70UPD", oDate.IND);
        Sql.SetData("A70UPT", oDate.INT);
        Sql.SetData("A70UPA", oDate.INA);
        strSQL += Sql.getInserSQL("A70") + "\r\n";        
        return strSQL;
         
    }
    /*  主檔新增 */
    public string OrderSQL_InsertA69(string A69I02UV0010)
    {
        string strSQL = "";
        string A67F01NV0064 = "";
        string A60F02NV0128 = oValue.Data("A60F02NV0128");
        Sql.ClearQuery();
        Sql.SetData("A69I02UV0010", A69I02UV0010);        
        Sql.SetNData("A69F01NV0064", A67F01NV0064);
        Sql.SetNData("A69F02NV0128", A60F02NV0128);
        Sql.SetData("A69IND", oDate.IND);
        Sql.SetData("A69INT", oDate.INT);
        Sql.SetData("A69INA", oDate.INA);
        Sql.SetData("A69UPD", oDate.IND);
        Sql.SetData("A69UPT", oDate.INT);
        Sql.SetData("A69UPA", oDate.INA);
        strSQL += Sql.getInserSQL("A69") + "\r\n";
        return strSQL;
    }
    
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }


}