<%@ WebHandler Language="C#" Class="A601L" %>

using System;
using System.Web;

public class A601L : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {

        string Rtn = "";
        Rtn += "資料1|data1|Z1" + "\n";
        Rtn += "資料2|data2|Z2" + "\n";
        context.Response.ContentType = "text/plain";
        context.Response.Write(Rtn);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}