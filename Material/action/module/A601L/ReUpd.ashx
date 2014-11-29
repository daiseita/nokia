<%@ WebHandler Language="C#" Class="Arrival" %>

using System;
using System.Web;
using System.Data;
public class Arrival : IHttpHandler {
    PageBase pb = new PageBase();
    Cls_Request oValue = new Cls_Request();
    Cls_SQL Sql = new Cls_SQL();
    Cls_Template oTemplate = new Cls_Template();
    Cls_Date oDate = new Cls_Date();
    Cls_SA_Fields saFiled = new Cls_SA_Fields();
    DataTable dt = new DataTable();
    Cls_CodeTransfer oCode = new Cls_CodeTransfer();
    public int A61I02 = 0;
    string ParentID = "";
    string A61I03JJA60I02;
    string A61I04JJA31I02;
    string A61D01;
    string pNum;
    string pNewDate;
    public void ProcessRequest (HttpContext context) {

        oValue.setRequestGet("Action,A61I03JJA60I02,A61I04JJA31I02,A61D01,Num,NewDate");

         A61I03JJA60I02 = oValue.Data("A61I03JJA60I02");
         A61I04JJA31I02 = oValue.Data("A61I04JJA31I02");
         A61D01 = oValue.Data("A61D01");
         pNum = oValue.Data("Num");
         pNewDate = oValue.Data("NewDate");        
        
        string RtnMsg = "";
        
        if (A61I03JJA60I02 != "" && A61I04JJA31I02 != "")
        {
            string SQL = "select A61I02UV0019,A61I03JJA60I02,A61I04JJA31I02,A61I07CV0001,A61I08CV0001,A61F01NV0064 from A61 where A61I03JJA60I02='" + A61I03JJA60I02 + "' and A61I04JJA31I02='" + A61I04JJA31I02 + "' and A61D01='" + A61D01 + "' and A61I11CV0001 <> '' order by A61I02UV0019 desc";
            dt = Sql.selectTable(SQL, "A61n");
            if(dt!=null){
            
                context.Response.Write("alert('已有資料入庫不允許變更數量');");
                return;
            }
            
            oDate.RecordNow();
            SQL = "select A61I02UV0019,A61I03JJA60I02,A61I04JJA31I02,A61I07CV0001,A61I08CV0001,A61F01NV0064 from A61 where A61I03JJA60I02='" + A61I03JJA60I02 + "' and A61I04JJA31I02='" + A61I04JJA31I02 + "' and A61D01='" + A61D01 + "' order by A61I02UV0019 desc";
            dt = Sql.selectTable(SQL, "A61");
            if (dt != null)
            {                
                if (dt.Rows.Count > Convert.ToInt32(pNum))
                {
                   //減少
                    int MinusNum = dt.Rows.Count - Convert.ToInt32(pNum);
                    RtnMsg = MinusA61(dt, MinusNum, A61I03JJA60I02, A61D01);
                    context.Response.Write(RtnMsg);
                }            
                else
                {
                    //增加
                    int PlusNum = Convert.ToInt32(pNum) - dt.Rows.Count;


                    RtnMsg = PluseA61(dt, PlusNum, A61I03JJA60I02, A61D01);
                    context.Response.Write(RtnMsg);
                }

                
            }
            else {

                context.Response.Write("alert('none');");
            }
           
        }
    }
    public string PluseA61(DataTable dt, int PlusNum, string A61I03JJA60I02, string A61D01)
    {
        //A61I02代碼
        string SQL = "";
        string strSQL = "";
        DataTable recordset = new DataTable();
        recordset = null;
        if (PlusNum > 0)
        {
            Sql.ClearQuery();
            SQL = "select A61I02UV0019 from A61 where left(A61I02UV0019,12)='" + A61I03JJA60I02 + "' order by A61I02UV0019 Desc ";
            recordset = Sql.selectTable(SQL, "A61s");
            if (recordset != null)
            {
                string pStr = recordset.Rows[0]["A61I02UV0019"].ToString();
                pStr = pStr.Substring(12, 7);
                A61I02 = Convert.ToInt32(pStr) + 1;
            }
            //子項查詢
            DataTable ChildDt = new DataTable();
            Sql.ClearQuery();
            SQL = "select A61I02UV0019,A61I03JJA60I02,A61I04JJA31I02,A61I07CV0001,A61I08CV0001,A61F01NV0064,A61I09CV0001 from A61 where A61I10JJA61I02='" + dt.Rows[0]["A61I02UV0019"].ToString() + "' order by A61I02UV0019 Desc ";
            ChildDt = Sql.selectTable(SQL, "A61c");
            for (int i = 0; i < PlusNum; i++)
            {

                strSQL += OrderSQL_InsertA61(A61I03JJA60I02, A61I02.ToString(), dt.Rows[i]["A61I03JJA60I02"].ToString(), dt.Rows[i]["A61I04JJA31I02"].ToString(), dt.Rows[i]["A61I07CV0001"].ToString(), dt.Rows[i]["A61I08CV0001"].ToString(), "", "", dt.Rows[i]["A61F01NV0064"].ToString(), A61D01);
                if (ChildDt != null)
                {
                    for (int p = 0; p < ChildDt.Rows.Count; p++)
                    {
                        A61I02 += 1;
                        strSQL += Child_InsertA61(A61I03JJA60I02, A61I02.ToString(), ChildDt.Rows[p]["A61I03JJA60I02"].ToString(), ChildDt.Rows[p]["A61I04JJA31I02"].ToString(), ChildDt.Rows[p]["A61I07CV0001"].ToString(), ChildDt.Rows[p]["A61I08CV0001"].ToString(), "V", ParentID, ChildDt.Rows[p]["A61F01NV0064"].ToString(), A61D01);
                    }
                }
                A61I02 += 1;
            }
        }
        if (pNewDate != A61D01) {
            if (Cls_Rule.IsNumeric(pNewDate) == false) {
                return "alert('請檢查日期格式，請輸入8碼日期yyyyhhss')";
            }
            strSQL += " Update A61 set A61D01='" + pNewDate + "' where A61I03JJA60I02='" + A61I03JJA60I02 + "' and A61I04JJA31I02='" + A61I04JJA31I02 + "' and A61D01='" + A61D01 + "' " + "\r\n";       
        }
        string RtnMsg = Pub_Function.executeSQL(strSQL);
        switch (RtnMsg)
        {
            case "":
                return "";
            case "success":
                return "LoadAjaxList();alert('新增成功!!');LoadInfo('" + A61I03JJA60I02 + "');";
            case "fail":
                return "alert('error-2')";
            default:
                return "alert('error-3')";
        }
       
    }

    /* 明細新增 */
    public string OrderSQL_InsertA61(string A60I02UV0012, string A61I02, string A61I03JJA60I02, string A61I04JJA31I02, string A61I07CV0001, string A61I08CV0001, string A61I09CV0001, string A61I10JJA61I02, string A61F01NV0064, string A61D01)
    {
        string strSQL = "";
        string str = "";
        string A61I02UV0019 = "";
        str = A61I02.ToString();
        A61I02UV0019 = A60I02UV0012 + str.PadLeft(7, Convert.ToChar("0"));
        ParentID = A61I02UV0019;
        Sql.ClearQuery();
        Sql.SetData("A61I02UV0019", A61I02UV0019);
        Sql.SetData("A61I03JJA60I02", A61I03JJA60I02);
        Sql.SetNData("A61I04JJA31I02", A61I04JJA31I02);
        Sql.SetData("A61I07CV0001", A61I07CV0001);
        Sql.SetData("A61I08CV0001", A61I08CV0001);
        Sql.SetData("A61I09CV0001", A61I09CV0001);
        Sql.SetData("A61I10JJA61I02", A61I10JJA61I02);
        Sql.SetData("A61F01NV0064", Pub_Function.setSingleQuotation(A61F01NV0064));
        Sql.SetData("A61D01", A61D01);
        Sql.SetData("A61IND", oDate.IND);
        Sql.SetData("A61INT", oDate.INT);
        Sql.SetData("A61INA", oDate.INA);
        Sql.SetData("A61UPD", oDate.IND);
        Sql.SetData("A61UPT", oDate.INT);
        Sql.SetData("A61UPA", oDate.INA);
        strSQL += Sql.getInserSQL("A61") + "\r\n";        
        return strSQL;
    }
    public string Child_InsertA61(string A60I02UV0012, string A61I02, string A61I03JJA60I02, string A61I04JJA31I02, string A61I07CV0001, string A61I08CV0001, string A61I09CV0001, string A61I10JJA61I02, string A61F01NV0064, string A61D01)
    {
        string strSQL = "";
        string str = "";
        string A61I02UV0019 = "";
        str = A61I02.ToString();
        A61I02UV0019 = A60I02UV0012 + str.PadLeft(7, Convert.ToChar("0"));
        Sql.ClearQuery();
        Sql.SetData("A61I02UV0019", A61I02UV0019);
        Sql.SetData("A61I03JJA60I02", A61I03JJA60I02);
        Sql.SetNData("A61I04JJA31I02", A61I04JJA31I02);
        Sql.SetData("A61I07CV0001", A61I07CV0001);
        Sql.SetData("A61I08CV0001", A61I08CV0001);
        Sql.SetData("A61I09CV0001", A61I09CV0001);
        Sql.SetData("A61I10JJA61I02", A61I10JJA61I02);
        Sql.SetData("A61F01NV0064", Pub_Function.setSingleQuotation(A61F01NV0064));
        Sql.SetData("A61D01", A61D01);
        Sql.SetData("A61IND", oDate.IND);
        Sql.SetData("A61INT", oDate.INT);
        Sql.SetData("A61INA", oDate.INA);
        Sql.SetData("A61UPD", oDate.IND);
        Sql.SetData("A61UPT", oDate.INT);
        Sql.SetData("A61UPA", oDate.INA);
        strSQL += Sql.getInserSQL("A61") + "\r\n";
        return strSQL;
    }
    public string MinusA61(DataTable dt, int MinusNum, string A61I03JJA60I02, string A61D01)
    {
        string strSQL = "";
        for (int i = 0; i < MinusNum; i++)
        {
            string A61I02UV0019 = dt.Rows[i]["A61I02UV0019"].ToString();            
            Sql.ClearQuery();
            Sql.SetWhere("or", "A61I02UV0019", "=", A61I02UV0019, true);
            Sql.SetWhere("or", "A61I10JJA61I02", "=", A61I02UV0019, true);
            strSQL += Sql.getDelteSQL("A61") + "\r\n";
        }
        if (pNewDate != A61D01)
        {
            if (Cls_Rule.IsNumeric(pNewDate) == false)
            {
                return "alert('請檢查日期格式，請輸入8碼日期yyyyhhss')";
            }
            strSQL += " Update A61 set A61D01='" + pNewDate + "' where A61I03JJA60I02='" + A61I03JJA60I02 + "' and A61I04JJA31I02='" + A61I04JJA31I02 + "' and A61D01='" + A61D01 + "' " + "\r\n";
        }

        string RtnMsg = Pub_Function.executeSQL(strSQL);
        switch (RtnMsg)
        {
            case "":
                return "alert('error-1')";
            case "success":
                return "LoadAjaxList();alert('刪除成功!!');LoadInfo('" + A61I03JJA60I02 + "');";
            case "fail":
                return "alert('error-2')";
            default:
                return "alert('error-3')";
        }        
    }
    public bool IsReusable {
        get {
            return false;
        }
    }

}
