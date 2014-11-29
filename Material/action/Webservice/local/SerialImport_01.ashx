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
    string A68I03JJA67I02 = "";
    string A68I04JJA31I02 = "";
    string A68I13JJA12I02 = "";
    string A68I05JJA19I02 = "";
    string A68D01 = "";
    string A67F02NV0128 = "";
    Dictionary<string, int> KeySum = new Dictionary<string, int>();
    Dictionary<string, string> codeArray = new Dictionary<string, string>();
    public void ProcessRequest (HttpContext context) {
        oValue.setRequestPost("Action,A68I03JJA67I02,Url,FileName,A68I04JJA31I02,A68I13JJA12I02");
        string strUrl = "";
        string strSQL = "";
        string strFileName = oValue.Data("FileName");
        
        string strRoute = pb.WebRoot + @"\Upload\local\SerialImort\";
        /* 訂單代碼 承包商代碼 品項代碼*/
        A68I04JJA31I02 = oValue.Data("A68I04JJA31I02");
        A68I03JJA67I02 = oValue.Data("A68I03JJA67I02");
        A68I13JJA12I02 = oValue.Data("A68I13JJA12I02");
                                                     
        strSQL = readExcel(strRoute, strFileName, context);
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
                    context.Response.Write("alert('" + Ms.Msg06 + "');hideFlash('" + A68I03JJA67I02 + "','" + A68I04JJA31I02 + "','" + A68I13JJA12I02 + "');");
                    break;
                case "fail":
                    context.Response.Write("alert('" + Ms.Msg05 + "');hideFlash();");
                    break;
                default:
                    break;
            }
        }
        else
        {

            context.Response.Write("alert('" + ErrorMsg + "');hideFlash();");
        }


        
    }
    public string readExcel(string strRoute, string FileName, HttpContext context)
    {
        DataTable SerialDt = new DataTable();
        string SQL= "";
        string strSQL = "";
        try
        {
            dt = oExcel.readExcelData(strRoute + FileName, "Sheet1$");
            DataTable Check_dt = new DataTable();
        }
        catch {
            ErrorMsg += "上傳格式錯誤!";
            return "";
        }
        
        if (dt != null)
        {
            string strCode = dt.Columns[0].ColumnName;
            int strColumnCount = dt.Columns.Count;
            int strRowsCount = dt.Rows.Count;  
            if (dt.Columns.Count > 1) {
                ErrorMsg += "上傳格式錯誤!";
                return "";
            }
            string cWhere ="";
            for (int c = 0; c < dt.Rows.Count; c++)
            {
                if (cWhere != "") { cWhere = cWhere + " or "; }
                cWhere = cWhere + " A63I03CV0032='" + dt.Rows[c][0].ToString() + "' ";
            }
            DataTable cDt = new DataTable();
            cDt = Sql.selectTable("select A63I03CV0032 from A63 where " + cWhere, "A63");
            if (cDt != null)
            {
                //ErrorMsg += "序號重複!! " + cDt.Rows[0][0].ToString();
                //return "";
            }
            
             strCode = dt.Columns[0].ColumnName;
             strColumnCount = dt.Columns.Count;
             strRowsCount = dt.Rows.Count;            
            Sql.ClearQuery();
            SQL = "select A68I02UV0019 from A68 where A68I04JJA31I02='" + A68I04JJA31I02 + "' and A68I03JJA67I02='" + A68I03JJA67I02 + "' and A68I13JJA12I02='" + A68I13JJA12I02 + "' ";
            SerialDt = Sql.selectTable(SQL, "A68s");
            /* 出庫資料 */
            if (SerialDt == null || SerialDt.Rows.Count < strRowsCount)
            {
                ErrorMsg +=  Ms.Msg31 ;
                return "";
            }                                  
        }
        else {
            ErrorMsg = "error 請檢查頁籤名稱是否為Sheet1";
        }
        if (ErrorMsg != "") { return "error"; }


        for (int x = 0; x < dt.Rows.Count; x++)
        {
            existCheckA63(SerialDt.Rows[x]["A68I02UV0019"].ToString());
            strSQL += setDataA63(SerialDt.Rows[x]["A68I02UV0019"].ToString(), dt.Rows[x][0].ToString());
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
    
    
    public bool IsReusable {
        get {
            return false;
        }
    }

}