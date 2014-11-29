<%@ WebHandler Language="C#" Class="Arrival" %>

using System;
using System.Web;
using System.Data;
using System.Collections;
using System.Collections.Generic;
public class Arrival : IHttpHandler {
    PageBase pb = new PageBase();
    Cls_Request oValue = new Cls_Request();
    Cls_SQL Sql = new Cls_SQL();
    Cls_Template oTemplate = new Cls_Template();
    Cls_Date oDate = new Cls_Date();
    Cls_SA_Fields saFiled = new Cls_SA_Fields();
    DataTable dt = new DataTable();
    Cls_CodeTransfer oCode = new Cls_CodeTransfer();
    public int A72I02 = 1;
    string ParentID = "";
    string A61I05JJA19I02 = "";
    string A71I02UV0010 = "";
    public void ProcessRequest (HttpContext context) {

        oValue.setRequestGet("Action,A71I02UV0010");
        A71I02UV0010 = oValue.Data("A71I02UV0010");        
        if (oValue.Data("Action") != "Operate")
        {
            context.Response.ContentType = "text/plain";
            context.Response.Write("");
            return;
        }
        else {
            
            OrderDataOperate(context);
        }                                                                    
    }
    Dictionary<string, int> codeArray = new Dictionary<string, int>();
    
    public void OrderDataOperate(HttpContext context)
    {
        Language_Msg Ms = new Language_Msg();
        oDate.RecordNow();
        //A61I05JJA19I02 = oValue.Data("A61I05JJA19I02");
        oDate.RecordNow();
        /* A71代碼產生*/
        DataSet OrderDataSst = new DataSet();
        DataTable dt = new DataTable();                
        dt = Sql.selectTable("select A71F03NT from A71 where A71I02UV0010='" + A71I02UV0010 + "'", "A71");

        

        //A72I02代碼        
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
        string pContent = dt.Rows[0]["A71F03NT"].ToString();
        string strSQL = "";
        dt = null;
        strSQL += setDataA71(A71I02UV0010);
        strSQL += setDataA72(A71I02UV0010);
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
                string SQL = "select top " + item.Value.ToString() + " A68I02UV0019,A68I04JJA31I02,A68I13JJA12I02 from A68 where A68I04JJA31I02='" + cA31I02 + "' and A68I13JJA12I02='" + cA12I20 + "' and A68I11CV0001='C' order by A68INA,A68I02UV0019";
                dt = Sql.selectTable(SQL, item.Key.ToString());
                if (dt == null || dt.Rows.Count < Convert.ToInt32(item.Value))
                {
                    context.Response.Write("alert('" + Ms.Msg23 + "');");                    
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
                strSQL += setDataA61(OrderDataSst.Tables[p].Rows[r]["A68I02UV0019"].ToString(), OrderDataSst.Tables[p].Rows[r]["A68I13JJA12I02_New"].ToString());
                strSQL += setDataA66(OrderDataSst.Tables[p].Rows[r]["A68I02UV0019"].ToString(), OrderDataSst.Tables[p].Rows[r]["A68I13JJA12I02_New"].ToString());
                strSQL += setDataA68(OrderDataSst.Tables[p].Rows[r]["A68I02UV0019"].ToString(), OrderDataSst.Tables[p].Rows[r]["A68I13JJA12I02_New"].ToString());
                strSQL += OrderItemAdd(OrderDataSst.Tables[p].Rows[r]["A68I02UV0019"].ToString(), OrderDataSst.Tables[p].Rows[r]["A68I13JJA12I02"].ToString(), OrderDataSst.Tables[p].Rows[r]["A68I13JJA12I02_New"].ToString(), OrderDataSst.Tables[p].Rows[r]["A68I04JJA31I02"].ToString());
                A72I02 += 1;
            }
        }

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
    public string setDataA71(string A71I02UV0010)
    {
        string strSQL = "";
        Sql.ClearQuery();
        //Sql.SetData("A61I11CV0001", "B");
        Sql.SetData("A71I03CV0001", "V");
        Sql.SetWhere("and", "A71I02UV0010", "=", A71I02UV0010, true);
        strSQL += Sql.getUpdateSQL("A71") + "\r\n";
        return strSQL;
    }
    public string setDataA72(string A71I02UV0010)
    {
        string strSQL = "";
        Sql.ClearQuery();                
        Sql.SetWhere("and", "A72I07JJA71I02", "=", A71I02UV0010, true);        
        strSQL += Sql.getDelteSQL("A72") + "\r\n";
        return strSQL;
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

    public string OrderItemAdd(string A72I03CV0019, string A72I05JJA12I02, string A72I06JJA12I02, string A72I08JJA31I02)
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
        Sql.SetData("A72I04CV0001", "V");
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
    public bool IsReusable {
        get {
            return false;
        }
    }

}
