using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using Excel = Microsoft.Office.Interop.Excel;
using System.Reflection;
using System.Data;
public partial class ExcelExport : System.Web.UI.Page
{
    Cls_SQL Sql = new Cls_SQL();
    string SQL = "";
    DataTable dt = new DataTable();
    DataGrid Gd1 = new DataGrid();
    DataGrid Gd2 = new DataGrid();
    Cls_Template oTemplate = new Cls_Template();
    string thisOut = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        
        Sql.ClearQuery();
        SQL = "select A12I02UV0010,A12I03CV0001,A12F01NV0064 from A12";
        Sql.sqlTransferColumn = "A12I03CV0001";
        dt = Sql.selectTable(SQL, "A12");
        
        Gd2.DataSource = dt;
        Gd2.DataBind();

        oTemplate.SetTemplatesDir("/template/excel/");
        oTemplate.SetTemplateFileCharset("test.html", "UTF-8");

        
        thisOut = oTemplate.GetOutput();
    }
    //另存新檔
    protected void Button1_Click(object sender, EventArgs e)
    {
        ExcelUtil eu = new ExcelUtil("Jeff_Yeh", "Jeff隨手記");
        eu.AddGrid(thisOut, "TestA");
        eu.AddGrid(Gd2, "TestB");
        eu.Export(this, "Jeff");
    }
    //寫入excel指定位置
    protected void Button2_Click(object sender, EventArgs e)
    {
        
    }
}
