<%@ WebHandler Language="C#" Class="ExeceltoDB_01" %>

using System;
using System.Web;
using System.IO;
using System.Data;
using System.Collections;

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
    
    public void ProcessRequest (HttpContext context) {
        oValue.setRequestPost("Action,A67F02NV0128,Url,FileName,DropDownList1,DropDownList2");
        string strUrl = "";
        string strSQL = "";
        string strFileName = oValue.Data("FileName");
        A67F02NV0128 = oValue.Data("A67F02NV0128");
        string strRoute = pb.WebRoot + @"\Upload\local\type02\";
        /* 供應商代碼 */
        A61I13JJA12I02 = oValue.Data("DropDownList1");
        A61I12JJA12I02 = oValue.Data("DropDownList2");
        strSQL = readExcel(strRoute, strFileName, context);
        
        
        if (ErrorMsg == "")
        {
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
        int P000000018 = 0;
        int P000000019 = 0;
        DataTable eDt = new DataTable();
        eDt = oExcel.readSheetInfo(strRoute + FileName);
        if (eDt != null)
        {
            for (int r = 0; r < eDt.Rows.Count; r++) {
                string tableName = eDt.Rows[r]["TABLE_NAME"].ToString().Replace("$", "");
                tableName = tableName.Replace("'", "");
                dt = oExcel.readExcelData(strRoute + FileName, tableName + "$");
                if (dt != null)
                {
                    int Floor = 0;
                    for (int u = 0; u < dt.Rows.Count; u++)
                    {
                        string pCheck = dt.Rows[u][0].ToString();
                        if (pCheck == "Item")
                        {
                            Floor = u + 1;
                            break;
                        }
                    }
                    int strd = dt.Rows.Count;
                    P000000019 += dt.Rows.Count - Floor;
                    ds.Tables.Add(dt);
                }
                else
                {
                    if (tableName.IndexOf("xlnm") <= 0)
                    {
                        ErrorMsg = Ms.Msg25 + "-1"; return "error";
                    }
                }
            }
            
        }else {
            ErrorMsg = Ms.Msg25 + "-2"; return "error";
        }
        
        if (ErrorMsg != "") { return "error"; }
        /* 在庫餘數 */
        DataTable dt18 = new DataTable();
        DataTable dt19 = new DataTable();
             
        Sql.ClearQuery();
        SQL = "select top " + P000000019.ToString() + " A61I02UV0019 from A61 where A61I04JJA31I02='" + "P000000019" + "' and A61I11CV0001='' order by A61INA ";
        dt19 = Sql.selectTable(SQL, "A6119" );
        if (dt19 == null || dt19.Rows.Count < P000000019)
        {            
            ErrorMsg += Ms.Msg23;
            return "" ;
        }                        
        
        string A67I02UV0012 = "";
        string A61I02UV0019 = "";
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
        //A68I02代碼
        recordset = null;
        Sql.ClearQuery();
        SQL = "select A68I02UV0019 from A68 where left(A68I02UV0019,13)='" + A67I02UV0012 + "J"+"' order by A68I02UV0019 Desc ";
        recordset = Sql.selectTable(SQL, "A68s");
        if (recordset != null)
        {
            string pStr = recordset.Rows[0]["A68I02UV0019"].ToString();
            pStr = pStr.Substring(13, 6);
            A68I02 = Convert.ToInt32(pStr) + 1;
        }
       
        /* 主檔 */
        strSQL += OrderSQL_InsertA67(A67I02UV0012);
        int counter = 0;
        string[] Array19 = "1,4".Split(',');
        for (int a = 0; a < ds.Tables.Count ; a++)
        {            
            int Start = 0;
            for (int x = 0; x < 10000; x++)
            {
                if (ds.Tables[a].Rows[x][0].ToString() == "1")
                {
                    Start = x;
                    break;
                }
            }
            if (ds.Tables[a].Columns.Count < 14) {
                ErrorMsg += Ms.Msg27 + "頁籤" + (a+1).ToString();
                return "";            
            }
            for (int b = Start; b < ds.Tables[a].Rows.Count; b++)
            {
                string strCode2 = ds.Tables[a].Rows[b][2].ToString();
                string strCode4 = ds.Tables[a].Rows[b][4].ToString();
                string strCode6 = ds.Tables[a].Rows[b][6].ToString();
                string strCode8 = ds.Tables[a].Rows[b][8].ToString();
                string strCode10 = ds.Tables[a].Rows[b][10].ToString();
                string strCode12 = ds.Tables[a].Rows[b][12].ToString();
                string strCode13 = ds.Tables[a].Rows[b][13].ToString();
                if (counter < dt19.Rows.Count)
                {
                    A61I02UV0019 = dt19.Rows[counter]["A61I02UV0019"].ToString();
                    /* A62檢查 && 出貨日期填入*/
                    existCheckA62(A61I02UV0019);
                    strSQL += setTimeA62(A61I02UV0019);
                    /* A61b資料填入 */
                    strSQL += setDataA61(A61I02UV0019);
                    strSQL += OrderItemAdd(A67I02UV0012, A61I02UV0019);
                    /* A63檢查 && 序號填入*/
                    existCheckA63(A61I02UV0019);
                    strSQL += setDataA63(A61I02UV0019, strCode4, "", "", "");
                    //機櫃
                    if (strCode2 != "" && strCode2 != "N/A" && ds.Tables[a].Rows[b][2] != DBNull.Value)
                    {
                        string strC =ds.Tables[a].Rows[b][1].ToString();
                        string strA68I02 = getA68I02(A67I02UV0012);
                        if (strC.IndexOf("FAN") > 0)
                        {                                                        
                            strSQL += ChildItemAdd(A67I02UV0012, strA68I02, "P000000023", A61I02UV0019, "風扇型機櫃");
                        }
                        else {                            
                            strSQL += ChildItemAdd(A67I02UV0012, strA68I02, "P000000024", A61I02UV0019, "熱交換型機櫃");
                        }
                        existCheckA62(strA68I02);
                        strSQL += setTimeA62(strA68I02);
                        existCheckA63(strA68I02);
                        strSQL += setDataA63(strA68I02, strCode2, "", "", "");
                    }
                    //控制模組(
                    if (strCode6 != "" && strCode6 != "N/A" && ds.Tables[a].Rows[b][6] != DBNull.Value)
                    {
                        string strA68I02 = getA68I02(A67I02UV0012);
                        strSQL += ChildItemAdd(A67I02UV0012, strA68I02, "P000000028", A61I02UV0019, "控制模組(CSU)");
                        existCheckA62(strA68I02);
                        strSQL += setTimeA62(strA68I02);
                        existCheckA63(strA68I02);
                        strSQL += setDataA63(strA68I02, strCode6, "", "", "");                        
                    }
                    //整流模塊1
                    if (strCode8 != "" && strCode8 != "N/A" && ds.Tables[a].Rows[b][8] != DBNull.Value)
                    {
                        string strA68I02 = getA68I02(A67I02UV0012);
                        strSQL += ChildItemAdd(A67I02UV0012, strA68I02, "P000000029", A61I02UV0019, "整流模塊");
                        existCheckA62(strA68I02);
                        strSQL += setTimeA62(strA68I02);
                        existCheckA63(strA68I02);
                        strSQL += setDataA63(strA68I02, strCode8, "", "", "");
                    }
                    //整流模塊2
                    if (strCode10 != "" && strCode10 != "N/A" && ds.Tables[a].Rows[b][10] != DBNull.Value)
                    {
                        string strA68I02 = getA68I02(A67I02UV0012);
                        strSQL += ChildItemAdd(A67I02UV0012, strA68I02, "P000000029", A61I02UV0019, "整流模塊");
                        existCheckA62(strA68I02);
                        strSQL += setTimeA62(strA68I02);
                        existCheckA63(strA68I02);
                        strSQL += setDataA63(strA68I02, strCode10, "", "", "");
                    }
                    //整流模塊3
                    if (strCode12 != "" && strCode12 != "N/A" && ds.Tables[a].Rows[b][12] != DBNull.Value)
                    {
                        string strA68I02 = getA68I02(A67I02UV0012);
                        strSQL += ChildItemAdd(A67I02UV0012, strA68I02, "P000000029", A61I02UV0019, "整流模塊");
                        existCheckA62(strA68I02);
                        strSQL += setTimeA62(strA68I02);
                        existCheckA63(strA68I02);
                        strSQL += setDataA63(strA68I02, strCode12, "", "", "");
                    }
                    //battery
                    if (strCode13 != "" && strCode13 != "N/A" && ds.Tables[a].Rows[b][13] != DBNull.Value)
                    {
                        string tName = "";string tID = "";
                        switch (strCode13)
                        {
                            case "FXH100-12I FR":
                                tName = "鉛酸電池 ( ２KW-100AH )-1套=4顆";
                                tID = "P000000021";
                                break;
                            case "Panasonic Battery":
                                tName = "Panasonic LI-ION BATTERY-1套=2顆";
                                tID = "P000000025";
                                break;
                            case "FXH165-12I FR":
                                tName = "鉛酸電池 ( ３KW-165AH )-1套=4顆";
                                tID = "P000000022";
                                break;    
                        }
                        string strA68I02 = getA68I02(A67I02UV0012);
                        strSQL += ChildItemAdd(A67I02UV0012, strA68I02, tID, A61I02UV0019, tName);
                        existCheckA62(strA68I02);
                        strSQL += setTimeA62(strA68I02);
                        existCheckA63(strA68I02);
                        strSQL += setDataA63(strA68I02, strCode13, "", "", "");
                    }
                    counter += 1;
                }
            }

        }

        return strSQL;   
    }
    public string getA68I02(string A67I02UV0012)
    {

        string A68I02UV0019 = A68I02.ToString();
        A68I02UV0019 = A67I02UV0012 + "J" + A68I02UV0019.PadLeft(6, '0');
        A68I02 = A68I02 + 1;
        return A68I02UV0019;
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
    public string setDataA63(string A61I02UV0019, string strCode1, string strCode2, string strCode3, string strCode4)
    {
        string strSQL = "";
        Sql.ClearQuery();        
        Sql.SetData("A63I03CV0032", strCode1);
        Sql.SetData("A63I04CV0032", strCode2);
        Sql.SetData("A63I05CV0032", strCode3);
        Sql.SetData("A63I06CV0032", strCode4);        
        Sql.SetWhere("and", "A63I02JJA61I02", "=", A61I02UV0019, true);
        strSQL += Sql.getUpdateSQL("A63") + "\r\n";
        return strSQL;
    }
    public string setDataA61(string A61I02UV0019)
    {
        string strSQL = "";
        Sql.ClearQuery();
        Sql.SetData("A61I11CV0001", "B");
        Sql.SetData("A61I13JJA12I02", A61I13JJA12I02);
        Sql.SetData("A61F01NV0064", "SMR");
        Sql.SetWhere("or", "A61I02UV0019", "=", A61I02UV0019, true);
        Sql.SetWhere("or", "A61I10JJA61I02", "=", A61I02UV0019, true);
        strSQL += Sql.getUpdateSQL("A61") + "\r\n";
        return strSQL;
    }
    public string setTimeA62(string A61I02UV0019)
    {
        string strSQL = "";
        Sql.ClearQuery();
        Sql.SetData("A62D02", oDate.IND);
        Sql.SetData("A62T02", oDate.INT);
        Sql.SetData("A62A02", oDate.INA);
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

    public string OrderItemAdd(string A67I02UV0012, string A68I02UV0019)
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
        Sql.SetNData("A68I04JJA31I02", dt.Rows[0]["A61I04JJA31I02"].ToString());
        Sql.SetNData("A68I07CV0001", dt.Rows[0]["A61I07CV0001"].ToString());
        Sql.SetData("A68I08CV0001", dt.Rows[0]["A61I08CV0001"].ToString());
        Sql.SetData("A68I12JJA12I02", A61I12JJA12I02);
        Sql.SetData("A68I13JJA12I02", A61I13JJA12I02);
        Sql.SetData("A68F01NV0064", "SMR");
        Sql.SetData("A68I11CV0001", "B");
        Sql.SetData("A68IND", oDate.IND);
        Sql.SetData("A68INT", oDate.INT);
        Sql.SetData("A68INA", oDate.INA);
        Sql.SetData("A68UPD", oDate.IND);
        Sql.SetData("A68UPT", oDate.INT);
        Sql.SetData("A68UPA", oDate.INA);
        strSQL += Sql.getInserSQL("A68") + "\r\n";
        return strSQL;
    }
    public string ChildItemAdd(string A67I02UV0012, string A68I02UV0019, string A68I04JJA31I02, string A68I10JJA68I02, string A68F01NV0064)
    {
        DataTable dt = new DataTable();
        bool IsChild = false;
        string strSQL = "";                              
        Sql.ClearQuery();
        Sql.SetData("A68I02UV0019", A68I02UV0019);
        Sql.SetData("A68I03JJA67I02", A67I02UV0012);
        Sql.SetData("A68I04JJA31I02", A68I04JJA31I02);
        Sql.SetData("A68I07CV0001", "L");
        Sql.SetData("A68I09CV0001", "V");
        Sql.SetData("A68I10JJA68I02", A68I10JJA68I02);
        Sql.SetData("A68I12JJA12I02", A61I12JJA12I02);
        Sql.SetData("A68I13JJA12I02", A61I13JJA12I02);
        Sql.SetNData("A68F01NV0064", A68F01NV0064);
        Sql.SetData("A68I11CV0001", "B");
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
    
    public bool IsReusable {
        get {
            return false;
        }
    }

}