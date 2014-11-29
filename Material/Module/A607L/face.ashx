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
        oValue.setRequestGet("Del,A71I01XA");
        string A65I01XA = oValue.Data("A65I01XA").ToString();
        if (A65I01XA == "") { oValue.setRequestGet("A65I01XA"); A65I01XA = oValue.Data("A65I01XA"); }
        if (oValue.Data("Action") == "Operrate") { OrderDataOperate(context); return; }
        if (oValue.Data("Action") == "Temp") { WriteTempData(context); return; }
        string A67I06CV0009 = "";
        SQL = "Select A65I01XA,A65I02UV0012,A65I03CV0001,A65F01NV0064,A65F02NV0128 from A65 where A65I01XA='" + oValue.Data("A65I01XA") + "'";
        recordset = Sql.selectTable(SQL, "A65");
        /* 邏輯 */        
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
        //SQL = "select DISTINCT A61I04JJA31I02,A31F01NV0064 from A61 left join A60 on A61I03JJA60I02 = A60I02UV0012 left join A31 on A61I04JJA31I02 = A31I02UV0010   where A60I04CV0001='' and A61I09CV0001 <>'V' and A61I07CV0001='L' ";
        SQL = "Select A31I02UV0010,A31F01NV0064,A31I06CV0001,A31I07CV0001,A31I08CV0001,A31F06NV0032 From A31 where A31I11JJA31I02='' and A31I03CV0001='B'";
        //Sql.sqlTransferColumn = "A31I06CV0001,A31I07CV0001,A31I08CV0001";
        recordset = Sql.selectTable(SQL, "A31");
        string pHtml = "";
        if (recordset != null)
        {
            for (int i = 0; i < recordset.Rows.Count; i++)
            {
                string str = recordset.Rows[i]["A31F01NV0064"].ToString();
                str = str.Replace("_", ""); str = str.Replace("'", ""); str = str.Replace("(", ""); str = str.Replace(")", ""); str = str.Replace(" ", ""); str = str.Replace(".", ""); str = str.Replace("=", "");
                pHtml += "<option class='" + str + "' value='" + recordset.Rows[i]["A31I02UV0010"].ToString() + "'>" +
                   "<span>" + recordset.Rows[i]["A31F01NV0064"].ToString() + "</span>" +
                    //recordset.Rows[i]["A31I06CV0001_NAME"].ToString() +
                    //recordset.Rows[i]["A31I07CV0001_NAME"].ToString() +
                    //recordset.Rows[i]["A31I08CV0001_NAME"].ToString() +"&nbsp;&nbsp;"+                   
                   "</option>";
            }
        }
        oTemplate.SetVariable("option", pHtml);

        Sql.ClearQuery();
        SQL = "select A12I02UV0010,A12F01NV0064 from A12 where A12I04CV0001='B' and A12I03CV0001='B'";
        //Sql.sqlTransferColumn = "A12I03CV0001";
        recordset = Sql.selectTable(SQL, "A12");
        if (recordset != null)
        {
            for (int i = 0; i < recordset.Rows.Count; i++)
            {
                oTemplate.SetVariable_HTML_OPTION("A61I13JJA12I02", recordset.Rows[i][1].ToString(), "", recordset.Rows[i][0].ToString());
                oTemplate.SetVariable_HTML_OPTION("A61I13JJA12I02_New", recordset.Rows[i][1].ToString(), "", recordset.Rows[i][0].ToString());
            }
        }
        oTemplate.SetVariable_HTML_SELECT("A61I13JJA12I02");
        oTemplate.SetVariable_HTML_SELECT("A61I13JJA12I02_New");
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

        
    }
    public void Delete(HttpContext context)
    {
        Language_Msg Ms = new Language_Msg();
        DataTable dt = new DataTable();
        string A71I01XA = oValue.Data("A71I01XA");
        /* 刪除檢查 */        
        Sql.ClearQuery();
        SQL = "Select A71I03CV0001,A71I02UV0010 from A71 where A71I01XA='" + A71I01XA + "'";
        dt = Sql.selectTable(SQL, "Check");
        if (dt != null)
        {
            if (dt.Rows[0]["A71I03CV0001"].ToString() != "")
            {
                context.Response.Write("alert('" + Ms.Msg26 + "')");
                return;
            }
            
        }else{
            return;
        }
        string strSQL = "";
        Sql.SetWhere("And", "A71I01XA", "=", A71I01XA, false);
        strSQL += Sql.getDelteSQL("A71") + "\r\n";

        Sql.ClearQuery();
        Sql.SetWhere("And", "A72I07JJA71I02", "=", dt.Rows[0]["A71I02UV0010"].ToString(), true );
        strSQL += Sql.getDelteSQL("A72") + "\r\n";
        
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
                context.Response.Write("alert('" + Ms.Msg05 + "');");
                break;
            default:
                break;
        }
    }
    public int A72I02 = 1;
    string ParentID = "";
    string A61I05JJA19I02 = "";
    string A71I02UV0010 = "";
    public void WriteTempData(HttpContext context)
    {
        Language_Msg Ms = new Language_Msg(); 
        /* A71代碼產生*/
        Sql.ClearQuery();
        A71I02UV0010 = Sql.Top1Query("A71", "A71I02UV0010", true);
        if (A71I02UV0010 == "")
        {
            A71I02UV0010 = "X000000001";
        }
        else
        {
            A71I02UV0010 = Cls_Rule.I02creater(A71I02UV0010, "X", 9);
        }
        string strSQL = OrderSQL_InsertA71(A71I02UV0010);



        string pContent = oValue.Data("OrderDataString");                
        DataSet OrderDataSst = new DataSet();
        DataTable dt = new DataTable();

        if (pContent != "")
        {
            /*在庫餘料檢查*/
            string[] OrderItem = pContent.Split(',');
            for (int i = 0; i < OrderItem.Length; i++)
            {
                string[] ItemData = OrderItem[i].Split('-');
                string strA31I02 = ItemData[0].Substring(0, 10);
                string strA12I02 = ItemData[0].Substring(10, 10);
                string strA12I02_New = ItemData[0].Substring(20, 10);
                string strNum = ItemData[1];

                if (codeArray.ContainsKey(strA31I02 + strA12I02))
                {
                    codeArray[strA31I02 + strA12I02] += Convert.ToInt32(strNum);
                }
                else
                {
                    codeArray.Add(strA31I02 + strA12I02, Convert.ToInt32(strNum));
                }
                string pSum = codeArray[strA31I02 + strA12I02].ToString();

            }
            foreach (KeyValuePair<string, int> item in codeArray)
            {
                string cA31I02 = item.Key.Substring(0, 10);
                string cA12I20 = item.Key.Substring(10, 10);
                Sql.ClearQuery();
                SQL = "select top " + item.Value.ToString() + " A68I02UV0019,A68I04JJA31I02,A68I13JJA12I02 from A68 where A68I04JJA31I02='" + cA31I02 + "' and A68I13JJA12I02='" + cA12I20 + "' and A68I11CV0001='C' order by A68INA,A68I02UV0019";
                dt = Sql.selectTable(SQL, item.Key.ToString());
                if (dt == null || dt.Rows.Count < Convert.ToInt32(item.Value))
                {
                    context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg23 + "');");
                    return;
                }
                else
                {
                    OrderDataSst.Tables.Add(dt);
                    OrderDataSst.Tables[item.Key].Columns.Add("A68I13JJA12I02_New");

                }
                dt = null;
            }
            for (int i = 0; i < OrderItem.Length; i++)
            {
                string[] ItemData = OrderItem[i].Split('-');
                string strA31I02 = ItemData[0].Substring(0, 10);
                string strA12I02 = ItemData[0].Substring(10, 10);
                string strA12I02_New = ItemData[0].Substring(20, 10);
                string strNum = ItemData[1];
                int couter = Convert.ToInt32(strNum);
                for (int x = 0; x < OrderDataSst.Tables[strA31I02 + strA12I02].Rows.Count; x++)
                {
                    if (OrderDataSst.Tables[strA31I02 + strA12I02].Rows[x]["A68I13JJA12I02_New"] == "" || OrderDataSst.Tables[strA31I02 + strA12I02].Rows[x]["A68I13JJA12I02_New"] == DBNull.Value)
                    {
                        OrderDataSst.Tables[strA31I02 + strA12I02].Rows[x]["A68I13JJA12I02_New"] = strA12I02_New;
                        couter = couter - 1;
                        if (couter == 0) { break; }
                    }
                }
            }
        }
        else
        {
            return;
        }
        for (int p = 0; p < OrderDataSst.Tables.Count; p++)
        {
            string A31Nmae = OrderDataSst.Tables[p].TableName.ToString();
            for (int r = 0; r < OrderDataSst.Tables[p].Rows.Count; r++)
            {
                /* A61b資料填入 */                
                strSQL += OrderItemAdd(OrderDataSst.Tables[p].Rows[r]["A68I02UV0019"].ToString(), OrderDataSst.Tables[p].Rows[r]["A68I13JJA12I02"].ToString(), OrderDataSst.Tables[p].Rows[r]["A68I13JJA12I02_New"].ToString(), OrderDataSst.Tables[p].Rows[r]["A68I04JJA31I02"].ToString(),"");
                A72I02 += 1;
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
    
    
    public void OrderDataOperate(HttpContext context)
    {
        Language_Msg Ms = new Language_Msg(); 
        oDate.RecordNow();
        //A61I05JJA19I02 = oValue.Data("A61I05JJA19I02");
        oDate.RecordNow();
        /* A71代碼產生*/
         Sql.ClearQuery();
        A71I02UV0010 = Sql.Top1Query("A71", "A71I02UV0010", true);
        if (A71I02UV0010 == "")
        {
            A71I02UV0010 = "X000000001";
        }
        else
        {
            A71I02UV0010 = Cls_Rule.I02creater(A71I02UV0010, "X", 9);
        }
       
        //A72I02代碼
        recordset = null;
        Sql.ClearQuery();        
        string pStr;
        pStr = Sql.Top1Query("A72", "A72I02UV0010", true);
        if (pStr == "")
        {
            A72I02 = 1;
        }
        else
        {
            A72I02 = Convert.ToInt32(pStr.Substring(1, 9)) + 1;
        }                              
        string pContent = oValue.Data("OrderDataString"); 
        string strSQL = "";
        strSQL += OrderSQL_InsertA71(A71I02UV0010);
        DataSet OrderDataSst = new DataSet ();
        DataTable dt = new DataTable();
                                                 
        if (pContent != "")
        {
            /*在庫餘料檢查*/
            string[] OrderItem = pContent.Split(',');
            for (int i = 0; i < OrderItem.Length; i++) {
                string[] ItemData = OrderItem[i].Split('-');
                string strA31I02 = ItemData[0].Substring(0, 10);
                string strA12I02 = ItemData[0].Substring(10, 10);
                string strA12I02_New = ItemData[0].Substring(20, 10);
                string strNum = ItemData[1];

                if (codeArray.ContainsKey(strA31I02 + strA12I02))
                {
                    codeArray[strA31I02 + strA12I02] += Convert.ToInt32(strNum);
                }
                else {
                    codeArray.Add(strA31I02 + strA12I02, Convert.ToInt32(strNum));
                }
                string pSum = codeArray[strA31I02 + strA12I02].ToString();
                               
            }
            foreach (KeyValuePair<string, int> item in codeArray)
            {
                string cA31I02 = item.Key.Substring(0, 10);
                string cA12I20 = item.Key.Substring(10, 10);
                Sql.ClearQuery();
                SQL = "select top " + item.Value.ToString() + " A68I02UV0019,A68I04JJA31I02,A68I13JJA12I02 from A68 where A68I04JJA31I02='" + cA31I02 + "' and A68I13JJA12I02='" + cA12I20 + "' and A68I11CV0001='C' order by A68INA,A68I02UV0019";
                dt = Sql.selectTable(SQL, item.Key.ToString());
                if (dt == null || dt.Rows.Count < Convert.ToInt32(item.Value))
                {                    
                    context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg23 + "');");
                    return;
                }
                else {
                    OrderDataSst.Tables.Add(dt);
                    OrderDataSst.Tables[item.Key].Columns.Add("A68I13JJA12I02_New");
                    
                }                
                dt = null;
            }
            for (int i = 0; i < OrderItem.Length; i++)
            {
                string[] ItemData = OrderItem[i].Split('-');
                string strA31I02 = ItemData[0].Substring(0, 10);
                string strA12I02 = ItemData[0].Substring(10, 10);
                string strA12I02_New = ItemData[0].Substring(20, 10);
                string strNum = ItemData[1];
                int couter = Convert.ToInt32(strNum);
                for (int x = 0; x < OrderDataSst.Tables[strA31I02 + strA12I02].Rows.Count; x++)
                {
                    if (OrderDataSst.Tables[strA31I02 + strA12I02].Rows[x]["A68I13JJA12I02_New"] == "" || OrderDataSst.Tables[strA31I02 + strA12I02].Rows[x]["A68I13JJA12I02_New"] == DBNull.Value)
                    {
                        OrderDataSst.Tables[strA31I02 + strA12I02].Rows[x]["A68I13JJA12I02_New"] = strA12I02_New;
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
                strSQL += setDataA61(OrderDataSst.Tables[p].Rows[r]["A68I02UV0019"].ToString(), OrderDataSst.Tables[p].Rows[r]["A68I13JJA12I02_New"].ToString());
                strSQL += setDataA66(OrderDataSst.Tables[p].Rows[r]["A68I02UV0019"].ToString(), OrderDataSst.Tables[p].Rows[r]["A68I13JJA12I02_New"].ToString());
                strSQL += setDataA68(OrderDataSst.Tables[p].Rows[r]["A68I02UV0019"].ToString(), OrderDataSst.Tables[p].Rows[r]["A68I13JJA12I02_New"].ToString());
                strSQL += OrderItemAdd(OrderDataSst.Tables[p].Rows[r]["A68I02UV0019"].ToString(), OrderDataSst.Tables[p].Rows[r]["A68I13JJA12I02"].ToString(), OrderDataSst.Tables[p].Rows[r]["A68I13JJA12I02_New"].ToString(), OrderDataSst.Tables[p].Rows[r]["A68I04JJA31I02"].ToString(),"V");
                A72I02 += 1;
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
    public string setDataA61(string A61I02UV0019, string A61I13JJA12I02)
    {
        string strSQL = "";
        Sql.ClearQuery();
        //Sql.SetData("A61I11CV0001", "B");
        Sql.SetData("A61I13JJA12I02", A61I13JJA12I02);       
        Sql.SetWhere("or", "A61I02UV0019", "=", A61I02UV0019, true);
        Sql.SetWhere("or", "A61I10JJA61I02", "=", A61I02UV0019, true);
        strSQL += Sql.getUpdateSQL("A61") + "\r\n";
        return strSQL;
    }
    public string setDataA68(string A68I02UV0019, string A68I13JJA12I02)
    {
        string strSQL = "";
        Sql.ClearQuery();
        //Sql.SetData("A68I11CV0001", "B");
        Sql.SetData("A68I13JJA12I02", A68I13JJA12I02);
        Sql.SetWhere("or", "A68I02UV0019", "=", A68I02UV0019, true);
        Sql.SetWhere("or", "A68I10JJA68I02", "=", A68I02UV0019, true);
        strSQL += Sql.getUpdateSQL("A68") + "\r\n";
        return strSQL;
    }
    public string setDataA66(string A66I02UV0019, string A66I13JJA12I02)
    {
        string strSQL = "";
        Sql.ClearQuery();
        //Sql.SetData("A66I11CV0001", "B");
        Sql.SetData("A66I13JJA12I02", A66I13JJA12I02);
        Sql.SetWhere("or", "A66I02UV0019", "=", A66I02UV0019, true);
        Sql.SetWhere("or", "A66I10JJA66I02", "=", A66I02UV0019, true);
        strSQL += Sql.getUpdateSQL("A66") + "\r\n";
        return strSQL;
    }

    public string OrderItemAdd(string A72I03CV0019, string A72I05JJA12I02, string A72I06JJA12I02, string A72I08JJA31I02, string A72I04CV0001) 
    {
        DataTable dt = new DataTable();
        bool IsChild = false;
        string strSQL = "";
        string A72I02UV0010 = "";

        A72I02UV0010 = A72I02.ToString();
        A72I02UV0010 = "C" + A72I02UV0010.PadLeft(9, '0');                
        Sql.ClearQuery();
        Sql.SetData("A72I02UV0010", A72I02UV0010);
        Sql.SetData("A72I03CV0019", A72I03CV0019);
        Sql.SetData("A72I04CV0001", A72I04CV0001);
        Sql.SetData("A72I05JJA12I02", A72I05JJA12I02);
        Sql.SetData("A72I06JJA12I02", A72I06JJA12I02);
        Sql.SetData("A72I07JJA71I02", A71I02UV0010);
        Sql.SetData("A72I08JJA31I02", A72I08JJA31I02);
        Sql.SetData("A72D01", oDate.IND);
        Sql.SetData("A72IND", oDate.IND);
        Sql.SetData("A72INT", oDate.INT);
        Sql.SetData("A72INA", oDate.INA);
        Sql.SetData("A72UPD", oDate.IND);
        Sql.SetData("A72UPT", oDate.INT);
        Sql.SetData("A72UPA", oDate.INA);
        strSQL += Sql.getInserSQL("A72") + "\r\n";        
        return strSQL;
         
    }
    /*  主檔新增 */
    public string OrderSQL_InsertA71(string A71I02UV0010)
    {
        oDate.RecordNow();
        string strSQL = "";
        string A67F01NV0064 = "";
        string A60F02NV0128 = oValue.Data("A60F02NV0128");
        Sql.ClearQuery();
        Sql.SetData("A71I02UV0010", A71I02UV0010);        
        Sql.SetNData("A71F01NV0064", A67F01NV0064);
        Sql.SetNData("A71F02NV0128", A60F02NV0128);
        Sql.SetNData("A71F03NT", oValue.Data("OrderDataString"));                
        Sql.SetData("A71IND", oDate.IND);
        Sql.SetData("A71INT", oDate.INT);
        Sql.SetData("A71INA", oDate.INA);
        Sql.SetData("A71UPD", oDate.IND);
        Sql.SetData("A71UPT", oDate.INT);
        Sql.SetData("A71UPA", oDate.INA);
        strSQL += Sql.getInserSQL("A71") + "\r\n";
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