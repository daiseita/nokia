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
        oValue.setRequestGet("A65I02UV0012");
        string thisOut = "";
        string WebUrl = PageBase.WebRoute.ToString();
        HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);
        HttpContext.Current.Response.Cache.SetExpires(DateTime.MinValue);
        HttpContext.Current.Response.Cache.SetNoStore();
        string SQL;
        string A31F01NV0064 = oValue.Data("A65I02UV0012");
        if (oValue.Data("A65I02UV0012") != "")
        {
            SQL = "select COUNT(A66I04JJA31I02 )cnt,A66I04JJA31I02,A66I13JJA12I02,A19F01NV0032,A31F06NV0032,A31I08CV0001 ,A12F01NV0064,A66D01 from A66 left join A19  on A66I05JJA19I02=A19I02UV0004 " +
                  "LEFT join A31 on A66I04JJA31I02=A31I02UV0010 Left join A12 on A66I12JJA12I02=A12I02UV0010  where A66I03JJA65I02='" + oValue.Data("A65I02UV0012") + "' and A66I09CV0001=''  group by " +
                  "A66I04JJA31I02,A66I13JJA12I02,A19F01NV0032,A31F06NV0032,A31I08CV0001,A12F01NV0064,A66D01";
            Sql.sqlTransferColumn = "A31I08CV0001";
            dt = Sql.selectTable(SQL, "A60");
            oTemplate.SetTemplatesDir(pb.ActionTemplateName + "module/");
            oTemplate.SetTemplateFileCharset(pb.Info_S_TemplateName, "UTF-8");
            oTemplate.SetVariable_HTML("A65I02UV0012", oValue.Data("A65I02UV0012"), 12);
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
                        if (pRName == "A66D01")
                        {
                            oTemplate.SetVariable_HTML("A66D01_S", pRValue, saFiled.GetColumeLength(pRName));
                            pRValue = pRValue.Substring(0, 4) + "/" + pRValue.Substring(4, 2) + "/" + pRValue.Substring(6, 2);
                        }
                        oTemplate.SetVariable_HTML(pRName, pRValue, saFiled.GetColumeLength(pRName));
                    };
                    oTemplate.SetVariable_HTML("A66I03JJA65I02", oValue.Data("A65I02UV0012"), 12);
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