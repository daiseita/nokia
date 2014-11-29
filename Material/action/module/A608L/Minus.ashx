<%@ WebHandler Language="C#" Class="Info" %>

using System;
using System.Web;
using System.Data;
public class Info : IHttpHandler {

    string Sort = "L";
    PageBase pb = new PageBase();
    Cls_Request oValue = new Cls_Request();
    Cls_SQL Sql = new Cls_SQL();    
    Cls_Date oDate = new Cls_Date();
    Cls_SA_Fields saFiled = new Cls_SA_Fields();
    public void ProcessRequest(HttpContext context)
    {
        Cls_Template oTemplate = new Cls_Template();
        DataTable dt = new DataTable();        
        oValue.setRequestGet("GroupID");
        string GroupID = oValue.Data("GroupID");
        string thisOut = "";
        string WebUrl = PageBase.WebRoute.ToString();
        HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);
        HttpContext.Current.Response.Cache.SetExpires(DateTime.MinValue);
        HttpContext.Current.Response.Cache.SetNoStore();
        Language_Msg Ms = new Language_Msg();
        string SQL;
        string strSQL = "";
        string OperateTyep = "A61";
        if (GroupID != "")
        {
            string strWhere ="";
            string[] A68I02 = GroupID.Split(',');
            for(int i=0;i< A68I02.Length ;i++){
                if (strWhere != "") { strWhere += " or "; }
              strWhere +=  " A68I02UV0019='"+A68I02[i]+"' or A68I10JJA68I02='"+A68I02[i]+"' ";
            }
            if (strWhere == "") { context.Response.Write("alert('error-1')"); return; }

            SQL = "select A68I02UV0019,A68I05JJA19I02,A68I12JJA12I02,A68I21CV0001 from A68 where " + strWhere;
            dt = Sql.selectTable(SQL, "A68");
            if (dt != null) {
                string A61I11 = "";
                if (dt.Rows[0]["A68I21CV0001"].ToString() == "")
                {
                    OperateTyep = "A66";
                    A61I11 = "A";
                }
                if (OperateTyep == "A66")
                {
                    for (int x = 0; x < dt.Rows.Count; x++)
                    {
                        strSQL += setDataA61(dt.Rows[x]["A68I02UV0019"].ToString(), dt.Rows[x]["A68I12JJA12I02"].ToString(), "", "A");
                        strSQL += setDataA66(dt.Rows[x]["A68I02UV0019"].ToString(), dt.Rows[x]["A68I12JJA12I02"].ToString(), "", "A");
                        strSQL += setTimeA62(dt.Rows[x]["A68I02UV0019"].ToString(),"");
                        strSQL += deleteA68(dt.Rows[x]["A68I02UV0019"].ToString());
                    }

                }
                else {
                    for (int x = 0; x < dt.Rows.Count; x++)
                    {
                        strSQL += setDataA61(dt.Rows[x]["A68I02UV0019"].ToString(), "", "", "");
                        strSQL += deleteA66(dt.Rows[x]["A68I02UV0019"].ToString());
                        strSQL += setTimeA62(dt.Rows[x]["A68I02UV0019"].ToString(),"V");
                        strSQL += deleteA68(dt.Rows[x]["A68I02UV0019"].ToString());
                    }
                }
                                               
            }            
            string RtnMsg = Pub_Function.executeSQL(strSQL);
            switch (RtnMsg)
            {
                case "":
                    context.Response.Write("alert('" + Ms.Msg13 + "');");
                    break;
                case "success":
                    context.Response.Write("alert('" + Ms.Msg06 + "');goReload();");
                    break;
                case "fail":
                    context.Response.Write("alert('" + Ms.Msg05 + "');");
                    break;
                default:
                    break;
            }
        }
        else {
            context.Response.Write("alert('error-2')");
        }

        
    }
    public string setDataA61(string A61I02UV0019, string A61I12JJA12I02, string A61I13JJA12I02, string A61I11CV0001)
    {
        string strSQL = "";
        Sql.ClearQuery();
        Sql.SetData("A61I11CV0001", A61I11CV0001);
        Sql.SetData("A61I12JJA12I02", A61I12JJA12I02);
        Sql.SetData("A61I13JJA12I02", A61I13JJA12I02);
        Sql.SetWhere("and", "A61I02UV0019", "=", A61I02UV0019, true);
        //Sql.SetWhere("or", "A61I10JJA61I02", "=", A61I02UV0019, true);
        strSQL += Sql.getUpdateSQL("A61") + "\r\n";
        return strSQL;
    }
    public string setDataA66(string A61I02UV0019, string A61I12JJA12I02, string A61I13JJA12I02, string A61I11CV0001)
    {
        string strSQL = "";
        Sql.ClearQuery();
        Sql.SetData("A66I11CV0001", A61I11CV0001);
        Sql.SetData("A66I12JJA12I02", A61I12JJA12I02);
        Sql.SetData("A66I13JJA12I02", A61I13JJA12I02);
        Sql.SetWhere("and", "A66I02UV0019", "=", A61I02UV0019, true);
        //Sql.SetWhere("or", "A66I10JJA66I02", "=", A61I02UV0019, true);
        strSQL += Sql.getUpdateSQL("A66") + "\r\n";
        return strSQL;
    }
    public string setTimeA62(string A61I02UV0019, string A68I21CV0001)
    {
        string strSQL = "";
        Sql.ClearQuery();
        if (A68I21CV0001 == "V") {
            Sql.SetData("A62D01", "");
            Sql.SetData("A62T01", "");
            Sql.SetData("A62A01", "");
        }
        Sql.SetData("A62D02", "");
        Sql.SetData("A62T02", "");
        Sql.SetData("A62A02", "");
        Sql.SetWhere("And", "A62I02JJA61I02", "=", A61I02UV0019, true);
        strSQL += Sql.getUpdateSQL("A62") + "\r\n";
        return strSQL;
    }
    public string deleteA68(string A61I02UV0019)
    {
        string strSQL = "";
        Sql.ClearQuery();
        Sql.SetWhere("And", "A68I02UV0019", "=", A61I02UV0019, true);
        strSQL += Sql.getDelteSQL("A68") + "\r\n";
        return strSQL;
    }

    public string deleteA66(string A61I02UV0019)
    {
        string strSQL = "";
        Sql.ClearQuery();
        Sql.SetWhere("And", "A66I02UV0019", "=", A61I02UV0019, true);
        strSQL += Sql.getDelteSQL("A66") + "\r\n";
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