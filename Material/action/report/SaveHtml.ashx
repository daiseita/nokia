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
    Cls_File oFile = new Cls_File();
    
    public void ProcessRequest(HttpContext context)
    {
        Cls_Template oTemplate = new Cls_Template();
        DataTable dt = new DataTable();

        oValue.setRequestPost("iHTML,filename");      
        string thisOut = "";
        string WebUrl = PageBase.WebRoute.ToString();
        HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);
        HttpContext.Current.Response.Cache.SetExpires(DateTime.MinValue);
        HttpContext.Current.Response.Cache.SetNoStore();

        string ThisHtml = oValue.Data("iHTML");
        string FileName = oValue.Data("filename");      
        string SQL;
        if (ThisHtml != "")
        {
            oFile.DeleteFile(@"\upload\temp\", FileName + ".txt");
            oFile.FileExist(@"\upload\temp\", FileName + ".txt", true);
            oFile.WriteTextCharSet(@"\upload\temp\", FileName + ".txt", ThisHtml, "UTF-8", true);           
            context.Response.ContentType = "text/plain";
            context.Response.Write("goExport('" + FileName + "');");
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