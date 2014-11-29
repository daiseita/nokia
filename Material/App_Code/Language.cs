using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Language 的摘要描述
/// </summary>
public class Language_Msg
{
    HttpCookie cCookie = new HttpCookie("Language");
    /* 語系: TW:中文繁體 CN:中文簡體 EN:英文 JP:日文 */
    string cLanguageType = "tw";       
    string[] sMsg = new string[41]; 
    public Language_Msg()
	{
        if (System.Web.HttpContext.Current.Request.Cookies["Language"] != null)
        {
            cLanguageType = System.Web.HttpContext.Current.Request.Cookies["Language"].Values["LangTYpe"].ToString();
        }
        else
        {
            cLanguageType = "tw";
        }
        LangSetting();
	}
    public void LanguageShift(string strLang)
    {
        DateTime dtm = DateTime.Now;
        TimeSpan ts = new TimeSpan(1, 0, 0, 0);
        cCookie.Expires = dtm.Add(ts);
        cCookie.Values.Add("LangTYpe", strLang);
        System.Web.HttpContext.Current.Response.AppendCookie(cCookie);
    }
    
    public void LangSetting()
    {
        switch (cLanguageType)
        {
            case "tw":
                sMsg[1] = "請檢查必需欄位是否填寫!!";
                sMsg[2] = "名稱欄位重覆!!";
                sMsg[3] = "代碼欄位重覆!!";
                sMsg[4] = "已被其他資料設定不允許刪除或異動!!";
                sMsg[5] = "處理過程發生錯誤!!";
                sMsg[6] = "執行完成!!";
                sMsg[7] = "帳號欄位重覆!!";
                sMsg[8] = "姓名欄位重覆!!";
                sMsg[9] = "結束日期不可早於開始日期!!";
                sMsg[10] = "查無相關資料!!";
                sMsg[11] = "查無上一筆資料!!";
                sMsg[12] = "查無下一筆資料!!";
                sMsg[13] = "資料庫忙碌中，請稍後再試!!";
                sMsg[14] = "輸入欄位格式錯誤!!";
                sMsg[15] = "欄位格式錯誤!!";
                sMsg[16] = "填入邏輯錯誤!!";
                sMsg[17] = "已儲存至草稿資料夾!!";
                sMsg[18] = "欄位長度不足";
                sMsg[19] = "請選擇主承商名稱!!";
                sMsg[20] = "請選擇3G或4G系統!!";                
                sMsg[21] = "批號重覆!!";
                sMsg[22] = "已有資料入庫不允許刪除!!";
                sMsg[23] = "數量不足";
                sMsg[24] = "Excel格式錯誤!，請檢查數量";
                sMsg[25] = "路徑錯誤!";
                sMsg[26] = "已有資料狀態變更不允許刪除!!";
                sMsg[27] = "Excel格式錯誤!檔案Ｐ格式是否正確!!";
                sMsg[28] = "箱號已出貨!!";
                sMsg[29] = "件號表載入失敗!";
                sMsg[30] = "品項資料中查無件號";
                sMsg[31] = "序號數量大於資料筆數";
                sMsg[32] = "品項資料中查無件號";
                sMsg[33] = "品項資料中查無件號";
                sMsg[34] = "品項資料中查無件號";
                sMsg[35] = "品項資料中查無件號";
                sMsg[36] = "品項資料中查無件號";
                sMsg[37] = "品項資料中查無件號";
                sMsg[38] = "品項資料中查無件號";
                sMsg[39] = "品項資料中查無件號";
                sMsg[40] = "品項資料中查無件號";
                break;
            case "cn":
                sMsg[1] = "請檢查必需欄位是否填寫!!";
                sMsg[2] = "名稱欄位重覆!!";
                sMsg[3] = "代碼欄位重覆!!";
                sMsg[4] = "已被其他資料設定不允許刪除或異動!!";
                sMsg[5] = "處理過程發生錯誤!!";
                sMsg[6] = "執行完成!!";
                sMsg[7] = "帳號欄位重覆!!";
                sMsg[8] = "姓名欄位重覆!!";
                sMsg[9] = "結束日期不可早於開始日期!!";
                sMsg[10] = "查無相關資料!!";
                sMsg[11] = "查無上一筆資料!!";
                sMsg[12] = "查無下一筆資料!!";
                sMsg[13] = "資料庫忙碌中，請稍後再試!!";
                sMsg[14] = "輸入欄位格式錯誤!!";
                sMsg[15] = "欄位格式錯誤!!";
                sMsg[16] = "填入邏輯錯誤!!";
                sMsg[17] = "已儲存至草稿資料夾!!";
                sMsg[18] = "已有資料入庫不允許刪除!!";
                sMsg[19] = "";
                sMsg[20] = "";
                sMsg[21] = "";
                sMsg[22] = "";
                sMsg[23] = "";
                sMsg[24] = "";
                sMsg[25] = "";
                sMsg[26] = "";
                sMsg[27] = "";
                sMsg[28] = "";
                sMsg[29] = "";
                sMsg[30] = "";
                break;
            case "en":
                sMsg[1] = "請檢查必需欄位是否填寫!!";
                sMsg[2] = "名稱欄位重覆!!";
                sMsg[3] = "代碼欄位重覆!!";
                sMsg[4] = "已被其他資料設定不允許刪除或異動!!";
                sMsg[5] = "處理過程發生錯誤!!";
                sMsg[6] = "執行完成!!";
                sMsg[7] = "帳號欄位重覆!!";
                sMsg[8] = "姓名欄位重覆!!";
                sMsg[9] = "結束日期不可早於開始日期!!";
                sMsg[10] = "查無相關資料!!";
                sMsg[11] = "查無上一筆資料!!";
                sMsg[12] = "查無下一筆資料!!";
                sMsg[13] = "資料庫忙碌中，請稍後再試!!";
                sMsg[14] = "輸入欄位格式錯誤!!";
                sMsg[15] = "欄位格式錯誤!!";
                sMsg[16] = "填入邏輯錯誤!!";
                sMsg[17] = "已儲存至草稿資料夾!!";
                sMsg[18] = "";
                sMsg[19] = "";
                sMsg[20] = "";
                break;
            case "jp":
                sMsg[1] = "請檢查必需欄位是否填寫!!";
                sMsg[2] = "名稱欄位重覆!!";
                sMsg[3] = "代碼欄位重覆!!";
                sMsg[4] = "已被其他資料設定不允許刪除或異動!!";
                sMsg[5] = "處理過程發生錯誤!!";
                sMsg[6] = "執行完成!!";
                sMsg[7] = "帳號欄位重覆!!";
                sMsg[8] = "姓名欄位重覆!!";
                sMsg[9] = "結束日期不可早於開始日期!!";
                sMsg[10] = "查無相關資料!!";
                sMsg[11] = "查無上一筆資料!!";
                sMsg[12] = "查無下一筆資料!!";
                sMsg[13] = "資料庫忙碌中，請稍後再試!!";
                sMsg[14] = "輸入欄位格式錯誤!!";
                sMsg[15] = "欄位格式錯誤!!";
                sMsg[16] = "填入邏輯錯誤!!";
                sMsg[17] = "已儲存至草稿資料夾!!";
                sMsg[18] = "";
                sMsg[19] = "";
                sMsg[20] = "";
                break;
            default:

                break;
        }
    }

    public string Msg01 { get { return sMsg[1]; } }
    public string Msg02 { get { return sMsg[2]; } }
    public string Msg03 { get { return sMsg[3]; } }
    public string Msg04 { get { return sMsg[4]; } }
    public string Msg05 { get { return sMsg[5]; } }
    public string Msg06 { get { return sMsg[6]; } }
    public string Msg07 { get { return sMsg[7]; } }
    public string Msg08 { get { return sMsg[8]; } }
    public string Msg09 { get { return sMsg[9]; } }
    public string Msg10 { get { return sMsg[10]; } }
    public string Msg11 { get { return sMsg[11]; } }
    public string Msg12 { get { return sMsg[12]; } }
    public string Msg13 { get { return sMsg[13]; } }
    public string Msg14 { get { return sMsg[14]; } }
    public string Msg15 { get { return sMsg[15]; } }
    public string Msg16 { get { return sMsg[16]; } }
    public string Msg17 { get { return sMsg[17]; } }
    public string Msg18 { get { return sMsg[18]; } }
    public string Msg19 { get { return sMsg[19]; } }
    public string Msg20 { get { return sMsg[20]; } }
    public string Msg21 { get { return sMsg[21]; } }
    public string Msg22 { get { return sMsg[22]; } }
    public string Msg23 { get { return sMsg[23]; } }
    public string Msg24 { get { return sMsg[24]; } }
    public string Msg25 { get { return sMsg[25]; } }
    public string Msg26 { get { return sMsg[26]; } }
    public string Msg27 { get { return sMsg[27]; } }
    public string Msg28 { get { return sMsg[28]; } }
    public string Msg29 { get { return sMsg[29]; } }
    public string Msg30 { get { return sMsg[30]; } }
    public string Msg31 { get { return sMsg[31]; } }
    public string Msg32 { get { return sMsg[32]; } }
    public string Msg33 { get { return sMsg[33]; } }
    public string Msg34 { get { return sMsg[34]; } }
    public string Msg35 { get { return sMsg[35]; } }
    public string Msg36 { get { return sMsg[36]; } }
    public string Msg37 { get { return sMsg[37]; } }
    public string Msg38 { get { return sMsg[38]; } }
    public string Msg39 { get { return sMsg[30]; } }
    public string Msg40 { get { return sMsg[40]; } }
}

public class Language_TF
{ 
    HttpCookie cCookie = new HttpCookie("Language");
    /* 語系: TW:中文繁體 CN:中文簡體 EN:英文 JP:日文 */
    string cLanguageType = "TW";    
    string[] sMsg = new string[51]; 
    public Language_TF()
	{
        if (System.Web.HttpContext.Current.Request.Cookies["Language"] != null)
        {
            cLanguageType = System.Web.HttpContext.Current.Request.Cookies["Language"].Values["LangTYpe"].ToString();
        }
        else {
            cLanguageType = "tw";
        }
        LangSetting();
	}
    public void LanguageShift(string strLang)
    {
        DateTime dtm = DateTime.Now;
        TimeSpan ts = new TimeSpan(1, 0, 0, 0);
        cCookie.Expires = dtm.Add(ts);
        cCookie.Values.Add("LangTYpe", strLang);
        System.Web.HttpContext.Current.Response.AppendCookie(cCookie);
    }
    public void LangSetting()
    {
        switch (cLanguageType)
        {
            case "tw":
                sMsg[1]  = "啟用";
                sMsg[2]  = "停用";
                sMsg[3]  = "供應商";
                sMsg[4]  = "承包商";
                sMsg[5]  = "";
                sMsg[6]  = "Local";
                sMsg[7]  = "Global";
                sMsg[8]  = "3G";
                sMsg[9]  = "4G";
                sMsg[10] = "SMR";
                sMsg[11] = "L2Swith";
                sMsg[12] = "";
                sMsg[13] = "";
                sMsg[14] = "供應商指送";
                sMsg[15] = "貨倉出貨";
                sMsg[16] = "";
                sMsg[17] = "";
                sMsg[18] = "";
                sMsg[19] = "";
                sMsg[20] = "";
                sMsg[21] = "";
                sMsg[22] = "";
                sMsg[23] = "";
                sMsg[24] = "";
                sMsg[25] = "";
                sMsg[26] = "";
                sMsg[27] = "";
                sMsg[28] = "";
                sMsg[29] = "";
                sMsg[30] = "";
                sMsg[31] = "";
                sMsg[32] = "";
                sMsg[33] = "";
                sMsg[34] = "";
                sMsg[35] = "";
                sMsg[36] = "";
                sMsg[37] = "";
                sMsg[38] = "";
                sMsg[39] = "";
                sMsg[40] = "";
                sMsg[41] = "";
                sMsg[42] = "";
                sMsg[43] = "";
                sMsg[44] = "";
                sMsg[45] = "";
                sMsg[46] = "";
                sMsg[47] = "";
                sMsg[48] = "";
                sMsg[49] = "";
                sMsg[50] = "";                  
                break;
            case "cn":
                sMsg[1] = "啟用";
                sMsg[2] = "停用";
                sMsg[3] = "男";
                sMsg[4] = "女";
                sMsg[5] = "開啟";
                sMsg[6] = "關閉";
                sMsg[7] = "隱藏";
                sMsg[8] = "公司";
                sMsg[9] = "部門";
                sMsg[10] = "群組";
                sMsg[11] = "個人";
                sMsg[12] = "指定單日";
                sMsg[13] = "指定時間區間";
                sMsg[14] = "指定每週";
                sMsg[15] = "指定每月";
                sMsg[16] = "指定每年";
                sMsg[17] = "通知相關人員";
                sMsg[18] = "不通知";
                sMsg[19] = "已審核";
                sMsg[20] = "待審核";
                sMsg[21] = "有效";
                sMsg[22] = "草稿";
                sMsg[23] = "公開";
                sMsg[24] = "不公開";
                sMsg[25] = "開始";
                sMsg[26] = "進行";
                sMsg[27] = "延誤";
                sMsg[28] = "提早";
                sMsg[29] = "結束";               
                sMsg[30] = "一般";
                sMsg[31] = "重要";
                sMsg[32] = "正常";
                sMsg[33] = "送件";
                sMsg[34] = "外借";
                sMsg[35] = "損壞";
                sMsg[36] = "維護";
                sMsg[37] = "其他";
                sMsg[38] = "不發送";
                sMsg[39] = "發送";
                sMsg[40] = "目錄";
                sMsg[41] = "資源";
                sMsg[42] = "";
                sMsg[43] = "";
                sMsg[44] = "";
                sMsg[45] = "";
                sMsg[46] = "";
                sMsg[47] = "";
                sMsg[48] = "";
                sMsg[49] = "";
                sMsg[50] = "";                
                break;
            case "en":
                sMsg[1] = "啟用";
                sMsg[2] = "停用";
                sMsg[3] = "男";
                sMsg[4] = "女";
                sMsg[5] = "開啟";
                sMsg[6] = "關閉";
                sMsg[7] = "隱藏";
                sMsg[8] = "公司";
                sMsg[9] = "部門";
                sMsg[10] = "群組";
                sMsg[11] = "個人";
                sMsg[12] = "指定單日";
                sMsg[13] = "指定時間區間";
                sMsg[14] = "指定每週";
                sMsg[15] = "指定每月";
                sMsg[16] = "指定每年";
                sMsg[17] = "通知相關人員";
                sMsg[18] = "不通知";
                sMsg[19] = "已審核";
                sMsg[20] = "待審核";
                sMsg[21] = "有效";
                sMsg[22] = "草稿";
                sMsg[23] = "公開";
                sMsg[24] = "不公開";
                sMsg[25] = "開始";
                sMsg[26] = "進行";
                sMsg[27] = "延誤";
                sMsg[28] = "提早";
                sMsg[29] = "結束";
                sMsg[30] = "一般";
                sMsg[31] = "重要";
                sMsg[32] = "正常";
                sMsg[33] = "送件";
                sMsg[34] = "外借";
                sMsg[35] = "損壞";
                sMsg[36] = "維護";
                sMsg[37] = "其他";
                sMsg[38] = "不發送";
                sMsg[39] = "發送";
                sMsg[40] = "目錄";
                sMsg[41] = "資源";
                sMsg[42] = "";
                sMsg[43] = "";
                sMsg[44] = "";
                sMsg[45] = "";
                sMsg[46] = "";
                sMsg[47] = "";
                sMsg[48] = "";
                sMsg[49] = "";
                sMsg[50] = "";            
                break;
            case "jp":
                sMsg[1] = "啟用";
                sMsg[2] = "停用";
                sMsg[3] = "男";
                sMsg[4] = "女";
                sMsg[5] = "開啟";
                sMsg[6] = "關閉";
                sMsg[7] = "隱藏";
                sMsg[8] = "公司";
                sMsg[9] = "部門";
                sMsg[10] = "群組";
                sMsg[11] = "個人";
                sMsg[12] = "指定單日";
                sMsg[13] = "指定時間區間";
                sMsg[14] = "指定每週";
                sMsg[15] = "指定每月";
                sMsg[16] = "指定每年";
                sMsg[17] = "通知相關人員";
                sMsg[18] = "不通知";
                sMsg[19] = "已審核";
                sMsg[20] = "待審核";
                sMsg[21] = "有效";
                sMsg[22] = "草稿";
                sMsg[23] = "公開";
                sMsg[24] = "不公開";
                sMsg[25] = "開始";
                sMsg[26] = "進行";
                sMsg[27] = "延誤";
                sMsg[28] = "提早";
                sMsg[29] = "結束";
                sMsg[30] = "一般";
                sMsg[31] = "重要";
                sMsg[32] = "正常";
                sMsg[33] = "送件";
                sMsg[34] = "外借";
                sMsg[35] = "損壞";
                sMsg[36] = "維護";
                sMsg[37] = "其他";
                sMsg[38] = "不發送";
                sMsg[39] = "發送";
                sMsg[40] = "目錄";
                sMsg[41] = "資源";
                sMsg[42] = "";
                sMsg[43] = "";
                sMsg[44] = "";
                sMsg[45] = "";
                sMsg[46] = "";
                sMsg[47] = "";
                sMsg[48] = "";
                sMsg[49] = "";
                sMsg[50] = "";            
                break;
            default:

                break;
        }
    }

    public string Msg01 { get { return sMsg[1]; } }
    public string Msg02 { get { return sMsg[2]; } }
    public string Msg03 { get { return sMsg[3]; } }
    public string Msg04 { get { return sMsg[4]; } }
    public string Msg05 { get { return sMsg[5]; } }
    public string Msg06 { get { return sMsg[6]; } }
    public string Msg07 { get { return sMsg[7]; } }
    public string Msg08 { get { return sMsg[8]; } }
    public string Msg09 { get { return sMsg[9]; } }
    public string Msg10 { get { return sMsg[10]; } }
    public string Msg11 { get { return sMsg[11]; } }
    public string Msg12 { get { return sMsg[12]; } }
    public string Msg13 { get { return sMsg[13]; } }
    public string Msg14 { get { return sMsg[14]; } }
    public string Msg15 { get { return sMsg[15]; } }
    public string Msg16 { get { return sMsg[16]; } }
    public string Msg17 { get { return sMsg[17]; } }
    public string Msg18 { get { return sMsg[18]; } }
    public string Msg19 { get { return sMsg[19]; } }
    public string Msg20 { get { return sMsg[20]; } }
    public string Msg21 { get { return sMsg[21]; } }
    public string Msg22 { get { return sMsg[22]; } }
    public string Msg23 { get { return sMsg[23]; } }
    public string Msg24 { get { return sMsg[24]; } }
    public string Msg25 { get { return sMsg[25]; } }
    public string Msg26 { get { return sMsg[26]; } }
    public string Msg27 { get { return sMsg[27]; } }
    public string Msg28 { get { return sMsg[28]; } }
    public string Msg29 { get { return sMsg[29]; } }
    public string Msg30 { get { return sMsg[30]; } }
    public string Msg31 { get { return sMsg[31]; } }
    public string Msg32 { get { return sMsg[32]; } }
    public string Msg33 { get { return sMsg[33]; } }
    public string Msg34 { get { return sMsg[34]; } }
    public string Msg35 { get { return sMsg[35]; } }
    public string Msg36 { get { return sMsg[36]; } }
    public string Msg37 { get { return sMsg[37]; } }
    public string Msg38 { get { return sMsg[38]; } }
    public string Msg39 { get { return sMsg[39]; } }
    public string Msg40 { get { return sMsg[40]; } }
    public string Msg41 { get { return sMsg[41]; } }
    public string Msg42 { get { return sMsg[42]; } }
    public string Msg43 { get { return sMsg[43]; } }
    public string Msg44 { get { return sMsg[44]; } }
    public string Msg45 { get { return sMsg[45]; } }
    public string Msg46 { get { return sMsg[46]; } }
    public string Msg47 { get { return sMsg[47]; } }
    public string Msg48 { get { return sMsg[48]; } }
    public string Msg49 { get { return sMsg[49]; } }
    public string Msg50 { get { return sMsg[50]; } }
}