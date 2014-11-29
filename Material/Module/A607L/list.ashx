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
        DataTable dt = new DataTable();
        string thisOut = "";
        string WebUrl = PageBase.WebRoute.ToString();
        oValue.setRequestGet("Action");
        HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);
        HttpContext.Current.Response.Cache.SetExpires(DateTime.MinValue);
        HttpContext.Current.Response.Cache.SetNoStore();

        oTemplate.SetTemplatesDir(pb.SiteFunctionTemplateName );
        oTemplate.SetTemplateFileCharset(pb.ListTemplateName , "UTF-8");

        oTemplate.SetVariable("WebUrl", PageBase.WebRoute.ToString());
        oTemplate.SetVariable("Action", oValue.Data("Action"));
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