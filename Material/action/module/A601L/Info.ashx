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
        oValue.setRequestGet("A60I02UV0012");
        string thisOut = "";
        string WebUrl = PageBase.WebRoute.ToString();
        HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);
        HttpContext.Current.Response.Cache.SetExpires(DateTime.MinValue);
        HttpContext.Current.Response.Cache.SetNoStore();
        string SQL;
        string A31F01NV0064 = oValue.Data("A60I02UV0012");
        if (oValue.Data("A60I02UV0012") != "")
        {
            SQL = "select count(A61I02UV0019)Total,A31F01NV0064,A61I04JJA31I02,A61D01 from A61  left join A31 on A61I04JJA31I02 = A31I02UV0010 " +
                "where A61I09CV0001 <>'V' and A61I03JJA60I02='" + oValue.Data("A60I02UV0012") + "' group by A31F01NV0064,A61D01,A61I04JJA31I02";
            dt = Sql.selectTable(SQL, "A60");
            oTemplate.SetTemplatesDir(pb.ActionTemplateName + "module/");
            oTemplate.SetTemplateFileCharset(pb.InfoTemplateName, "UTF-8");
            //oTemplate.SetVariable_HTML("A31I11JJA31I02", oValue.Data("A31I02UV0010"), 10);
            oTemplate.SetVariable_HTML("A60I02UV0012", oValue.Data("A60I02UV0012"), 12);
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
                        if (pRName == "A61D01")
                        {
                            oTemplate.SetVariable_HTML("A61D01_S", pRValue, saFiled.GetColumeLength(pRName));                        
                            pRValue = pRValue.Substring(0, 4) + "/" + pRValue.Substring(4, 2) + "/" + pRValue.Substring(6, 2);                            
                        }
                        oTemplate.SetVariable_HTML(pRName, pRValue, saFiled.GetColumeLength(pRName));
                    };                    
                    oTemplate.SetVariable_HTML("serial", (i+1).ToString(), 4);
                    oTemplate.ParseBlock("List1");
                }
            }
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