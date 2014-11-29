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
        oValue.setRequestGet("A68I03JJA67I02,A68I04JJA31I02,Action");
        string thisOut = "";
        string WebUrl = PageBase.WebRoute.ToString();
        HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);
        HttpContext.Current.Response.Cache.SetExpires(DateTime.MinValue);
        HttpContext.Current.Response.Cache.SetNoStore();
        string SQL;
        string Sort = "G";
        string A68I03JJA67I02 = oValue.Data("A68I03JJA67I02");
        string A68I04JJA31I02 = oValue.Data("A68I04JJA31I02");
        SQL = "select DISTINCT A66D01 from A66 where A66I07CV0001='" + Sort + "' order by A66D01 desc";
        dt = Sql.selectTable(SQL, "A66");
        oTemplate.SetTemplatesDir(pb.ActionTemplateName + "module/");
        oTemplate.SetTemplateFileCharset("A602G_PackingList_content.html", "UTF-8");
        //oTemplate.SetVariable_HTML("Action", "Add", 3);            
        if (dt != null)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                string str = "";
                string A68IND = dt.Rows[i][0].ToString().Substring(0, 4) + "/" + dt.Rows[i][0].ToString().Substring(4, 2) + "/" + dt.Rows[i][0].ToString().Substring(6, 2);
                oTemplate.SetVariable_HTML_OPTION("A66D01", A68IND, "", dt.Rows[i][0].ToString());
            }
        }
        oTemplate.SetVariable_HTML_SELECT("A66D01");
        
        
        thisOut = oTemplate.GetOutput();

        context.Response.ContentType = "text/plain";
        context.Response.Write(thisOut);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}