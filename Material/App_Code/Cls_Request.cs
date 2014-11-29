using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Text.RegularExpressions;
public class Cls_Request : System.Web.UI.Page
{
    Dictionary<string, string> thisInfo = new Dictionary<string, string>();
    string strMethod = "POST";
    public Cls_Request()
    {
    }
    /* HTTP 資料傳輸方法 */
    public string HttpMethod { set { this.strMethod = value; } get { return this.strMethod; } }
    /* 取得http傳遞參數 */
    public void setRequest(string strIdString)
    {
        if (strMethod == "POST")
        {
            setRequestPost(strIdString);
        }
        else
        {
            setRequestGet(strIdString);
        }
    }
    /* 取得http POST 傳遞參數 */
    public void setRequestPost(string strIdString)
    {
        string[] pArrayName = Regex.Split(strIdString, @",");
        foreach (string name in pArrayName)
        {
            if (thisInfo.ContainsKey(name))
            {
                thisInfo.Remove(name);
                thisInfo.Add(name, HttpContext.Current.Request.Form[name]);

                
            }
            else
            {
                thisInfo.Add(name, HttpContext.Current.Request.Form[name]);
            }
        }
    }
    /* 取得http GET 傳遞參數 */
    public void setRequestGet(string strIdString)
    {
        string[] pArrayName = Regex.Split(strIdString, @",");
        foreach (string name in pArrayName)
        {
            if (thisInfo.ContainsKey(name))
            {
                thisInfo.Remove(name);
                thisInfo.Add(name, HttpContext.Current.Request.QueryString[name]);
            }
            else
            {
                thisInfo.Add(name, HttpContext.Current.Request.QueryString[name]);
            }
        }
    }
    /* 取回參數 */
    public string Data(string strId)
    {
        string pReturn = "";
        if (thisInfo[strId] != null)
        {
            pReturn = Server.UrlDecode(thisInfo[strId]);
        }
        else {

            pReturn = "";
        }
        return pReturn;
    }
    /* 存入參數 */
    public void setData(string strId, string strValue)
    {
        if (thisInfo.ContainsKey(strId))
        {
            thisInfo.Remove(strId);
            thisInfo.Add(strId, strValue);
        }
        else
        {
            thisInfo.Add(strId, strValue);
        }
    }
    
    /* 欄位參數檢查 */
    public bool EmptyCheck(string CheckString)
    {
        bool pReturn = true;
        string[] pArrayName = Regex.Split(CheckString, @",");
        foreach (string name in pArrayName)
        {
            if (Data(name) == "")
            {
                pReturn = false;
            }
        }
        return pReturn;
    }
    /* 欄位參數檢查-禁用中文 */
    public bool ColumnNoChines(string CheckString)
    {
        bool pReturn = true;
        string[] pArrayName = Regex.Split(CheckString, @",");
        foreach (string name in pArrayName)
        {
            if (Data(name) != "")
            {
                if (Cls_Rule.IsIncludeChinese(Data(name)) == true)
                {
                    pReturn = false;
                    break;
                }
            }
        }
        return pReturn;
    }
    /* 欄位參數檢查-英文+數字+符號 */
    public bool ColumnStringNumericSymbol(string CheckString)
    {
        bool pReturn = true;
        string[] pArrayName = Regex.Split(CheckString, @",");
        foreach (string name in pArrayName)
        {
            if (Data(name) != "")
            {
                if (Cls_Rule.IsStringNumericSymbol(Data(name)) == false)
                {
                    pReturn = false;
                    break;
                }
            }
        }
        return pReturn;
    }
    /* 欄位參數檢查-數字 */
    public bool ColumnNumeric(string CheckString)
    {
        bool pReturn = true;
        string[] pArrayName = Regex.Split(CheckString, @",");
        foreach (string name in pArrayName)
        {
            if (Data(name) != "")
            {
                if (Cls_Rule.IsNumeric(Data(name)) == false)
                {
                    pReturn = false;
                    break;
                }
            }
        }
        return pReturn;
    }
    /* 欄位參數檢查-數字+英文 */
    public bool ColumnStringNumeric(string CheckString)
    {
        bool pReturn = true;
        string[] pArrayName = Regex.Split(CheckString, @",");
        foreach (string name in pArrayName)
        {
            if (Data(name) != "")
            {
                if (Cls_Rule.IsStringNumeric(Data(name)) == false)
                {
                    pReturn = false;
                    break;
                }
            }
        }
        return pReturn;
    }
    /* 欄位參數檢查-Mail */
    public bool ColumnMail(string CheckString)
    {
        bool pReturn = true;
        string[] pArrayName = Regex.Split(CheckString, @",");
        foreach (string name in pArrayName)
        {
            if (Data(name) != "")
            {
                if (Cls_Rule.IsMail(Data(name)) == false)
                {
                    pReturn = false;
                    break;
                }
            }
        }
        return pReturn;
    }
}