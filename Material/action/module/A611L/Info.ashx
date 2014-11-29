<%@ WebHandler Language="C#" Class="Info" %>

using System;
using System.Web;
using System.Data;
using System.Collections.Generic;
public class Info : IHttpHandler {
    PageBase pb = new PageBase();
    Cls_Request oValue = new Cls_Request();
    Cls_SQL Sql = new Cls_SQL();
    Cls_Template oTemplate = new Cls_Template();
    Cls_Date oDate = new Cls_Date();
    Cls_SA_Fields saFiled = new Cls_SA_Fields();
    DataTable dt = new DataTable();
    Cls_CodeTransfer oCode = new Cls_CodeTransfer();
    Dictionary<string, string> CntData1 = new Dictionary<string, string>();
    Dictionary<string, string> CntData2 = new Dictionary<string, string>();
    Dictionary<string, string> CntData3 = new Dictionary<string, string>();
    Dictionary<string, string> CntData4 = new Dictionary<string, string>();
    string A61I07CV0001 = "";
    public void ProcessRequest(HttpContext context)
    {
        
       
        oValue.setRequestGet("A61I07CV0001");
        string thisOut = "";
        string WebUrl = PageBase.WebRoute.ToString();
        HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);
        HttpContext.Current.Response.Cache.SetExpires(DateTime.MinValue);
        HttpContext.Current.Response.Cache.SetNoStore();
        string SQL;
        A61I07CV0001 = oValue.Data("A61I07CV0001");        
        string strW = "";
        DataTable DtCn1 = new DataTable();
        DataTable DtCn2 = new DataTable();
        DataTable DtCn3 = new DataTable();
        DataTable DtCn4 = new DataTable();
        
        if (A61I07CV0001 != "")
        {
            SQL = "select A31I02UV0010,A31F01NV0064 from A31  where A31I05CV0001='" + A61I07CV0001 + "'  and A31I11JJA31I02=''  order by A31F01NV0064";
            dt = Sql.selectTable(SQL, "A31");
            oTemplate.SetTemplatesDir(pb.ActionTemplateName + "module/");
            oTemplate.SetTemplateFileCharset(pb.InfoTemplateName, "UTF-8");
            oTemplate.SetVariable_HTML("A61I07CV0001", oValue.Data("A61I07CV0001"), 1);
            //oTemplate.SetVariable_HTML("A31F01NV0064_INPUT", A31F01NV0064, 64);
            //oTemplate.SetVariable_HTML("Action", "Add", 3);
            string ContractorID = "";
            string DateID = "";
            string checker = "";
            if (dt != null)
            {


                DtCn1 = Sql.selectTable("select COUNT(A61I11CV0001)cntA, A61I04JJA31I02 from A61 where A61I07CV0001='" + A61I07CV0001 + "'  group by A61I04JJA31I02", "CN1");
                DtCn2 = Sql.selectTable("select COUNT(A61I11CV0001)cntA, A61I04JJA31I02 from A61 where (A61I11CV0001='' or A61I11CV0001 = 'B') and A61I07CV0001='" + A61I07CV0001 + "'   group by A61I04JJA31I02", "CN2");
                DtCn3 = Sql.selectTable("select COUNT(A61I11CV0001)cntA, A61I04JJA31I02 from A61 where A61I11CV0001='A' and A61I07CV0001='" + A61I07CV0001 + "'  group by A61I04JJA31I02", "CN3");
                DtCn4 = Sql.selectTable("select COUNT(A61I11CV0001)cntA, A61I04JJA31I02 from A61 where A61I11CV0001 <> '' and A61I11CV0001 <> 'A' and A61I11CV0001 <> 'B' and A61I07CV0001='" + A61I07CV0001 + "'  group by A61I04JJA31I02", "CN4");
                if (DtCn1 != null)
                {
                    CntData1 = DictionaryWork(DtCn1);
                }
                if (DtCn2 != null)
                {
                    CntData2 = DictionaryWork(DtCn2);
                }
                if (DtCn3 != null)
                {
                    CntData3 = DictionaryWork(DtCn3);
                }
                if (DtCn4 != null)
                {
                    CntData4 = DictionaryWork(DtCn4);
                }
                dt.Columns.Add("cnt1", typeof(string));
                dt.Columns.Add("cnt2", typeof(string));
                dt.Columns.Add("cnt3", typeof(string));
                dt.Columns.Add("cnt4", typeof(string));

                dt = TableWork1(dt);
                //包商資料處理
                Sql.ClearQuery();
                DataTable titleDt = new DataTable();
                SQL = "select A12F01NV0064,A12I02UV0010 from A12 where A12I03CV0001 ='B' ";
                titleDt = Sql.selectTable(SQL, "title");
                if (titleDt != null)
                {
                    oTemplate.UpdateBlock("List2");
                    for (int i = 0; i < titleDt.Rows.Count; i++)
                    {
                        oTemplate.SetVariable("Contractor", titleDt.Rows[i][0].ToString());
                        oTemplate.ParseBlock("List2");
                    }
                    dt = TableWork2(dt, titleDt);
                }
                else
                {
                    oTemplate.SetVariable("Contractor", "");
                }
                dt = checkContractor(dt, titleDt);


                string pHtml = "";
                dt.Columns.Add("N1", typeof(string));
                dt.Columns.Add("N2", typeof(string));
                
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    string strN1 = (Convert.ToInt32(dt.Rows[i]["B000000007"]) + Convert.ToInt32(dt.Rows[i]["B000000008"]) + Convert.ToInt32(dt.Rows[i]["B000000009"]) + Convert.ToInt32(dt.Rows[i]["B000000010"])).ToString();
                    string strN2 = (Convert.ToInt32(dt.Rows[i]["B000000011"]) + Convert.ToInt32(dt.Rows[i]["B000000012"]) + Convert.ToInt32(dt.Rows[i]["B000000013"])).ToString();
                    dt.Rows[i]["N1"] = strN1;
                    dt.Rows[i]["N2"] = strN2;
                    pHtml += "<tr >";
                    for (int m = 1; m < dt.Columns.Count; m++)
                    {
                        pHtml += "<td >" + dt.Rows[i][m].ToString() + "</td>";
                    }
                    pHtml += "</tr >";

                }
                oTemplate.SetVariable("HTML", pHtml);


            }
            else {
                oTemplate.SetVariable("Contractor", "");
                oTemplate.SetVariable("HTML", "");
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
    //包商統計
    public DataTable checkContractor(DataTable dt, DataTable contractor)
    {
        DataTable countDt = new DataTable();
        DataSet ds1 = new DataSet();
        ds1.Tables.Add(dt);
        for (int i = 0; i < contractor.Rows.Count; i++)
        {
            countDt = Sql.selectTable("select COUNT(A61I11CV0001)cntA, A61I04JJA31I02,A61I13JJA12I02 from A61 where A61I11CV0001 <> '' and A61I11CV0001 <> 'A' and A61I11CV0001 <> 'B' and A61I07CV0001='" + A61I07CV0001 + "'  group by A61I04JJA31I02,A61I13JJA12I02", "serch");
            if (countDt != null)
            {
                for (int j = 0; j < countDt.Rows.Count; j++)
                {
                    string strA12 = countDt.Rows[j]["A61I13JJA12I02"].ToString();
                    string strKey = countDt.Rows[j]["A61I04JJA31I02"].ToString();
                    string strNum = countDt.Rows[j]["cntA"].ToString();
                    DataRow[] Arrow = ds1.Tables[0].Select("A31I02UV0010 = '" + strKey + "' ");                    
                    Arrow[0][strA12] = strNum;
                }
            }
        }

        return ds1.Tables[0];
    }
    //統計資料暫存
    public Dictionary<string, string> DictionaryWork(DataTable dt) {
         Dictionary<string, string> Work = new Dictionary<string, string>();
         for (int i = 0; i < dt.Rows.Count; i++)
         {
             if (!Work.ContainsKey(dt.Rows[i][1].ToString()))
             {

                 Work.Add(dt.Rows[i][1].ToString(), dt.Rows[i][0].ToString());
             }
         }
        
        return Work;
    }
    //包商統計資料0放入dt
    public DataTable TableWork2(DataTable dt,DataTable contractor)
    {
        for (int i = 0; i < contractor.Rows.Count; i++)
        {
            dt.Columns.Add(contractor.Rows[i]["A12I02UV0010"].ToString(), typeof(string));
            for (int p = 0; p < dt.Rows.Count; p++) {
                dt.Rows[p][contractor.Rows[i]["A12I02UV0010"].ToString()] = "0";
            }
        }

            return dt;
    }
    //一般統計資料放入dt
    public DataTable TableWork1(DataTable dt) {

        for (int a = 0; a < dt.Rows.Count; a++)
        {


            if (CntData1.ContainsKey(dt.Rows[a]["A31I02UV0010"].ToString()))
            {
                dt.Rows[a]["cnt1"] = CntData1[dt.Rows[a]["A31I02UV0010"].ToString()];
            }
            else
            {
                dt.Rows[a]["cnt1"] = "0";
            }
            if (CntData2.ContainsKey(dt.Rows[a]["A31I02UV0010"].ToString()))
            {
                dt.Rows[a]["cnt2"] = CntData2[dt.Rows[a]["A31I02UV0010"].ToString()];
            }
            else
            {
                dt.Rows[a]["cnt2"] = "0";
            }
            if (CntData3.ContainsKey(dt.Rows[a]["A31I02UV0010"].ToString()))
            {
                dt.Rows[a]["cnt3"] = CntData3[dt.Rows[a]["A31I02UV0010"].ToString()];
            }
            else
            {
                dt.Rows[a]["cnt3"] = "0";
            }
            if (CntData4.ContainsKey(dt.Rows[a]["A31I02UV0010"].ToString()))
            {
                dt.Rows[a]["cnt4"] = CntData4[dt.Rows[a]["A31I02UV0010"].ToString()];
            }
            else
            {
                dt.Rows[a]["cnt4"] = "0";
            }

        }
        return dt;
    }
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}