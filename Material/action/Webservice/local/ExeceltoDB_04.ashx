<%@ WebHandler Language="C#" Class="ExeceltoDB_01" %>

using System;
using System.Web;
using System.IO;
using System.Data;
using System.Collections;
using System.Collections.Generic;
public class ExeceltoDB_01 : IHttpHandler {
    PageBase pb = new PageBase();
    Cls_Request oValue = new Cls_Request();
    Language_Msg Ms = new Language_Msg();
    string ErrorMsg = "";
    Cls_SQL Sql = new Cls_SQL();
    Cls_Date oDate = new Cls_Date();
    Cls_Excel oExcel = new Cls_Excel();
    DataTable SheetName = new DataTable();
    DataTable dt = new DataTable();
    DataTable recordset = new DataTable();
    DataSet ds = new DataSet();
    string Sort = "L";
    int A68I02 = 1;
    string ParentID = "";
    string A61I13JJA12I02 = "";
    string A67F02NV0128 = "";
    string A61I12JJA12I02 = "";
    string A68I05JJA19I02 = "";
    
    Dictionary<string, int> KeySum = new Dictionary<string, int>();
    Dictionary<string, string> codeArray = new Dictionary<string, string>();
    Dictionary<string, string> ProvidorArray = new Dictionary<string, string>();
    Dictionary<string, string> ContractorArray = new Dictionary<string, string>();
    public void ProcessRequest (HttpContext context) {
        oValue.setRequestPost("Action,A67F02NV0128,Url,FileName,DropDownList1,DropDownList2");
        string strUrl = "";
        string strSQL = "";
        string strFileName = oValue.Data("FileName");
        A67F02NV0128 = oValue.Data("A67F02NV0128");
        string strRoute = pb.WebRoot + @"\Upload\local\type04\";
        /* 供應商代碼 */
        A61I13JJA12I02 = oValue.Data("DropDownList1");
        A61I12JJA12I02 = oValue.Data("DropDownList2");
        
        //strSQL = readExcel(@"C:\Users\admin\Desktop\" + @"123.xlsx", "Sheet1",context );
        
        DataTable oDt = new DataTable();
        /* 供應商代碼 */
        oDt = Sql.selectTable("select A12I02UV0010,A12F01NV0064,A12I10JJA19I02  from A12 where A12I03CV0001='A' ", "chk1");
        if (oDt != null)
        {
            for (int i = 0; i < oDt.Rows.Count; i++)
            {
                if (!ProvidorArray.ContainsKey(oDt.Rows[i]["A12F01NV0064"].ToString()))
                {
                    ProvidorArray.Add(oDt.Rows[i]["A12F01NV0064"].ToString(), oDt.Rows[i]["A12I02UV0010"].ToString() + oDt.Rows[i]["A12I10JJA19I02"].ToString());
                }
            }
        }
        oDt = null;
        /* 承包商代碼 */
        oDt = Sql.selectTable("select A12I02UV0010,A12F01NV0064 from A12 where A12I03CV0001='B' ", "chk2");
        if (oDt != null)
        {
            for (int i = 0; i < oDt.Rows.Count; i++)
            {
                if (!ContractorArray.ContainsKey(oDt.Rows[i]["A12F01NV0064"].ToString()))
                {
                    ContractorArray.Add(oDt.Rows[i]["A12F01NV0064"].ToString(), oDt.Rows[i]["A12I02UV0010"].ToString() );
                }
            }
        }
                                      
        strSQL = readExcel(strRoute, strFileName, context);
        
        //strSQL = "";
        
        if (ErrorMsg == "")
        {
            //string RtnMsg = "";
            string RtnMsg = Pub_Function.executeSQL(strSQL);
            switch (RtnMsg)
            {
                case "":
                    context.Response.Write("alert('" + Ms.Msg13 + "');hideFlash();");
                    break;
                case "success":
                    context.Response.Write("alert('" + Ms.Msg06 + "');hideFlash();");
                    break;
                case "fail":
                    context.Response.Write("alert('" + Ms.Msg05 + "');hideFlash();");
                    break;
                default:
                    break;
            }
        }
        else {

            context.Response.Write("alert('" + ErrorMsg + "');hideFlash();");
        }


        
    }
    public string readExcel(string strRoute, string FileName, HttpContext context)
    {
        
        string SQL= "";
        string strSQL = "";        
        dt = oExcel.readExcelData(strRoute + FileName, "Sheet1$");
        DataTable Check_dt = new DataTable();
        string strCode = dt.Columns[0].ColumnName;
        int strColumnCount = dt.Columns.Count;
        int strRowsCount = dt.Rows.Count;  
        if (dt != null)
        {
            string cWhere ="";
            if (dt.Columns.Count  < 4) {
                ErrorMsg +=  "上傳資料格式錯誤!";
                return "";
            }
            for (int c = 0; c < dt.Rows.Count; c++)
            {
                if (cWhere != "") { cWhere = cWhere + " or "; }
                cWhere = cWhere + " A63I03CV0032='" + dt.Rows[c][0].ToString() + "' ";
                string strDate = dt.Rows[c][1].ToString();
                if(Cls_Rule.IsNumeric(strDate)==false || strDate.Length  != 8)
                {
                    ErrorMsg += "第" + (c + 1) + "行日期格式錯誤!";
                    return "";
                }
                string strProvidor = dt.Rows[c][2].ToString();
                if (!ProvidorArray.ContainsKey(strProvidor)) {
                    ErrorMsg += "第" + (c + 1) + "行供應商查無資料!";
                    return "";
                }
                string strContractor = dt.Rows[c][3].ToString();
                if (!ContractorArray.ContainsKey(strContractor))
                {
                    ErrorMsg += "第" + (c + 1) + "行承包商查無資料!";
                    return "";
                }
            }
            DataTable cDt = new DataTable();
            cDt = Sql.selectTable("select A63I03CV0032 from A63 where " + cWhere, "A63");
            if (cDt != null)
            {
                ErrorMsg += "序號重複!! " + cDt.Rows[0][0].ToString();
                return "";
            }
            
             strCode = dt.Columns[0].ColumnName;
             strColumnCount = dt.Columns.Count;
             strRowsCount = dt.Rows.Count;            
            Sql.ClearQuery();
            SQL = "select top " + strRowsCount.ToString() + " A61I02UV0019 from A61 left join A31 on A61I04JJA31I02 = A31I02UV0010  where A31I14CV0024='" + strCode + "' and A61I11CV0001='' and A61I07CV0001='L' order by A61INA ";
            Check_dt = Sql.selectTable(SQL, "A6118");
            /* 在庫餘數 */
            if (Check_dt == null || Check_dt.Rows.Count < strRowsCount)
            {
                ErrorMsg += "件號-" + strCode + "訂單餘數不足!";
                return "";
            }
            
                                              
        }
        else {
            ErrorMsg = "error 請檢查頁籤名稱是否為Sheet1";
        }
        if (ErrorMsg != "") { return "error"; }
                                           

        string A67I02UV0012 = "";
        string A61I02UV0019 = "";
        string A65I02UV0012 = "";
        oDate.RecordNow();

        oDate.RecordNow();
        /* A67代碼產生*/
        string str = oDate.IND + Sort;
        SQL = "select A67I02UV0012 from A67 where left(A67I02UV0012,9)='" + str + "' order by A67I02UV0012 Desc";
        Sql.ClearQuery();
        recordset = Sql.selectTable(SQL, "A67");
        if (recordset != null)
        {
            string pStr = recordset.Rows[0]["A67I02UV0012"].ToString();
            A67I02UV0012 = (Convert.ToInt32(pStr.Substring(9, 3)) + 1).ToString();
            A67I02UV0012 = str + A67I02UV0012.PadLeft(3, Convert.ToChar("0"));
        }
        else
        {
            A67I02UV0012 = str + "001";
        }
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

        /* 主檔 */
        strSQL += OrderSQL_InsertA67(A67I02UV0012);
        strSQL += OrderSQL_InsertA65(A65I02UV0012);
        //A68I02代碼
        recordset = null;
        Sql.ClearQuery();
        SQL = "select A68I02UV0019 from A68 where left(A68I02UV0019,12)='" + A67I02UV0012 + "' order by A68I02UV0019 Desc ";
        recordset = Sql.selectTable(SQL, "A68s");
        if (recordset != null)
        {
            string pStr = recordset.Rows[0]["A68I02UV0019"].ToString();
            pStr = pStr.Substring(12, 7);
            A68I02 = Convert.ToInt32(pStr) + 1;
        }

        if (Check_dt != null) {

            for (int b = 0; b < Check_dt.Rows.Count; b++)
            {
                // 件號 日期 供應商 承包商
                string[] CodeArray = new string[5];
                for (int p = 0; p < strColumnCount; p++)
                {
                    CodeArray[p] = dt.Rows[b][p].ToString();
                }

                    A61I02UV0019 = Check_dt.Rows[b]["A61I02UV0019"].ToString();
                /* A62檢查 && 出貨日期填入*/
                existCheckA62(A61I02UV0019);
                strSQL += setTimeA62(A61I02UV0019, CodeArray[1]);
                /* A61b資料填入 */
                strSQL += setDataA61(A61I02UV0019, ProvidorArray[CodeArray[2]].Substring(0, 10), ContractorArray[CodeArray[3]], ProvidorArray[CodeArray[2]].Substring(10, 4));
                strSQL += OrderItemAdd(A67I02UV0012, A61I02UV0019, ProvidorArray[CodeArray[2]].Substring(0, 10), ContractorArray[CodeArray[3]], ProvidorArray[CodeArray[2]].Substring(10, 4), CodeArray[1]);
                strSQL += OrderItemA66(A65I02UV0012, A61I02UV0019, ProvidorArray[CodeArray[2]].Substring(0, 10), ContractorArray[CodeArray[3]], ProvidorArray[CodeArray[2]].Substring(10, 4), CodeArray[1]);
                /* A63檢查 && 序號填入*/
                existCheckA63(A61I02UV0019);
                strSQL += setDataA63(A61I02UV0019, CodeArray[0]);
            }
           
         
        }
                                

        return strSQL;   
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
    public string setDataA63(string A61I02UV0019, string strCode1)
    {
        if (strCode1 == null) { strCode1 = ""; }
        
        string strSQL = "";
        Sql.ClearQuery();        
        Sql.SetData("A63I03CV0032", strCode1);
        
        Sql.SetWhere("and", "A63I02JJA61I02", "=", A61I02UV0019, true);
        strSQL += Sql.getUpdateSQL("A63") + "\r\n";
        return strSQL;
    }
    public string setDataA61(string A61I02UV0019, string A61I12JJA12I02, string A61I13JJA12I02, string A68I05JJA19I02)
    {
        string strSQL = "";
        Sql.ClearQuery();
        Sql.SetData("A61I11CV0001", "B");
        Sql.SetData("A61I13JJA12I02", A61I13JJA12I02);
        Sql.SetData("A61I12JJA12I02", A61I12JJA12I02);
        Sql.SetData("A61I05JJA19I02", A68I05JJA19I02);
        Sql.SetWhere("or", "A61I02UV0019", "=", A61I02UV0019, true);
        Sql.SetWhere("or", "A61I10JJA61I02", "=", A61I02UV0019, true);
        strSQL += Sql.getUpdateSQL("A61") + "\r\n";
        return strSQL;
    }
    public string setTimeA62(string A61I02UV0019,string A68D01)
    {
        string strSQL = "";
        Sql.ClearQuery();
        Sql.SetData("A62D01", A68D01);
        Sql.SetData("A62T01", "000000");
        Sql.SetData("A62A01", A68D01+"000000");
        Sql.SetData("A62D02", A68D01);
        Sql.SetData("A62T02", "000000");
        Sql.SetData("A62A02", A68D01 + "000000");
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

    
    /*  主檔新增 */
    public string OrderSQL_InsertA67(string A67I02UV0012)
    {
        string strSQL = "";
        string A67F01NV0064 = "";
        
        Sql.ClearQuery();
        Sql.SetData("A67I02UV0012", A67I02UV0012);
        Sql.SetData("A67I03CV0001", Sort);
        Sql.SetNData("A67F01NV0064", A67F01NV0064);
        Sql.SetNData("A67F02NV0128", A67F02NV0128);
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
        Sql.SetNData("A65F02NV0128", A67F02NV0128);
        Sql.SetData("A65IND", oDate.IND);
        Sql.SetData("A65INT", oDate.INT);
        Sql.SetData("A65INA", oDate.INA);
        Sql.SetData("A65UPD", oDate.IND);
        Sql.SetData("A65UPT", oDate.INT);
        Sql.SetData("A65UPA", oDate.INA);
        strSQL += Sql.getInserSQL("A65") + "\r\n";
        return strSQL;
    }
    public string OrderItemAdd(string A67I02UV0012, string A68I02UV0019, string A61I12JJA12I02, string A61I13JJA12I02, string A68I05JJA19I02, string A68D01)
    {
        DataTable dt = new DataTable();
        bool IsChild = false;
        string strSQL = "";
        string SQL = "select A61I04JJA31I02,A61I07CV0001,A61I08CV0001,A61F01NV0064 from A61 where A61I02UV0019='" + A68I02UV0019 + "'";
        Sql.ClearQuery();
        dt = Sql.selectTable(SQL, "A31");
        if (dt == null)
        {
            return "error";
        }
        Sql.ClearQuery();
        Sql.SetData("A68I02UV0019", A68I02UV0019);
        Sql.SetData("A68I03JJA67I02", A67I02UV0012);
        Sql.SetNData("A68I04JJA31I02", dt.Rows[0]["A61I04JJA31I02"].ToString());
        Sql.SetNData("A68I07CV0001", dt.Rows[0]["A61I07CV0001"].ToString());
        Sql.SetData("A68I08CV0001", dt.Rows[0]["A61I08CV0001"].ToString());
        Sql.SetData("A68I05JJA19I02", A68I05JJA19I02);
        Sql.SetData("A68I12JJA12I02", A61I12JJA12I02);
        Sql.SetData("A68I13JJA12I02", A61I13JJA12I02);
        Sql.SetData("A68F01NV0064", Pub_Function.setSingleQuotation(dt.Rows[0]["A61F01NV0064"].ToString()));
        Sql.SetData("A68I11CV0001", "B");
        Sql.SetData("A68I21CV0001", "V");
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
    public string OrderItemA66(string A65I02UV0012, string A66I02UV0019, string A61I12JJA12I02, string A61I13JJA12I02, string A68I05JJA19I02, string A68D01)
    {
        DataTable dt = new DataTable();
        bool IsChild = false;
        string strSQL = "";
        string SQL = "select A61I04JJA31I02,A61I07CV0001,A61I08CV0001,A61F01NV0064 from A61 where A61I02UV0019='" + A66I02UV0019 + "'";
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
        Sql.SetData("A66I05JJA19I02", A68I05JJA19I02);
        Sql.SetData("A66I12JJA12I02", A61I12JJA12I02);
        Sql.SetData("A66I13JJA12I02", A61I13JJA12I02);
        Sql.SetData("A66I10JJA66I02", "");
        Sql.SetData("A66I09CV0001", "");
        Sql.SetData("A66F01NV0064", Pub_Function.setSingleQuotation(dt.Rows[0]["A61F01NV0064"].ToString()));
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
    
    public bool IsReusable {
        get {
            return false;
        }
    }

}