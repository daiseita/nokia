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
    public void ProcessRequest (HttpContext context) {

        oValue.setRequestGet("Action,A73I02JJA67I02,A73I03JJA12I02,A73D01,A73I04JJA31I02");
        if (oValue.Data("Action") != "") {             
            if(oValue.Data("Action")=="Del"){                
                context.Response.Write( Cancel(context));
                return;
            }else{
                context.Response.Write(ArrivalStatus(context));
             return ;
            }
        }
        string A73I02JJA67I02 = oValue.Data("A73I02JJA67I02");
        string A73I03JJA12I02 = oValue.Data("A73I03JJA12I02");
        string A73D01 = oValue.Data("A73D01");
        string A73I04JJA31I02 = oValue.Data("A73I04JJA31I02");
        string RtnMsg = "";
        if (A73I02JJA67I02 != "" && A73I03JJA12I02 != "")
        {
            if (DataExist(A73I02JJA67I02, A73I03JJA12I02, A73D01, A73I04JJA31I02) == false)
            {
                Language_Msg Ms = new Language_Msg();
                string strSQL = "";
                oDate.RecordNow();

                Sql.SetData("A73I02JJA67I02", A73I02JJA67I02);
                Sql.SetData("A73I03JJA12I02", A73I03JJA12I02);
                Sql.SetData("A73I04JJA31I02", A73I04JJA31I02);
                Sql.SetData("A73D01", A73D01);
                Sql.SetData("A73IND", oDate.IND);
                Sql.SetData("A73INT", oDate.INT);
                Sql.SetData("A73INA", oDate.INA);

                strSQL += Sql.getInserSQL("A73") + "\r\n";

                strSQL += "UPDATE A62 SET A62.A62D02 = '" + oDate.IND + "',A62.A62T02 = '" + oDate.INT + "',A62.A62A02 = '" + oDate.INA + "'" +
                    " FROM A68 Left JOIN A62 ON A68.A68I02UV0019 = A62.A62I02JJA61I02 where A68I03JJA67I02 ='" + A73I02JJA67I02 + "' and A68I13JJA12I02='" + A73I03JJA12I02 + "' and A68I04JJA31I02='" + A73I04JJA31I02 + "' \r\n";
                dt = null;
                string strWhereA61 = "";
                string strWhereA66 = "";
                string strWhereA68 = "";
                string strD = "select A68I02UV0019 from A68 where A68I03JJA67I02 ='" + A73I02JJA67I02 + "' and A68I13JJA12I02='" + A73I03JJA12I02 + "' and A68I04JJA31I02 ='" + A73I04JJA31I02 + "'";
                dt = Sql.selectTable(strD, "A68");
                if (dt != null)
                {
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        if (strWhereA61 != "") { strWhereA61 += " or "; }
                        strWhereA61 += " A61I02UV0019 ='" + dt.Rows[i]["A68I02UV0019"].ToString() + "' ";
                        if (strWhereA66 != "") { strWhereA66 += " or "; }
                        strWhereA66 += " A66I02UV0019 ='" + dt.Rows[i]["A68I02UV0019"].ToString() + "' ";
                        if (strWhereA68 != "") { strWhereA68 += " or "; }
                        strWhereA68 += " A68I02UV0019 ='" + dt.Rows[i]["A68I02UV0019"].ToString() + "' ";
                    }

                    strSQL += " update A61 set A61I11CV0001='C' where " + strWhereA61 + "\r\n";
                    strSQL += " update A66 set A66I11CV0001='C' where " + strWhereA66 + "\r\n";
                    strSQL += " update A68 set A68I11CV0001='C' where " + strWhereA68 + "\r\n";
                }


                context.Response.ContentType = "text/plain";
                RtnMsg = Pub_Function.executeSQL(strSQL);
                switch (RtnMsg)
                {
                    case "":
                        context.Response.Write(Ms.Msg13);
                        break;
                    case "success":
                        context.Response.Write("OK");
                        break;
                    case "fail":
                        context.Response.Write(Ms.Msg05);
                        break;
                    default:
                        break;
                }
            }
            else {
                context.Response.Write("exist");
                return;
            }
                       
        }
    }

    //get到貨狀態
    public string ArrivalStatus(HttpContext context)
    {
        oValue.setRequestGet("Action,A73I02JJA67I02,A73I03JJA12I02,A73D01,A73I04JJA31I02");
        string A73I02JJA67I02 = oValue.Data("A73I02JJA67I02");
        string A73I03JJA12I02 = oValue.Data("A73I03JJA12I02");
        string A73D01 = oValue.Data("A73D01");
        string A73I04JJA31I02 = oValue.Data("A73I04JJA31I02");
        if (DataExist(A73I02JJA67I02, A73I03JJA12I02, A73D01, A73I04JJA31I02))
        {
            return "OK";
        }
        else
        {
            return "none";
        }
    }
    public bool DataExist(string A73I02JJA67I02, string A73I03JJA12I02, string A73D01, string A73I04JJA31I02)
    {
        string str = "select A73I02JJA67I02 from A73 where A73I02JJA67I02='" + A73I02JJA67I02 + "' and A73I03JJA12I02='" + A73I03JJA12I02 + "'  and A73D01='" + A73D01 + "' and A73I04JJA31I02='" + A73I04JJA31I02 + "'";
        dt = Sql.selectTable(str, "A73");
        if (dt != null)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    public string Cancel(HttpContext context)
    {
         Language_Msg Ms = new Language_Msg();
         oValue.setRequestGet("Action,A73I02JJA67I02,A73I03JJA12I02,A73D01,A73I04JJA31I02");
        string A73I02JJA67I02 = oValue.Data("A73I02JJA67I02");
        string A73I03JJA12I02 = oValue.Data("A73I03JJA12I02");
        string A73D01 = oValue.Data("A73D01");
        string A73I04JJA31I02 = oValue.Data("A73I04JJA31I02");
        string RtnMsg = "";
        string strSQL = "delete from A73 where A73I02JJA67I02='" + A73I02JJA67I02 + "' and A73I03JJA12I02='" + A73I03JJA12I02 + "' and A73D01='" + A73D01 + "' and A73I04JJA31I02='" + A73I04JJA31I02 + "' \r\n";
        /* 時間 */
        //strSQL += "UPDATE A62 SET A62.A62D02 = '',A62.A62T02 = '',A62.A62A02 = ''" +
        //             " FROM A68 Left JOIN A62 ON A68.A68I02UV0019 = A62.A62I02JJA61I02 where A68I03JJA67I02 ='" + A73I02JJA67I02 + "' and A68I13JJA12I02='" + A73I03JJA12I02 + "' and A68D01='" + A73D01 + "' \r\n";
        
        dt = null;
        string strWhereA61 = "";
        string strWhereA66 = "";
        string strWhereA68 = "";
        string strD = "select A68I02UV0019 from A68 where A68I03JJA67I02 ='" + A73I02JJA67I02 + "' and A68I13JJA12I02='" + A73I03JJA12I02 + "'  and A68D01='" + A73D01 + "'";
        dt = Sql.selectTable(strD, "A68");
        if (dt != null)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (strWhereA61 != "") { strWhereA61 += " or "; }
                strWhereA61 += " A61I02UV0019 ='" + dt.Rows[i]["A68I02UV0019"].ToString() + "' ";
                if (strWhereA66 != "") { strWhereA66 += " or "; }
                strWhereA66 += " A66I02UV0019 ='" + dt.Rows[i]["A68I02UV0019"].ToString() + "' ";
                if (strWhereA68 != "") { strWhereA68 += " or "; }
                strWhereA68 += " A68I02UV0019 ='" + dt.Rows[i]["A68I02UV0019"].ToString() + "' ";
            }

            strSQL += " update A61 set A61I11CV0001='B' where " + strWhereA61 + "\r\n";
            strSQL += " update A66 set A66I11CV0001='B' where " + strWhereA66 + "\r\n";
            strSQL += " update A68 set A68I11CV0001='B' where " + strWhereA68 + "\r\n";
        }
        
        string Msg ="";
        RtnMsg = Pub_Function.executeSQL(strSQL);
        switch (RtnMsg)
        {
            case "":
                Msg = Ms.Msg13;
                break;
            case "success":
                Msg = "OK";
                break;
            case "fail":
                Msg = Ms.Msg05;
                break;
            default:
                break;
        }
        return Msg;
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}
