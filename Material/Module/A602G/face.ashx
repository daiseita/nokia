﻿<%@ WebHandler Language="C#" Class="A60_face" %>

using System;
using System.Web;
using System.Data;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;
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
    Dictionary<string, string> SerialArray = new Dictionary<string, string>();
    string SQL;
    PageBase pb = new PageBase();
    string tClientIP = PageBase.strIP;
    string TableName = "A60";
    string Sort = "G";
    public void ProcessRequest(HttpContext context)
    {
        Language_TF TF = new Language_TF();
        oValue.setRequestPost("Action,OrderDataString,SerialDataString,A65I01XA,A65F02NV0128,A61I05JJA19I02,A60F02NV0128,A63F08CV0064,A63F09CV0128,A63I10CV0032,A63I11CV0032,A63I13CV0032,A63I14CV0032,A63I15CV0032,A63I16CV0032,A66D01");
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
                string columnString = "A60I01XA,A60I02UV0012,A60I03CV0001,A60F01NV0064,A60F02NV0128,A63F08CV0064,A63F09CV0128,A63I10CV0032,A63I11CV0032,A63I13CV0032,A63I14CV0032,A63I15CV0032,A63I16CV0032,A66D01";
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
        SQL = "Select A31I02UV0010,A31F01NV0064,A31I06CV0001,A31I07CV0001,A31I08CV0001,A31F06NV0032 From A31 where A31I11JJA31I02='' and A31I03CV0001='B'";
        //SQL = "select DISTINCT A61I04JJA31I02,A31F01NV0064 from A61 left join A60 on A61I03JJA60I02 = A60I02UV0012 left join A31 on A61I04JJA31I02 = A31I02UV0010   where A60I04CV0001='' and A61I09CV0001 <>'V' and A61I07CV0001='L' ";
        //Sql.sqlTransferColumn = "A31I06CV0001,A31I07CV0001,A31I08CV0001";
        recordset = Sql.selectTable(SQL, "A31");
        string pHtml = "";
        if (recordset != null)
        {
            for (int i = 0; i < recordset.Rows.Count; i++)
            {
                string str = recordset.Rows[i]["A31F06NV0032"].ToString();
                str = str.Replace("_", ""); str = str.Replace("'", ""); str = str.Replace("(", ""); str = str.Replace(")", ""); str = str.Replace(" ", ""); str = str.Replace(".", ""); str = str.Replace("=", "");
                pHtml += "<option class='" + str + "' value='" + recordset.Rows[i]["A31I02UV0010"].ToString() + "'>" +
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
            }
        }
        oTemplate.SetVariable_HTML_SELECT("A61I05JJA19I02");
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
            Sql.SetData("A62D01", "");
            Sql.SetData("A62T01", "");
            Sql.SetData("A62A01", "");
            for (int y = 0; y < dt.Rows.Count; y++)
            {
                Sql.SetWhere("or", "A62I02JJA61I02", "=", dt.Rows[y]["A66I02UV0019"].ToString(), true);
            }
            strSQL += Sql.getUpdateSQL("A62") + "\r\n";
            

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
    int A66I02 = 1;
    string ParentID = "";
    string A61I05JJA19I02 = "";
    public void OrderDataOperate(HttpContext context)
    {
        Language_Msg Ms = new Language_Msg();
        string A65I02UV0012 = "";
        string A61I02UV0019 = "";
        oDate.RecordNow();
        //A61I05JJA19I02 = oValue.Data("A61I05JJA19I02");
        oDate.RecordNow();
        /* A67代碼產生*/
        string str = oDate.IND + Sort ;
        string SQL = "select A65I02UV0012 from A65 where left(A65I02UV0012,9)='" + str + "' order by A65I02UV0012 Desc";
        Sql.ClearQuery();
        recordset = Sql.selectTable(SQL, "A65");
        if (recordset != null)
        {
            string pStr = recordset.Rows[0]["A65I02UV0012"].ToString();
            A65I02UV0012 = ( Convert.ToInt32( pStr.Substring(9, 3))+1).ToString();
            A65I02UV0012 = str + A65I02UV0012.PadLeft(3, Convert.ToChar("0"));
        }
        else {            
            A65I02UV0012 = str + "001";
        }                
        //A61I02代碼
        recordset = null;
        Sql.ClearQuery();
        SQL = "select A66I02UV0019 from A66 where left(A66I02UV0019,12)='" + A65I02UV0012 + "' order by A66I02UV0019 Desc ";
        recordset = Sql.selectTable(SQL, "A66s");
        if (recordset != null)
        {
            string pStr = recordset.Rows[0]["A66I02UV0019"].ToString();
            pStr = pStr.Substring(12, 7);
            A66I02 = Convert.ToInt32(pStr)+1;
        }                        
        string pContent = oValue.Data("OrderDataString");
        string pSerialContent = oValue.Data("SerialDataString");
        
        string strSQL = "";
        strSQL += OrderSQL_InsertA65(A65I02UV0012);
        DataSet OrderDataSst = new DataSet ();
        DataTable dt = new DataTable();
                                                 
        if (pContent != "")
        {
            /*訂單檢查*/
            string[] OrderItem = pContent.Split(',');
            string[] SerailGrop = Regex.Split(pSerialContent, "&&");
            for (int i = 0; i < OrderItem.Length; i++) {
                string[] ItemData = OrderItem[i].Split('@');
                string strA31I02 = ItemData[0].Substring(0, 10);
                string strA19I02 = ItemData[0].Substring(10, 4);
                string strA12I02 = ItemData[0].Substring(14, 10);
                int pLength = ItemData[0].Length;
                string strPack = ItemData[0].Substring(24, (pLength - 24));
                string strNum = ItemData[1];

                if (codeArray.ContainsKey(strA31I02))
                {
                    codeArray[strA31I02] += Convert.ToInt32(strNum);
                }
                else {
                    codeArray.Add(strA31I02, Convert.ToInt32(strNum ));
                }
                string pSum = codeArray[strA31I02].ToString();
               
                //strSQL += OrderItemAdd(ItemData[0], ItemData[1], A65I02UV0012);
            }
            foreach (KeyValuePair<string, int> item in codeArray)
            {
                Sql.ClearQuery();
                SQL = "select top " + item.Value.ToString() + " A61I02UV0019,A61I05JJA19I02,A61I12JJA12I02,A61I20CV0020,A61F01NV0064,A63F08CV0064,A63F09CV0128,A63I10CV0032,A63I11CV0032,A63I12CV0032,A63I13CV0032,A63I14CV0032,A63I15CV0032,A63I16CV0032 from A61 left join A63 on A61I02UV0019=A63I02JJA61I02 where A61I04JJA31I02='" + item.Key.ToString() + "' and A61I11CV0001='' order by A61INA,A61I02UV0019 ";
                dt = Sql.selectTable(SQL, item.Key.ToString());
                if (dt == null || dt.Rows.Count < Convert.ToInt32(item.Value))
                {                    
                    context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg23 + "');");
                    return;
                }
                else {
                    dt.Columns.Add("A66D01", typeof(string));
                    OrderDataSst.Tables.Add(dt);
                }                
                dt = null;
            }
            /* 序號填入 */
            for (int s = 0; s < SerailGrop.Length; s++)
            {
                string strXX = SerailGrop[s];
                string[] SerailLine = Regex.Split(SerailGrop[s], "and");                
                string A63I12CV0032 = SerailLine[4];
                if (!SerialArray.ContainsKey(SerailLine[4]))                
                {
                    SerialArray.Add(SerailLine[4], SerailGrop[s]);
                }
            }                
            for (int i = 0; i < OrderItem.Length; i++)
            {
                string[] ItemData = OrderItem[i].Split('@');
                string strA31I02 = ItemData[0].Substring(0, 10);
                string strA19I02 = ItemData[0].Substring(10, 4);
                string strA12I02 = ItemData[0].Substring(14, 10);
                string strA66D01 = ItemData[4];
                int pLength = ItemData[0].Length;
                string strPack = ItemData[0].Substring(24, (pLength - 24));                
                string strNum = ItemData[1];
                /* 序號資料處理 ---- */
                string A63F08CV0064 = "";
                string A63F09CV0128 = "";
                string A63I10CV0032 = "";
                string A63I11CV0032 = "";
                string A63I12CV0032 = "";
                string A63I13CV0032 = "";
                string A63I14CV0032 = "";
                string A63I15CV0032 = "";
                string A63I16CV0032 = "";
                string serialString = "";
                if (SerialArray.ContainsKey(strPack))           
                {
                    serialString = SerialArray[strPack];
                    string[] SerailLine = Regex.Split(serialString, "and");
                    A63F08CV0064 = SerailLine[0];
                    A63F09CV0128 = SerailLine[1];
                    A63I10CV0032 = SerailLine[2];
                    A63I11CV0032 = SerailLine[3];
                    A63I12CV0032 = SerailLine[4];
                    A63I13CV0032 = SerailLine[5];
                    A63I14CV0032 = SerailLine[6];
                    A63I15CV0032 = SerailLine[7];
                    A63I16CV0032 = SerailLine[8];
                }
                int couter = Convert.ToInt32( strNum);
                for(int x = 0; x < OrderDataSst.Tables[strA31I02].Rows.Count;x++){
                   if(OrderDataSst.Tables[strA31I02].Rows[x]["A61I05JJA19I02"]==""){                                              
                       OrderDataSst.Tables[strA31I02].Rows[x]["A61I05JJA19I02"] = strA19I02;
                       OrderDataSst.Tables[strA31I02].Rows[x]["A61I12JJA12I02"] = strA12I02;
                       OrderDataSst.Tables[strA31I02].Rows[x]["A61I20CV0020"] = strPack;

                       OrderDataSst.Tables[strA31I02].Rows[x]["A63F08CV0064"] = A63F08CV0064;
                       OrderDataSst.Tables[strA31I02].Rows[x]["A63F09CV0128"] = A63F09CV0128;
                       OrderDataSst.Tables[strA31I02].Rows[x]["A63I10CV0032"] = A63I10CV0032;
                       OrderDataSst.Tables[strA31I02].Rows[x]["A63I11CV0032"] = A63I11CV0032;
                       OrderDataSst.Tables[strA31I02].Rows[x]["A63I12CV0032"] = A63I12CV0032;
                       OrderDataSst.Tables[strA31I02].Rows[x]["A63I13CV0032"] = A63I13CV0032;
                       OrderDataSst.Tables[strA31I02].Rows[x]["A63I14CV0032"] = A63I14CV0032;
                       OrderDataSst.Tables[strA31I02].Rows[x]["A63I15CV0032"] = A63I15CV0032;
                       OrderDataSst.Tables[strA31I02].Rows[x]["A63I16CV0032"] = A63I16CV0032;
                       OrderDataSst.Tables[strA31I02].Rows[x]["A66D01"] = strA66D01;
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
                /* A62檢查 && 出貨日期填入*/
                existCheckA62(OrderDataSst.Tables[p].Rows[r]["A61I02UV0019"].ToString());
                existCheckA63(OrderDataSst.Tables[p].Rows[r]["A61I02UV0019"].ToString());
                strSQL += setTimeA62(OrderDataSst.Tables[p].Rows[r]["A61I02UV0019"].ToString(), OrderDataSst.Tables[p].Rows[r]["A66D01"].ToString());
                /* A61b資料填入 */
                strSQL += setDataA61(OrderDataSst.Tables[p].Rows[r]["A61I02UV0019"].ToString(), OrderDataSst.Tables[p].Rows[r]["A61I05JJA19I02"].ToString(), OrderDataSst.Tables[p].Rows[r]["A61I12JJA12I02"].ToString(), OrderDataSst.Tables[p].Rows[r]["A61I20CV0020"].ToString());
                strSQL += OrderItemAdd(A65I02UV0012, OrderDataSst.Tables[p].Rows[r]["A61I02UV0019"].ToString(), OrderDataSst.Tables[p].Rows[r]["A61I05JJA19I02"].ToString(), OrderDataSst.Tables[p].Rows[r]["A61I12JJA12I02"].ToString(), "", OrderDataSst.Tables[p].Rows[r]["A61I20CV0020"].ToString(), OrderDataSst.Tables[p].Rows[r]["A61F01NV0064"].ToString(), OrderDataSst.Tables[p].Rows[r]["A66D01"].ToString());

                strSQL += setDataA63(OrderDataSst.Tables[p].Rows[r]["A61I02UV0019"].ToString(), "", OrderDataSst.Tables[p].Rows[r]["A63F08CV0064"].ToString(), OrderDataSst.Tables[p].Rows[r]["A63F09CV0128"].ToString(), OrderDataSst.Tables[p].Rows[r]["A63I10CV0032"].ToString(), OrderDataSst.Tables[p].Rows[r]["A63I11CV0032"].ToString(), OrderDataSst.Tables[p].Rows[r]["A63I12CV0032"].ToString(), OrderDataSst.Tables[p].Rows[r]["A63I13CV0032"].ToString(), OrderDataSst.Tables[p].Rows[r]["A63I14CV0032"].ToString(), OrderDataSst.Tables[p].Rows[r]["A63I15CV0032"].ToString(), OrderDataSst.Tables[p].Rows[r]["A63I16CV0032"].ToString());
                    
                string ParentID = OrderDataSst.Tables[p].Rows[r]["A61I02UV0019"].ToString();
                string House = OrderDataSst.Tables[p].Rows[r]["A61I05JJA19I02"].ToString();
                string Providor = OrderDataSst.Tables[p].Rows[r]["A61I12JJA12I02"].ToString();
                string PackNum = OrderDataSst.Tables[p].Rows[r]["A61I20CV0020"].ToString();
                SQL = "select A61I02UV0019,A31F01NV0064 from A61 left join  A31 on A61I04JJA31I02=A31I02UV0010 where A61I10JJA61I02='" + ParentID + "'";
                Sql.ClearQuery();
                DataTable ChildDt = new DataTable();
                ChildDt = Sql.selectTable(SQL, "A61ch");
                if (ChildDt != null)
                {
                    for (int i = 0; i < ChildDt.Rows.Count; i++)
                    {
                        strSQL += OrderItemAdd(A65I02UV0012, ChildDt.Rows[i]["A61I02UV0019"].ToString(), House, Providor, ParentID, PackNum, ChildDt.Rows[i]["A31F01NV0064"].ToString(), OrderDataSst.Tables[p].Rows[r]["A66D01"].ToString());
                        existCheckA62(ChildDt.Rows[i]["A61I02UV0019"].ToString());
                        strSQL += setTimeA62(ChildDt.Rows[i]["A61I02UV0019"].ToString(), OrderDataSst.Tables[p].Rows[r]["A66D01"].ToString());
                        existCheckA63(ChildDt.Rows[i]["A61I02UV0019"].ToString());
                        strSQL += setDataA63(ChildDt.Rows[i]["A61I02UV0019"].ToString(), "", OrderDataSst.Tables[p].Rows[r]["A63F08CV0064"].ToString(), OrderDataSst.Tables[p].Rows[r]["A63F09CV0128"].ToString(), OrderDataSst.Tables[p].Rows[r]["A63I10CV0032"].ToString(), OrderDataSst.Tables[p].Rows[r]["A63I11CV0032"].ToString(), OrderDataSst.Tables[p].Rows[r]["A63I12CV0032"].ToString(), OrderDataSst.Tables[p].Rows[r]["A63I13CV0032"].ToString(), OrderDataSst.Tables[p].Rows[r]["A63I14CV0032"].ToString(), OrderDataSst.Tables[p].Rows[r]["A63I15CV0032"].ToString(), OrderDataSst.Tables[p].Rows[r]["A63I16CV0032"].ToString());
                    }
                }
            }
        }
        /* 測試用 */
        //strSQL = "";        
        
        string RtnMsg = Pub_Function.executeSQL(strSQL);
        switch (RtnMsg)
        {
            case "":
                context.Response.Write("alert('" + Ms.Msg13 + "');");
                break;
            case "success":
                context.Response.Write("alert('" + Ms.Msg06 + "');");
                break;
            case "fail":
                context.Response.Write("alert('" + Ms.Msg05 + "');");
                break;
            default:
                break;
        }
    }
    public string setDataA61(string A61I02UV0019, string A61I05JJA19I02, string A61I12JJA12I02, string A61I20CV0020)
    {
        string strSQL = "";
        Sql.ClearQuery();
        Sql.SetData("A61I11CV0001", "A");
        Sql.SetData("A61I05JJA19I02", A61I05JJA19I02);
        Sql.SetData("A61I12JJA12I02", A61I12JJA12I02);
        Sql.SetData("A61I20CV0020", A61I20CV0020);
        Sql.SetWhere("or", "A61I02UV0019", "=", A61I02UV0019, true);
        Sql.SetWhere("or", "A61I10JJA61I02", "=", A61I02UV0019, true);
        strSQL += Sql.getUpdateSQL("A61") + "\r\n";
        return strSQL;
    }
    public string setTimeA62(string A61I02UV0019,string A66D01)
    {
        string strSQL = "";
        Sql.ClearQuery();
        Sql.SetData("A62D01", A66D01);
        Sql.SetData("A62T01", "000000");
        Sql.SetData("A62A01", A66D01+"000000");
        Sql.SetWhere("And", "A62I02JJA61I02", "=", A61I02UV0019, true);
        strSQL += Sql.getUpdateSQL("A62") + "\r\n";
        return strSQL;
    }
    public void existCheckA62(string A61I02UV0019)
    {
        DataTable dt = new DataTable();        
        string strSQL = "";
        string SQL = "select A62I02JJA61I02 from A62 where A62I02JJA61I02='" + A61I02UV0019 + "'";
        Sql.ClearQuery();
        dt = Sql.selectTable(SQL, "A62");
        if (dt == null)
        {
            Sql.SetData("A62I02JJA61I02", A61I02UV0019);
            strSQL += Sql.getInserSQL("A62") + "\r\n";
            string RtnMsg = Pub_Function.executeSQL(strSQL);
        }        
    }
    public void existCheckA63(string A61I02UV0019)
    {
        DataTable dt = new DataTable();
        string strSQL = "";
        string SQL = "select A63I02JJA61I02 from A63 where A63I02JJA61I02='" + A61I02UV0019 + "'";
        Sql.ClearQuery();
        dt = Sql.selectTable(SQL, "A63");
        if (dt == null)
        {
            Sql.SetData("A63I02JJA61I02", A61I02UV0019);
            strSQL += Sql.getInserSQL("A63") + "\r\n";
            string RtnMsg = Pub_Function.executeSQL(strSQL);
        }
    }
    public string setDataA63(string A61I02UV0019, string A63I03CV0032, string A63F08CV0064, string A63F09CV0128, string A63I10CV0032, string A63I11CV0032, string A63I12CV0032, string A63I13CV0032, string A63I14CV0032, string A63I15CV0032, string A63I16CV0032)
    {
        string strSQL = "";
        Sql.ClearQuery();
        Sql.SetData("A63I03CV0032", A63I03CV0032);
        Sql.SetData("A63F08CV0064", A63F08CV0064);
        Sql.SetData("A63F09CV0128", A63F09CV0128);
        Sql.SetData("A63I10CV0032", A63I10CV0032);
        Sql.SetData("A63I11CV0032", A63I11CV0032);
        Sql.SetData("A63I12CV0032", A63I12CV0032);
        Sql.SetData("A63I13CV0032", A63I13CV0032);
        Sql.SetData("A63I14CV0032", A63I14CV0032);
        Sql.SetData("A63I15CV0032", A63I15CV0032);
        Sql.SetData("A63I16CV0032", A63I16CV0032);
        Sql.SetWhere("and", "A63I02JJA61I02", "=", A61I02UV0019, true);
        strSQL += Sql.getUpdateSQL("A63") + "\r\n";
        return strSQL;
    }
    public string OrderItemAdd(string A65I02UV0012, string A66I02UV0019, string A61I05JJA19I02, string A61I12JJA12I02, string A61I10JJA61I02, string A61I20CV0020, string A61F01NV0064,string A66D01) 
    {
        DataTable dt = new DataTable();
        bool IsChild = false;
        string strSQL = "";
        string SQL = "select A61I04JJA31I02,A61I07CV0001,A61I08CV0001 from A61 where A61I02UV0019='" + A66I02UV0019 + "'";
        Sql.ClearQuery();
        dt = Sql.selectTable(SQL, "A31");
        if (dt == null)
        {
            return "error";
        }        
        Sql.ClearQuery();
        Sql.SetData("A66I02UV0019", A66I02UV0019);
        Sql.SetData("A66I03JJA65I02", A65I02UV0012);        
        Sql.SetNData("A66I04JJA31I02", dt.Rows[0]["A61I04JJA31I02"].ToString());
        Sql.SetNData("A66I07CV0001", Sort );
        Sql.SetData("A66I08CV0001", dt.Rows[0]["A61I08CV0001"].ToString());
        Sql.SetData("A66I05JJA19I02", A61I05JJA19I02);
        Sql.SetData("A66I12JJA12I02", A61I12JJA12I02);
        Sql.SetData("A66I10JJA66I02", A61I10JJA61I02);
        Sql.SetData("A66I20CV0020", A61I20CV0020);
        if (A61I10JJA61I02 != "") {
            Sql.SetData("A66I09CV0001", "V");
        }
        Sql.SetData("A66F01NV0064", Pub_Function.setSingleQuotation(A61F01NV0064));
        Sql.SetData("A66I11CV0001", "A");
        Sql.SetData("A66D01", A66D01);        
        Sql.SetData("A66IND", oDate.IND);
        Sql.SetData("A66INT", oDate.INT);
        Sql.SetData("A66INA", oDate.INA);
        Sql.SetData("A66UPD", oDate.IND);
        Sql.SetData("A66UPT", oDate.INT);
        Sql.SetData("A66UPA", oDate.INA);
        strSQL += Sql.getInserSQL("A66") + "\r\n";        
        return strSQL;
                      
        
    }
    /*  主檔新增 */
    public string OrderSQL_InsertA65(string A65I02UV0012)
    {
        string strSQL = "";
        string A65F01NV0064 = "";
        string A60F02NV0128 = oValue.Data("A60F02NV0128");        
        Sql.ClearQuery();
        Sql.SetData("A65I02UV0012", A65I02UV0012);
        Sql.SetData("A65I03CV0001", Sort );
        Sql.SetNData("A65F01NV0064", A65F01NV0064);
        Sql.SetNData("A65F02NV0128", A60F02NV0128);
        Sql.SetData("A65IND", oDate.IND);
        Sql.SetData("A65INT", oDate.INT);
        Sql.SetData("A65INA", oDate.INA);
        Sql.SetData("A65UPD", oDate.IND);
        Sql.SetData("A65UPT", oDate.INT);
        Sql.SetData("A65UPA", oDate.INA);
        strSQL += Sql.getInserSQL("A65") + "\r\n";        
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