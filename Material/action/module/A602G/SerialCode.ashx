<%@ WebHandler Language="C#" Class="Info" %>

using System;
using System.Web;
using System.Data;
public class Info : IHttpHandler {

    public void ProcessRequest(HttpContext context)
    {
        PageBase pb = new PageBase();
        Cls_Request oValue = new Cls_Request();
        Cls_SQL Sql = new Cls_SQL();
        Cls_Template oTemplate = new Cls_Template();
        Cls_Date oDate = new Cls_Date();
        Cls_SA_Fields saFiled = new Cls_SA_Fields();
        DataTable dt = new DataTable();
        oValue.setRequestGet("A63I02JJA61I02");
        string thisOut = "";
        string WebUrl = PageBase.WebRoute.ToString();
        HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);
        HttpContext.Current.Response.Cache.SetExpires(DateTime.MinValue);
        HttpContext.Current.Response.Cache.SetNoStore();
        string SQL;
        string A63I02JJA61I02 = oValue.Data("A63I02JJA61I02");        
        if (A63I02JJA61I02 != "")
        {
            SQL = "select A63I03CV0032 from A66  left join A63 on A66I02UV0019 = A63I02JJA61I02 where A66I10JJA66I02 ='" + A63I02JJA61I02 + "' order by A66I02UV0019 ";
            dt = Sql.selectTable(SQL, "A66");
            if (dt != null) {
                for (int x = 0; x < dt.Rows.Count; x++)
                {
                    if (thisOut != "") { thisOut += " | "; }
                    thisOut += dt.Rows[x][0].ToString();
                }
            }
            

            context.Response.ContentType = "text/plain";
            context.Response.Write(thisOut);
        }
        else
        {
            context.Response.ContentType = "text/plain";
            context.Response.Write("");
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}