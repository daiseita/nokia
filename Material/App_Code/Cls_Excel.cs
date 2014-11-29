using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.OleDb;
using Excel = Microsoft.Office.Interop.Excel;
using System.Reflection;
using System.Web.UI.WebControls;
using System.Web.UI;
using System.IO;
using System.Text;
using System.Runtime.InteropServices;
/// <summary>
/// Cls_Excel 的摘要描述
/// </summary>
public class Cls_Excel
{
	public Cls_Excel()
	{
		//
		// TODO: 在此加入建構函式的程式碼
		//
	}
    public string ErroMsg = "";
    public int SheetCount = 0;
    public DataTable readSheetInfo(string strUrl)
    {
        DataTable dt = new DataTable();
        OleDbConnection cn = new OleDbConnection(getConnectString(strUrl));
        cn.Open();
        try
        {
            dt = cn.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);

        }
        catch (Exception ex)
        {
            ErroMsg =ex.Message;
        }
        cn.Dispose();
        GC.Collect();
        return dt;
    }
    public string GetSheetsName(string strUrl)
    {
        //Excel.Application efa = null;
        //Excel.Workbook ewb = null;
        //Excel.Worksheet ews = null;
        //string SheetNameString = "";
        //try
        //{
        //    efa = new Excel.Application();
        //    ewb = default(Excel.Workbook);
        //    ews = default(Excel.Worksheet);
        //    string fileName = null;
        //    fileName = strUrl;
        //    ewb = efa.Workbooks.Open(fileName);
        //    foreach (Excel.Worksheet sheet in ewb.Worksheets)
        //    {
        //        if (SheetNameString != "") { SheetNameString += ","; }
        //        SheetNameString += sheet.Name;
        //    }
        //}
        //catch
        //{

        //}
        //finally
        //{
        //    if (ews != null)
        //    {
        //        Marshal.FinalReleaseComObject(ews);
        //    }
        //    if (ewb != null)
        //    {
        //        ewb.Close(false); //忽略尚未存檔內容，避免跳出提示卡住
        //        Marshal.FinalReleaseComObject(ewb);
        //    }
        //    if (efa != null)
        //    {
        //        //efa.Workbooks.Close();
        //        //efa.Quit();
        //        //Marshal.FinalReleaseComObject(efa);
        //    }

        //}
        ///* 解決excel.exe無法關閉 */
        //try
        //{
        //    if (efa != null) // isRunning是判断xlApp是怎么启动的flag.
        //    {
        //        efa.Quit();
        //        System.Runtime.InteropServices.Marshal.ReleaseComObject(efa);
        //        //释放COM组件，其实就是将其引用计数减1
        //        //System.Diagnostics.Process theProc;
        //        foreach (System.Diagnostics.Process theProc in System.Diagnostics.Process.GetProcessesByName("EXCEL"))
        //        {
        //            //先关闭图形窗口。如果关闭失败...有的时候在状态里看不到图形窗口的excel了，
        //            //但是在进程里仍然有EXCEL.EXE的进程存在，那么就需要杀掉它:p
        //            if (theProc.CloseMainWindow() == false)
        //            {
        //                theProc.Kill();
        //            }
        //        }
        //        efa = null;

        //    }
        //}
        //catch { }
        //return SheetNameString;
        return "";
    }


    public DataTable readExcelData(string strUrl, string strSheetName)
    {

        DataTable dt = new DataTable();
        OleDbConnection cn = new OleDbConnection(getConnectString(strUrl));
        string qs = "SELECT * FROM [" + strSheetName + "]";
        try
        {
            OleDbDataAdapter dr = new OleDbDataAdapter(qs, cn);
            dr.Fill(dt);
            dr.Dispose();
        }
        catch (Exception ex)
        {
            ErroMsg = ex.Message;
        }

        cn.Dispose();
        GC.Collect();
        if (dt.Rows.Count > 0)
        {
            return dt;
        }
        else {
            return null; 
        }
    }

    public string getConnectString(string strUrl)
    {
        //1.檔案位置
        string FileName = strUrl;
        //2.提供者名稱
        string ProviderName = "Microsoft.Jet.OLEDB.4.0;";
        //3.Excel版本，Excel 8.0 針對Excel2000及以上版本，Excel5.0 針對Excel97。
        string ExtendedString = "'Excel 8.0;";
        //4.第一行是否為標題
        string Hdr = "Yes;";
        //5.IMEX=1 通知驅動程序始終將「互混」數據列作為文本讀取
        string IMEX = "0';";
        string cs =
                "Data Source=" + FileName + ";" +
                "Provider=" + ProviderName +
                "Extended Properties=" + ExtendedString +
                "HDR=" + Hdr +
                "IMEX=" + IMEX;
        string strconn = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + strUrl + ";Extended Properties='Excel 12.0 Xml;HDR=YES';";
        //string connectString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + strUrl + ";Extended Properties='Excel 8.0;HDR=YES;IMEX=1;'";
        return strconn;

    }

    public DataTable creatNewExcelByRule(DataSet ds, DataTable RuleDt, int RowsCount)
    {
        DataTable dt = new DataTable();
        dt = AddColumn(dt, RuleDt.Rows.Count, RuleDt);
        int Max = RowsCount;
        for (int d = 0; d < Max; d++)
        {
            DataRow row = dt.NewRow();
            dt.Rows.Add(row);
        }
        for (int i = 0; i < RuleDt.Rows.Count; i++)
        {
            string SheetName = "Table" + RuleDt.Rows[i][0];
            int ColumNum = Convert.ToInt32(RuleDt.Rows[i][1]) - 1;
            for (int x = 0; x < Max; x++)
            {
                dt.Rows[x][i] = ds.Tables[SheetName].Rows[x][ColumNum].ToString();
            }

        }

        return dt;
    }

    private DataTable AddColumn(DataTable dt, int ColumnNum, DataTable RuleDt)
    {
        for (int i = 0; i < ColumnNum; i++)
        {
            DataColumn column = new DataColumn();
            column.DataType = typeof(string);
            column.ColumnName = RuleDt.Rows[i][2].ToString();
            dt.Columns.Add(column);
        }
        return dt;
    }

    public bool ExportExcelByDataTable(DataTable dt)
    {
        try
        {
            System.Web.UI.WebControls.DataGrid grid = new System.Web.UI.WebControls.DataGrid();
            grid.HeaderStyle.Font.Bold = true;
            grid.DataSource = dt;
            grid.DataMember = dt.TableName;
            grid.DataBind();

            //string ExcelName = Application.StartupPath + @"\export\" + string.Format("{0:yyyyMMddhhmmss}", DateTime.Now) + ".xls";
            string ExcelName = "";
            // render the DataGrid control to a file
            using (StreamWriter sw = new StreamWriter(ExcelName))
            {
                using (HtmlTextWriter hw = new HtmlTextWriter(sw))
                {
                    grid.RenderControl(hw);
                }
            }
            grid.Dispose();
            return true;
        }
        catch
        {
            return false;
        }

    }

    public  void ExporttoExcel(DataTable table)
    {
        HttpContext.Current.Response.Clear();
        HttpContext.Current.Response.ClearContent();
        HttpContext.Current.Response.ClearHeaders();
        HttpContext.Current.Response.Buffer = true;
        HttpContext.Current.Response.ContentType = "application/ms-excel";
        //HttpContext.Current.Response.ContentType = "application/ms-word";
        HttpContext.Current.Response.Write(@"<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.0 Transitional//EN"">");
        HttpContext.Current.Response.AddHeader("Content-Disposition", "attachment;filename=Reports.xls");
        // HttpContext.Current.Response.AddHeader("Content-Disposition", "attachment;filename=Reports.doc");
        HttpContext.Current.Response.Charset = "UTF-8";
        HttpContext.Current.Response.ContentEncoding = System.Text.Encoding.GetEncoding("windows-1250");
        HttpContext.Current.Response.Write("<font style='font-size:10.0pt; font-family:Calibri;'>");
        HttpContext.Current.Response.Write("<BR><BR><BR>");
        HttpContext.Current.Response.Write("<Table border='1' bgColor='#ffffff' borderColor='#000000' cellSpacing='0' cellPadding='0' style='font-size:10.0pt; font-family:Calibri; background:white;'> <TR>");
        int columnscount = table.Columns.Count ;

        for (int j = 0; j < columnscount; j++)
        {
            HttpContext.Current.Response.Write("<Td>");
            HttpContext.Current.Response.Write("<B>");
            HttpContext.Current.Response.Write(table.Columns[j].ColumnName.ToString());
            HttpContext.Current.Response.Write("</B>");
            HttpContext.Current.Response.Write("</Td>");
        }
        HttpContext.Current.Response.Write("</TR>");
        foreach (DataRow row in table.Rows)
        {
            HttpContext.Current.Response.Write("<TR>");
            for (int i = 0; i < table.Columns.Count; i++)
            {
                HttpContext.Current.Response.Write("<Td>");
                HttpContext.Current.Response.Write(row[i].ToString());
                HttpContext.Current.Response.Write("</Td>");
            }

            HttpContext.Current.Response.Write("</TR>");
        }
        HttpContext.Current.Response.Write("</Table>");
        HttpContext.Current.Response.Write("</font>");
        HttpContext.Current.Response.Flush();
        HttpContext.Current.Response.End();
    }


}

public class ExcelUtil
{
    string _Author;
    string _Company;

    StringBuilder sbBody = new StringBuilder();
    StringBuilder sbSheet = new StringBuilder();
    public ExcelUtil(string Author, string Company)
    {
        _Author = Author;
        _Company = Company;
        sbBody.AppendFormat(
            "MIME-Version: 1.0\r\n" +
            "X-Document-Type: Workbook\r\n" +
            "Content-Type: multipart/related; boundary=\"-=BOUNDARY_EXCEL\"\r\n\r\n" +
            "---=BOUNDARY_EXCEL\r\n" +
            "Content-Type: text/html; charset=\"UTF-8\"\r\n\r\n" +
            "<html xmlns:o=\"urn:schemas-microsoft-com:office:office\"\r\n" +
            "xmlns:x=\"urn:schemas-microsoft-com:office:excel\">\r\n\r\n" +
            "<head>\r\n" +
            "<meta http-equiv=\"content-type\" content=\"application/ms-excel; charset=UTF-8\"/>\r\n\r\n" +
            "<xml>\r\n" +
            "<o:DocumentProperties>\r\n" +
            "<o:Author>{0}</o:Author>\r\n" +
            "<o:LastAuthor>{0}</o:LastAuthor>\r\n" +
            "<o:Created>{1}</o:Created>\r\n" +
            "<o:LastSaved>{1}</o:LastSaved>\r\n" +
            "<o:Company>{2}</o:Company>\r\n" +
            "<o:Version>11.5606</o:Version>\r\n" +
            "</o:DocumentProperties>\r\n" +
            "</xml>\r\n" +
            "<xml>\r\n" +
            "<x:ExcelWorkbook>\r\n" +
            "<x:ExcelWorksheets>\r\n"
            , _Author
            , DateTime.Now.ToString()
            , _Company);
    }

    private string ExportExcel()
    {
        StringBuilder sb = new StringBuilder(sbBody.ToString());

        sb.Append("</x:ExcelWorksheets>\r\n" +
            "</x:ExcelWorkbook>\r\n" +
            "</xml>\r\n" +
            "</head>\r\n" +
            "</html>\r\n\r\n");

        sb.Append(sbSheet.ToString());

        sb.Append("---=BOUNDARY_EXCEL--");

        return sb.ToString();
    }

    public void AddGrid(DataGrid grid, string sheetName)
    {
        string gid = Guid.NewGuid().ToString();
        sbBody.AppendFormat("<x:ExcelWorksheet>\r\n" +
            "<x:Name>{0}</x:Name>\r\n" +
            "<x:WorksheetSource HRef=\"cid:{1}\"/>\r\n" +
            "</x:ExcelWorksheet>\r\n"
            , sheetName.Replace(":", "").Replace("\\", "").Replace("/", "").Replace("?", "").Replace("*", "").Replace("[", "").Replace("]", "").Trim()
            , gid);

        StringWriter sw = new StringWriter();
        HtmlTextWriter htw = new HtmlTextWriter(sw);
        grid.RenderControl(htw);

        sbSheet.AppendFormat("---=BOUNDARY_EXCEL\r\n" +
            "Content-ID: {0}\r\n" +
            "Content-Type: text/html; charset=\"UTF-8\"\r\n\r\n" +
            "<html xmlns:o=\"urn:schemas-microsoft-com:office:office\"\r\n" +
            "xmlns:x=\"urn:schemas-microsoft-com:office:excel\">\r\n\r\n" +
            "<head>\r\n" +
            "<meta http-equiv=\"content-type\" content=\"application/ms-excel; charset=UTF-8\"/>\r\n\r\n" +
            "<xml>\r\n" +
            "<x:WorksheetOptions>\r\n" +
            "<x:ProtectContents>False</x:ProtectContents>\r\n" +
            "<x:ProtectObjects>False</x:ProtectObjects>\r\n" +
            "<x:ProtectScenarios>False</x:ProtectScenarios>\r\n" +
            "</x:WorksheetOptions>\r\n" +
            "</xml>\r\n" +
            "</head>\r\n" +
            "<body>\r\n"
            , gid);
        sbSheet.Append(sw.ToString());
        sbSheet.Append("</body>\r\n" +
            "</html>\r\n\r\n");
        sw.Close();
        htw.Close();
    }
    public void AddGrid(string Template, string sheetName)
    {
        string gid = Guid.NewGuid().ToString();
        sbBody.AppendFormat("<x:ExcelWorksheet>\r\n" +
            "<x:Name>{0}</x:Name>\r\n" +
            "<x:WorksheetSource HRef=\"cid:{1}\"/>\r\n" +
            "</x:ExcelWorksheet>\r\n"
            , sheetName.Replace(":", "").Replace("\\", "").Replace("/", "").Replace("?", "").Replace("*", "").Replace("[", "").Replace("]", "").Trim()
            , gid);

        StringWriter sw = new StringWriter();
        HtmlTextWriter htw = new HtmlTextWriter(sw);
        //grid.RenderControl(htw);

        sbSheet.AppendFormat("---=BOUNDARY_EXCEL\r\n" +
            "Content-ID: {0}\r\n" +
            "Content-Type: text/html; charset=\"UTF-8\"\r\n\r\n" +
            "<html xmlns:o=\"urn:schemas-microsoft-com:office:office\"\r\n" +
            "xmlns:x=\"urn:schemas-microsoft-com:office:excel\">\r\n\r\n" +
            "<head>\r\n" +
            "<meta http-equiv=\"content-type\" content=\"application/ms-excel; charset=UTF-8\"/>\r\n\r\n" +
            "<xml>\r\n" +
            "<x:WorksheetOptions>\r\n" +
            "<x:ProtectContents>False</x:ProtectContents>\r\n" +
            "<x:ProtectObjects>False</x:ProtectObjects>\r\n" +
            "<x:ProtectScenarios>False</x:ProtectScenarios>\r\n" +
            "</x:WorksheetOptions>\r\n" +
            "</xml>\r\n" +
            "</head>\r\n" +
            "<body>\r\n"
            , gid);
        //sbSheet.Append(sw.ToString());
        sbSheet.Append(Template);
        sbSheet.Append("</body>\r\n" +
            "</html>\r\n\r\n");
        sw.Close();
        htw.Close();
    }


    public void Export(Page page, string FileName)
    {
        page.Response.Clear();
        page.Response.Buffer = true;
        page.Response.Charset = "";
        page.Response.AddHeader("content-disposition", string.Format("attachment;filename={0}.xls", FileName));
        
        page.Response.ContentEncoding = Encoding.GetEncoding("UTF-8");
        page.Response.ContentType = "application/vnd.ms-excel";
        page.Response.Write(ExportExcel());
        page.Response.End();
    }

    public void Export(HttpContext context, string FileName)
    {
        context.Response.Clear();
        context.Response.Buffer = true;
        context.Response.Charset = "";
        context.Response.AddHeader("content-disposition", string.Format("attachment;filename={0}.xls", FileName));        
        context.Response.ContentEncoding = Encoding.GetEncoding("UTF-8");
        context.Response.ContentType = "application/vnd.ms-excel";
        context.Response.Write(ExportExcel());
        context.Response.End();
    }

    public void Clear()
    {
        sbBody.Remove(0, sbBody.Length);
        sbSheet.Remove(0, sbBody.Length);
    }
}