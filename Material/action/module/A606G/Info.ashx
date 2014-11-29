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
        Cls_CodeTransfer oCode = new Cls_CodeTransfer();
        oValue.setRequestGet("A69I02UV0010");
        string thisOut = "";
        string WebUrl = PageBase.WebRoute.ToString();
        HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);
        HttpContext.Current.Response.Cache.SetExpires(DateTime.MinValue);
        HttpContext.Current.Response.Cache.SetNoStore();
        string SQL;
        string A31F01NV0064 = oValue.Data("A69I02UV0010");        
        if (oValue.Data("A69I02UV0010") != "")
        {
            SQL = "select COUNT(A70I08JJA31I02 )cnt,A31F01NV0064,L19.A19F01NV0032,R19.A19F01NV0032 from A70 Left join A31 on A70I08JJA31I02 = A31I02UV0010 left join (select A19I02UV0004,A19F01NV0032 from A19)L19 " +
                  "on A70I05JJA19I02 = L19.A19I02UV0004 left join (select A19I02UV0004,A19F01NV0032 from A19)R19 on A70I06JJA19I02 = R19.A19I02UV0004 where A70I07JJA69I02='" + oValue.Data("A69I02UV0010") + "' group by A31F01NV0064,L19.A19F01NV0032,R19.A19F01NV0032";
            dt = Sql.selectTable(SQL, "A69");
            oTemplate.SetTemplatesDir(pb.ActionTemplateName + "module/");
            oTemplate.SetTemplateFileCharset(pb.InfoTemplateName, "UTF-8");
            //oTemplate.SetVariable_HTML("A67I02UV0012", oValue.Data("A67I02UV0012"), 12);
            //oTemplate.SetVariable_HTML("A31F01NV0064_INPUT", A31F01NV0064, 64);
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

                    oTemplate.SetVariable_HTML("A69I02UV0010", oValue.Data("A69I02UV0010"), 12);
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