using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Cls_Char 的摘要描述
/// </summary>
public class Cls_Char
{
	public Cls_Char()
	{
		//
		// TODO: 在此加入建構函式的程式碼
		//
	}

    public string setReturnToBR(string strContent) {
        strContent = strContent.Replace("\r\n", "<br>");
        strContent = strContent.Replace("\\n", "<br>");
        strContent = strContent.Replace("\n", "<br>");
        
        return strContent;
    }
    public string setClearSymbol(string strContent)
    {
        strContent = strContent.Replace(" ", "");
        strContent = strContent.Replace(":", "");
        strContent = strContent.Replace("/", "");

        return strContent;
    }
}