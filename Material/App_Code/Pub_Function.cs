using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Pub_Function 的摘要描述
/// </summary>
public class Pub_Function 
{
    static Cls_SQL Sql = new Cls_SQL();
    static Cls_File oFile = new Cls_File();
	public Pub_Function()
	{
		//
		// TODO: 在此加入建構函式的程式碼
		//
	}
    public static string setSingleQuotation(string strContent) {
        strContent= strContent.Replace("'", "''");
        return strContent;
    }

    /* 產生sql請求文字檔 */
    public static string SqlRequest(string SQL) {
        Cls_File oFile = new Cls_File();
        string strContent = "";
        strContent += "BEGIN TRANSACTION [Tran1]" + "\r\n";
        strContent +=  SQL + "\r\n";
        strContent += "Commit TRAN [Tran1]" + "\r\n";
        string GUID = Guid.NewGuid().ToString();
        oFile.CreatFileCharSet("/sql/request/", GUID + ".txt", strContent, "UTF-8");
        return GUID;
    }
    /* 檢查sql處理情況 RtnMsg='' 10秒逾時 RtnMsg=success 成功 RtnMsg = fail = 失敗  */
    public static string SqlResponse(string GUID) {
        Cls_File oFile = new Cls_File();
        string RtnMsg = "";
        for (int i = 1; i <= 100; i++)
        {            
            RtnMsg = oFile.ReadTextCharSet("/sql/response/", GUID + ".txt", "UTF-8");
            if (RtnMsg != "") {
                oFile.DeleteFile("/sql/response/", GUID + ".txt");          
                break; 
            }
            System.Threading.Thread.Sleep(100);
        }
        if (RtnMsg == "") {
            oFile.DeleteFile("/sql/request/", GUID + ".txt");            
        }

        return RtnMsg;
    }

    public static  string executeSQL(string SQL) {
        string pCheck = "success";
        Sql.ClearQuery();
        Sql.transBegin();
        Sql.PureExecuteSQL(SQL);
        Sql.transCommit();
        if (Sql.errorMessage != "") {
            ErrRecord(SQL, Sql.errorMessage);
            pCheck = "fail"; 
        }

        return pCheck;
    }
    public static void ErrRecord(string strSQL, string strMsg) {
        PageBase pb = new PageBase();
        oFile.FileExist("/", @"HyErrorMsg.txt", true);
        string strContent = DateTime.Now.ToString() + "\r\n";
        strContent += strSQL + "\r\n";
        strContent += strMsg + "\r\n";
        strContent += "\r\n";
        oFile.WriteTextCharSet("/", @"\HyErrorMsg.txt", strContent, "UTF-8", true);

    }
}