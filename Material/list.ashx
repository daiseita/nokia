<%@ WebHandler Language="C#" Class="A10_list" %>

using System;
using System.Web;
using System.Data;
public class A10_list : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        PageBase pb = new PageBase();
        Cls_Request oValue = new Cls_Request();
        Cls_SQL Sql = new Cls_SQL();
        Cls_Template oTemplate = new Cls_Template();
        Cls_Date oDate = new Cls_Date();
        Cls_SA_Fields saFiled = new Cls_SA_Fields();
        DataTable dt = new DataTable();
        oValue.setRequestGet("A60I02UV0012");
        string thisOut = "";
        string WebUrl = PageBase.WebRoute.ToString();
        HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);
        HttpContext.Current.Response.Cache.SetExpires(DateTime.MinValue);
        HttpContext.Current.Response.Cache.SetNoStore();
        string SQL;
        string A31F01NV0064 = oValue.Data("A60I02UV0012");
        SQL = "select A31I01XA,A31I02UV0010,A31F01NV0064,A31I12FD0200  from A31";
        dt = Sql.selectTable(SQL, "A31");
        oTemplate.SetTemplatesDir("/");
        oTemplate.SetTemplateFileCharset("Sample_list_content.html", "UTF-8");
        //oTemplate.SetVariable_HTML("A31I11JJA31I02", oValue.Data("A31I02UV0010"), 10);
        //oTemplate.SetVariable_HTML("A60I02UV0012", oValue.Data("A60I02UV0012"), 12);
        //oTemplate.SetVariable_HTML("Action", "Add", 3);
        oTemplate.UpdateBlock("List1");
        if (dt != null)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                for (int s = 0; s < dt.Columns.Count; s++)
                {
                    string pRName = dt.Columns[s].ColumnName;
                    string pRValue = dt.Rows[i][pRName].ToString();
                    
                    oTemplate.SetVariable_HTML(pRName, pRValue, saFiled.GetColumeLength(pRName));
                    
                };             
                oTemplate.ParseBlock("List1");
            }
        }
        thisOut = oTemplate.GetOutput();

        context.Response.ContentType = "text/plain";
        context.Response.Write(thisOut);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}