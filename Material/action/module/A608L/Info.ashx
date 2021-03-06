﻿<%@ WebHandler Language="C#" Class="Info" %>

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
        Dictionary<string, string> codeArray = new Dictionary<string, string>();
        oValue.setRequestGet("A74I02JJA67I02,A74I03JJA12I02,A74I04JJA31I02,A74D01");
        string thisOut = "";
        string WebUrl = PageBase.WebRoute.ToString();
        HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);
        HttpContext.Current.Response.Cache.SetExpires(DateTime.MinValue);
        HttpContext.Current.Response.Cache.SetNoStore();
        string SQL;
        string A74I02JJA67I02 = oValue.Data("A74I02JJA67I02");
        string A74I03JJA12I02 = oValue.Data("A74I03JJA12I02");
        string A74I04JJA31I02 = oValue.Data("A74I04JJA31I02");
        string A74D01 = oValue.Data("A74D01");
        string strW = "";
        DataSet Ds = new DataSet();
        DataTable CodeDt = new DataTable();
        if (oValue.Data("A74I02JJA67I02") != "")
        {
            SQL = "select A68I02UV0019,A12F01NV0064,A31F01NV0064,A68D01  from A68 left join A12 on A68I13JJA12I02=A12I02UV0010 LEFT join A31 on A68I04JJA31I02=A31I02UV0010  where A68I09CV0001='' ";
            SQL += " and A68I03JJA67I02='" + A74I02JJA67I02 + "' and A68I04JJA31I02='" + A74I04JJA31I02 + "' and A68I13JJA12I02='" + A74I03JJA12I02 + "' and A68D01='" + A74D01 + "'";
            dt = Sql.selectTable(SQL, "A68");
            oTemplate.SetTemplatesDir(pb.ActionTemplateName + "module/");
            oTemplate.SetTemplateFileCharset(pb.InfoTemplateName, "UTF-8");
            oTemplate.SetVariable_HTML("A74I02JJA67I02", oValue.Data("A74I02JJA67I02"), 12);
            //oTemplate.SetVariable_HTML("A31F01NV0064_INPUT", A31F01NV0064, 64);
            //oTemplate.SetVariable_HTML("Action", "Add", 3);        
            string strWhere ="";
            if (dt != null)
            {

                SQL = "select A68I02UV0019,A63I03CV0032,A68I10JJA68I02 from A68 left join A63 on  A68I02UV0019 = A63I02JJA61I02 where ";
                for (int r = 0; r < dt.Rows.Count; r++)
                {
                    if (strWhere != "") { strWhere += " or "; }
                    strWhere += " A68I02UV0019='" + dt.Rows[r]["A68I02UV0019"].ToString() + "' or A68I10JJA68I02='" + dt.Rows[r]["A68I02UV0019"].ToString() + "' ";
                }
                SQL = SQL + strWhere;
                CodeDt = Sql.selectTable(SQL, "A68c");
                dt.Columns.Add("A63I03CV0032");

                for (int x = 0; x < CodeDt.Rows.Count; x++) {
                    string cA68I02 = CodeDt.Rows[x]["A68I02UV0019"].ToString();
                    string cA68I10 = CodeDt.Rows[x]["A68I10JJA68I02"].ToString();
                    for (int y = 0; y < dt.Rows.Count; y++) { 
                        string pA68I02 =dt.Rows[y]["A68I02UV0019"].ToString();
                        if (cA68I02 == pA68I02 || cA68I10 == pA68I02)
                        {
                            if (dt.Rows[y]["A63I03CV0032"] != "" && dt.Rows[y]["A63I03CV0032"] != DBNull.Value)
                            {
                                dt.Rows[y]["A63I03CV0032"] += " | ";
                           }
                            dt.Rows[y]["A63I03CV0032"] += CodeDt.Rows[x]["A63I03CV0032"].ToString();
                           break;
                        }                                                                    
                    }
                }                
            }
                            
            oTemplate.UpdateBlock("List1");
            if (dt != null)
            {                                                                
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    for (int s = 0; s < dt.Columns.Count; s++)
                    {
                        string pRName = dt.Columns[s].ColumnName;
                        string pRValue = dt.Rows[i][pRName].ToString();                        
                        oTemplate.SetVariable(pRName, pRValue);                     
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