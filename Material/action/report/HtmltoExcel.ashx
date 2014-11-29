<%@ WebHandler Language="C#" Class="Info" %>

using System;
using System.Web;
using System.Data;
using System.Collections.Generic;
using System.Text.RegularExpressions;
public class Info : IHttpHandler {

    string Sort = "L";
    PageBase pb = new PageBase();
    Cls_Request oValue = new Cls_Request();
    Cls_SQL Sql = new Cls_SQL();    
    Cls_Date oDate = new Cls_Date();
    Cls_SA_Fields saFiled = new Cls_SA_Fields();
    Dictionary<string, string> CompanyData = new Dictionary<string, string>();
    public void ProcessRequest(HttpContext context)
    {
        Cls_Template oTemplate = new Cls_Template();
        DataTable dt = new DataTable();
        Cls_File oFile = new Cls_File();
        oValue.setRequestGet("filename");
        oValue.setRequestPost("ExcelHTML");      
        string thisOut = "";
        string WebUrl = PageBase.WebRoute.ToString();
        HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);
        HttpContext.Current.Response.Cache.SetExpires(DateTime.MinValue);
        HttpContext.Current.Response.Cache.SetNoStore();
        string FileName = oValue.Data("filename");        
        string SQL;
        if (FileName != "")
        {

            string pHtml = oFile.ReadTextCharSet(@"\upload\temp\", FileName + ".txt","UTF-8");
            
            ExcelUtil eu = new ExcelUtil("test", "test01");
            eu.AddGrid(pHtml, "統計表");
            eu.Export(context, FileName);
            
            
            

            context.Response.ContentType = "text/plain";
            context.Response.Write("");
        }
        else {
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