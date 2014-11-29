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
        oValue.setRequestGet("A71I02UV0010");
        string thisOut = "";
        string WebUrl = PageBase.WebRoute.ToString();
        HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);
        HttpContext.Current.Response.Cache.SetExpires(DateTime.MinValue);
        HttpContext.Current.Response.Cache.SetNoStore();
        string SQL;
        string A31F01NV0064 = oValue.Data("A71I02UV0010");        
        if (oValue.Data("A71I02UV0010") != "")
        {
            SQL = "select COUNT(A72I08JJA31I02 )cnt,A31F01NV0064,L12.A12F01NV0064,R12.A12F01NV0064 from A72 Left join A31 on A72I08JJA31I02 = A31I02UV0010 left join (select A12I02UV0010,A12F01NV0064 from A12)L12 " +
                  "on A72I05JJA12I02 = L12.A12I02UV0010 left join (select A12I02UV0010,A12F01NV0064 from A12)R12 on A72I06JJA12I02 = R12.A12I02UV0010 where A72I07JJA71I02='" + oValue.Data("A71I02UV0010") + "' group by A31F01NV0064,L12.A12F01NV0064,R12.A12F01NV0064";
            dt = Sql.selectTable(SQL, "A71");
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

                    oTemplate.SetVariable_HTML("A71I02UV0010", oValue.Data("A71I02UV0010"), 12);
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