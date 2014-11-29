<%@ WebHandler Language="C#" Class="Info" %>

using System;
using System.Web;
using System.Data;
public class Info : IHttpHandler {

    string Sort = "G";
    PageBase pb = new PageBase();
    Cls_Request oValue = new Cls_Request();
    Cls_SQL Sql = new Cls_SQL();    
    Cls_Date oDate = new Cls_Date();
    Cls_SA_Fields saFiled = new Cls_SA_Fields();
    public void ProcessRequest(HttpContext context)
    {
        Cls_Template oTemplate = new Cls_Template();
        DataTable dt = new DataTable();
        
        oValue.setRequestGet("A66D01");
        string A66D01 = oValue.Data("A66D01");
        string thisOut = "";
        string WebUrl = PageBase.WebRoute.ToString();
        HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);
        HttpContext.Current.Response.Cache.SetExpires(DateTime.MinValue);
        HttpContext.Current.Response.Cache.SetNoStore();
        string SQL;
        
        if (A66D01 != "")
        {

            ExcelUtil eu = new ExcelUtil("test", "test01");
            string Office = "1234";
            string pHtml = getExcel(A66D01, "B000000015", "Contractor");
            eu.AddGrid(pHtml, Office);
            eu.Export(context, A66D01);                

            context.Response.ContentType = "text/plain";
            context.Response.Write("");
        }
        else {
            context.Response.ContentType = "text/plain";
            context.Response.Write("");
        }

        
    }

    public string getExcel(string A66D01, string strA12,string cType)
    {
        Cls_Template oTemplate = new Cls_Template();
        string pHtml = "";
        string SQL = "";
        SQL = "select A12I02UV0010,A12F05NV0256,A20F07CV0032,A02F01NV0016,A03F01NV0016,A20F01NV0006,A12F01NV0064 from A12 left join A20 On A12I02UV0010 = A20I10JJA12I02 left join A02 on " +
                  " A12I08JJA02I02 = A02I02UV0002   left join A03 on A12I09JJA03I02=A03I02UV0003 where A12I02UV0010='" + strA12 + "'";
        
        DataTable dt = new DataTable();
        //dt = Sql.selectTable(SQL, "A66n");
        //oTemplate.SetTemplatesDir(pb.ExcelTemplateName);
        //if (cType == "Contractor")
        //{
        //    oTemplate.SetTemplateFileCharset("PackingList_Title_C_content.html", "UTF-8");
        //}
        //else
        //{
        //    oTemplate.SetTemplateFileCharset("PackingList_Title_P_content.html", "UTF-8");
        //}
        //oTemplate.SetVariable("A66D01", A66D01);
        
        //if (dt != null)
        //{
        //    for (int s = 0; s < dt.Columns.Count; s++)
        //    {
        //        string pRName = dt.Columns[s].ColumnName;
        //        string pRValue = dt.Rows[0][pRName].ToString();
        //        oTemplate.SetVariable_HTML(pRName, pRValue, saFiled.GetColumeLength(pRName));
        //    };
        //}
        //dt = null;

        //if (cType == "Contractor")
        //{
        //    SQL = "select DISTINCT A66I03JJA67I02 ,A66I13JJA12I02,A67F02NV0128 from A66 left join A67 On A66I03JJA67I02 =A67I02UV0012  where A66I07CV0001='" + Sort + "' " +
        //       " and A66D01='" + A66D01 + "' and  A66I13JJA12I02='" + strA12 + "' and A67F02NV0128 <>'' and A66I10JJA66I02=''";

        //}
        //else
        //{
        //    SQL = "select DISTINCT A66I03JJA67I02 ,A66I13JJA12I02,A67F02NV0128 from A66 left join A67 On A66I03JJA67I02 =A67I02UV0012  where A66I07CV0001='" + Sort + "' " +
        //      " and A66D01='" + A66D01 + "' and  A66I12JJA12I02='" + strA12 + "' and A67F02NV0128 <>'' and A66I10JJA66I02=''";

        //}
        
        //string strInfo = "";
        //dt = Sql.selectTable(SQL, "A67o");
        //if (dt != null)
        //{
            
        //    for (int x = 0; x < dt.Rows.Count ; x++)
        //    {
        //        if (strInfo != "") { strInfo += " | "; }
        //        strInfo += dt.Rows[x]["A67F02NV0128"].ToString();
        //    }
        //}

        //oTemplate.SetVariable("Info", strInfo);
        //pHtml += oTemplate.GetOutput();

        pHtml += getTableItemExcel(A66D01, strA12, cType);
        
        return pHtml;
    }

    public string getTableItemExcel(string A66D01, string strA12, string cType)
    {
        Cls_Template oTemplate = new Cls_Template();
        DataTable CodeDt = new DataTable();
        string pHtml = "";
        string SQL = "";
        SQL = "select distinct A63F09CV0128,A66I20CV0020,A63F08CV0064,A63I11CV0032,A63I12CV0032,A63I13CV0032,A63I14CV0032,A63I15CV0032,A63I16CV0032 from A66 left join A63 on A66I02UV0019 = A63I02JJA61I02 where A66D01=" + A66D01;
        
        DataTable dt = new DataTable();
        dt = Sql.selectTable(SQL, "A66c");
        oTemplate.SetTemplatesDir(pb.ExcelTemplateName);
        oTemplate.SetTemplateFileCharset("PackingList_Serail_Item_content.html", "UTF-8");
        dt.Columns.Add("Code", typeof(string));
        string ThisPack = "";
        string CodeString = "";
        DataSet ds1 = new DataSet();
        ds1.Tables.Add(dt);
        SQL = "select A66I20CV0020 ,A66F01NV0064, A63I03CV0032 from A66 left join A63 on A66I02UV0019 = A63I02JJA61I02 where   A66D01=" + A66D01 + " and A66I10JJA66I02 <> '' order by A66I20CV0020";
        CodeDt = Sql.selectTable(SQL, "A66c");
        if (CodeDt != null) {
            for (int p = 0; p < CodeDt.Rows.Count; p++) { 
                string RowPack = CodeDt.Rows[p]["A66I20CV0020"].ToString();
                if (ThisPack != "" && ThisPack != RowPack)
                {
                    DataRow[] Arrow = ds1.Tables[0].Select("A66I20CV0020 = '" + ThisPack + "' ");
                    Arrow[0]["Code"] = CodeString;
                    CodeString = "";
                }
                ThisPack = RowPack;
                CodeString += CodeDt.Rows[p]["A66F01NV0064"].ToString() + "  [ " + CodeDt.Rows[p]["A63I03CV0032"].ToString() + " ] <br  style=\"mso-data-placement:same-cell;\"> ";
                if (p == CodeDt.Rows.Count - 1) {
                    DataRow[] Arrow = ds1.Tables[0].Select("A66I20CV0020 = '" + ThisPack + "' ");
                    Arrow[0]["Code"] = CodeString;
                    CodeString = "";
                }
            }        
        }
        
        oTemplate.UpdateBlock("List1");
        if (dt != null) {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                for (int s = 0; s < dt.Columns.Count; s++)
                {
                    string pRName = dt.Columns[s].ColumnName;
                    string pRValue = dt.Rows[i][pRName].ToString();
                    oTemplate.SetVariable_HTML(pRName, pRValue, saFiled.GetColumeLength(pRName));
                };                
                //oTemplate.SetVariable_HTML("serial", (i + 1).ToString(), 4);
                oTemplate.ParseBlock("List1");
            }        
        }
        

        pHtml = oTemplate.GetOutput();


        pHtml = pHtml.Replace("&lt;", "<");
        pHtml = pHtml.Replace("&gt;", ">");
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