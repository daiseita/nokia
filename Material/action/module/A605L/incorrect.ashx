<%@ WebHandler Language="C#" Class="Info" %>

using System;
using System.Web;
using System.Data;
public class Info : IHttpHandler {

    PageBase pb = new PageBase();
    Cls_Request oValue = new Cls_Request();
    Cls_SQL Sql = new Cls_SQL();
    Cls_Template oTemplate = new Cls_Template();
    Cls_Date oDate = new Cls_Date();
    Cls_SA_Fields saFiled = new Cls_SA_Fields();
    DataTable dt = new DataTable();
    Cls_CodeTransfer oCode = new Cls_CodeTransfer();
    public void ProcessRequest(HttpContext context)
    {
        oValue.setRequestGet("Action,A74I02JJA67I02,A74I03JJA12I02,A74I04JJA31I02,A74I04JJA31I02,A74D01");
        if (oValue.Data("A74I02JJA67I02") == "")
        {
            oValue.setRequestPost("Action,A74I01XA,A74I01XA,A74I02JJA67I02,A74I03JJA12I02,A74I04JJA31I02,A74F01FD0400,A74F02NT,A74D01");
        }
        string thisOut = "";
        string WebUrl = PageBase.WebRoute.ToString();
        HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);
        HttpContext.Current.Response.Cache.SetExpires(DateTime.MinValue);
        HttpContext.Current.Response.Cache.SetNoStore();
        string SQL;
        string A74I02JJA67I02 = oValue.Data("A74I02JJA67I02");
        string A74I03JJA12I02 = oValue.Data("A74I03JJA12I02");
        string A74I04JJA31I02 = oValue.Data("A74I04JJA31I02");
        string A74D01 = oValue.Data("A74D01");
        if (A74I02JJA67I02 != "" && A74I03JJA12I02!="")
        {
            SQL = "select top 1 A74I01XA,A74I02JJA67I02,A74I03JJA12I02,A74F01FD0400,A74F02NT from A74 where A74I02JJA67I02='" + A74I02JJA67I02 + "' and A74I03JJA12I02='" + A74I03JJA12I02 + "' and A74I04JJA31I02='" + A74I04JJA31I02 + "' and A74D01='" + A74D01 + "'";
            dt = Sql.selectTable(SQL, "A74");
            /* 新增編輯邏輯 */
            if (oValue.Data("Action") == "Add" || oValue.Data("Action") == "Upd") { InsertUpdate(context); return; }
            
            oTemplate.SetTemplatesDir(pb.ActionTemplateName + "module/");
            oTemplate.SetTemplateFileCharset("A605L_incorrect_content.html", "UTF-8");
            
            if (dt != null)
            {
                //編輯
                DataSet DataSet1 = new DataSet();
                DataSet1.Tables.Add(dt);
                foreach (DataColumn columename in DataSet1.Tables["A74"].Columns)
                {
                    string pRName = columename.ToString();
                    string pRValue = DataSet1.Tables["A74"].Rows[0][columename].ToString();
                    oTemplate.SetVariable_HTML(pRName, pRValue, saFiled.GetColumeLength(pRName));
                }
                dt.Dispose();
                oTemplate.SetVariable("Action", "Upd");
            }
            else
            {
                //新增
                try
                {
                    string columnString = "A74I01XA,A74I02JJA67I02,A74I03JJA12I02,A74F01FD0400,A74F02NT,A74D01";
                    string[] Column = columnString.Split(',');
                    for (int i = 0; i < Column.Length; i++)
                    {
                        var pRName = Column[i];
                        string pRValue = "";
                        oTemplate.SetVariable_HTML(pRName, pRValue, saFiled.GetColumeLength(pRName));
                    }
                    oTemplate.SetVariable("Action", "Add");
                }
                catch { }               
            }
            oTemplate.SetVariable_HTML("A74I02JJA67I02", A74I02JJA67I02, 12);
            oTemplate.SetVariable_HTML("A74I03JJA12I02", A74I03JJA12I02, 19);
            oTemplate.SetVariable_HTML("A74I04JJA31I02", A74I04JJA31I02, 12);
            oTemplate.SetVariable_HTML("A74D01", A74D01, 8);         
            thisOut = oTemplate.GetOutput();

            context.Response.ContentType = "text/plain";
            context.Response.Write(thisOut);
        }
        else
        {
            context.Response.ContentType = "text/plain";
            context.Response.Write("");
        }
    }
    public void InsertUpdate(HttpContext context)
    {
        string OperateType = "Add";
        Language_Msg Ms = new Language_Msg();
        string SQL = "";
        string A74I01XA = oValue.Data("A74I01XA");
        string A30I02UV0004 = "";
        /* 空白檢查*/
        if (oValue.EmptyCheck("A74F01FD0400") == false)
        {
            context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg01 + "');");
            return;
        }
       
        oDate.RecordNow();        
        string A74I02JJA67I02 = oValue.Data("A74I02JJA67I02");
        string A74I03JJA12I02 = oValue.Data("A74I03JJA12I02");
        string A74I04JJA31I02 = oValue.Data("A74I04JJA31I02");
        string A74F01FD0400 = oValue.Data("A74F01FD0400");
        string A74F02NT = oValue.Data("A74F02NT");
        string A74D01 = oValue.Data("A74D01");
        Sql.ClearQuery();
        dt = null;
        SQL = "select top 1 A74I01XA,A74I02JJA67I02,A74I03JJA12I02,A74F01FD0400,A74F02NT from A74 where A74I02JJA67I02='" + A74I02JJA67I02 + "' and A74I03JJA12I02='" + A74I03JJA12I02 + "' and A74I04JJA31I02='" + A74I04JJA31I02 + "' and A74D01='" + A74D01 + "'";
        dt = Sql.selectTable(SQL, "A74");
        if (dt != null) {
            A74I01XA = dt.Rows[0]["A74I01XA"].ToString();
            OperateType = "Upd";        
        }
        string strSQL = "";
        string Error = "";
        //Sql.transBegin();
        Sql.ClearQuery();
        Sql.SetData("A74I02JJA67I02", A74I02JJA67I02);
        Sql.SetData("A74I03JJA12I02", A74I03JJA12I02);
        Sql.SetNData("A74I04JJA31I02", A74I04JJA31I02);
        Sql.SetNData("A74D01", A74D01);
        Sql.SetData("A74F01FD0400", A74F01FD0400);
        Sql.SetData("A74F02NT", A74F02NT);        
        Sql.SetData("A74IND", oDate.IND);
        Sql.SetData("A74INT", oDate.INT);
        Sql.SetData("A74INA", oDate.INA);

       
        
        if( OperateType == "Add")
        {
            strSQL += Sql.getInserSQL("A74") + "\r\n";
        }
        else
        {
            Sql.SetWhere("And", "A74I01XA", "=", A74I01XA, false);
            strSQL += Sql.getUpdateSQL("A74") + "\r\n";
        }
        if (Sql.errorMessage != "") { Error = Sql.errorMessage; }

        ////string GUID = Pub_Function.SqlRequest(strSQL);
        ////string RtnMsg = Pub_Function.SqlResponse(GUID);

        string RtnMsg = Pub_Function.executeSQL(strSQL);
        switch (RtnMsg)
        {
            case "":
                context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg13 + "');");
                break;
            case "success":
                context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg06 + "');");
                break;
            case "fail":
                context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg05 + "');");
                break;
            default:
                break;
        }
    }
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}