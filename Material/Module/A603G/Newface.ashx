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
    Dictionary<string, string> codeArray = new Dictionary<string, string>();
    string SQL;
    PageBase pb = new PageBase();
    string tClientIP = PageBase.strIP;
    string TableName = "A60";
    string Sort = "G";
    public void ProcessRequest(HttpContext context)
    {
        Language_TF TF = new Language_TF();
        oValue.setRequestPost("Action,OrderDataString,A67I01XA,A67F02NV0128,A61I13JJA12I02,A60F02NV0128,A66I13JJA12I02,A66D01,PackNumString");
        oValue.setRequestGet("Del");
        string A67I01XA = oValue.Data("A67I01XA").ToString();
        if (A67I01XA == "") { oValue.setRequestGet("A67I01XA"); A67I01XA = oValue.Data("A67I01XA"); }
        if (oValue.Data("PackNumString") != "") { OrderDataOperate(context); return; }
        string A67I06CV0009 = "";
        SQL = "Select A67I01XA,A67I02UV0012,A67I03CV0001,A67F01NV0064,A67F02NV0128 from A67 where A67I01XA='" + oValue.Data("A67I01XA") + "'";
        recordset = Sql.selectTable(SQL, "A67");
        /* 新增編輯邏輯 */
        if (oValue.Data("Action") == "Add" || oValue.Data("Action") == "Upd") { InsertUpdate(context); return; }
        /* 刪除邏輯 */
        if (oValue.Data("Del") == "Del") { Delete(context); return; }

        oTemplate.SetTemplatesDir(pb.SiteFunctionTemplateName );
        oTemplate.SetTemplateFileCharset("A603G_Newface_content.html", "UTF-8");                                              
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
                string columnString = "A60I01XA,A60I02UV0012,A60I03CV0001,A60F01NV0064,A60F02NV0128,A66I13JJA12I02,A66D01";
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


            oTemplate.SetVariable_HTML_RADIO("WorkType", TF.Msg14, "", "A");
            oTemplate.SetVariable_HTML_RADIO("WorkType", TF.Msg15, "B", "B");
            
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

        

        recordset = null;
        Sql.ClearQuery();
        SQL = " select distinct A60I05CV0032 from A60 where A60I03CV0001 ='G' order by A60I05CV0032 desc";
        //Sql.sqlTransferColumn = "A12I03CV0001";
        recordset = Sql.selectTable(SQL, "A60p");
        if (recordset != null)
        {
            for (int i = 0; i < recordset.Rows.Count; i++)
            {
                oTemplate.SetVariable_HTML_OPTION("PONUM", recordset.Rows[i][0].ToString(), "", recordset.Rows[i][0].ToString());
            }
        }
        oTemplate.SetVariable_HTML_SELECT("PONUM");
        oTemplate.SetVariable_HTML_SELECT("ITEM");
        oTemplate.SetVariable_HTML_SELECT("CASENUM");
        recordset = null;
        Sql.ClearQuery();
        SQL = " select  A12I02UV0010,A12F01NV0064 from A12 where A12I03CV0001 ='B' ";
        //Sql.sqlTransferColumn = "A12I03CV0001";
        recordset = Sql.selectTable(SQL, "A12p");
        if (recordset != null)
        {
            for (int i = 0; i < recordset.Rows.Count; i++)
            {
                oTemplate.SetVariable_HTML_OPTION("A66I13JJA12I02", recordset.Rows[i][1].ToString(), "", recordset.Rows[i][0].ToString());
            }
        }
        oTemplate.SetVariable_HTML_SELECT("A66I13JJA12I02");
        
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
        SQL = "Select A68I03JJA67I02 from A68 where A68I03JJA67I02='" + A67I02UV0012 + "' and ( A68I11CV0001 <>'B' and A68I11CV0001 <>'C' )";
        recordset = Sql.selectTable(SQL, "Check");
        if (recordset != null)
        {
            context.Response.Write("alert('" + Ms.Msg26 + "')");
            return;
        }
        string strSQL = "";
        Sql.SetWhere("And", "A67I01XA", "=", A67I01XA, false);
        strSQL += Sql.getDelteSQL("A67") + "\r\n";
        string SQL2 = "select A68I02UV0019 from A68 where A68I03JJA67I02='" + A67I02UV0012 + "'";
        DataTable dt = new DataTable();
        Sql.ClearQuery();
        dt = Sql.selectTable(SQL2, "A67d");        
        if (dt != null)
        {
            Sql.SetData("A61I13JJA12I02", "");
            Sql.SetData("A61I11CV0001", "");
            for (int x = 0; x < dt.Rows.Count; x++)
            {
                Sql.SetWhere("or", "A61I02UV0019", "=", dt.Rows[x]["A68I02UV0019"].ToString(), true);
                Sql.SetWhere("or", "A61I10JJA61I02", "=", dt.Rows[x]["A68I02UV0019"].ToString(), true);
            }
            strSQL += Sql.getUpdateSQL("A61") + "\r\n";
            Sql.ClearQuery();
            Sql.SetData("A62D02", "");
            Sql.SetData("A62T02", "");
            Sql.SetData("A62A02", "");
            for (int y = 0; y < dt.Rows.Count; y++)
            {
                Sql.SetWhere("or", "A62I02JJA61I02", "=", dt.Rows[y]["A68I02UV0019"].ToString(), true);
            }
            strSQL += Sql.getUpdateSQL("A62") + "\r\n";
            
        }
        Sql.ClearQuery();
        Sql.SetWhere("And", "A68I03JJA67I02", "=", A67I02UV0012, true);
        strSQL += Sql.getDelteSQL("A68") + "\r\n";
        
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
        //A68I02代碼
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
        string pContent = oValue.Data("PackNumString"); 
        string strSQL = "";
        /* 產生出料主檔sql碼 */
        strSQL += OrderSQL_InsertA67(A67I02UV0012);
        DataSet OrderDataSst = new DataSet ();
        DataTable dt = new DataTable();
        if (pContent != "")
        {            
            
            string[] OrderItem = pContent.Split(',');                        
            dt = null;
            for (int i = 0; i < OrderItem.Length; i++)
            {
                string[] ItemData = OrderItem[i].Split('-');
                string strDate = ItemData[1];
                string strContractor = ItemData[0];
                string strPack = ItemData[2];
                
                Sql.ClearQuery();
                SQL = "select  A66I02UV0019,A66I04JJA31I02,A66I05JJA19I02,A66I12JJA12I02,A66I09CV0001,A66I10JJA66I02,A66F01NV0064 from A66 where A66I20CV0020='" + strPack + "' ";
                dt = Sql.selectTable(SQL, "A66" + strPack);
                if (dt != null)
                {
                    for (int r = 0; r < dt.Rows.Count; r++)
                    {

                        /* A62檢查 && 出貨日期填入*/
                        existCheckA62(dt.Rows[r]["A66I02UV0019"].ToString());
                        strSQL += setTimeA62(dt.Rows[r]["A66I02UV0019"].ToString(), strDate);
                        /* A61b資料填入 */
                        strSQL += setDataA61(dt.Rows[r]["A66I02UV0019"].ToString(), dt.Rows[r]["A66I12JJA12I02"].ToString(), strPack);
                        strSQL += OrderItemAdd(A67I02UV0012, dt.Rows[r]["A66I02UV0019"].ToString(), dt.Rows[r]["A66I12JJA12I02"].ToString(), strContractor, strPack, dt.Rows[r]["A66I05JJA19I02"].ToString(), dt.Rows[r]["A66I09CV0001"].ToString(), dt.Rows[r]["A66I10JJA66I02"].ToString(), dt.Rows[r]["A66F01NV0064"].ToString(), strDate);
                        strSQL += setDataA66(dt.Rows[r]["A66I02UV0019"].ToString(), strContractor);
                    }
                }
                dt = null;
            }
                        
        }
        else {
            return;
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
    public string setDataA66(string A66I02UV0019, string A66I13JJA12I02)
    {
        string strSQL = "";
        Sql.ClearQuery();
        Sql.SetData("A66I11CV0001", "B");
        Sql.SetData("A66I13JJA12I02", A66I13JJA12I02);
        Sql.SetWhere("or", "A66I02UV0019", "=", A66I02UV0019, true);
        Sql.SetWhere("or", "A66I10JJA66I02", "=", A66I02UV0019, true);
        strSQL += Sql.getUpdateSQL("A66") + "\r\n";
        return strSQL;
    }
    public string setDataA61(string A61I02UV0019 ,string A61I12JJA12I02,string A61I13JJA12I02)
    {
        string strSQL = "";
        Sql.ClearQuery();
        Sql.SetData("A61I11CV0001", "B");
        Sql.SetData("A61I12JJA12I02", A61I12JJA12I02);
        Sql.SetData("A61I13JJA12I02", A61I13JJA12I02);
        Sql.SetWhere("or", "A61I02UV0019", "=", A61I02UV0019, true);
        Sql.SetWhere("or", "A61I10JJA61I02", "=", A61I02UV0019, true);
        strSQL += Sql.getUpdateSQL("A61") + "\r\n";
        return strSQL;
    }
    public string setTimeA62(string A61I02UV0019,string A68D01)
    {
        string strSQL = "";
        Sql.ClearQuery();
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

    public string OrderItemAdd(string A67I02UV0012, string A68I02UV0019, string A61I12JJA12I02, string A61I13JJA12I02, string A66I20CV0020, string A66I05JJA19I02, string A66I09CV0001, string A66I10JJA66I02, string A66F01NV0064,string A68D01) 
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
        Sql.SetData("A68I05JJA19I02", A66I05JJA19I02);
        Sql.SetNData("A68I04JJA31I02", dt.Rows[0]["A61I04JJA31I02"].ToString());
        Sql.SetNData("A68I07CV0001", dt.Rows[0]["A61I07CV0001"].ToString());
        Sql.SetData("A68I08CV0001", dt.Rows[0]["A61I08CV0001"].ToString());
        Sql.SetData("A68I09CV0001", A66I09CV0001);
        Sql.SetData("A68I12JJA12I02", A61I12JJA12I02);
        Sql.SetData("A68I13JJA12I02", A61I13JJA12I02);
        Sql.SetData("A68I20CV0020", A66I20CV0020);
        Sql.SetData("A68I10JJA68I02", A66I10JJA66I02);
        Sql.SetData("A68F01NV0064", Pub_Function.setSingleQuotation(A66F01NV0064));    
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
   
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }


}