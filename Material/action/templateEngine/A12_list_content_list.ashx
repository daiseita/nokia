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
        oValue.setRequestGet("SearchTxt,PageNum,ThisPage");
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
            Sql.SetWhere("or", "A12F01NV0064", "like", oValue.Data("SearchTxt"), true);
        }
        string TableString = "";
        //Sql.ClearQuery();



        TableString = "select A12I01XA,A12I02UV0010,A12I03CV0001,A12I04CV0001,A12I05JJA12I02,A12I06FD0400,A12I07II,A12I08JJA02I02,A12I09JJA03I02,A12F01NV0064,A12F02CV0016,A12F03CV0016,A12F04CV0016,A12F05NV0256,A12F06NV0064,A12F07NV0012,A12IND,A12INT,A12INA,A12INU,A12UPD,A12UPT,A12UPA,A12UPU,A12UPC,A02F01NV0016,A03F01NV0016  from A12 left join A02 on A12I08JJA02I02 = A02I02UV0002 left join A03 on A12I09JJA03I02 = A03I02UV0003";
        Sql.SetColumnName("A12I01XA,A12I02UV0010,A12I03CV0001,A12I04CV0001,A12I05JJA12I02,A12I06FD0400,A12I07II,A12I08JJA02I02,A12I09JJA03I02,A12F01NV0064,A12F02CV0016,A12F03CV0016,A12F04CV0016,A12F05NV0256,A12F06NV0064,A12F07NV0012,A12IND,A12INT,A12INA,A12INU,A12UPD,A12UPT,A12UPA,A12UPU,A12UPC,A02F01NV0016,A03F01NV0016");
        Sql.SetTableName("( " + TableString + " )A12 ");
        Sql.sqlTransferColumn = "A12I03CV0001,A12I04CV0001";
        Sql.SetOrderBy("A12I02UV0010", true);
        Sql.RecordCountQuery("A12I02UV0010");
        dt = Sql.Query("A12", ThisPage, PageNum);

        if (dt != null)
        {
            DataSet DataSet1 = new DataSet();
            DataSet1.Tables.Add(dt);
            for (int i = 0; i < DataSet1.Tables["A12"].Rows.Count; i++)
            {
                List<ValueInput> Input01_Value = new List<ValueInput>();
                for (int s = 0; s < DataSet1.Tables["A12"].Columns.Count; s++)
                {
                    string ColumnName = DataSet1.Tables["A12"].Columns[s].ColumnName;

                    if (ColumnName == "A12INA" && DataSet1.Tables["A12"].Rows[i][s].ToString()!="")
                    {
                        string A12INA = DataSet1.Tables["A12"].Rows[i][s].ToString().Substring(0, 4) + "/" + DataSet1.Tables["A12"].Rows[i][s].ToString().Substring(4, 2) + "/" + DataSet1.Tables["A12"].Rows[i][s].ToString().Substring(6, 2) + " " + DataSet1.Tables["A12"].Rows[i][s].ToString().Substring(8, 2) + ":" + DataSet1.Tables["A12"].Rows[i][s].ToString().Substring(10, 2) + ":" + DataSet1.Tables["A12"].Rows[i][s].ToString().Substring(12, 2);
                        Input01_Value.Add(new ValueInput { value = A12INA });
                    }
                    else
                    {
                        Input01_Value.Add(new ValueInput { value = DataSet1.Tables["A12"].Rows[i][s].ToString() });
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