<%@ WebHandler Language="C#" Class="CountList" %>

using System;
using System.Web;
using System.Data;
public class CountList : IHttpHandler {

    public void ProcessRequest(HttpContext context)
    {
        PageBase pb = new PageBase();
        Cls_Request oValue = new Cls_Request();
        Cls_SQL Sql = new Cls_SQL();
        Cls_Template oTemplate = new Cls_Template();
        Cls_Date oDate = new Cls_Date();
        Cls_SA_Fields saFiled = new Cls_SA_Fields();
        DataTable dt = new DataTable();
        oValue.setRequestGet("A68I13JJA12I02");
        string thisOut = "";
        string WebUrl = PageBase.WebRoute.ToString();
        HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);
        HttpContext.Current.Response.Cache.SetExpires(DateTime.MinValue);
        HttpContext.Current.Response.Cache.SetNoStore();
        string SQL;
        string A68I13JJA12I02 = oValue.Data("A68I13JJA12I02");
        SQL = "select count(A68I04JJA31I02)pSum,A31F01NV0064,A68I04JJA31I02 from A68 left join A31 on A68I04JJA31I02 = A31I02UV0010 " +
              "where A68I13JJA12I02='" + oValue.Data("A68I13JJA12I02") + "' and A68I11CV0001='C'   and A68I09CV0001='' " +
              "group by A31F01NV0064,A68I04JJA31I02";
        dt = Sql.selectTable(SQL, "A60");
        oTemplate.SetTemplatesDir(pb.ActionTemplateName + "module/");
        oTemplate.SetTemplateFileCharset("A607L_countlist_A68_content.html", "UTF-8");
        //oTemplate.SetVariable_HTML("A31I11JJA31I02", oValue.Data("A31I02UV0010"), 10);
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
                oTemplate.SetVariable_HTML("serial", (i + 1).ToString(), 4);
                oTemplate.ParseBlock("List1");
            }
        }

        dt = null; SQL = "select A12F01NV0064 from A12 where A12I02UV0010='" + A68I13JJA12I02 + "'";
        dt = Sql.selectTable(SQL, "A12");
        if (dt != null)
        {
            oTemplate.SetVariable_HTML("A12F01NV0064", dt.Rows[0]["A12F01NV0064"].ToString(), 32);
        }
        else {
            oTemplate.SetVariable_HTML("A12F01NV0064", "", 32);
        }
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