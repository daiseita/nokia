using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
/*
    System.Web.HttpContext.Current.Response.Write("<script language='JavaScript'>alert('1111');</script>");
    HttpContext.Current.Request.QueryString["s"];
*/

public class PageBase : System.Web.UI.Page
{
    
    Cls_Request ovalue = new Cls_Request();
    public static  string strAccount = "";
    public static string  strIP = "";
    public string ListTemplateName = "";
    public string FaceTemplateName = "";
    public string InfoTemplateName = "";
    public string Info_S_TemplateName = "";
    public string SiteFunctionTemplateName = "/template/SiteFunction/";
    public string ActionTemplateName = "/template/action/";
    public string ExcelTemplateName = "/template/excel/";
    string[] PagePath = new string[7];
    string cLanguageType = "tw";    
    public PageBase()
    {
        //取得路徑
        beforeStart();

        // System.Web.HttpContext.Current.Response.Write("<script language='JavaScript'>alert('1111');</script>");
        /* 帳號檢查 */
        ////if (System.Web.HttpContext.Current.Request.Cookies["Login"] != null)
        ////{
        ////    strAccount = System.Web.HttpContext.Current.Request.Cookies["Login"].Values["strAccount"].ToString();
        ////    if (strAccount == "")
        ////    {
        ////        System.Web.HttpContext.Current.Response.Redirect("/eip/login.aspx");
        ////    }
        ////    else
        ////    {
        ////        SQL = "Select top 1 H04I02UV0009 from H04 where H04I03JJE04I02 ='" + strAccount + "' order by H04F12FD0400 desc";
        ////        recordset = Sql.selectTable(SQL, "E01");
        ////        strLiveAaccount = recordset.Rows[0]["H04I02UV0009"].ToString();

        ////    }

        ////}
        ////else {
        ////    System.Web.HttpContext.Current.Response.Redirect("/eip/login.aspx");
        ////}
        /////* 語系設定 */
        ////if (System.Web.HttpContext.Current.Request.Cookies["Language"] != null)
        ////{
        ////    cLanguageType = System.Web.HttpContext.Current.Request.Cookies["Language"].Values["LangTYpe"].ToString();
        ////}
        ////else {            
        ////    HttpCookie Cookie = new HttpCookie("Language");
        ////    DateTime dtm = DateTime.Now;
        ////    TimeSpan ts = new TimeSpan(1, 0, 0, 0);
        ////    Cookie.Expires = dtm.Add(ts);
        ////    Cookie.Values.Add("LangTYpe", "tw");
        ////    System.Web.HttpContext.Current.Response.AppendCookie(Cookie);
        ////}
        
    }   

    public void beforeStart()
    {
        
        PagePathPrcedure();
    }

    /* url路徑存入陣列 */
    private void PagePathPrcedure()
    {
        try
        {

            string sss = HttpContext.Current.Request.Url.ToString();
            int t = HttpContext.Current.Request.Url.Segments.Length - 1;
            int x = 0;
            while (x < 10)
            {
                PagePath[x] =  Server.UrlDecode(HttpContext.Current.Request.Url.Segments[x]);
                x++;
                if (x > t) { break; }
            }
            ListTemplateName = PagePath[t-1].Replace('/','_')+"list_content.html";
            FaceTemplateName = PagePath[t - 1].Replace('/', '_') + "face_content.html";
            InfoTemplateName = PagePath[t - 1].Replace('/', '_') + "info_content.html";
            Info_S_TemplateName = PagePath[t - 1].Replace('/', '_') + "info_simple_content.html";
        }
        catch (HttpException ex)
        {
            throw ex;
        }
    }
    public static string getUpperFolderName() {
        string strName = "";
       // int Max = HttpRe

        return strName;
    }

    public string PUB_Account { get { return strAccount; } }
    public string PUB_Company  { get { return "顯揚資訊有限公司"; } }
    public string PUB_Tel      { get { return "02-22401698"; } }
    public string PUB_Fax      { get { return "02-22409528"; } }
    public string PUB_Language { get { return cLanguageType.ToLower(); } }
    public string SiteUrl      { get {  return Server.UrlDecode(Request.Url.ToString()); } }

    public string PagePath1    { get { return PagePath[0]; } }
    public string PagePath2    { get { return PagePath[1]; } }
    public string PagePath3    { get { return PagePath[2]; } }
    public string PagePath4    { get { return PagePath[3]; } }
    public string PagePath5    { get { return PagePath[4]; } }
    
    public string Host         { get { return Request.Url.Host.ToString(); } }

    public string WebUrl       { get { return Page.ResolveClientUrl("~"); } }
    public string WebRoot { get { return Server.MapPath("~"); } }    


    public static string WebRoute { get { return "http://cks.cms.com"; } }
    /* DB -  */
    public static string DB_Database { get { return "cks"; } }
    public static string DB_Server { get { return "192.168.14.129"; } }
    public static string DB_UserID { get { return "sa"; } }
    public static string DB_Password { get { return "Cks-Bis-Server"; } }
    public static string DB_ConnectString { get { return @"Server=CKS-SI-DATABASE\EFENCE;Database=cks;User ID=sa;Password=Cks-Bis-Server;Trusted_Connection=False;"; } }

    public static string DB_Database2 { get { return "cks_bak"; } }
    public static string DB_Server2 { get { return "192.168.14.129"; } }
    public static string DB_UserID2 { get { return "sa"; } }
    public static string DB_Password2 { get { return "Cks-Bis-Server"; } }
    public static string DB_ConnectString2 { get { return @"Server=CKS-SI-DATABASE\EFENCE;Database=cks_bak;User ID=sa;Password=Cks-Bis-Server;Trusted_Connection=False;"; } }

    public static string SocketServerIP { get { return "10.20.20.167"; } }
    

    public static void setCookieID(string  strId) {

        HttpCookie Cookie = new HttpCookie("Passing");
        DateTime dtm = DateTime.Now;
        TimeSpan ts = new TimeSpan(1, 0, 0, 0);
        Cookie.Expires = dtm.Add(ts);
        Cookie.Values.Add("strAccount", strId);
        HttpContext.Current.Response.AppendCookie(Cookie);
    }
    public static string getClientIP() {
        string ip = null;
        System.Web.UI.Page WebBrowser = new System.Web.UI.Page();

        if (WebBrowser.Request.ServerVariables["HTTP_X_FORWARDED_FOR"].ToString() == string.Empty || WebBrowser.Request.ServerVariables["HTTP_X_FORWARDED_FOR"].ToUpper().IndexOf("UNKNOWN") > 0)
        {
            ip = WebBrowser.Request.ServerVariables["REMOTE_ADDR"];
        }
        else if (WebBrowser.Request.ServerVariables["HTTP_X_FORWARDED_FOR"].IndexOf(",") > 0)
        {
            ip = WebBrowser.Request.ServerVariables["HTTP_X_FORWARDED_FOR"].Substring(1, WebBrowser.Request.ServerVariables["HTTP_X_FORWARDED_FOR"].IndexOf(",") - 1);
        }
        else if (WebBrowser.Request.ServerVariables["HTTP_X_FORWARDED_FOR"].IndexOf(";") > 0)
        {
            ip = WebBrowser.Request.ServerVariables["HTTP_X_FORWARDED_FOR"].Substring(1, WebBrowser.Request.ServerVariables["HTTP_X_FORWARDED_FOR"].IndexOf(";") - 1);
        }
        else
        {
            ip = WebBrowser.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
        }
        ip = ip.Replace("\n", "");
        return ip;        
    }


    public static string getFolderNanme() {
        bool pBool = false;
        string strAccount = "";
        try
        {
            HttpCookie cookie = HttpContext.Current.Request.Cookies["Passing"];
            strAccount = cookie.Values["strAccount"].ToString();
        }
        catch {
            HttpContext.Current.Response.Redirect("http://10.20.20.167");
        }
        return strAccount;
    }
    public static void Check_Login() { 
        bool pBool = false  ;
        string strAccount ="";
        HttpCookie cookie = HttpContext.Current.Request.Cookies["Account"];
        if (cookie != null)
        {
            strAccount = cookie.Values["strAccount"].ToString();
            PageBase.strAccount = strAccount;
            if (strAccount != "")
            {                
                pBool = true;
            }
        }
        //cookie.Values.Remove("strAccount");
        if (strAccount == "")
        {
            string strIP = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];
            Cls_SQL Sql = new Cls_SQL();
            DataTable dt = new DataTable();
            dt = Sql.selectTable("select top 1 U01I02UV0024 from U01 where U01I07CV0015 ='" + strIP + "'", "U01");
            try
            {
                if (dt.Rows.Count > 0)
                {
                    HttpCookie Cookie = new HttpCookie("Account");
                    DateTime dtm = DateTime.Now;
                    TimeSpan ts = new TimeSpan(1, 0, 0, 0);
                    Cookie.Expires = dtm.Add(ts);
                    Cookie.Values.Add("strAccount", dt.Rows[0]["U01I02UV0024"].ToString());
                    HttpContext.Current.Response.AppendCookie(Cookie);
                    pBool = true;
                    PageBase.strAccount = dt.Rows[0]["U01I02UV0024"].ToString();
                }
            }
            catch { 
            
            }
        }
        if (pBool == false)
        {
            HttpContext.Current.Response.Redirect(PageBase.WebRoute + "/login.aspx");
        }               
    }
    public static string getPageName()
    {
        string str = HttpContext.Current.Request.Path.ToString();
        string[] words = str.Split('/'); 
        words[words.Length-1] = words[words.Length-1].Replace(".aspx","");
        words[words.Length - 1] = words[words.Length - 1].Replace(".ashx", "");
        words[words.Length - 1] = words[words.Length - 1].Replace(".html", "");
        return words[words.Length - 1];
    }

}