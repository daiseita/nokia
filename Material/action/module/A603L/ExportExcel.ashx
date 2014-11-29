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
        
        oValue.setRequestGet("A68IND");
        string A68IND = oValue.Data("A68IND");
        string thisOut = "";
        string WebUrl = PageBase.WebRoute.ToString();
        HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);
        HttpContext.Current.Response.Cache.SetExpires(DateTime.MinValue);
        HttpContext.Current.Response.Cache.SetNoStore();

        
        
        string SQL;        
        if (A68IND != "")
        {
            /* 廠商資料 */
            SQL = "select  A12I02UV0010,A12F01NV0064,A20F01NV0006,A20F06CV0032,A20F07CV0032,A12F05NV0256,A02F01NV0016 ,A03F01NV0016  from A12 left join (select A20I10JJA12I02,A20I02UV0010 ,A20F01NV0006,A20F06CV0032,A20F07CV0032 from A20 where A20I03CV0001='B')A20 on A12I02UV0010 = A20I10JJA12I02 left join A02 on A12I08JJA02I02  = A02I02UV0002 left join A03 on A12I09JJA03I02 = A03I02UV0003 ";
            dt = Sql.selectTable(SQL, "Com");
            if (dt != null) {
                for (int y = 0; y < dt.Rows.Count; y++)
                {
                    if (!CompanyData.ContainsKey(dt.Rows[y]["A12I02UV0010"].ToString()))
                    {
                        string strValue = dt.Rows[y]["A12F01NV0064"].ToString() + "," + dt.Rows[y]["A20F01NV0006"].ToString() + "," + dt.Rows[y]["A20F06CV0032"].ToString() + "," + dt.Rows[y]["A20F07CV0032"].ToString() + "," + dt.Rows[y]["A02F01NV0016"].ToString() + "," + dt.Rows[y]["A03F01NV0016"].ToString() + "," + dt.Rows[y]["A12F05NV0256"].ToString();
                        CompanyData.Add(dt.Rows[y]["A12I02UV0010"].ToString(), strValue);
                    }
                }
            }
            dt = null; ;
            SQL = "select DISTINCT A68IND,A68I13JJA12I02,A12F01NV0064 from A68 left join A12 on A68I13JJA12I02 = A12I02UV0010  where A68I07CV0001='" + Sort + "' and A68IND='" + A68IND + "' and A68I10JJA68I02='' order by A68IND,A68I13JJA12I02,A12F01NV0064 desc ";
            dt = Sql.selectTable(SQL, "A68");
            if (dt != null) {
                string strTitle = A68IND + "出貨單";
                ExcelUtil eu = new ExcelUtil("test", "test01");
                for (int s = 0; s < dt.Rows.Count ; s++)
                {
                    string Office = dt.Rows[s]["A12F01NV0064"].ToString();
                    string pHtml = getExcel(dt.Rows[s]["A68IND"].ToString(),dt.Rows[s]["A68I13JJA12I02"].ToString(),"Contractor");
                    eu.AddGrid(pHtml, Office);
                }
                dt = null;
                SQL = "select DISTINCT A68I12JJA12I02,A12F01NV0064 from A68 left join A12 on A68I12JJA12I02 = A12I02UV0010  where A68I07CV0001='" + Sort + "' and A68IND='" + A68IND + "' and   A68I10JJA68I02='' order by A68I12JJA12I02,A12F01NV0064 desc ";
                dt = Sql.selectTable(SQL, "A68p");
                if (dt != null)
                {
                    for (int s = 0; s < dt.Rows.Count; s++)
                    {
                        string Office = dt.Rows[s]["A12F01NV0064"].ToString();
                        string pHtml = getExcel(A68IND, dt.Rows[s]["A68I12JJA12I02"].ToString(), "Providor");
                        eu.AddGrid(pHtml, Office);
                    }
                }
                eu.Export(context, A68IND);
            }                       

            context.Response.ContentType = "text/plain";
            context.Response.Write("");
        }
        else {
            context.Response.ContentType = "text/plain";
            context.Response.Write("");
        }

        
    }

    public string getExcel(string A68IND, string strA12,string cType)
    {
        Cls_Template oTemplate = new Cls_Template();
        string pHtml = "";
        string SQL = "";
        SQL = "select A12I02UV0010,A12F05NV0256,A20F07CV0032,A02F01NV0016,A03F01NV0016,A20F01NV0006,A12F01NV0064 from A12 left join A20 On A12I02UV0010 = A20I10JJA12I02 left join A02 on " +
                  " A12I08JJA02I02 = A02I02UV0002   left join A03 on A12I09JJA03I02=A03I02UV0003 where A12I02UV0010='" + strA12 + "'";
        
        DataTable dt = new DataTable();
        dt = Sql.selectTable(SQL, "A68n");
        oTemplate.SetTemplatesDir(pb.ExcelTemplateName);
        if (cType == "Contractor")
        {
            oTemplate.SetTemplateFileCharset("PackingList_Title_C_content.html", "UTF-8");
        }
        else
        {
            oTemplate.SetTemplateFileCharset("PackingList_Title_P_content.html", "UTF-8");
        }
        
        oTemplate.SetVariable("A68IND", A68IND);
        
        if (dt != null)
        {
            for (int s = 0; s < dt.Columns.Count; s++)
            {
                string pRName = dt.Columns[s].ColumnName;
                string pRValue = dt.Rows[0][pRName].ToString();
                oTemplate.SetVariable_HTML(pRName, pRValue, saFiled.GetColumeLength(pRName));
            };
        }
        dt = null;

        if (cType == "Contractor")
        {
            SQL = "select DISTINCT A68I03JJA67I02 ,A68I13JJA12I02,A67F02NV0128 from A68 left join A67 On A68I03JJA67I02 =A67I02UV0012  where A68I07CV0001='" + Sort + "' " +
               " and A68IND='" + A68IND + "' and  A68I13JJA12I02='" + strA12 + "' and A67F02NV0128 <>'' and A68I10JJA68I02=''";

        }
        else
        {
            SQL = "select DISTINCT A68I03JJA67I02 ,A68I13JJA12I02,A67F02NV0128 from A68 left join A67 On A68I03JJA67I02 =A67I02UV0012  where A68I07CV0001='" + Sort + "' " +
              " and A68IND='" + A68IND + "' and  A68I12JJA12I02='" + strA12 + "' and A67F02NV0128 <>'' and A68I10JJA68I02=''";

        }
        
        string strInfo = "";
        dt = Sql.selectTable(SQL, "A67o");
        if (dt != null)
        {
            
            for (int x = 0; x < dt.Rows.Count ; x++)
            {
                if (strInfo != "") { strInfo += " | "; }
                strInfo += dt.Rows[x]["A67F02NV0128"].ToString();
            }
        }

        oTemplate.SetVariable("Info", strInfo);
        /* title */
        pHtml += oTemplate.GetOutput();
        
        /* 明細 */
        pHtml += getTableItemExcel(A68IND, strA12, cType);
        
        return pHtml;
    }

    public string getTableItemExcel(string A68IND, string strA12, string cType)
    {
        Cls_Template oTemplate = new Cls_Template();
        string pHtml = "";
        string SQL = "";
        if (cType == "Contractor")
        {
            SQL = "select COUNT(A68I04JJA31I02 )cnt,A68I04JJA31I02,A68I12JJA12I02,A68I13JJA12I02,A12F01NV0064,A31F01NV0064,A31I14CV0024,A68D01  from A68 left join A12 " +
                     " on A68I13JJA12I02=A12I02UV0010  LEFT join A31 on A68I04JJA31I02=A31I02UV0010 where  A68I07CV0001='" + Sort + "' and  A68IND='" + A68IND + "' " +
                     " and A68I13JJA12I02='" + strA12 + "'  and A68I10JJA68I02=''  group by A68I04JJA31I02,A68I12JJA12I02,A68I13JJA12I02,A12F01NV0064,A31F01NV0064,A31I14CV0024,A68D01 order by A68D01;;";
        }
        else {
            SQL = "select COUNT(A68I04JJA31I02 )cnt,A68I04JJA31I02,A31F01NV0064,A31I14CV0024,A68D01,A68I13JJA12I02  from A68 left join A12 " +
                     " on A68I13JJA12I02=A12I02UV0010  LEFT join A31 on A68I04JJA31I02=A31I02UV0010 where   A68I07CV0001='" + Sort + "' and  A68IND='" + A68IND + "' " +
                     " and A68I12JJA12I02='" + strA12 + "'  and A68I10JJA68I02=''  group by A68I04JJA31I02,A31F01NV0064,A31I14CV0024,A68D01,A68I13JJA12I02 order by A68D01;";
        }
        DataTable dt = new DataTable();
        dt = Sql.selectTable(SQL, "A68c");
        oTemplate.SetTemplatesDir(pb.ExcelTemplateName);
        if (cType == "Contractor")
        {
            oTemplate.SetTemplateFileCharset("PackingList_Item_C_content.html", "UTF-8");
        }
        else {
            oTemplate.SetTemplateFileCharset("PackingList_Item_P_content.html", "UTF-8");
        }
        oTemplate.UpdateBlock("List1");
        if (dt != null) {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                for (int s = 0; s < dt.Columns.Count; s++)
                {
                    string pRName = dt.Columns[s].ColumnName;
                    string pRValue = dt.Rows[i][pRName].ToString();
                    if (pRName == "A68D01")
                    {                        
                        pRValue = pRValue.Substring(0, 4) + "/" + pRValue.Substring(4, 2) + "/" + pRValue.Substring(6, 2);
                    }
                    
                    oTemplate.SetVariable_HTML(pRName, pRValue, saFiled.GetColumeLength(pRName));
                };                
                oTemplate.SetVariable_HTML("serial", (i + 1).ToString(), 4);
                //A12F01NV0064,A20F01NV0006,A20F06CV0032,A20F07CV0032,A12F05NV0256,A02F01NV0016 ,A03F01NV0016  
                if (cType == "Contractor")
                {
                    string strID = dt.Rows[i]["A68I12JJA12I02"].ToString();
                    if (CompanyData.ContainsKey(strID)) {
                        string[] columeData = Regex.Split(CompanyData[strID], ",");
                        oTemplate.SetVariable("ProvidorName", columeData[0]);
                        oTemplate.SetVariable("Name", columeData[1]);
                        oTemplate.SetVariable("tel01", columeData[2]);
                        oTemplate.SetVariable("tel02", columeData[3]);
                        
                    }
                }
                else {
                    string strID = dt.Rows[i]["A68I13JJA12I02"].ToString();
                    if (CompanyData.ContainsKey(strID))
                    {
                        string[] columeData = Regex.Split(CompanyData[strID], ",");
                        oTemplate.SetVariable("ProvidorName", columeData[0]);
                        oTemplate.SetVariable("Name", columeData[1]);
                        oTemplate.SetVariable("tel01", columeData[2]);
                        oTemplate.SetVariable("tel02", columeData[3]);

                    }
                }
                
                
                oTemplate.ParseBlock("List1");
            }        
        }
        
        pHtml = oTemplate.GetOutput();

        return pHtml;
    }
   

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}