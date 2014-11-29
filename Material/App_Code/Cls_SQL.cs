using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Text.RegularExpressions;
using System.Web.UI.WebControls;
public class Cls_SQL
{
    SqlConnection conn;
    public Cls_CodeTransfer oCode = new Cls_CodeTransfer();
    private int intCount = 0;
    private int intId = 0;
    private int thisRecordCount = 0;
    private int thisPage = 1;
    private int thisPageCount = 1;
    private int thisPageNum = 1;
    private int thisDataFrom = 1;
    private int thisDataEnd = 1;
    private SqlTransaction trans = null;
    DataSet thisDataSet = new DataSet();
    Dictionary<string, string> DataInfo = new Dictionary<string, string>();
    Dictionary<string, string> NDataInfo = new Dictionary<string, string>();
    List<string> Surround = new List<string>();
    private string WhereString = "";
    private string RcWhereString = "";
    private string OrderByString = "";
    private string ColumnNameString = "";
    private string TableNameString = "";

    /*  錯誤訊息 */
    private string strError = "";
    /*  sql連線字串 */
    private string connectionStr = "";
    /* transfer欄位字串  */
    private string strTranferColumn = "";
    /* trans 記錄錯誤狀態 */
    private string ErrorRecorder = "";
    /* 暫存sql碼 */
    private string RecordSqlstring = "";

    public Cls_SQL()
    {
        //
        // TODO: 在此加入建構函式的程式碼
        conn = sqlConnection();
    }
    public DataSet getDatasetRecord()
    {

        return thisDataSet;
    }
    //公開方法getConnectionString，返回數據庫連接字符串/
    public string getConnectionString()
    {

        connectionStr = @"Server=127.0.0.1;Database=Nokia_Material;User ID=sa;Password=1234;Trusted_Connection=False;";
        //connectionStr = @"Server=192.168.168.100\HsienYang;Database=Nokia_Material;User ID=sa;Password=chiwei670802;Trusted_Connection=False;";
        //connectionStr = "Data Source=219.71.38.165;Integrated Security=SSPI;Initial Catalog=Nokia_Material";
        //connectionStr = "Server=127.0.0.1;Database=Nokia_Material;integrated security=sspi;Trusted_Connection=False;";
        return connectionStr;
    }
    /* 公開屬性errorMessage，返回錯誤信息 */
    public string errorMessage { set { strError = value; } get { return strError; } }
    /* RecordCount where條件式 */
    public string CountWhere { set { RcWhereString = value; } get { return RcWhereString; } }
    /* 暫存sql碼 */
    public string TemporarySQL { set { RecordSqlstring = value; } get { return RecordSqlstring; } }
    /* 加入transfer欄位 */
    public string sqlTransferColumn { set { this.strTranferColumn = value; } get { return this.strTranferColumn; } }
    /* 回傳查詢條件字串 */
    public string getWhere { get { return getWhereString(); } }
    /* 記錄總筆數 */
    public int RecordCount { get { return thisRecordCount; } set { thisRecordCount = value; } }
    /* 每頁筆數 */
    public int PageNum { get { return thisPageNum; } set { thisPageNum = value; } }
    /* 目前頁數 */
    public int Page { get { return thisPage; } set { thisPage = value; } }
    /* 總頁數 */
    public int PageCount { get { return thisPageCount; } set { thisPageCount = value; } }
    /* 開始筆數 */
    public int DataFrom
    {
        get
        {
            if (Page == 1)
            {
                thisDataFrom = 1;
            }
            else
            {
                thisDataFrom = ((Page - 1) * PageNum) + 1;
            }
            return thisDataFrom;
        }
        set { DataFrom = value; }
    }
    /* 結數筆數 */
    public int DataEnd
    {
        get
        {
            if (Page == PageCount)
            {
                thisDataEnd = Convert.ToInt32(thisRecordCount);
            }
            else
            {
                thisDataEnd = (Page * PageNum);
            }
            return thisDataEnd;
        }
        set { DataEnd = value; }
    }
    //sqlConnection，返回數據庫連接
    public SqlConnection sqlConnection()
    {
        try
        {
            return new SqlConnection(getConnectionString());
        }
        catch (Exception)
        {
            return null;
        }
    }
    /*  一般資料庫查詢  */
    public DataTable selectTable(string sql, string tableName)
    {
        try
        {
            //若數據庫連接的當前狀態是關閉的，則打開連接                
            if (conn.State == ConnectionState.Closed) { conn.Open(); }
            if (getWhereString() != "") { sql += " where " + getWhereString(); }
            SqlDataAdapter mySqlDataAdapter = new SqlDataAdapter(sql, conn);
            DataTable dt = new DataTable(tableName);
            mySqlDataAdapter.Fill(dt);
            thisRecordCount = dt.Rows.Count;
            /*  transfer 欄位資料加入 */
            if (strTranferColumn != "") { AddtranferColumn(dt); }

            //if (thisDataSet.Tables.IndexOf(tableName) > 0) { thisDataSet.Tables.Remove(tableName); }

            //thisDataSet.Tables.Add(dt);
            if (dt.Rows.Count > 0)
            {
                return dt;
            }
            else {
                return null;
            }
        }
        catch (Exception e)
        {
            strError += "數據檢索失敗：" + e.Message;
            ErrorRecorder += strError;
            return null;
        }
        finally
        {
            if (conn.State != ConnectionState.Closed)
            {
                conn.Close();
            }
        }
    }

    /*  資料總筆數查詢  */
    public long RecordCountQuery(string strColumn)
    {
        if (conn.State == ConnectionState.Closed) { conn.Open(); }
        try
        {
            //若數據庫連接的當前狀態是關閉的，則打開連接
            if (conn.State == ConnectionState.Closed) { conn.Open(); }
            string QuerySring = "";
            QuerySring = "select Count(" + strColumn + ")RecoundCount from " + TableNameString;
            //if (RcWhereString != "") { QuerySring += " Where " + RcWhereString; }
            if (getWhereString() != "") { QuerySring += " where " + getWhereString(); }
            //if (OrderByString != "") { QuerySring += " Order by " + OrderByString; }
            SqlDataAdapter mySqlDataAdapter = new SqlDataAdapter(QuerySring, conn);
            DataTable dt = new DataTable();
            mySqlDataAdapter.Fill(dt);
            thisRecordCount = Convert.ToInt32(dt.Rows[0]["RecoundCount"]); ;

            return thisRecordCount;
        }
        catch (Exception e)
        {
            strError += "數據檢索失敗：" + e.Message;
            ErrorRecorder += strError;
            return 0;
        }
        finally
        {
            if (conn.State != ConnectionState.Closed) { conn.Close(); }
        }
    }
    /*  Top1查詢  */
    public string Top1Query(string tableName, string strColumn, bool bonDesc)
    {
        if (conn.State == ConnectionState.Closed) { conn.Open(); }
        try
        {
            //若數據庫連接的當前狀態是關閉的，則打開連接
            if (conn.State == ConnectionState.Closed) { conn.Open(); }
            string QuerySring = ""; string pDesc = "";
            if (bonDesc == true) { pDesc = " Desc"; }
            QuerySring = "select  top 1 " + strColumn + " from " + tableName;
            QuerySring += " Order by " + strColumn + " " + pDesc;
            SqlDataAdapter mySqlDataAdapter = new SqlDataAdapter(QuerySring, conn);
            DataTable dt = new DataTable(tableName);
            mySqlDataAdapter.Fill(dt);
            if (dt.Rows.Count > 0)
            {
                return dt.Rows[0][strColumn].ToString();
            }
            else
            {
                return "";
            }
        }
        catch (Exception e)
        {
            strError += "數據檢索失敗：" + e.Message;
            ErrorRecorder += strError;
            return "";
        }
        finally
        {
            if (conn.State != ConnectionState.Closed) { conn.Close(); }
        }
    }


    /*  排序資料庫查詢  */
    public DataTable Query(string TableName, int Page, int PageNum)
    {
        string sql = "";
        if (conn.State == ConnectionState.Closed) { conn.Open(); }
        try
        {
            //若數據庫連接的當前狀態是關閉的，則打開連接
            if (conn.State == ConnectionState.Closed)
            {
                conn.Open();
            }
            thisPage = Page;
            thisPageNum = PageNum;
            setPageCount();

            sql += "with PageSetting as( select " + ColumnNameString + " ,row_number()over(order by " + OrderByString + " )as RowNum from " + TableNameString;
            if (getWhereString() != "") { sql += " where " + getWhereString(); }
            sql += " ) select " + ColumnNameString + " from PageSetting where RowNum between " + DataFrom.ToString() + " and " + DataEnd.ToString();

            SqlDataAdapter mySqlDataAdapter = new SqlDataAdapter(sql, conn);
            DataTable dt = new DataTable(TableName);
            mySqlDataAdapter.Fill(dt);
            if (strTranferColumn != "") { dt = AddtranferColumn(dt); }
            //if (thisDataSet.Tables.IndexOf(TableName) > 0) { thisDataSet.Tables.Remove(TableName); }
            //thisDataSet.Tables.Add(dt);
            if (dt.Rows.Count > 0)
            {
                return dt;
            }
            else
            {
                return null;
            }
        }
        catch (Exception e)
        {
            strError += "數據檢索失敗：" + e.Message;
            ErrorRecorder += strError;
            return null;
        }
        finally
        {
            if (conn.State != ConnectionState.Closed)
            {
                conn.Close();
            }
        }
    }

    public int getInsertId()
    {
        return intId;
    }
    /*  資料庫新增  */
    public bool insert(string sql, SqlConnection sqlConn)
    {
        if (conn.State == ConnectionState.Closed) { conn.Open(); }
        try
        {
            //若數據庫連接的當前狀態是關閉的，則打開連接
            if (conn.State == ConnectionState.Closed)
            {
                conn.Open();
            }

            //查錄插入記錄的ID
            SqlDataAdapter mySqlDataAdapter = new SqlDataAdapter(sql + "SELECT @@IDENTITY;", conn);
            DataTable dt = new DataTable();
            mySqlDataAdapter.Fill(dt);

            if (dt.Rows.Count != 0)
            {
                intId = Convert.ToInt32(dt.Rows[0][0]);
                return true;
            }
            else
            {
                return false;
            }
        }
        catch (Exception e)
        {
            strError += "插入數據庫失敗：" + e.Message;
            ErrorRecorder += strError;
            return false;
        }
        finally
        {
            if (conn.State != ConnectionState.Closed)
            {
                conn.Close();
            }
        }
    }
    /*  執行sql命令  */
    public bool executeSQL(string sql, SqlConnection sqlConn)
    {
        if (conn.State == ConnectionState.Closed) { conn.Open(); }
        try
        {
            if (conn.State == ConnectionState.Closed)
            {
                conn.Open();
            }
            SqlCommand cmd = new SqlCommand(sql, conn);

            if (DataInfo.Count > 0)
            {
                foreach (KeyValuePair<string, string> item in DataInfo)
                {
                    cmd.Parameters.AddWithValue("@" + item.Key.ToString(), item.Value.ToString());
                }
            }
            if (NDataInfo.Count > 0)
            {
                foreach (KeyValuePair<string, string> item in NDataInfo)
                {
                    cmd.Parameters.AddWithValue("@" + item.Key.ToString(), item.Value.ToString());
                }
            }
            if (trans != null)
            {
                cmd.Transaction = trans;//事務添加
            }
            cmd.CommandType = CommandType.Text;
            intCount = cmd.ExecuteNonQuery();
            return true;
        }
        catch (Exception e)
        {
            strError += "更新數據庫失敗：" + e.Message + "----" + RecordSqlstring;
            ErrorRecorder += strError;
            return false;
        }
        finally
        {
            if (conn.State != ConnectionState.Closed && trans == null)
            {
                conn.Close();
            }
        }
    }


    /*  執行sql命令  */
    public bool PureExecuteSQL(string sql)
    {
        if (conn.State == ConnectionState.Closed) { conn.Open(); }
        try
        {
            if (conn.State == ConnectionState.Closed)
            {
                conn.Open();
            }
            SqlCommand cmd = new SqlCommand(sql, conn);

            if (trans != null)
            {
                cmd.Transaction = trans;//事務添加
            }
            cmd.CommandType = CommandType.Text;
            intCount = cmd.ExecuteNonQuery();
            return true;
        }
        catch (Exception e)
        {
            strError += "更新數據庫失敗：" + e.Message;
            ErrorRecorder += strError;
            return false;
        }
        finally
        {
            if (conn.State != ConnectionState.Closed && trans == null)
            {
                conn.Close();
            }
        }
    }

    /*  TransBegin  */
    public bool transBegin()
    {
        if (conn.State == ConnectionState.Closed) { conn.Open(); }
        trans = conn.BeginTransaction();
        ErrorRecorder = "";
        return true;
    }
    /*  Commit  */
    public bool transCommit()
    {
        try
        {
            if (ErrorRecorder == "")
            {
                trans.Commit();
                trans.Dispose();
                conn.Close();
            }
            else
            {
                conn.Close();
            }
        }
        catch (Exception e)
        {
            trans.Rollback();
            throw e;
        }
        finally
        {

        }

        return true;
    }
    /*  RollBack  */
    public bool transRollback()
    {
        trans.Rollback();
        trans.Dispose();
        return true;
    }
    /*  transfer欄位處理  */
    public DataTable AddtranferColumn(DataTable dt)
    {
        string[] sArray = Regex.Split(strTranferColumn, ",", RegexOptions.IgnoreCase);
        foreach (string colume in sArray)
        {
            /*  add  XXXXX_NAME欄位  */
            dt.Columns.Add(new DataColumn(colume + "_NAME", typeof(string)));
        }
        foreach (DataRow dataRow in dt.Rows)
        {
            foreach (string colume in sArray)
            {
                dataRow[colume + "_NAME"] = oCode.ExportData(colume, dataRow[colume].ToString()).ToString();
            }
        }
        return dt;
    }
    /* 分頁設定 */
    public PagedDataSource SetPage(DataTable dt, int Page, int PageNum)
    {
        PagedDataSource pd = new PagedDataSource();
        pd.AllowPaging = true;
        pd.PageSize = PageNum;
        pd.CurrentPageIndex = Page - 1;
        pd.DataSource = dt.DefaultView;
        /*記錄*/
        thisPageNum = PageNum;
        thisPage = Page;
        thisPageCount = pd.PageCount;
        thisRecordCount = dt.Rows.Count;
        return pd;
    }
    /*  頁數計算  */
    public void setPageCount()
    {
        if (thisRecordCount != 0)
        {
            double num, pageCount, pageNum;
            pageCount = Convert.ToDouble(thisRecordCount);
            pageNum = Convert.ToDouble(thisPageNum);
            num = pageCount / pageNum;
            num = Math.Ceiling(num);
            thisPageCount = Convert.ToInt32(num);
            setPageRange();
        }

    }
    /*  資料範圍計算  */
    public void setPageRange()
    {
        thisDataFrom = ((thisPage - 1) * thisPageNum) + 1;
        thisDataEnd = (thisPage) * thisPageNum;
        if (thisDataEnd > thisRecordCount) { thisDataEnd = thisRecordCount; }
    }
    /* ---------------------------------------------------------------------------------------------------------------------------------  */
    /*  產生查詢條件式  */
    public string getWhereString()
    {
        if (Surround.Count > 0)
        {
            string str = "";
            foreach (string t in Surround)
            {
                str += t.ToString();
            }
            WhereString = str + " ( " + WhereString + " ) ";
        }

        return WhereString;
    }


    /*  清除參數資料  */
    public void ClearQuery()
    {
        DataInfo.Clear();
        NDataInfo.Clear();
        WhereString = "";
        RcWhereString = "";
        OrderByString = "";
        ColumnNameString = "";
        TableNameString = "";
        strTranferColumn = "";
        Surround.Clear();
        strError = "";
    }
    /* 設定查詢欄位 */
    public void SetColumnName(string strColumnName)
    {
        ColumnNameString = strColumnName;
    }
    /* 設定查詢資料表 */
    public void SetTableName(string strTableName)
    {
        TableNameString = strTableName;
    }

    /* 設定查詢條件式 */
    public void SetWhere(string strLogic, string strColumn, string strCondition, string strValue, bool bonIsChar)
    {
        if (strCondition == "like") { strValue = "%" + strValue + "%"; }
        if (bonIsChar == true) { strValue = "'" + strValue + "'"; }
        if (WhereString == "")
        {
            WhereString += "  " + strColumn + "  " + strCondition + "  " + strValue;
        }
        else
        {
            WhereString += "  " + strLogic + "  " + strColumn + "  " + strCondition + "  " + strValue;
        }
    }
    /* 設定排序條件式 */
    public void SetOrderBy(string strColumn, bool bonDesc)
    {
        string pDesc = "";
        if (bonDesc == true) { pDesc = " Desc"; }
        if (OrderByString == "")
        {
            OrderByString += strColumn + pDesc;
        }
        else
        {
            OrderByString += ", " + strColumn + pDesc;
        }
    }

    /* 設定欄位資料 */
    public void SetData(string strColumnName, string strValue)
    {
        if (DataInfo.ContainsKey(strColumnName))
        {
            DataInfo.Remove(strColumnName);
        }
        else
        {
            DataInfo.Add(strColumnName, strValue);
        }
    }
    /* 設定欄位資料 */
    public void SetNData(string strColumnName, string strValue)
    {
        if (NDataInfo.ContainsKey(strColumnName))
        {
            NDataInfo.Remove(strColumnName);
        }
        else
        {
            NDataInfo.Add(strColumnName, strValue);
        }
    }
    /* 設定複合式查詢條件 */
    public void SetSurround(string strLogic)
    {
        if (WhereString != "")
        {

            Surround.Add(" (" + WhereString + ") " + strLogic);
            WhereString = "";
        }

    }

    /*  新增數據庫  */
    public bool SetInsert(string strTable)
    {
        string strExSQL = "";
        string strF = "";
        string strK = "";
        string strValue = "";
        RecordSqlstring = "";
        foreach (KeyValuePair<string, string> item in DataInfo)
        {
            if (strF != "") { strF += ","; }
            if (strK != "") { strK += ","; }
            if (strValue != "") { strValue += ","; }
            strF += item.Key.ToString();
            strK += "@" + item.Key.ToString();
            strValue += "'" + item.Value.ToString() + "'";
        }
        foreach (KeyValuePair<string, string> item in NDataInfo)
        {
            if (strF != "") { strF += ","; }
            if (strK != "") { strK += ","; }
            if (strValue != "") { strValue += ","; }
            strF += item.Key.ToString();
            strK += "@" + item.Key.ToString();
            strValue += " N'" + item.Value.ToString() + "'";
        }
        strExSQL = "Insert Into " + strTable + "  (" + strF + ") Values (" + strK + ")";
        RecordSqlstring = "Insert Into " + strTable + "  (" + strF + ") Values (" + strValue + ")";
        return executeSQL(strExSQL, null);
    }
    /*  刪除數據庫  */
    public bool SetDelte(string strTable)
    {
        string strExSQL = "";
        RecordSqlstring = "";
        strExSQL = "Delete from " + strTable + " ";
        RecordSqlstring = "Delete from " + strTable + " ";
        if (getWhereString() != "")
        {
            strExSQL += " Where " + getWhereString() + " ";
            RecordSqlstring += " Where " + getWhereString() + " ";
        }
        return executeSQL(strExSQL, null);
    }
    /*  更新數據庫  */
    public bool SetUpdate(string strTable)
    {
        string strExSQL = "";
        string strF = "";
        string strValue = "";
        RecordSqlstring = "";
        foreach (KeyValuePair<string, string> item in DataInfo)
        {
            if (strF != "") { strF += ","; }
            if (strValue != "") { strValue += ","; }
            strF += item.Key.ToString() + "=@" + item.Key.ToString();
            strValue += item.Key.ToString() + "= '" + item.Value.ToString() + "'";
        }
        foreach (KeyValuePair<string, string> item in NDataInfo)
        {
            if (strF != "") { strF += ","; }
            if (strValue != "") { strValue += ","; }
            strF += item.Key.ToString() + "=@" + item.Key.ToString();
            strValue += item.Key.ToString() + "= N'" + item.Value.ToString() + "'";
        }
        strExSQL = "Update " + strTable + " Set " + strF;
        RecordSqlstring = "Update " + strTable + " Set " + strValue;
        if (getWhereString() != "")
        {
            strExSQL += " Where " + getWhereString() + " ";
            RecordSqlstring += " Where " + getWhereString() + " ";
        }
        return executeSQL(strExSQL, null);
    }
    /*  新增數據庫--SQL碼  */
    public string getInserSQL(string strTable)
    {
        string strF = "";
        string strValue = "";
        RecordSqlstring = "";
        foreach (KeyValuePair<string, string> item in DataInfo)
        {
            if (strF != "") { strF += ","; }
            if (strValue != "") { strValue += ","; }
            strF += item.Key.ToString();
            strValue += "'" + item.Value.ToString() + "'";
        }
        foreach (KeyValuePair<string, string> item in NDataInfo)
        {
            if (strF != "") { strF += ","; }
            if (strValue != "") { strValue += ","; }
            strF += item.Key.ToString();
            strValue += " N'" + item.Value.ToString() + "'";
        }
        RecordSqlstring = "Insert Into " + strTable + "  (" + strF + ") Values (" + strValue + ")";
        return RecordSqlstring;
    }

    /*  刪除數據庫--SQL碼  */
    public string getDelteSQL(string strTable)
    {
        string strExSQL = "";
        RecordSqlstring = "";
        strExSQL = "Delete from " + strTable + " ";
        RecordSqlstring = "Delete from " + strTable + " ";
        if (getWhereString() != "")
        {
            strExSQL += " Where " + getWhereString() + " ";
            RecordSqlstring += " Where " + getWhereString() + " ";
        }
        return RecordSqlstring;
    }

    /*  更新數據庫--SQL碼  */
    public string getUpdateSQL(string strTable)
    {
        string strValue = "";
        RecordSqlstring = "";
        foreach (KeyValuePair<string, string> item in DataInfo)
        {
            if (strValue != "") { strValue += ","; }
            strValue += item.Key.ToString() + "= '" + item.Value.ToString() + "'";
        }
        foreach (KeyValuePair<string, string> item in NDataInfo)
        {
            if (strValue != "") { strValue += ","; }
            strValue += item.Key.ToString() + "= N'" + item.Value.ToString() + "'";
        }
        RecordSqlstring = "Update " + strTable + " Set " + strValue;
        if (getWhereString() != "")
        {
            RecordSqlstring += " Where " + getWhereString() + " ";
        }
        return RecordSqlstring;
    }

}