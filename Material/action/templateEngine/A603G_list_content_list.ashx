<%@ WebHandler Language="C#" Class="A10_list_content_list" %>

using System;
using System.Web;
using System.Data;
using System.Collections.Generic;
using System.Linq;
public class A10_list_content_list : IHttpHandler {

    List<RootObject> Root = new List<RootObject>();
    List<HtmlInput> Input = new List<HtmlInput>();
    List<HtmlSelect> Select = new List<HtmlSelect>();
    List<HtmlRadio> Radio = new List<HtmlRadio>();
    List<HtmlCheckbox> Checkbox = new List<HtmlCheckbox>();
    ParameInfo ParameList = new ParameInfo();
    PageBase pb = new PageBase();
    
    public void ProcessRequest(HttpContext context)
    {
        Cls_Request oValue = new Cls_Request();
        Cls_SQL Sql = new Cls_SQL();
        Cls_Date oDate = new Cls_Date();
        DataTable dt = new DataTable();
        oValue.setRequestGet("SearchTxt,PageNum,ThisPage,A12I02UV0010_P,A12I02UV0010_C,DateTxt,A31I02UV0010,A63I03CV0032");
        string SerchWhere = "";
        string A12I02UV0010_P = oValue.Data("A12I02UV0010_P");
        string A12I02UV0010_C = oValue.Data("A12I02UV0010_C");
        string DateTxt = oValue.Data("DateTxt");
        string A31I02UV0010 = oValue.Data("A31I02UV0010");
        string A63I03CV0032 = oValue.Data("A63I03CV0032");
        string SQL = "";
        if (A12I02UV0010_P != "" || A12I02UV0010_C != "" || DateTxt != "" || A31I02UV0010 != "" || A63I03CV0032 !="")
        {
            string pWhere = "";
            SQL = "select distinct A68I03JJA67I02 from A68 where ";
            if (A12I02UV0010_P != "")
            {
                pWhere += " A68I12JJA12I02='" + A12I02UV0010_P + "' ";
            }
            if (A12I02UV0010_C != "")
            {
                if (pWhere != "") { pWhere += " and "; }
                pWhere += " A68I13JJA12I02='" + A12I02UV0010_C + "' ";
            }
            if (DateTxt != "")
            {
                if (pWhere != "") { pWhere += " and "; }
                pWhere += " A68D01='" + DateTxt + "' ";
            }
            if (A31I02UV0010 != "")
            {
                if (pWhere != "") { pWhere += " and "; }
                pWhere += " A68I04JJA31I02='" + A31I02UV0010 + "' ";
            }
            dt = null;
            if (A63I03CV0032 != "")
            {
                //序號搜尋
                dt = Sql.selectTable("select A63I02JJA61I02 from A63 where A63I03CV0032 like '%" + A63I03CV0032 + "%'", "Search2");
                if (dt != null)
                {
                    bool IsSingle = true;
                    if (pWhere != "") { IsSingle = false ; }                    
                    for (int k = 0; k < dt.Rows.Count; k++)
                    {
                        if (pWhere != "") { pWhere += " or "; }
                        pWhere += " A68I02UV0019='" + dt.Rows[k]["A63I02JJA61I02"].ToString() + "' ";
                    }
                    if(IsSingle == false ){
                       pWhere += " and (" + pWhere  + " ) " ;
                    }
                }
                else {
                    pWhere += " A68I02UV0019='00'";
                }

            }
            dt = null;
            dt = Sql.selectTable(SQL + pWhere, "Search");
            if (dt != null)
            {
                for (int k = 0; k < dt.Rows.Count; k++)
                {
                    if (SerchWhere != "") { SerchWhere += " or "; }
                    SerchWhere += " A67I02UV0012='" + dt.Rows[k]["A68I03JJA67I02"].ToString() + "' ";
                }
            }
            else
            {
                SerchWhere = " A67I02UV0012 ='00000'";
            }

        }
        dt = null;
        
        int PageNum, ThisPage;
        if (oValue.Data("PageNum") != "")
        {
            PageNum = Convert.ToInt32(oValue.Data("PageNum"));
        }
        else
        {
            PageNum = 10;
        }
        if (oValue.Data("ThisPage") != "")
        {
            ThisPage = Convert.ToInt32(oValue.Data("ThisPage"));
        }
        else
        {
            ThisPage = 1;
        }        
        if (oValue.Data("SearchTxt") != "")
        {
            Sql.SetWhere("or", "A67INA", "like", oValue.Data("SearchTxt"), true);
            Sql.SetWhere("or", "A67F02NV0128", "like", oValue.Data("SearchTxt"), true);
            Sql.SetWhere("or", "A67I02UV0012", "like", oValue.Data("SearchTxt"), true); 
        }
        string TableString = "";
        //Sql.ClearQuery();



        TableString = "select A67I01XA,A67I02UV0012,A67I03CV0001,A67F01NV0064,A67F02NV0128,A67IND,A67INT,A67INA from A67 where A67I03CV0001='G'";
        if (SerchWhere != "")
        {
            TableString += " and (" + SerchWhere + ") ";
        }
        Sql.SetColumnName("A67I01XA,A67I02UV0012,A67I03CV0001,A67F01NV0064,A67F02NV0128,A67IND,A67INT,A67INA");
        Sql.SetTableName("( " + TableString + " )A67 ");
        //Sql.sqlTransferColumn = "A67I03CV0001";
        Sql.SetOrderBy("A67INA", true);
        Sql.RecordCountQuery("A67I02UV0012");
        dt = Sql.Query("A67", ThisPage, PageNum);
        if (dt != null)
        {
            DataSet DataSet1 = new DataSet();
            DataSet1.Tables.Add(dt);
            for (int i = 0; i < DataSet1.Tables["A67"].Rows.Count; i++)
            {
                List<ValueInput> Input01_Value = new List<ValueInput>();
                for (int s = 0; s < DataSet1.Tables["A67"].Columns.Count; s++)
                {
                    string ColumnName = DataSet1.Tables["A67"].Columns[s].ColumnName;

                    if (ColumnName == "A67INA")
                    {
                        string A67INA = DataSet1.Tables["A67"].Rows[i][s].ToString().Substring(0, 4) + "/" + DataSet1.Tables["A67"].Rows[i][s].ToString().Substring(4, 2) + "/" + DataSet1.Tables["A67"].Rows[i][s].ToString().Substring(6, 2) + " " + DataSet1.Tables["A67"].Rows[i][s].ToString().Substring(8, 2) + ":" + DataSet1.Tables["A67"].Rows[i][s].ToString().Substring(10, 2) + ":" + DataSet1.Tables["A67"].Rows[i][s].ToString().Substring(12, 2);
                        Input01_Value.Add(new ValueInput { value = A67INA });
                    }
                    else
                    {
                        Input01_Value.Add(new ValueInput { value = DataSet1.Tables["A67"].Rows[i][s].ToString() });
                    }


                }
                Input.Add(new HtmlInput
                {
                    colume = Input01_Value
                });
            }
            DataSet1.Dispose();
        }
        else
        {
            for (int i = 0; i < 0; i++)
            {
                List<ValueInput> Input01_Value = new List<ValueInput>();
                for (int s = 0; s < 1; s++)
                {
                    Input01_Value.Add(new ValueInput { value = "" });
                }
                Input.Add(new HtmlInput
                {
                    colume = Input01_Value
                });
            }
        }

        PageInfo PageInfo = new PageInfo();
        PageInfo.DataCount = Sql.RecordCount.ToString();
        PageInfo.PageCount = Sql.PageCount.ToString();
        PageInfo.DataFrom = Sql.DataFrom.ToString();
        PageInfo.DataEnd = Sql.DataEnd.ToString();
        PageInfo.ThisPage = ThisPage.ToString();
        PageInfo.PageNum = PageNum.ToString();

        /* select 供應商 */
        string SQL_s1 = "  select A12I02UV0010,A12F01NV0064 from A12 where A12I03CV0001 ='A' and A12I04CV0001 = 'B' ";
        Sql.ClearQuery();
        dt = Sql.selectTable(SQL_s1, "A12a");
        if (dt != null)
        {
            DataSet DataSet2 = new DataSet();
            DataSet2.Tables.Add(dt);
            List<TittleSelect> select01_Tittile = new List<TittleSelect>();
            List<ValueSelect> select01_Value = new List<ValueSelect>();
            for (int i = 0; i < DataSet2.Tables["A12a"].Rows.Count; i++)
            {
                select01_Tittile.Add(new TittleSelect { value = DataSet2.Tables["A12a"].Rows[i]["A12F01NV0064"].ToString() });
                select01_Value.Add(new ValueSelect { value = DataSet2.Tables["A12a"].Rows[i]["A12I02UV0010"].ToString() });
            }
            Select.Add(new HtmlSelect
            {
                tittle = select01_Tittile,
                value = select01_Value
            });
            DataSet2.Dispose();
        }
        else
        {
            List<TittleSelect> select01_Tittile = new List<TittleSelect>();
            List<ValueSelect> select01_Value = new List<ValueSelect>();
            Select.Add(new HtmlSelect
            {
                tittle = select01_Tittile,
                value = select01_Value
            });
        }
        dt = null;
        SQL_s1 = "  select A12I02UV0010,A12F01NV0064 from A12 where A12I03CV0001 ='B' and A12I04CV0001 = 'B' ";
        Sql.ClearQuery();
        dt = Sql.selectTable(SQL_s1, "A12b");
        if (dt != null)
        {
            DataSet DataSet3 = new DataSet();
            DataSet3.Tables.Add(dt);
            List<TittleSelect> select02_Tittile = new List<TittleSelect>();
            List<ValueSelect> select02_Value = new List<ValueSelect>();
            for (int i = 0; i < DataSet3.Tables["A12b"].Rows.Count; i++)
            {
                select02_Tittile.Add(new TittleSelect { value = DataSet3.Tables["A12b"].Rows[i]["A12F01NV0064"].ToString() });
                select02_Value.Add(new ValueSelect { value = DataSet3.Tables["A12b"].Rows[i]["A12I02UV0010"].ToString() });
            }
            Select.Add(new HtmlSelect
            {
                tittle = select02_Tittile,
                value = select02_Value
            });
            DataSet3.Dispose();
        }
        else
        {
            List<TittleSelect> select01_Tittile = new List<TittleSelect>();
            List<ValueSelect> select01_Value = new List<ValueSelect>();
            Select.Add(new HtmlSelect
            {
                tittle = select01_Tittile,
                value = select01_Value
            });
        }
        dt = null;
        SQL_s1 = "  select distinct A68D01 from A68 where A68I07CV0001='G' order by A68D01 desc ";
        Sql.ClearQuery();
        dt = Sql.selectTable(SQL_s1, "A68c");
        if (dt != null)
        {
            DataSet DataSet3 = new DataSet();
            DataSet3.Tables.Add(dt);
            List<TittleSelect> select02_Tittile = new List<TittleSelect>();
            List<ValueSelect> select02_Value = new List<ValueSelect>();
            for (int i = 0; i < DataSet3.Tables["A68c"].Rows.Count; i++)
            {
                select02_Tittile.Add(new TittleSelect { value = DataSet3.Tables["A68c"].Rows[i]["A68D01"].ToString() });
                select02_Value.Add(new ValueSelect { value = DataSet3.Tables["A68c"].Rows[i]["A68D01"].ToString() });
            }
            Select.Add(new HtmlSelect
            {
                tittle = select02_Tittile,
                value = select02_Value
            });
            DataSet3.Dispose();
        }
        else
        {
            List<TittleSelect> select01_Tittile = new List<TittleSelect>();
            List<ValueSelect> select01_Value = new List<ValueSelect>();
            Select.Add(new HtmlSelect
            {
                tittle = select01_Tittile,
                value = select01_Value
            });
        }
        dt = null;
        SQL_s1 = "  select distinct A31I02UV0010,A31F01NV0064 from A31 where A31I05CV0001='G' and A31I11JJA31I02 =''  order by A31F01NV0064   ";
        Sql.ClearQuery();
        dt = Sql.selectTable(SQL_s1, "A31c");
        if (dt != null)
        {
            DataSet DataSet3 = new DataSet();
            DataSet3.Tables.Add(dt);
            List<TittleSelect> select02_Tittile = new List<TittleSelect>();
            List<ValueSelect> select02_Value = new List<ValueSelect>();
            for (int i = 0; i < DataSet3.Tables["A31c"].Rows.Count; i++)
            {
                select02_Tittile.Add(new TittleSelect { value = DataSet3.Tables["A31c"].Rows[i]["A31F01NV0064"].ToString() });
                select02_Value.Add(new ValueSelect { value = DataSet3.Tables["A31c"].Rows[i]["A31I02UV0010"].ToString() });
            }
            Select.Add(new HtmlSelect
            {
                tittle = select02_Tittile,
                value = select02_Value
            });
            DataSet3.Dispose();
        }
        else
        {
            List<TittleSelect> select01_Tittile = new List<TittleSelect>();
            List<ValueSelect> select01_Value = new List<ValueSelect>();
            Select.Add(new HtmlSelect
            {
                tittle = select01_Tittile,
                value = select01_Value
            });
        }
        
        
        /*  傳遞參數 */
        List<ParameArray> parameAry = new List<ParameArray>();
        parameAry.Add(new ParameArray { value = pb.PUB_Language });
        ParameList.parame = parameAry;

        Root.Add(new RootObject { html_input = Input, html_Select = Select, html_Radio = Radio, html_Checkbox = Checkbox, page_Info = PageInfo, tag_pareme = ParameList });

        string Json = JsonHelper.JsonSerializer(Root);

        context.Response.ContentType = "text/plain";
        context.Response.Write(Json);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}


/*  http://json2csharp.com/ Json2C#產生器  */
/* [{"html_Radio":[{"tittle":[{"value":"radio名稱1"},{"value":"radio稱2"}],"value":[{"value":"radio1"},{"value":"radio2"}]}],"html_Select":[{"tittle":[{"value":"下拉式名稱1"},{"value":"下拉式名稱2"},{"value":"下拉式名稱3"}],"value":[{"value":"下拉式參數1"},{"value":"下拉式參數2"},{"value":"下拉式參數3"}]}],"html_input":[{"colume":[{"value":"欄位01-內容"},{"value":"欄位02-內容"},{"value":"欄位03-內容"},{"value":"欄位04-內容"}]},{"colume":[{"value":"欄位01-內容2"},{"value":"欄位02-內容2"},{"value":"欄位03-內容2"},{"value":"欄位04-內容2"}]}]}] */
public class ValueInput
{
    public string value { get; set; }
}

public class HtmlInput
{
    public List<ValueInput> colume { get; set; }
}

public class TittleSelect
{
    public string value { get; set; }
}

public class ValueSelect
{
    public string value { get; set; }
}

public class HtmlSelect
{
    public List<TittleSelect> tittle { get; set; }
    public List<ValueSelect> value { get; set; }
}

public class TittleRadio
{
    public string value { get; set; }
}

public class ValueRadio
{
    public string value { get; set; }
}

public class HtmlRadio
{
    public List<TittleRadio> tittle { get; set; }
    public List<ValueRadio> value { get; set; }
}
public class HtmlCheckbox
{
    public string tittle { get; set; }
    public string value { get; set; }
}
public class PageInfo
{
    public string PageCount { get; set; }
    public string DataCount { get; set; }
    public string DataFrom { get; set; }
    public string DataEnd { get; set; }
    public string ThisPage { get; set; }
    public string PageNum { get; set; }
}
public class ParameArray
{
    public string value { get; set; }
}
public class ParameInfo
{
    public List<ParameArray> parame { get; set; }
}
public class RootObject
{
    public List<HtmlInput> html_input { get; set; }
    public List<HtmlSelect> html_Select { get; set; }
    public List<HtmlRadio> html_Radio { get; set; }
    public List<HtmlCheckbox> html_Checkbox { get; set; }
    public PageInfo page_Info { get; set; }
    public ParameInfo tag_pareme { get; set; }
}