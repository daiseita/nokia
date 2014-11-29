<%@ WebHandler Language="C#" Class="Info" %>

using System;
using System.Web;
using System.Data;
using System.Collections.Generic;
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
        Cls_CodeTransfer oCode = new Cls_CodeTransfer();
        Dictionary<string, string> ItemArray = new Dictionary<string, string>();
        oValue.setRequestGet("A63I15CV0032");
        string thisOut = "";
        string WebUrl = PageBase.WebRoute.ToString();
        HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);
        HttpContext.Current.Response.Cache.SetExpires(DateTime.MinValue);
        HttpContext.Current.Response.Cache.SetNoStore();
        string SQL;
        string A63I15CV0032 = oValue.Data("A63I15CV0032");
        if (oValue.Data("A63I15CV0032") != "")
        {
            SQL = " select COUNT(A61I20CV0020)cnt ,A61I20CV0020,A31F06NV0032 from (select A61I20CV0020,A31F06NV0032 from A61 left " +
                  "join A63 on A61I02UV0019 = A63I02JJA61I02 left join A31 On A61I04JJA31I02 = A31I02UV0010  where A61I11CV0001 ='A' and " +
                  "A61I10JJA61I02=''  and A63I15CV0032  ='" + A63I15CV0032 + "' )A63 group by A61I20CV0020,A31F06NV0032 ";
            dt = Sql.selectTable(SQL, "A63");
            oTemplate.SetTemplatesDir(pb.ActionTemplateName + "module/");
            oTemplate.SetTemplateFileCharset("A603G_CheckPackingList_content.html", "UTF-8");
            //oTemplate.SetVariable_HTML("A67I02UV0012", oValue.Data("A67I02UV0012"), 12);
            //oTemplate.SetVariable_HTML("A31F01NV0064_INPUT", A31F01NV0064, 64);
            //oTemplate.SetVariable_HTML("Action", "Add", 3);
            
            
            oTemplate.UpdateBlock("List1");
            if (dt != null)
            {
                for (int k = 0; k < dt.Rows.Count; k++)
                {
                    string str = dt.Rows[k]["A31F06NV0032"].ToString() + " 數量 X " + dt.Rows[k]["cnt"].ToString();
                    if (ItemArray.ContainsKey(dt.Rows[k]["A61I20CV0020"].ToString()))
                    {
                        ItemArray[dt.Rows[k]["A61I20CV0020"].ToString()] += "<div style='padding:0px 2px;float:right'>" + str + "</div>";
                    }
                    else
                    {
                        ItemArray.Add(dt.Rows[k]["A61I20CV0020"].ToString(), "<div style='padding:0px 2px;float:right'>" + str + "</div>");
                    }
                }
                
                int i = 0;
                foreach (KeyValuePair<string, string> flag in ItemArray)
                {
                    oTemplate.SetVariable("PackNum", flag.Key );
                    oTemplate.SetVariable("HtmlTag", flag.Value);
                    oTemplate.SetVariable_HTML("serial", (i + 1).ToString(), 4);
                    oTemplate.ParseBlock("List1");
                }
                               
            }
            //dt = null;
            //string LastDes = "";
            //string Descriptiion = ""; 
            //SQL = "select A63F09CV0128 from A63 where A63I15CV0032='" + A63I15CV0032 + "'";
            //dt = Sql.selectTable(SQL, "des");
            //if (dt != null) {
            //    for (int i = 0; i < dt.Rows.Count; i++)
            //    {
            //        if (LastDes != dt.Rows[i][0].ToString()) {
            //            if (Descriptiion != "") { Descriptiion += "   |    "; }
            //            Descriptiion += dt.Rows[i][0].ToString();
            //        }
            //        LastDes = dt.Rows[i][0].ToString();
            //    }           
            //}
            //oTemplate.SetVariable("Description", Descriptiion);
            thisOut = oTemplate.GetOutput();

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