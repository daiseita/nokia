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
        oValue.setRequestGet("A67I02UV0012,A12I02UV0010");
        string thisOut = "";
        string WebUrl = PageBase.WebRoute.ToString();
        HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);
        HttpContext.Current.Response.Cache.SetExpires(DateTime.MinValue);
        HttpContext.Current.Response.Cache.SetNoStore();
        string SQL;
        string A31F01NV0064 = oValue.Data("A67I02UV0012");
        string A12I02UV0010 = oValue.Data("A12I02UV0010");
        string strW = "";
        if (A12I02UV0010 != "") { strW = " and A68I13JJA12I02='" + A12I02UV0010 + "' "; }
        if (oValue.Data("A67I02UV0012") != "")
        {
            SQL = "select COUNT(A68I04JJA31I02 )cnt,A68I04JJA31I02,A68I13JJA12I02,L12.A12F01NV0064,A31F01NV0064,A31I08CV0001,R12.A12F01NV0064,A68D01  from A68 left join (select A12I02UV0010,A12F01NV0064 from A12)L12 " +
                  "on A68I13JJA12I02=L12.A12I02UV0010 left join (select A12I02UV0010,A12F01NV0064 from A12)R12 on A68I12JJA12I02=R12.A12I02UV0010 LEFT join A31 on A68I04JJA31I02=A31I02UV0010 where A68I03JJA67I02='" + oValue.Data("A67I02UV0012") + "' and A68I09CV0001='' " + strW +
                  " group by A68I04JJA31I02,A68I13JJA12I02,L12.A12F01NV0064,R12.A12F01NV0064,A31F01NV0064,A31I08CV0001,A68D01";
            dt = Sql.selectTable(SQL, "A60");
            oTemplate.SetTemplatesDir(pb.ActionTemplateName + "module/");
            oTemplate.SetTemplateFileCharset(pb.Info_S_TemplateName , "UTF-8");
            oTemplate.SetVariable_HTML("A67I02UV0012", oValue.Data("A67I02UV0012"), 12);
            //oTemplate.SetVariable_HTML("A31F01NV0064_INPUT", A31F01NV0064, 64);
            //oTemplate.SetVariable_HTML("Action", "Add", 3);
            string ContractorID = "";
            string DateID = "";
            string checker = "";            
            oTemplate.UpdateBlock("List1");
            if (dt != null)
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    for (int s = 0; s < dt.Columns.Count; s++)
                    {
                        string pRName = dt.Columns[s].ColumnName;
                        string pRValue = dt.Rows[i][pRName].ToString();
                        if (pRName == "A68D01")
                        {
                            oTemplate.SetVariable_HTML("A68D01_S", pRValue, saFiled.GetColumeLength(pRName));
                            pRValue = pRValue.Substring(0, 4) + "/" + pRValue.Substring(4, 2) + "/" + pRValue.Substring(6, 2);                            
                        }
                        oTemplate.SetVariable_HTML(pRName, pRValue, saFiled.GetColumeLength(pRName));
                        if (pRName == "A68I13JJA12I02") {
                            if (checker != pRValue + dt.Rows[i]["A68D01"].ToString())
                            {
                                if (ContractorID != "") { ContractorID += ","; }
                                ContractorID += pRValue + dt.Rows[i]["A68D01"].ToString();
                            }
                            checker = pRValue + dt.Rows[i]["A68D01"].ToString();
                        }
                        
                    };
                    oTemplate.SetVariable_HTML("A31I08CV0001_NAME", oCode.ExportData("A31I08CV0001", dt.Rows[i]["A31I08CV0001"].ToString()), 6);
                    oTemplate.SetVariable_HTML("A68I03JJA67I02", oValue.Data("A67I02UV0012"), 12);
                    oTemplate.SetVariable_HTML("serial", (i+1).ToString(), 4);
                    oTemplate.ParseBlock("List1");
                }
                oTemplate.SetVariable_HTML("ContractorID", ContractorID, 512);
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