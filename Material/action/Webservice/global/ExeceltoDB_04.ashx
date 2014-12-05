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
    DataSet exDs = new DataSet();
    string Sort = "G";
    int A66I02 = 1;
    string ParentID = "";
    string A61I05JJA19I02 = "";
    string A67F02NV0128 = "";
    string A61I12JJA12I02 = "";
    Dictionary<string, int> KeySum = new Dictionary<string, int>();
    Dictionary<string, string> ItemID = new Dictionary<string, string>();
    Dictionary<string, string> ProvidorArray = new Dictionary<string, string>();
    Dictionary<string, string> HouseArray = new Dictionary<string, string>();
    public void ProcessRequest (HttpContext context) {
        oValue.setRequestPost("Action,A67F02NV0128,Url,FileName,DropDownList1,DropDownList2");
        string strUrl = "";
        string strSQL = "";
        string strFileName = oValue.Data("FileName");
        A67F02NV0128 = oValue.Data("A67F02NV0128");
        string strRoute = pb.WebRoot + @"\Upload\global\type04\";
       
        A61I05JJA19I02 = oValue.Data("DropDownList1");
        A61I12JJA12I02 = oValue.Data("DropDownList2");
        DataTable oDt = new DataTable();
        /* 供應商代碼 */
        oDt = Sql.selectTable("select A12I02UV0010,A12F01NV0064 from A12 where A12I03CV0001='A' ", "chk1");
        if (oDt != null) {
            for (int i = 0; i < oDt.Rows.Count; i++) { 
                 if(!ProvidorArray.ContainsKey(oDt.Rows[i]["A12F01NV0064"].ToString())){
                       ProvidorArray.Add(oDt.Rows[i]["A12F01NV0064"].ToString(),oDt.Rows[i]["A12I02UV0010"].ToString());
                 }
            }
        }
        /* 倉庫代碼 */
        oDt = null;
        oDt = Sql.selectTable("select A19I02UV0004,A19F01NV0032 from A19  ", "chk2");
        if (oDt != null)
        {
            for (int i = 0; i < oDt.Rows.Count; i++)
            {
                if (!HouseArray.ContainsKey(oDt.Rows[i]["A19F01NV0032"].ToString()))
                {
                    HouseArray.Add(oDt.Rows[i]["A19F01NV0032"].ToString(), oDt.Rows[i]["A19I02UV0004"].ToString());
                }
            }
        }
       

        strSQL = readExcel(strRoute, strFileName, context);
        
        //測試用
        //strSQL = "";
        
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
        DataTable mergeDt = new DataTable();
        mergeDt = null;
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
                    if (mergeDt == null)
                    {
                        mergeDt = dt;
                    }
                    else {
                        mergeDt.Merge(dt);
                    }
                }
                else
                {
                    if (tableName.IndexOf("xlnm") <= 0)
                    {                        
                        //ErrorMsg = Ms.Msg25 + "-1"; return "error";
                    }
                }
            }            
        }else {
            ErrorMsg = Ms.Msg25 + "-2"; return "error";
        }
        
        if (ErrorMsg != "") { return "error"; }
        /* 數量計算 */
        for (int c = 0; c < mergeDt.Rows.Count; c++)
        {
            string ItemNum = mergeDt.Rows[c][5].ToString();
            int Num = Convert.ToInt32(mergeDt.Rows[c][6]);
            if (KeySum.ContainsKey(ItemNum))
            {
                KeySum[ItemNum] += Num;
            }
            else {
                KeySum.Add(ItemNum, Num);
            }
        }         
        
        DataTable ItemDt = new DataTable();
        Sql.ClearQuery();
        SQL = "select A31I02UV0010 ,A31I14CV0024 from A31 where A31I14CV0024<>''";
        ItemDt = Sql.selectTable(SQL, "A31i");
        if (ItemDt == null)
        {
            ErrorMsg += Ms.Msg29;
            return "";
        }
        else {
            for (int i = 0; i < ItemDt.Rows.Count; i++) {
                if (!ItemID.ContainsKey(ItemDt.Rows[i]["A31I14CV0024"].ToString()))
                {
                    ItemID.Add(ItemDt.Rows[i]["A31I14CV0024"].ToString(), ItemDt.Rows[i]["A31I02UV0010"].ToString());
                }
                else
                {
                    ErrorMsg += "件號重覆-" + ItemDt.Rows[i]["A31I14CV0024"].ToString();
                }
            }
        }
        mergeDt.Columns.Add("A61I02UV0019");
        mergeDt.Columns.Add("A61I04JJA31I02");
        mergeDt.Columns.Add("A61I08CV0001");
        mergeDt.Columns.Add("A61I09CV0001");
        mergeDt.Columns.Add("A61I10JJA61I02");
        mergeDt.Columns.Add("A31I12FD0200");
        mergeDt.Columns.Add("A31I14CV0024");
        mergeDt.Columns.Add("A31F01NV0064");
        /* 格式檢查 */

        //資料筆數x數量
        int intCount = mergeDt.Rows.Count;

        for (int a = 0; a < intCount; a++)
        {
            if (Convert.ToInt32(mergeDt.Rows[a][6]) > 1)
            {
                for (int p = 0; p < (Convert.ToInt32(mergeDt.Rows[a][6]) - 1); p++)
                {
                    DataRow dr = mergeDt.NewRow();
                    for (int j = 0; j < 25; j++)
                    {
                        dr[j] = mergeDt.Rows[a][j].ToString();
                    }
                    mergeDt.Rows.Add(dr);
                }
            }
        }
        
        /* 在庫餘數 */
        DataTable dt18 = new DataTable();
        DataTable dt19 = new DataTable();
        foreach (KeyValuePair<string, int> kv in KeySum)
        {
            string item = kv.Key.ToString();
            string num = kv.Value.ToString();
            if (!ItemID.ContainsKey(item)) {
                ErrorMsg += Ms.Msg30 + item ;
                return "";
            }            
            Sql.ClearQuery();
            SQL = "select top " + num + " A61I02UV0019,A61I04JJA31I02,A61I08CV0001 ,A61I09CV0001 ,A61I10JJA61I02,A31I12FD0200,A31I14CV0024,A31F01NV0064 from A61 left join A31 on A61I04JJA31I02 = A31I02UV0010   where A61I04JJA31I02='" + ItemID[item] + "' and A61I11CV0001='' order by A61INA ";
            dt19 = Sql.selectTable(SQL, "A6119" + item);
            if (dt19 == null || dt19.Rows.Count < Convert.ToInt32(num))
            {
                ErrorMsg += "訂單餘數不足" + " " + kv.Key.ToString();
                return "";
            }
            else {
               

                    for (int x = 0; x < dt19.Rows.Count; x++)
                    {
                        string A61I0 = dt19.Rows[x]["A61I02UV0019"].ToString();
                        string PackNum = dt19.Rows[x]["A31I14CV0024"].ToString();
                        string A61I04JJA31I02 = dt19.Rows[x]["A61I04JJA31I02"].ToString();
                        string A61I08CV0001 = dt19.Rows[x]["A61I08CV0001"].ToString();
                        string A61I09CV0001 = dt19.Rows[x]["A61I09CV0001"].ToString();
                        string A61I10JJA61I02 = dt19.Rows[x]["A61I10JJA61I02"].ToString();
                        string A31I12FD0200 = dt19.Rows[x]["A31I12FD0200"].ToString();
                        string A31I14CV0024 = dt19.Rows[x]["A31I14CV0024"].ToString();
                        string A31F01NV0064 = dt19.Rows[x]["A31F01NV0064"].ToString();
                        for (int y = 0; y < mergeDt.Rows.Count; y++)
                        {
                            //比對件號
                            string strC = mergeDt.Rows[y][5].ToString();
                            if (strC == PackNum)
                            {
                                if (mergeDt.Rows[y]["A61I02UV0019"] == DBNull.Value || mergeDt.Rows[y]["A61I02UV0019"] == "")
                                {
                                    mergeDt.Rows[y]["A61I02UV0019"] = A61I0;
                                    mergeDt.Rows[y]["A61I04JJA31I02"] = A61I04JJA31I02;
                                    mergeDt.Rows[y]["A61I08CV0001"] = A61I08CV0001;
                                    mergeDt.Rows[y]["A61I09CV0001"] = A61I09CV0001;
                                    mergeDt.Rows[y]["A61I10JJA61I02"] = A61I10JJA61I02;
                                    mergeDt.Rows[y]["A31I12FD0200"] = A31I12FD0200;
                                    mergeDt.Rows[y]["A31I14CV0024"] = A31I14CV0024;
                                    mergeDt.Rows[y]["A31F01NV0064"] = A31F01NV0064;
                                    break;
                                }
                            }
                        }
                    }

                exDs.Tables.Add(dt19 );
            }
            dt19 = null;
        }     
                   
        string A65I02UV0012 = "";
        string A61I02UV0019 = "";
        oDate.RecordNow();                   
        /* A67代碼產生*/
        string str = oDate.IND + Sort;
        SQL = "select A65I02UV0012 from A65 where left(A65I02UV0012,9)='" + str + "' order by A65I02UV0012 Desc";
        Sql.ClearQuery();
        recordset = Sql.selectTable(SQL, "A65");
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
        strSQL += OrderSQL_InsertA65(A65I02UV0012);

        for (int a = 0; a < mergeDt.Rows.Count ; a++)
        {
            string cA61I02 = mergeDt.Rows[a]["A61I02UV0019"].ToString();
            string cA61I04 = mergeDt.Rows[a]["A61I04JJA31I02"].ToString();
            string cA61I08 = mergeDt.Rows[a]["A61I08CV0001"].ToString();
            string cA61I09 = mergeDt.Rows[a]["A61I09CV0001"].ToString();
            string cA61I10 = mergeDt.Rows[a]["A61I10JJA61I02"].ToString();
            string cA61F01 = mergeDt.Rows[a]["A31F01NV0064"].ToString();
           
            string cDate = mergeDt.Rows[a][0].ToString();
            if (cDate.Length != 8 || Cls_Rule.IsNumeric(cDate)== false )
            {
                ErrorMsg += "格式錯誤-" + cDate;
                return "";
            }
            string cProvidor = mergeDt.Rows[a][1].ToString();
            if (ProvidorArray.ContainsKey(cProvidor.Trim()))
            {
                cProvidor = ProvidorArray[cProvidor.Trim()];
            }
            else
            {
                ErrorMsg += "格式錯誤-" + cProvidor.Trim();
                return "";
                cProvidor = "";
            }
            string cHouse = mergeDt.Rows[a][2].ToString();
            if (HouseArray.ContainsKey(cHouse.Trim()))
            {
                cHouse = HouseArray[cHouse.Trim()];
            }
            else {
                ErrorMsg += "格式錯誤-" + cHouse.Trim();
                return "";
                cHouse = "";
            }

            string PackN = mergeDt.Rows[a][7].ToString();
            string cA63I08 = mergeDt.Rows[a][3].ToString();
            string cA63I09 = mergeDt.Rows[a][4].ToString();
            string cA63I10 = mergeDt.Rows[a][5].ToString();
            string cA63I11 = mergeDt.Rows[a][6].ToString();
            string cA63I12 = mergeDt.Rows[a][7].ToString();
            string cA63I13 = mergeDt.Rows[a][8].ToString();
            string cA63I14 = mergeDt.Rows[a][9].ToString();
            string cA63I15 = mergeDt.Rows[a][10].ToString();
            string cA63I16 = mergeDt.Rows[a][11].ToString();
            string cCode1 = mergeDt.Rows[a][12].ToString();
            string cCode2 = mergeDt.Rows[a][13].ToString();
            string cCode3 = mergeDt.Rows[a][14].ToString();
            string cCode4 = mergeDt.Rows[a][15].ToString();
            string cCode5 = mergeDt.Rows[a][16].ToString();

            if (cA63I08.Length > 32)
            {
                ErrorMsg += "sku欄位超出字串長度限制";
                return "";
            }
            
            /* A62檢查 && 出貨日期填入*/
            existCheckA62(cA61I02);
            strSQL += setTimeA62(cA61I02, cDate);
            /* A63檢查 && 序號填入*/
            existCheckA63(cA61I02);
            /* A61b資料填入 */
            strSQL += setDataA61(cA61I02, cA61F01, PackN);
            strSQL += OrderItemAdd(A65I02UV0012, cA61I02, cA61I04, cA61I08, cA61I09, cA61I10, cA61F01, PackN, cProvidor, cHouse, cDate);
            strSQL += setDataA63(cA61I02, "", cA63I08, cA63I09, cA63I10, cA63I11, cA63I12, cA63I13, cA63I14, cA63I15, cA63I16);

            SQL = "select A61I02UV0019,A61I04JJA31I02,A61I10JJA61I02,A31I12FD0200,A31F01NV0064 from A61 left join A31 on A61I04JJA31I02 = A31I02UV0010 where A61I10JJA61I02='" + cA61I02 + "' order by A31I12FD0200";
            Sql.ClearQuery();
            DataTable ChildDt = new DataTable();
            ChildDt = Sql.selectTable(SQL, "A61ch");
            if (ChildDt != null)
            {
                if (cCode1 != "" && ChildDt.Rows.Count >= 1)
                {
                    string nA61I02 = ChildDt.Rows[0]["A61I02UV0019"].ToString();
                    string nA61I04 = ChildDt.Rows[0]["A61I04JJA31I02"].ToString();
                    string nParentID = ChildDt.Rows[0]["A61I10JJA61I02"].ToString();
                    string n31F01 = ChildDt.Rows[0]["A31F01NV0064"].ToString();
                    strSQL += ChildItemAdd(A65I02UV0012, nA61I02, nA61I04, cA61I08, cA61I09, cA61I10, n31F01, PackN, nParentID, cProvidor, cHouse, cDate);
                    existCheckA62(nA61I02);
                    strSQL += setTimeA62(nA61I02, cDate);
                    existCheckA63(nA61I02);
                    strSQL += setDataA63(nA61I02, cCode1, cA63I08, cA63I09, cA63I10, cA63I11, cA63I12, cA63I13, cA63I14, cA63I15, cA63I16);
                }
                if (cCode2 != "" && ChildDt.Rows.Count >= 2)
                {
                    string nA61I02 = ChildDt.Rows[1]["A61I02UV0019"].ToString();
                    string nA61I04 = ChildDt.Rows[1]["A61I04JJA31I02"].ToString();
                    string nParentID = ChildDt.Rows[1]["A61I10JJA61I02"].ToString();
                    string n31F01 = ChildDt.Rows[1]["A31F01NV0064"].ToString();
                    strSQL += ChildItemAdd(A65I02UV0012, nA61I02, nA61I04, cA61I08, cA61I09, cA61I10, n31F01, PackN, nParentID, cProvidor, cHouse, cDate);
                    existCheckA62(nA61I02);
                    strSQL += setTimeA62(nA61I02, cDate);
                    existCheckA63(nA61I02);
                    strSQL += setDataA63(nA61I02, cCode2, cA63I08, cA63I09, cA63I10, cA63I11, cA63I12, cA63I13, cA63I14, cA63I15, cA63I16);
                }
                if (cCode3 != "" && ChildDt.Rows.Count >= 3)
                {
                    string nA61I02 = ChildDt.Rows[2]["A61I02UV0019"].ToString();
                    string nA61I04 = ChildDt.Rows[2]["A61I04JJA31I02"].ToString();
                    string nParentID = ChildDt.Rows[2]["A61I10JJA61I02"].ToString();
                    string n31F01 = ChildDt.Rows[2]["A31F01NV0064"].ToString();
                    strSQL += ChildItemAdd(A65I02UV0012, nA61I02, nA61I04, cA61I08, cA61I09, cA61I10, n31F01, PackN, nParentID, cProvidor, cHouse, cDate);
                    existCheckA62(nA61I02);
                    strSQL += setTimeA62(nA61I02, cDate);
                    existCheckA63(nA61I02);
                    strSQL += setDataA63(nA61I02, cCode3, cA63I08, cA63I09, cA63I10, cA63I11, cA63I12, cA63I13, cA63I14, cA63I15, cA63I16);
                }
                if (cCode4 != "" && ChildDt.Rows.Count >= 4)
                {
                    string nA61I02 = ChildDt.Rows[3]["A61I02UV0019"].ToString();
                    string nA61I04 = ChildDt.Rows[3]["A61I04JJA31I02"].ToString();
                    string nParentID = ChildDt.Rows[3]["A61I10JJA61I02"].ToString();
                    string n31F01 = ChildDt.Rows[3]["A31F01NV0064"].ToString();
                    strSQL += ChildItemAdd(A65I02UV0012, nA61I02, nA61I04, cA61I08, cA61I09, cA61I10, n31F01, PackN, nParentID, cProvidor, cHouse, cDate);
                    existCheckA62(nA61I02);
                    strSQL += setTimeA62(nA61I02, cDate);
                    existCheckA63(nA61I02);
                    strSQL += setDataA63(nA61I02, cCode4, cA63I08, cA63I09, cA63I10, cA63I11, cA63I12, cA63I13, cA63I14, cA63I15, cA63I16);
                }
                if (cCode5 != "" && ChildDt.Rows.Count >= 5)
                {
                    string nA61I02 = ChildDt.Rows[4]["A61I02UV0019"].ToString();
                    string nA61I04 = ChildDt.Rows[4]["A61I04JJA31I02"].ToString();
                    string nParentID = ChildDt.Rows[4]["A61I10JJA61I02"].ToString();
                    string n31F01 = ChildDt.Rows[4]["A31F01NV0064"].ToString();
                    strSQL += ChildItemAdd(A65I02UV0012, nA61I02, nA61I04, cA61I08, cA61I09, cA61I10, n31F01, PackN, nParentID, cProvidor, cHouse, cDate);
                    existCheckA62(nA61I02);
                    strSQL += setTimeA62(nA61I02, cDate);
                    existCheckA63(nA61I02);
                    strSQL += setDataA63(nA61I02, cCode5, cA63I08, cA63I09, cA63I10, cA63I11, cA63I12, cA63I13, cA63I14, cA63I15, cA63I16);
                }
            }
            ChildDt = null;
        }
                                     
        return strSQL;   
    }
    public string getA68I02(string A67I02UV0012)
    {

        string A68I02UV0019 = A66I02.ToString();
        A68I02UV0019 = A67I02UV0012 + "J" + A68I02UV0019.PadLeft(6, '0');
        A66I02 = A66I02 + 1;
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
    public string setDataA63(string A61I02UV0019, string A63I03CV0032,string A63F08CV0064, string A63F09CV0128, string A63I10CV0032, string A63I11CV0032, string A63I12CV0032, string A63I13CV0032, string A63I14CV0032, string A63I15CV0032, string A63I16CV0032)
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
    public string setDataA61(string A61I02UV0019, string A61F01NV0064, string A61I20CV0020)
    {
        string strSQL = "";
        Sql.ClearQuery();
        Sql.SetData("A61I11CV0001", "A");
        Sql.SetData("A61I05JJA19I02", A61I05JJA19I02);
        Sql.SetData("A61I12JJA12I02", A61I12JJA12I02);
        Sql.SetData("A61I20CV0020", A61I20CV0020);
        Sql.SetData("A61F01NV0064", A61F01NV0064);
        Sql.SetWhere("or", "A61I02UV0019", "=", A61I02UV0019, true);
        Sql.SetWhere("or", "A61I10JJA61I02", "=", A61I02UV0019, true);
        strSQL += Sql.getUpdateSQL("A61") + "\r\n";
        return strSQL;
    }
    public string setTimeA62(string A61I02UV0019,string cDate)
    {
        string strSQL = "";
        Sql.ClearQuery();
        Sql.SetData("A62D01", cDate);
        Sql.SetData("A62T01", "000000");
        Sql.SetData("A62A01", cDate + "000000");
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

    public string OrderItemAdd(string A65I02UV0012, string A66I02UV0019, string A61I04JJA31I02, string A61I08CV0001, string A61I09CV0001, string A61I10JJA61I02, string A61F01NV0064, string PackN, string cProvidor, string cHouse, string cDate)
    {
        DataTable dt = new DataTable();
        bool IsChild = false;
        string strSQL = "";      
        Sql.ClearQuery();
        Sql.SetData("A66I02UV0019", A66I02UV0019);
        Sql.SetData("A66I03JJA65I02", A65I02UV0012);
        Sql.SetNData("A66I04JJA31I02", A61I04JJA31I02);
        Sql.SetNData("A66I07CV0001", Sort);
        Sql.SetData("A66I08CV0001", A61I08CV0001);
        Sql.SetData("A66I09CV0001", A61I09CV0001);
        Sql.SetData("A66I12JJA12I02", cProvidor);
        Sql.SetData("A66I05JJA19I02", cHouse);
        Sql.SetData("A66F01NV0064", Pub_Function.setSingleQuotation(A61F01NV0064));
        Sql.SetData("A66I20CV0020", PackN);
        Sql.SetData("A66I11CV0001", "A");
        Sql.SetData("A66D01", cDate);
        Sql.SetData("A66IND", oDate.IND);
        Sql.SetData("A66INT", oDate.INT);
        Sql.SetData("A66INA", oDate.INA);
        Sql.SetData("A66UPD", oDate.IND);
        Sql.SetData("A66UPT", oDate.INT);
        Sql.SetData("A66UPA", oDate.INA);
        strSQL += Sql.getInserSQL("A66") + "\r\n";
        return strSQL;
    }
    public string ChildItemAdd(string A65I02UV0012, string A66I02UV0019, string A61I04JJA31I02, string A61I08CV0001, string A61I09CV0001, string A61I10JJA61I02, string A61F01NV0064, string PackN, string ParentID, string cProvidor, string cHouse, string cDate)
    {
        DataTable dt = new DataTable();
        bool IsChild = false;
        string strSQL = "";
        Sql.ClearQuery();
        Sql.SetData("A66I02UV0019", A66I02UV0019);
        Sql.SetData("A66I03JJA65I02", A65I02UV0012);
        Sql.SetNData("A66I04JJA31I02", A61I04JJA31I02);
        Sql.SetNData("A66I07CV0001", Sort);
        Sql.SetData("A66I08CV0001", A61I08CV0001);
        Sql.SetData("A66I09CV0001", "V");
        Sql.SetData("A66I10JJA66I02", ParentID);
        Sql.SetData("A66I12JJA12I02", cProvidor);
        Sql.SetData("A66I05JJA19I02", cHouse);
        Sql.SetData("A66F01NV0064", Pub_Function.setSingleQuotation(A61F01NV0064));
        Sql.SetData("A66I20CV0020", PackN);
        Sql.SetData("A66I11CV0001", "A");
        Sql.SetData("A66D01", cDate);
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
    
    public bool IsReusable {
        get {
            return false;
        }
    }

}