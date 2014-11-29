using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.ComponentModel;
using System.Web.Script.Services;

/// <summary>
/// Service1 的摘要描述
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// 若要允許使用 ASP.NET AJAX 從指令碼呼叫此 Web 服務，請取消註解下一行。
 [System.Web.Script.Services.ScriptService]
public class Service1 : System.Web.Services.WebService {

    public Service1 () {

        //如果使用設計的元件，請取消註解下行程式碼 
        //InitializeComponent(); 
    }
    [WebMethod(EnableSession = true)]
    public List<string> HelloWorld(string m, string t)
    {

        List<string> listRet = new List<string>();

        listRet.Add("Leo Shih - json");

        listRet.Add("Hello World- json");

        listRet.Add("12345678- json");

        listRet.Add(m + " - json");

        listRet.Add(t + " - json");

        return listRet;

    }
    [WebMethod(EnableSession = true)]
    public List<string> HelloXML(string m, string t)
   {

	List<string> listRet = new List<string>();

	listRet.Add("Leo Shih - xml");

	listRet.Add("Hello World - xml");

	listRet.Add("12345678 - xml");

	listRet.Add(m + " - xml");

	listRet.Add(t + " - xml");

	return listRet;

   }
    
}
