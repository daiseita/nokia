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
    Dictionary<string, string> HouseArray = new Dictionary<string, string>();
    string SQL;
    PageBase pb = new PageBase();
    string tClientIP = PageBase.strIP;
    string TableName = "A60";
    string Sort = "L";
    public void ProcessRequest(HttpContext context)
    {
        Language_TF TF = new Language_TF();
        oValue.setRequestPost("Action,OrderDataString,A67I01XA,A67F02NV0128,A61I13JJA12I02,A60F02NV0128,A68D01");
        oValue.setRequestGet("Del");
        string A67I01XA = oValue.Data("A67I01XA").ToString();
        if (A67I01XA == "") { oValue.setRequestGet("A67I01XA"); A67I01XA = oValue.Data("A67I01XA"); }
        if (oValue.Data("OrderDataString") != "") { OrderDataOperate(context); return; }
        string A67I06CV0009 = "";
        SQL = "Select A67I01XA,A67I02UV0012,A67I03CV0001,A67F01NV0064,A67F02NV0128 from A67 where A67I01XA='" + oValue.Data("A67I01XA") + "'";
        recordset = Sql.selectTable(SQL, "A67");
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
                string columnString = "A60I01XA,A60I02UV0012,A60I03CV0001,A60F01NV0064,A60F02NV0128,A68D01";
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


            oTemplate.SetVariable_HTML_RADIO("WorkType", TF.Msg14, "A", "A");
            oTemplate.SetVariable_HTML_RADIO("WorkType", TF.Msg15, "", "B");
            
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
        SQL = "select A12I02UV0010,A12I03CV0001,A12F01NV0064 from A12 where A12I04CV0001='B' and A12I03CV0001='B'";
        Sql.sqlTransferColumn = "A12I03CV0001";
        recordset = Sql.selectTable(SQL, "A12");
        if (recordset != null)
        {
            for (int i = 0; i < recordset.Rows.Count; i++)
            {
                oTemplate.SetVariable_HTML_OPTION("A61I13JJA12I02", recordset.Rows[i][2].ToString(), "", recordset.Rows[i][0].ToString());
            }
        }
        oTemplate.SetVariable_HTML_SELECT("A61I13JJA12I02");

        recordset = null;
        Sql.ClearQuery();
        SQL = "select A12I02UV0010,A12F01NV0064 from A12 where A12I04CV0001='B' and A12I03CV0001='A'";
        //Sql.sqlTransferColumn = "A12I03CV0001";
        recordset = Sql.selectTable(SQL, "A12");
        if (recordset != null)
        {
            for (int i = 0; i < recordset.Rows.Count; i++)
            {
                oTemplate.SetVariable_HTML_OPTION("A61I12JJA12I02", recordset.Rows[i][1].ToString(), "", recordset.Rows[i][0].ToString());
            }
        }
        oTemplate.SetVariable_HTML_SELECT("A61I12JJA12I02");

        recordset = null;
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
        
        string Rtn = oTemplate.GetOutput();
        context.Response.ContentType = "text/plain";
        context.Response.Write(Rtn);

    }
    public void InsertUpdate(HttpContext context)
    {
        
    }
    public void Delete(HttpContext context)
    {
        Language_Msg Ms = new Language_Msg();
        string A67I02UV0012 = recordset.Rows[0]["A67I02UV0012"].ToString();
        string A67I01XA = recordset.Rows[0]["A67I01XA"].ToString();      
        /* 刪除檢查 */
        recordset.Dispose();
        Sql.ClearQuery();
        SQL = "Select A68I03JJA67I02 from A68 where A68I03JJA67I02='" + A67I02UV0012 + "' and ( A68I11CV0001 <>'B'  )";
        recordset = Sql.selectTable(SQL, "Check");
        if (recordset != null)
        {
            context.Response.Write("alert('" + Ms.Msg26 + "')");
            return;
        }
        string strSQL = "";
        Sql.SetWhere("And", "A67I01XA", "=", A67I01XA, false);
        strSQL += Sql.getDelteSQL("A67") + "\r\n";
        string SQL2 = "select A68I02UV0019,A68I21CV0001 from A68 where A68I03JJA67I02='" + A67I02UV0012 + "'";
        DataTable dt = new DataTable();
        Sql.ClearQuery();
        dt = Sql.selectTable(SQL2, "A67d");        
        if (dt != null)
        {
            string A68I21CV0001 = dt.Rows[0]["A68I21CV0001"].ToString();
            Sql.SetData("A61I13JJA12I02", "");
            Sql.SetData("A61I11CV0001", "");
            Sql.SetData("A61I05JJA19I02", "");
            Sql.SetData("A61I12JJA12I02", "");
            for (int x = 0; x < dt.Rows.Count; x++)
            {
                Sql.SetWhere("or", "A61I02UV0019", "=", dt.Rows[x]["A68I02UV0019"].ToString(), true);
                Sql.SetWhere("or", "A61I10JJA61I02", "=", dt.Rows[x]["A68I02UV0019"].ToString(), true);
            }
            strSQL += Sql.getUpdateSQL("A61") + "\r\n";


            Sql.ClearQuery();
            for (int y = 0; y < dt.Rows.Count; y++)
            {
                Sql.SetWhere("or", "A66I02UV0019", "=", dt.Rows[y]["A68I02UV0019"].ToString(), true);
                Sql.SetWhere("or", "A66I10JJA66I02", "=", dt.Rows[y]["A68I02UV0019"].ToString(), true);
            }
            strSQL += Sql.getDelteSQL("A66") + "\r\n";

            if (A68I21CV0001 == "V")
            {
                Sql.ClearQuery();
                for (int y = 0; y < dt.Rows.Count; y++)
                {
                    Sql.SetWhere("or", "A62I02JJA61I02", "=", dt.Rows[y]["A68I02UV0019"].ToString(), true);
                }
                strSQL += Sql.getDelteSQL("A62") + "\r\n";
            }
            else {
                Sql.ClearQuery();
                Sql.SetData("A62D02", "");
                Sql.SetData("A62T02", "");
                Sql.SetData("A62A02", "");
                for (int x = 0; x < dt.Rows.Count; x++)
                {
                    Sql.SetWhere("and", "A62I02JJA61I02", "=", dt.Rows[x]["A68I02UV0019"].ToString(), true);                    
                }
                strSQL += Sql.getUpdateSQL("A62") + "\r\n";
            }
            Sql.ClearQuery();
            for (int e = 0; e < dt.Rows.Count; e++)
            {
                Sql.SetWhere("or", "A63I02JJA61I02", "=", dt.Rows[e]["A68I02UV0019"].ToString(), true);
            }
            strSQL += Sql.getDelteSQL("A63") + "\r\n";
        }
        Sql.ClearQuery();
        Sql.SetWhere("And", "A68I03JJA67I02", "=", A67I02UV0012, true);
        strSQL += Sql.getDelteSQL("A68") + "\r\n";
        
        DataTable uDt = new DataTable();
        Sql.ClearQuery();
        uDt = Sql.selectTable("select A66I03JJA65I02 from A66 where A66I02UV0019 ='" + dt.Rows[0]["A68I02UV0019"].ToString() + "'", "A67l");
        if (uDt != null)
        {
            Sql.ClearQuery();
            Sql.SetWhere("And", "A65I02UV0012", "=", uDt.Rows[0]["A66I03JJA65I02"].ToString(), true);
            strSQL += Sql.getDelteSQL("A65") + "\r\n";
        }
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
    int A68I02 = 1;
    string ParentID = "";
    string A61I13JJA12I02 = "";
    public void OrderDataOperate(HttpContext context)
    {
        Language_Msg Ms = new Language_Msg();
        string A67I02UV0012 = "";
        string A61I02UV0019 = "";
        string A65I02UV0012 = "";
        oDate.RecordNow();
        //A61I13JJA12I02 = oValue.Data("A61I13JJA12I02");
        oDate.RecordNow();
        /* A67代碼產生*/
        string str = oDate.IND + Sort ;
        string SQL = "select A67I02UV0012 from A67 where left(A67I02UV0012,9)='" + str + "' order by A67I02UV0012 Desc";
        Sql.ClearQuery();
        recordset = Sql.selectTable(SQL, "A67");
        if (recordset != null)
        {
            string pStr = recordset.Rows[0]["A67I02UV0012"].ToString();
            A67I02UV0012 = ( Convert.ToInt32( pStr.Substring(9, 3))+1).ToString();
            A67I02UV0012 = str + A67I02UV0012.PadLeft(3, Convert.ToChar("0"));
        }
        else {            
            A67I02UV0012 = str + "001";
        }
        recordset = null;
        /* A65代碼產生*/
        str = oDate.IND + Sort;
        SQL = "select A65I02UV0012 from A65 where left(A65I02UV0012,9)='" + str + "' order by A65I02UV0012 Desc";
        Sql.ClearQuery();
        recordset = Sql.selectTable(SQL, "A65p");
        if (recordset != null)
        {
            string pStr = recordset.Rows[0]["A65I02UV0012"].ToString();
            A65I02UV0012 = (Convert.ToInt32(pStr.Substring(9, 3)) + 1).ToString();
            A65I02UV0012 = str + A65I02UV0012.PadLeft(3, Convert.ToChar("0"));
        }
        else
        {
            A65I02UV0012 = str + "001";
        }
        /* 供應商對應貨倉 array */
        recordset = null;
        SQL = "select A12I02UV0010,A12I10JJA19I02 from A12 ";
        Sql.ClearQuery();
        recordset = Sql.selectTable(SQL, "A12p");
        if (recordset != null) {
            for (int p = 0; p < recordset.Rows.Count; p++)
            {
                if (!HouseArray.ContainsKey(recordset.Rows[p]["A12I02UV0010"].ToString()))
                {
                    HouseArray.Add(recordset.Rows[p]["A12I02UV0010"].ToString(), recordset.Rows[p]["A12I10JJA19I02"].ToString());
                }
            }        
        }
        
                       
        //A61I02代碼
        recordset = null;
        Sql.ClearQuery();
        SQL = "select A68I02UV0019 from A68 where left(A68I02UV0019,12)='" + A67I02UV0012 + "' order by A68I02UV0019 Desc ";
        recordset = Sql.selectTable(SQL, "A68s");
        if (recordset != null)
        {
            string pStr = recordset.Rows[0]["A68I02UV0019"].ToString();
            pStr = pStr.Substring(12, 7);
            A68I02 = Convert.ToInt32(pStr)+1;
        }                        
        string pContent = oValue.Data("OrderDataString"); 
        string strSQL = "";
        /* 產生出料主檔sql碼 */
        strSQL += OrderSQL_InsertA67(A67I02UV0012);
        strSQL += OrderSQL_InsertA65(A67I02UV0012);
        DataSet OrderDataSst = new DataSet ();
        DataTable dt = new DataTable();
        if (pContent != "")
        {
            /*在庫餘料檢查*/
            string[] OrderItem = pContent.Split(',');
            for (int i = 0; i < OrderItem.Length; i++)
            {
                string[] ItemData = OrderItem[i].Split('-');
                string strA31I02 = ItemData[0].Substring(0, 10);
                string strA12I02C = ItemData[0].Substring(10, 10);
                string strA12I02P = ItemData[0].Substring(20, 10);
                string strA68D01 = ItemData[0].Substring(30, 8);
                string strNum = ItemData[1];

                if (codeArray.ContainsKey(strA31I02))
                {
                    codeArray[strA31I02] += Convert.ToInt32(strNum);
                }
                else
                {
                    codeArray.Add(strA31I02, Convert.ToInt32(strNum));
                }
                string pSum = codeArray[strA31I02].ToString();

                //strSQL += OrderItemAdd(ItemData[0], ItemData[1], A65I02UV0012);
            }
            /* 將供應商&承包商暫存於datatable */
            foreach (KeyValuePair<string, int> item in codeArray)
            {
                Sql.ClearQuery();
                SQL = "select top " + item.Value.ToString() + " A61I02UV0019,A61I12JJA12I02,A61I13JJA12I02,A61I05JJA19I02,A61F01NV0064 from A61  where A61I04JJA31I02='" + item.Key.ToString() + "' and A61I11CV0001='' order by A61INA,A61I02UV0019 ";
                dt = Sql.selectTable(SQL, item.Key.ToString());
                if (dt == null || dt.Rows.Count < Convert.ToInt32(item.Value))
                {
                    context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg23 + "');");
                    return;
                }
                else
                {
                    dt.Columns.Add("A68D01", typeof(string));
                    OrderDataSst.Tables.Add(dt);
                }
                dt = null;
            }
            
            /* 產生出料sql碼 */
            for (int i = 0; i < OrderItem.Length; i++)
            {
                string[] ItemData = OrderItem[i].Split('-');
                string strA31I02 = ItemData[0].Substring(0, 10);
                string strA12I02C = ItemData[0].Substring(10, 10);
                string strA12I02P = ItemData[0].Substring(20, 10);
                string strA68D01 = ItemData[0].Substring(30, 8);
                string strNum = ItemData[1];
                int couter = Convert.ToInt32(strNum);
                for (int x = 0; x < OrderDataSst.Tables[strA31I02].Rows.Count; x++)
                {
                    if (OrderDataSst.Tables[strA31I02].Rows[x]["A61I13JJA12I02"] == "")
                    {
                        OrderDataSst.Tables[strA31I02].Rows[x]["A61I12JJA12I02"] = strA12I02P;
                        OrderDataSst.Tables[strA31I02].Rows[x]["A61I13JJA12I02"] = strA12I02C;
                        OrderDataSst.Tables[strA31I02].Rows[x]["A68D01"] = strA68D01;
                        if (HouseArray.ContainsKey(strA12I02P))
                        {
                            OrderDataSst.Tables[strA31I02].Rows[x]["A61I05JJA19I02"] = HouseArray[strA12I02P];
                        }
                        else {
                            OrderDataSst.Tables[strA31I02].Rows[x]["A61I05JJA19I02"] = "";
                        }
                        couter = couter - 1;
                        if (couter == 0) { break; }
                    }
                }
            }            
        }
        else {
            return;
        }

        for (int p = 0; p < OrderDataSst.Tables.Count; p++)
        {
            string A31Nmae = OrderDataSst.Tables[p].TableName.ToString();
            for (int r = 0; r < OrderDataSst.Tables[p].Rows.Count; r++)
            {
                /* A62檢查 */
                existCheckA62(OrderDataSst.Tables[p].Rows[r]["A61I02UV0019"].ToString());


                strSQL += OrderItemAdd(A67I02UV0012, OrderDataSst.Tables[p].Rows[r]["A61I02UV0019"].ToString(), OrderDataSst.Tables[p].Rows[r]["A61I05JJA19I02"].ToString(), OrderDataSst.Tables[p].Rows[r]["A61I12JJA12I02"].ToString(), OrderDataSst.Tables[p].Rows[r]["A61I13JJA12I02"].ToString(), "", OrderDataSst.Tables[p].Rows[r]["A61F01NV0064"].ToString(), OrderDataSst.Tables[p].Rows[r]["A68D01"].ToString());
                strSQL += OrderItemA66(A67I02UV0012, OrderDataSst.Tables[p].Rows[r]["A61I02UV0019"].ToString(), OrderDataSst.Tables[p].Rows[r]["A61I05JJA19I02"].ToString(), OrderDataSst.Tables[p].Rows[r]["A61I12JJA12I02"].ToString(), OrderDataSst.Tables[p].Rows[r]["A61I13JJA12I02"].ToString(), "", OrderDataSst.Tables[p].Rows[r]["A61F01NV0064"].ToString(), OrderDataSst.Tables[p].Rows[r]["A68D01"].ToString());
                string ParentID = OrderDataSst.Tables[p].Rows[r]["A61I02UV0019"].ToString();
                string Providor = OrderDataSst.Tables[p].Rows[r]["A61I12JJA12I02"].ToString();
                string Contractor = OrderDataSst.Tables[p].Rows[r]["A61I13JJA12I02"].ToString();                
                SQL = "select A61I02UV0019,A31F01NV0064 from A61 left join  A31 on A61I04JJA31I02=A31I02UV0010 where A61I10JJA61I02='" + ParentID + "'";
                Sql.ClearQuery();
                DataTable ChildDt = new DataTable();
                ChildDt = Sql.selectTable(SQL, "A61ch");
                if (ChildDt != null)
                {
                    for (int i = 0; i < ChildDt.Rows.Count; i++)
                    {
                        strSQL += OrderItemAdd(A67I02UV0012, ChildDt.Rows[i]["A61I02UV0019"].ToString(), OrderDataSst.Tables[p].Rows[r]["A61I05JJA19I02"].ToString(), Providor, Contractor, ParentID, ChildDt.Rows[i]["A31F01NV0064"].ToString(), ChildDt.Rows[i]["A68D01"].ToString());
                        strSQL += OrderItemA66(A67I02UV0012, ChildDt.Rows[i]["A61I02UV0019"].ToString(), OrderDataSst.Tables[p].Rows[r]["A61I05JJA19I02"].ToString(), Providor, Contractor, ParentID, ChildDt.Rows[i]["A31F01NV0064"].ToString(), ChildDt.Rows[i]["A68D01"].ToString());
                        existCheckA62(ChildDt.Rows[i]["A61I02UV0019"].ToString());
                        strSQL += setTimeA62(ChildDt.Rows[i]["A61I02UV0019"].ToString(), OrderDataSst.Tables[p].Rows[r]["A68D01"].ToString());
                    }
                }
                /* A61b資料填入&& 出貨日期填入 */
                strSQL += setDataA61(OrderDataSst.Tables[p].Rows[r]["A61I02UV0019"].ToString(), OrderDataSst.Tables[p].Rows[r]["A61I12JJA12I02"].ToString(), OrderDataSst.Tables[p].Rows[r]["A61I13JJA12I02"].ToString(), OrderDataSst.Tables[p].Rows[r]["A61I05JJA19I02"].ToString());
                strSQL += setTimeA62(OrderDataSst.Tables[p].Rows[r]["A61I02UV0019"].ToString(), OrderDataSst.Tables[p].Rows[r]["A68D01"].ToString());
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
    public string setDataA61(string A61I02UV0019, string A61I12JJA12I02, string A61I13JJA12I02, string A61I05JJA19I02)
    {
        string strSQL = "";
        Sql.ClearQuery();
        Sql.SetData("A61I11CV0001", "B");
        Sql.SetData("A61I05JJA19I02", A61I05JJA19I02);
        Sql.SetData("A61I12JJA12I02", A61I12JJA12I02);
        Sql.SetData("A61I13JJA12I02", A61I13JJA12I02);
        Sql.SetWhere("or", "A61I02UV0019", "=", A61I02UV0019, true);
        Sql.SetWhere("or", "A61I10JJA61I02", "=", A61I02UV0019, true);
        strSQL += Sql.getUpdateSQL("A61") + "\r\n";
        return strSQL;
    }
    public string setTimeA62(string A61I02UV0019, string A68D01)
    {
        string strSQL = "";
        Sql.ClearQuery();
        Sql.SetData("A62D01", A68D01);
        Sql.SetData("A62T01", "000000");
        Sql.SetData("A62A01", A68D01 + "000000");
        Sql.SetData("A62D02", A68D01);
        Sql.SetData("A62T02", "000000");
        Sql.SetData("A62A02", A68D01+"000000");
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

    public string OrderItemAdd(string A67I02UV0012, string A68I02UV0019, string A61I05JJA19I02, string A61I12JJA12I02, string A61I13JJA12I02, string A61I10JJA61I02, string A61F01NV0064, string A68D01) 
    {
        DataTable dt = new DataTable();
        bool IsChild = false;
        string strSQL = "";
        string SQL = "select A61I04JJA31I02,A61I07CV0001,A61I08CV0001 from A61 where A61I02UV0019='" + A68I02UV0019 + "'";
        Sql.ClearQuery();
        dt = Sql.selectTable(SQL, "A31");
        if (dt == null)
        {
            return "error";
        }        
        Sql.ClearQuery();
        Sql.SetData("A68I02UV0019", A68I02UV0019);
        Sql.SetData("A68I03JJA67I02", A67I02UV0012);
        Sql.SetData("A68I05JJA19I02", A61I05JJA19I02);
        Sql.SetNData("A68I04JJA31I02", dt.Rows[0]["A61I04JJA31I02"].ToString());
        Sql.SetNData("A68I07CV0001", dt.Rows[0]["A61I07CV0001"].ToString());
        Sql.SetData("A68I08CV0001", dt.Rows[0]["A61I08CV0001"].ToString());
        Sql.SetData("A68I12JJA12I02", A61I12JJA12I02);
        Sql.SetData("A68I13JJA12I02", A61I13JJA12I02);

        Sql.SetData("A68I10JJA68I02", A61I10JJA61I02);
        if (A61I10JJA61I02 != "") {
            Sql.SetData("A68I09CV0001", "V");
        }
        Sql.SetData("A68F01NV0064", Pub_Function.setSingleQuotation(A61F01NV0064));
        Sql.SetData("A68I21CV0001", "V");
        Sql.SetData("A68I11CV0001", "B");
        Sql.SetData("A68D01", A68D01);
        Sql.SetData("A68IND", oDate.IND);
        Sql.SetData("A68INT", oDate.INT);
        Sql.SetData("A68INA", oDate.INA);
        Sql.SetData("A68UPD", oDate.IND);
        Sql.SetData("A68UPT", oDate.INT);
        Sql.SetData("A68UPA", oDate.INA);
        strSQL += Sql.getInserSQL("A68") + "\r\n";        
        return strSQL;
                      
        
    }
    /*  主檔新增 */
    public string OrderSQL_InsertA67(string A67I02UV0012)
    {
        string strSQL = "";
        string A67F01NV0064 = "";
        string A60F02NV0128 = oValue.Data("A60F02NV0128");        
        Sql.ClearQuery();
        Sql.SetData("A67I02UV0012", A67I02UV0012);
        Sql.SetData("A67I03CV0001", Sort );
        Sql.SetNData("A67F01NV0064", A67F01NV0064);
        Sql.SetNData("A67F02NV0128", A60F02NV0128);
        Sql.SetData("A67IND", oDate.IND);
        Sql.SetData("A67INT", oDate.INT);
        Sql.SetData("A67INA", oDate.INA);
        Sql.SetData("A67UPD", oDate.IND);
        Sql.SetData("A67UPT", oDate.INT);
        Sql.SetData("A67UPA", oDate.INA);
        strSQL += Sql.getInserSQL("A67") + "\r\n";        
        return strSQL;
    }

    /*  主檔新增 */
    public string OrderSQL_InsertA65(string A65I02UV0012)
    {
        string strSQL = "";
        string A65F01NV0064 = "";
        string A60F02NV0128 = "";
        Sql.ClearQuery();
        Sql.SetData("A65I02UV0012", A65I02UV0012);
        Sql.SetData("A65I03CV0001", Sort);
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
    /*  A66                    string A67I02UV0012, string A68I02UV0019,s tring A61I05JJA19I02, string A61I12JJA12I02, string A61I13JJA12I02, string A61I10JJA61I02, string A61F01NV0064*/
    public string OrderItemA66(string A65I02UV0012, string A66I02UV0019, string A61I05JJA19I02, string A61I12JJA12I02, string A61I13JJA12I02, string A61I10JJA61I02, string A61F01NV0064, string A68D01)
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
        Sql.SetNData("A66I07CV0001", Sort);
        Sql.SetData("A66I08CV0001", dt.Rows[0]["A61I08CV0001"].ToString());
        Sql.SetData("A66I05JJA19I02", A61I05JJA19I02);
        Sql.SetData("A66I12JJA12I02", A61I12JJA12I02);
        Sql.SetData("A66I13JJA12I02", A61I13JJA12I02);
        Sql.SetData("A66I10JJA66I02", A61I10JJA61I02);
        if (A61I10JJA61I02 != "")
        {
            Sql.SetData("A66I09CV0001", "V");
        }
        Sql.SetData("A66F01NV0064", Pub_Function.setSingleQuotation(A61F01NV0064));
        Sql.SetData("A66I11CV0001", "B");
        Sql.SetData("A66D01", A68D01);
        Sql.SetData("A66IND", oDate.IND);
        Sql.SetData("A66INT", oDate.INT);
        Sql.SetData("A66INA", oDate.INA);
        Sql.SetData("A66UPD", oDate.IND);
        Sql.SetData("A66UPT", oDate.INT);
        Sql.SetData("A66UPA", oDate.INA);
        strSQL += Sql.getInserSQL("A66") + "\r\n";
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