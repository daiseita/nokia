<%@ WebHandler Language="C#" Class="A60_face" %>

using System;
using System.Web;
using System.Data;
public class A60_face : IHttpHandler {
   
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
    string TableName = "A60";
    string Sort = "L";
    public void ProcessRequest(HttpContext context)
    {
        Language_TF TF = new Language_TF();
        oValue.setRequestPost("Action,OrderDataString,A60I01XA,A60F02NV0128");
        oValue.setRequestGet("Del");
        string A60I01XA = oValue.Data("A60I01XA").ToString();
        if (A60I01XA == "") { oValue.setRequestGet("A60I01XA"); A60I01XA = oValue.Data("A60I01XA"); }
        if (oValue.Data("OrderDataString") != "") { OrderDataOperate(context); return; }
        string A60I06CV0009 = "";
        SQL = "Select A60I01XA,A60I02UV0012,A60I03CV0001,A60F01NV0064,A60F02NV0128 from A60 where A60I01XA='" + oValue.Data("A60I01XA") + "'";
        recordset = Sql.selectTable(SQL, "A60");
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
            foreach (DataColumn columename in DataSet1.Tables["A60"].Columns)
            {
                string pRName = columename.ToString();
                string pRValue = DataSet1.Tables["A60"].Rows[0][columename].ToString();
                oTemplate.SetVariable_HTML(pRName, pRValue, saFiled.GetColumeLength(pRName));
            }
            oTemplate.SetVariable_HTML_RADIO("A60I03CV0001", TF.Msg01, DataSet1.Tables["A60"].Rows[0]["A60I03CV0001"].ToString(), "B");
            oTemplate.SetVariable_HTML_RADIO("A60I03CV0001", TF.Msg02, DataSet1.Tables["A60"].Rows[0]["A60I03CV0001"].ToString(), "S");

            //A60I06CV0009 = recordset.Rows[0]["A60I06CV0009"].ToString();
            oTemplate.SetVariable("Action", "Upd");

            recordset.Dispose();
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
            oTemplate.SetVariable_HTML_RADIO("A60I03CV0001", TF.Msg01, "B", "B");
            oTemplate.SetVariable_HTML_RADIO("A60I03CV0001", TF.Msg02, "", "S");
            oTemplate.SetVariable("Action", "Add");
        }

        /* 下拉式選單 */

        Sql.ClearQuery();
        SQL = "Select A31I02UV0010,A31F01NV0064,A31I06CV0001,A31I07CV0001,A31I08CV0001,A31F06NV0032 From A31 where A31I11JJA31I02='' and A31I03CV0001='B'";
        Sql.sqlTransferColumn = "A31I06CV0001,A31I07CV0001,A31I08CV0001";
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
        string A60I02UV0012 = recordset.Rows[0]["A60I02UV0012"].ToString();
        string A60I01XA = recordset.Rows[0]["A60I01XA"].ToString();
        /* 刪除檢查 */
        recordset.Dispose();
        Sql.ClearQuery();
        SQL = "Select A61I03JJA60I02 from A61 where A61I03JJA60I02='" + A60I02UV0012 + "' and A61I11CV0001 <>''";
        recordset = Sql.selectTable(SQL, "Check");
        if (recordset != null)
        {
            context.Response.Write("alert('" + Ms.Msg22 + "')");
            return;
        }
        string strSQL = "";
        Sql.SetWhere("And", "A60I01XA", "=", A60I01XA, false);
        strSQL += Sql.getDelteSQL("A60") + "\r\n";
        Sql.ClearQuery();
        Sql.SetWhere("And", "A61I03JJA60I02", "=", A60I02UV0012, true);
        strSQL += Sql.getDelteSQL("A61") + "\r\n";
        
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
    int A61I02 = 1;
    string ParentID = "";
    public void OrderDataOperate(HttpContext context)
    {
        Language_Msg Ms = new Language_Msg();
        string A60I02UV0012 = "";
        string A61I02UV0019 = "";
       
        oDate.RecordNow();
        /* A60代碼產生*/
        string str = oDate.IND + Sort ;
        string SQL = "select A60I02UV0012 from A60 where left(A60I02UV0012,9)='" + str + "' order by A60I02UV0012 Desc";
        Sql.ClearQuery();
        recordset = Sql.selectTable(SQL, "A60");
        if (recordset != null)
        {
            string pStr = recordset.Rows[0]["A60I02UV0012"].ToString();
            A60I02UV0012 = ( Convert.ToInt32( pStr.Substring(9, 3))+1).ToString();
            A60I02UV0012 = str + A60I02UV0012.PadLeft(3, Convert.ToChar("0"));
        }
        else {            
            A60I02UV0012 = str + "001";
        }                
        //A61I02代碼
        recordset = null;
        Sql.ClearQuery();
        SQL = "select A61I02UV0019 from A61 where left(A61I02UV0019,12)='" + A60I02UV0012 + "' order by A61I02UV0019 Desc ";
        recordset = Sql.selectTable(SQL, "A61s");
        if (recordset != null)
        {
            string pStr = recordset.Rows[0]["A61I02UV0019"].ToString();
            pStr = pStr.Substring(12, 7);
            A61I02 = Convert.ToInt32(pStr)+1;
        }                        
        string pContent = oValue.Data("OrderDataString"); 
        string strSQL = "";
        strSQL  += OrderSQL_InsertA60(A60I02UV0012);
        if (pContent != "")
        {
            string[] OrderItem = pContent.Split(',');
            for (int i = 0; i < OrderItem.Length; i++) {
                string[] ItemData = OrderItem[i].Split('-');
                strSQL += OrderItemAdd(ItemData[0], ItemData[1], A60I02UV0012);
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
    string A61I08CV0001 = "";
    public string OrderItemAdd(string A61I04JJA31I02, string strNum, string A60I02UV0012) 
    {
        A61I08CV0001 = "";
        DataTable dt = new DataTable();
        bool IsChild = false;
        string strSQL = "";
        string SQL = "select A31I09CV0001,A31I06CV0001,A31I07CV0001 from A31 where A31I02UV0010='" + A61I04JJA31I02 + "'";
        Sql.ClearQuery();
        dt = Sql.selectTable(SQL, "A31");
        if (dt == null)
        {
            return "error";
        }
        else{ 
            if(dt.Rows[0]["A31I09CV0001"].ToString()=="V"){
                IsChild = true;
            }
            
            if (dt.Rows[0]["A31I06CV0001"].ToString() == "V" && dt.Rows[0]["A31I07CV0001"].ToString() == "V")
            {
                A61I08CV0001 = "C";
            }
            else if (dt.Rows[0]["A31I06CV0001"].ToString() == "V" )
            {
                A61I08CV0001 = "A";
            }
            else if (dt.Rows[0]["A31I07CV0001"].ToString() == "V")
            {
                A61I08CV0001 = "B";
            }
            else { }
           
        }
        int Num = Convert.ToInt32(strNum);
        for (int x = 0; x < Num; x++)            
        {
            ParentID = "";
            string A61I02UV0019 = "";
            string str = "";
            str = A61I02.ToString();
            A61I02UV0019 = A60I02UV0012 + str.PadLeft(7, Convert.ToChar("0"));
            SQL = "select A31F01NV0064 from A31 where A31I02UV0010='" + A61I04JJA31I02 + "' ";
            Sql.ClearQuery();
            dt = Sql.selectTable(SQL, "A31c");
            strSQL += OrderSQL_InsertA61(A60I02UV0012, A61I02UV0019, A60I02UV0012, A61I04JJA31I02, "", "", A61I08CV0001, dt.Rows[0]["A31F01NV0064"].ToString());
            
            if (IsChild == true) {
                //上層id
                ParentID = A61I02UV0019;
                dt = null;
                SQL = "select A31I02UV0010,A31I12FD0200,A31F01NV0064 from A31 where A31I11JJA31I02='" + A61I04JJA31I02 + "' order by  A31I12FD0200";
                Sql.ClearQuery();
                dt = Sql.selectTable(SQL, "A31e");
                if (dt != null) {               
                        for (int i = 0; i < dt.Rows.Count; i++)
                        {
                            A61I02UV0019 = "";
                            str = "";
                            str = A61I02.ToString();
                            A61I02UV0019 = A60I02UV0012 + str.PadLeft(7, Convert.ToChar("0"));
                            strSQL += OrderSQL_InsertA61(A60I02UV0012, A61I02UV0019, A60I02UV0012, dt.Rows[i]["A31I02UV0010"].ToString(), "V", A61I04JJA31I02, A61I08CV0001, dt.Rows[i]["A31F01NV0064"].ToString());
                        }                
                }
            }
        }  
        return strSQL;
    }
    /*  主檔新增 */
    public string OrderSQL_InsertA60(string A60I02UV0012)
    {
        string strSQL = "";
        string A60F01NV0064 = "";
        string A60F02NV0128 = oValue.Data("A60F02NV0128");
        Sql.ClearQuery();
        Sql.SetData("A60I02UV0012", A60I02UV0012);
        Sql.SetData("A60I03CV0001", Sort );
        Sql.SetNData("A60F01NV0064", A60F01NV0064);
        Sql.SetNData("A60F02NV0128", A60F02NV0128);
        Sql.SetData("A60IND", oDate.IND);
        Sql.SetData("A60INT", oDate.INT);
        Sql.SetData("A60INA", oDate.INA);
        Sql.SetData("A60UPD", oDate.IND);
        Sql.SetData("A60UPT", oDate.INT);
        Sql.SetData("A60UPA", oDate.INA);
        strSQL += Sql.getInserSQL("A60") + "\r\n";        
        return strSQL;
    }
    /* 明細新增 */
    public string OrderSQL_InsertA61(string A60I02UV0012, string A61I02UV0019, string A61I03JJA60I02, string A61I04JJA31I02, string A61I09CV0001, string A61I10JJA61I02, string A61I08CV0001, string A61F01NV0064)
    {
        string strSQL = "";      
        Sql.ClearQuery();
        Sql.SetData("A61I02UV0019", A61I02UV0019);
        Sql.SetData("A61I03JJA60I02", A61I03JJA60I02);
        Sql.SetNData("A61I04JJA31I02", A61I04JJA31I02);
        Sql.SetData("A61I07CV0001", Sort);
        Sql.SetData("A61I08CV0001", A61I08CV0001);
        Sql.SetData("A61I09CV0001", A61I09CV0001);
        Sql.SetData("A61I10JJA61I02", ParentID);
        Sql.SetData("A61F01NV0064", Pub_Function.setSingleQuotation(A61F01NV0064));
        Sql.SetData("A61IND", oDate.IND);
        Sql.SetData("A61INT", oDate.INT);
        Sql.SetData("A61INA", oDate.INA);
        Sql.SetData("A61UPD", oDate.IND);
        Sql.SetData("A61UPT", oDate.INT);
        Sql.SetData("A61UPA", oDate.INA);
        strSQL += Sql.getInserSQL("A61") + "\r\n";                
        A61I02 += 1;
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