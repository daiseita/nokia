<%@ WebHandler Language="C#" Class="Info" %>

using System;
using System.Web;
using System.Data;
using System.Text.RegularExpressions;
public class Info : IHttpHandler {

    PageBase pb = new PageBase();
    Cls_Request oValue = new Cls_Request();
    Cls_SQL Sql = new Cls_SQL();
    Cls_Template oTemplate = new Cls_Template();
    Cls_Date oDate = new Cls_Date();
    Cls_SA_Fields saFiled = new Cls_SA_Fields();
    DataTable dt = new DataTable();
    Cls_CodeTransfer oCode = new Cls_CodeTransfer();
    public string A68I02 = "";
    public string strDate = "";
    public void ProcessRequest(HttpContext context)
    {
        oValue.setRequestGet("Action,A74I01XA,A74I02JJA67I02,A74I03JJA12I02,A74I04JJA31I02,Num,A74D01");
        if (oValue.Data("A74I02JJA67I02") == "")
        {
            oValue.setRequestPost("Action,A74I01XA,A74I02JJA67I02,A74I03JJA12I02,A74I04JJA31I02,Num,A74D01");
            if (oValue.Data("Action") == "Add") { InsertUpdate(context); return; }

            return;
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
        A74D01 = A74D01.Replace("/", "");
        if (A74I02JJA67I02 != "" && A74I03JJA12I02!="")
        {
            SQL = "select top 1 A74I01XA,A74I02JJA67I02,A74I03JJA12I02,A74I04JJA31I02,A74F01FD0400,A74F02NT,A31F01NV0064,A12F01NV0064,A74D01 from A74 left join A31 on A74I04JJA31I02=A31I02UV0010 left join A12 on A74I03JJA12I02=A12I02UV0010 where A74I02JJA67I02='" + A74I02JJA67I02 + "' and A74I03JJA12I02='" + A74I03JJA12I02 + "' and A74I04JJA31I02='" + A74I04JJA31I02 + "' and A74D01='" + A74D01 + "'";
            dt = Sql.selectTable(SQL, "A74");            
                       
            oTemplate.SetTemplatesDir(pb.ActionTemplateName + "module/");
            oTemplate.SetTemplateFileCharset("A608L_Plus_content.html", "UTF-8");
            
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
                oTemplate.SetVariable_HTML("Num", "", 8);
                oTemplate.SetVariable("Action", "Add");
            }
            else
            {
               
            }
            //oTemplate.SetVariable_HTML("A74I02JJA67I02", A74I02JJA67I02, 12);
            //oTemplate.SetVariable_HTML("A74I03JJA12I02", A74I03JJA12I02, 19);
            //oTemplate.SetVariable_HTML("A74I04JJA31I02", A74I04JJA31I02, 12);         
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
        string SourceTable = "";
        string strSQL = "";
        string Error = "";
        Language_Msg Ms = new Language_Msg();
        string SQL = "";
        string A74I01XA = oValue.Data("A74I01XA");
        string A30I02UV0004 = "";
        /* 空白檢查*/
        if (oValue.EmptyCheck("Num") == false)
        {
            context.Response.Write("RtnMsg('RtnMsg','" + Ms.Msg01 + "');");
            return;
        }
        oDate.RecordNow();
        Sql.ClearQuery();
        string A74I02JJA67I02 = oValue.Data("A74I02JJA67I02");
        string A74I03JJA12I02 = oValue.Data("A74I03JJA12I02");
        string A74I04JJA31I02 = oValue.Data("A74I04JJA31I02");
        string A74D01 = oValue.Data("A74D01");
        strDate = A74D01;
        string A68I12JJA12I02 ="";
        string strNum = oValue.Data("Num");
        SQL = "select top 1 A68I02UV0019,A68I05JJA19I02,A68I12JJA12I02,A68I21CV0001 from A68 where A68I03JJA67I02='" + A74I02JJA67I02 + "' and A68I13JJA12I02='" + A74I03JJA12I02 + "' and A68I04JJA31I02='" + A74I04JJA31I02 + "' and A68D01='" + A74D01 + "'";
        dt = Sql.selectTable(SQL, "A68");
        DataTable opDt = new DataTable();
        if (dt != null)
        {
            A68I02 = dt.Rows[0]["A68I02UV0019"].ToString();
            A68I12JJA12I02 = dt.Rows[0]["A68I12JJA12I02"].ToString();
            string cType = A74I02JJA67I02.Substring(8, 1);
            if (dt.Rows[0]["A68I21CV0001"].ToString() == "V")
            {
                SourceTable = "A61";
                //供應商指送                
                string sqlA61 = "select top " + strNum + " A61I02UV0019,A61I05JJA19I02,A61I07CV0001,A61I08CV0001,A61I11CV0001,A61I12JJA12I02,A61I20CV0020,A61F01NV0064 from A61 where A61I04JJA31I02='" + A74I04JJA31I02 + "' and A61I11CV0001='' and A61I07CV0001='" + cType + "' ";
                Sql.ClearQuery();
                opDt = Sql.selectTable(sqlA61, "A61c");
                if (opDt == null || opDt.Rows.Count < Convert.ToInt32(strNum))
                {
                    context.Response.Write("alert('" + Ms.Msg23 + "-1');");
                    return;
                }
            }
            else {
                SourceTable = "A66";
                //貨倉出貨                             
                string sqlA66 = "select top " + strNum + " A66I02UV0019,A66I05JJA19I02,A66I07CV0001,A66I08CV0001,A66I11CV0001,A66I12JJA12I02,A66I20CV0020,A66F01NV0064 from A66 where A66I04JJA31I02='" + A74I04JJA31I02 + "' and A66I11CV0001='A' and A66I07CV0001='" + cType + "' ";
                Sql.ClearQuery();
                opDt = Sql.selectTable(sqlA66, "A61c");
                if (opDt == null || opDt.Rows.Count < Convert.ToInt32(strNum))
                {
                    context.Response.Write("alert('" + Ms.Msg23 + "-2');");
                    return;
                }
            }            
        }
        else {
            context.Response.Write("alert('error-1');");
            return;
        }

        if (opDt != null) {
            //A68I02UV0019,A68I03JJA67I02,A68I04JJA31I02,A68I05JJA19I02,A68I07CV0001,A68I08CV0001,A68I09CV0001,A68I10JJA68I02,A68I11CV0001,A68I12JJA12I02,A68I13JJA12I02
            string A66I03JJA65I02 = "";
            string A66I05JJA19I02 = "";
            string A66I12JJA12I02 = "";
            string A66I13JJA12I02 = "";
            DataTable uDt = new DataTable();
            string strId = "";           
            Sql.ClearQuery();
            string cType = A74I02JJA67I02.Substring(8, 1);
            string strX = "select top 1 A66I03JJA65I02,A66I05JJA19I02,A66I12JJA12I02,A66I13JJA12I02 from A66 where A66I02UV0019='" + A68I02 + "'";
            uDt = Sql.selectTable(strX, "A66o");
            if (uDt != null)
            {
                A66I03JJA65I02 = uDt.Rows[0]["A66I03JJA65I02"].ToString();
                A66I05JJA19I02 = uDt.Rows[0]["A66I05JJA19I02"].ToString();
                A66I12JJA12I02 = uDt.Rows[0]["A66I12JJA12I02"].ToString();
                A66I13JJA12I02 = uDt.Rows[0]["A66I13JJA12I02"].ToString();
            }
            
            for (int i = 0; i < opDt.Rows.Count; i++) {
                               
                
                if (SourceTable == "A66")
                {
                    existCheckA62(opDt.Rows[i]["A66I02UV0019"].ToString());
                    

                    strSQL += setDataA66(opDt.Rows[i]["A66I02UV0019"].ToString(), opDt.Rows[i]["A66I12JJA12I02"].ToString(), A74I03JJA12I02);  
                    
                    /* 供應商不同 指送延用原供應商 倉庫出貨以入料供應商 */
                    strSQL += getInsertSQL(opDt.Rows[i]["A66I02UV0019"].ToString(), A74I02JJA67I02, A74I04JJA31I02, opDt.Rows[i]["A66I05JJA19I02"].ToString(), opDt.Rows[i]["A66I07CV0001"].ToString(), opDt.Rows[i]["A66I08CV0001"].ToString(), "", "B", opDt.Rows[i]["A66I12JJA12I02"].ToString(), A74I03JJA12I02, opDt.Rows[i]["A61F01NV0064"].ToString(), strDate, "");
                    strSQL += getInsertSQL66(opDt.Rows[i]["A66I02UV0019"].ToString(), A66I03JJA65I02, A74I04JJA31I02, opDt.Rows[i]["A66I05JJA19I02"].ToString(), opDt.Rows[i]["A66I07CV0001"].ToString(), opDt.Rows[i]["A66I08CV0001"].ToString(), "", "B", opDt.Rows[i]["A66I12JJA12I02"].ToString(), A74I03JJA12I02, opDt.Rows[i]["A61F01NV0064"].ToString(),"");

                    /* 子項查詢 */
                    string ParentID = opDt.Rows[i]["A66I02UV0019"].ToString();
                    SQL = "select A66I02UV0019,A66I04JJA31I02,A31F01NV0064 from A66 left join  A31 on A66I04JJA31I02=A31I02UV0010 where A66I10JJA66I02='" + ParentID + "'";
                    Sql.ClearQuery();
                    DataTable ChildDt = new DataTable();
                    ChildDt = Sql.selectTable(SQL, "A66ch");
                    if (ChildDt != null)
                    {
                        for (int u = 0; u < ChildDt.Rows.Count; u++)
                        {
                            strSQL += getChildInsertSQL(ChildDt.Rows[u]["A66I02UV0019"].ToString(), A74I02JJA67I02, ChildDt.Rows[u]["A66I04JJA31I02"].ToString(), opDt.Rows[i]["A66I05JJA19I02"].ToString(), opDt.Rows[i]["A66I07CV0001"].ToString(), opDt.Rows[i]["A66I08CV0001"].ToString(), ParentID, "B", opDt.Rows[i]["A66I12JJA12I02"].ToString(), A74I03JJA12I02, ChildDt.Rows[u]["A31F01NV0064"].ToString(), strDate,"");
                            strSQL += getChildInsertSQL66(ChildDt.Rows[u]["A66I02UV0019"].ToString(), A66I03JJA65I02, ChildDt.Rows[u]["A66I04JJA31I02"].ToString(), opDt.Rows[i]["A66I05JJA19I02"].ToString(), opDt.Rows[i]["A66I07CV0001"].ToString(), opDt.Rows[i]["A66I08CV0001"].ToString(), ParentID, "B", opDt.Rows[i]["A66I12JJA12I02"].ToString(), A74I03JJA12I02, ChildDt.Rows[u]["A31F01NV0064"].ToString(), "");
                            existCheckA62(ChildDt.Rows[u]["A66I02UV0019"].ToString());
                            strSQL += setTimeA62(ChildDt.Rows[u]["A66I02UV0019"].ToString(),"");
                        }
                    }

                    strSQL += setDataA61(opDt.Rows[i]["A66I02UV0019"].ToString(), opDt.Rows[i]["A66I12JJA12I02"].ToString(), A74I03JJA12I02, opDt.Rows[i]["A66I05JJA19I02"].ToString());
                    strSQL += setTimeA62(opDt.Rows[i]["A66I02UV0019"].ToString(), "");
                }
                else {
                    existCheckA62(opDt.Rows[i]["A61I02UV0019"].ToString());


                    strSQL += getInsertSQL(opDt.Rows[i]["A61I02UV0019"].ToString(), A74I02JJA67I02, A74I04JJA31I02, A66I05JJA19I02, opDt.Rows[i]["A61I07CV0001"].ToString(), opDt.Rows[i]["A61I08CV0001"].ToString(), "", "B", A66I12JJA12I02, A66I13JJA12I02, opDt.Rows[i]["A61F01NV0064"].ToString(), strDate, "V");
                    strSQL += getInsertSQL66(opDt.Rows[i]["A61I02UV0019"].ToString(), A66I03JJA65I02, A74I04JJA31I02, A66I05JJA19I02, opDt.Rows[i]["A61I07CV0001"].ToString(), opDt.Rows[i]["A61I08CV0001"].ToString(), "", "B", A66I12JJA12I02, A66I13JJA12I02, opDt.Rows[i]["A61F01NV0064"].ToString(), strDate);
                    /* 子項查詢 */
                    string ParentID = opDt.Rows[i]["A61I02UV0019"].ToString();
                    SQL = "select A61I02UV0019,A61I04JJA31I02,A31F01NV0064 from A61 left join  A31 on A61I04JJA31I02=A31I02UV0010 where A61I10JJA61I02='" + ParentID + "'";
                    Sql.ClearQuery();
                    DataTable ChildDt = new DataTable();
                    ChildDt = Sql.selectTable(SQL, "A61ch");
                    if (ChildDt != null)
                    {
                        for (int u = 0; u < ChildDt.Rows.Count; u++)
                        {
                            strSQL += getChildInsertSQL(ChildDt.Rows[u]["A61I02UV0019"].ToString(), A74I02JJA67I02, ChildDt.Rows[u]["A61I04JJA31I02"].ToString(), A66I05JJA19I02, opDt.Rows[i]["A61I07CV0001"].ToString(), opDt.Rows[i]["A61I08CV0001"].ToString(), ParentID, "B", A66I12JJA12I02, A66I13JJA12I02, ChildDt.Rows[u]["A31F01NV0064"].ToString(), strDate,"V");
                            strSQL += getChildInsertSQL66(ChildDt.Rows[u]["A61I02UV0019"].ToString(), A66I03JJA65I02, ChildDt.Rows[u]["A61I04JJA31I02"].ToString(), A66I05JJA19I02, opDt.Rows[i]["A61I07CV0001"].ToString(), opDt.Rows[i]["A61I08CV0001"].ToString(), ParentID, "B", A66I12JJA12I02, A66I13JJA12I02, ChildDt.Rows[u]["A31F01NV0064"].ToString(), strDate);
                            existCheckA62(ChildDt.Rows[u]["A61I02UV0019"].ToString());
                            strSQL += setTimeA62(ChildDt.Rows[u]["A61I02UV0019"].ToString(), "V");
                        }
                    }

                    strSQL += setDataA61(opDt.Rows[i]["A61I02UV0019"].ToString(), A66I12JJA12I02, A66I13JJA12I02, A66I05JJA19I02);
                    strSQL += setTimeA62(opDt.Rows[i]["A61I02UV0019"].ToString(), "V");
                }
                
            }
        
            
        }
        //strSQL = "";                              
        string RtnMsg = Pub_Function.executeSQL(strSQL);
        switch (RtnMsg)
        {
            case "":
                context.Response.Write("alert('" + Ms.Msg13 + "');");
                break;
            case "success":
                context.Response.Write("alert('" + Ms.Msg06 + "');");
                break;
            case "fail":
                context.Response.Write("alert('" + Ms.Msg05 + "');");
                break;
            default:
                break;
        }
    }
    /*新增*/
    public string getInsertSQL(string A68I02UV0019, string A68I03JJA67I02, string A68I04JJA31I02, string A68I05JJA19I02, string A68I07CV0001, string A68I08CV0001, string A68I10JJA68I02, string A68I11CV0001, string A68I12JJA12I02, string A68I13JJA12I02, string A68F01NV0064, string A68D01, string A68I21CV0001)
    {
        string pReturn = "";
        Sql.ClearQuery();
        Sql.SetData("A68I02UV0019", A68I02UV0019);
        Sql.SetData("A68I03JJA67I02", A68I03JJA67I02);
        Sql.SetData("A68I04JJA31I02", A68I04JJA31I02);
        Sql.SetData("A68I05JJA19I02", A68I05JJA19I02);
        Sql.SetData("A68I07CV0001", A68I07CV0001);
        Sql.SetData("A68I08CV0001", A68I08CV0001);
        //Sql.SetData("A68I09CV0001", A68I09CV0001);
        Sql.SetData("A68I10JJA68I02", A68I10JJA68I02);
        Sql.SetData("A68I11CV0001", A68I11CV0001);
        Sql.SetData("A68I12JJA12I02", A68I12JJA12I02);
        Sql.SetData("A68I13JJA12I02", A68I13JJA12I02);
        Sql.SetData("A68F01NV0064", A68F01NV0064);
        if (A68D01 != "")
        {
            Sql.SetData("A68D01", A68D01);
        }
        Sql.SetData("A68I21CV0001", A68I21CV0001);
        Sql.SetData("A68IND", oDate.IND);
        Sql.SetData("A68INT", oDate.INT);
        Sql.SetData("A68INA", oDate.INA);
        Sql.SetData("A68UPD", oDate.IND);
        Sql.SetData("A68UPT", oDate.INT);
        Sql.SetData("A68UPA", oDate.INA);
        pReturn = Sql.getInserSQL("A68") + "\r\n";
        return pReturn;
    }
    /*新增*/
    public string getInsertSQL66(string A68I02UV0019, string A68I03JJA67I02, string A68I04JJA31I02, string A68I05JJA19I02, string A68I07CV0001, string A68I08CV0001, string A68I10JJA68I02, string A68I11CV0001, string A68I12JJA12I02, string A68I13JJA12I02, string A68F01NV0064, string A68D01)
    {
        string pReturn = "";
        Sql.ClearQuery();
        Sql.SetData("A66I02UV0019", A68I02UV0019);
        Sql.SetData("A66I03JJA65I02", A68I03JJA67I02);
        Sql.SetData("A66I04JJA31I02", A68I04JJA31I02);
        Sql.SetData("A66I05JJA19I02", A68I05JJA19I02);
        Sql.SetData("A66I07CV0001", A68I07CV0001);
        Sql.SetData("A66I08CV0001", A68I08CV0001);
        //Sql.SetData("A68I09CV0001", A68I09CV0001);
        Sql.SetData("A66I10JJA66I02", A68I10JJA68I02);
        Sql.SetData("A66I11CV0001", A68I11CV0001);
        Sql.SetData("A66I12JJA12I02", A68I12JJA12I02);
        Sql.SetData("A66I13JJA12I02", A68I13JJA12I02);
        Sql.SetData("A66F01NV0064", A68F01NV0064);
        if (A68D01 != "")
        {
            Sql.SetData("A66D01", A68D01);
        }
        Sql.SetData("A66IND", oDate.IND);
        Sql.SetData("A66INT", oDate.INT);
        Sql.SetData("A66INA", oDate.INA);
        Sql.SetData("A66UPD", oDate.IND);
        Sql.SetData("A66UPT", oDate.INT);
        Sql.SetData("A66UPA", oDate.INA);
        pReturn = Sql.getInserSQL("A66") + "\r\n";
        return pReturn;
    }

    public string getChildInsertSQL(string A68I02UV0019, string A68I03JJA67I02, string A68I04JJA31I02, string A68I05JJA19I02, string A68I07CV0001, string A68I08CV0001, string A68I10JJA68I02, string A68I11CV0001, string A68I12JJA12I02, string A68I13JJA12I02, string A68F01NV0064, string A68D01, string A68I21CV0001)
    {
        string pReturn = "";
        Sql.ClearQuery();
        Sql.SetData("A68I02UV0019", A68I02UV0019);
        Sql.SetData("A68I03JJA67I02", A68I03JJA67I02);
        Sql.SetData("A68I04JJA31I02", A68I04JJA31I02);
        Sql.SetData("A68I05JJA19I02", A68I05JJA19I02);
        Sql.SetData("A68I07CV0001", A68I07CV0001);
        Sql.SetData("A68I08CV0001", A68I08CV0001);
        Sql.SetData("A68I09CV0001", "V");        
        Sql.SetData("A68I10JJA68I02", A68I10JJA68I02);
        Sql.SetData("A68I11CV0001", A68I11CV0001);
        Sql.SetData("A68I12JJA12I02", A68I12JJA12I02);
        Sql.SetData("A68I13JJA12I02", A68I13JJA12I02);
        Sql.SetData("A68F01NV0064", A68F01NV0064);
        if (A68D01 != "")
        {
            Sql.SetData("A68D01", A68D01);
        }
        Sql.SetData("A68I21CV0001", A68I21CV0001);
        Sql.SetData("A68IND", oDate.IND);
        Sql.SetData("A68INT", oDate.INT);
        Sql.SetData("A68INA", oDate.INA);
        Sql.SetData("A68UPD", oDate.IND);
        Sql.SetData("A68UPT", oDate.INT);
        Sql.SetData("A68UPA", oDate.INA);
        pReturn = Sql.getInserSQL("A68") + "\r\n";
        return pReturn;
    }
    public string getChildInsertSQL66(string A68I02UV0019, string A68I03JJA67I02, string A68I04JJA31I02, string A68I05JJA19I02, string A68I07CV0001, string A68I08CV0001, string A68I10JJA68I02, string A68I11CV0001, string A68I12JJA12I02, string A68I13JJA12I02, string A68F01NV0064, string A68D01)
    {
        string pReturn = "";
        Sql.ClearQuery();
        Sql.SetData("A66I02UV0019", A68I02UV0019);
        Sql.SetData("A66I03JJA65I02", A68I03JJA67I02);
        Sql.SetData("A66I04JJA31I02", A68I04JJA31I02);
        Sql.SetData("A66I05JJA19I02", A68I05JJA19I02);
        Sql.SetData("A66I07CV0001", A68I07CV0001);
        Sql.SetData("A66I08CV0001", A68I08CV0001);
        Sql.SetData("A66I09CV0001", "V");
        Sql.SetData("A66I10JJA66I02", A68I10JJA68I02);
        Sql.SetData("A66I11CV0001", A68I11CV0001);
        Sql.SetData("A66I12JJA12I02", A68I12JJA12I02);
        Sql.SetData("A66I13JJA12I02", A68I13JJA12I02);
        Sql.SetData("A66F01NV0064", A68F01NV0064);
        if (A68D01 != "") {
            Sql.SetData("A66D01", A68D01);
        }
        Sql.SetData("A66IND", oDate.IND);
        Sql.SetData("A66INT", oDate.INT);
        Sql.SetData("A66INA", oDate.INA);
        Sql.SetData("A66UPD", oDate.IND);
        Sql.SetData("A66UPT", oDate.INT);
        Sql.SetData("A66UPA", oDate.INA);
        pReturn = Sql.getInserSQL("A66") + "\r\n";
        return pReturn;
    }
    public string setDataA61(string A61I02UV0019, string A61I12JJA12I02, string A61I13JJA12I02, string A61I05JJA19I02)
    {
        string strSQL = "";
        Sql.ClearQuery();
        Sql.SetData("A61I11CV0001", "B");
        Sql.SetData("A61I12JJA12I02", A61I12JJA12I02);
        Sql.SetData("A61I13JJA12I02", A61I13JJA12I02);
        Sql.SetData("A61I05JJA19I02", A61I05JJA19I02);
        Sql.SetWhere("or", "A61I02UV0019", "=", A61I02UV0019, true);
        Sql.SetWhere("or", "A61I10JJA61I02", "=", A61I02UV0019, true);
        strSQL += Sql.getUpdateSQL("A61") + "\r\n";
        return strSQL;
    }
    public string setDataA66(string A61I02UV0019, string A61I12JJA12I02, string A61I13JJA12I02)
    {
        string strSQL = "";
        Sql.ClearQuery();
        Sql.SetData("A66I11CV0001", "B");
        Sql.SetData("A66I12JJA12I02", A61I12JJA12I02);
        Sql.SetData("A66I13JJA12I02", A61I13JJA12I02);
        Sql.SetWhere("or", "A66I02UV0019", "=", A61I02UV0019, true);
        Sql.SetWhere("or", "A66I10JJA66I02", "=", A61I02UV0019, true);
        strSQL += Sql.getUpdateSQL("A66") + "\r\n";
        return strSQL;
    }
    public string setTimeA62(string A61I02UV0019, string A68I21CV0001)
    {
        string strSQL = "";
        Sql.ClearQuery();
        if (A68I21CV0001 == "V") {
            Sql.SetData("A62D01", strDate);
            Sql.SetData("A62T01", "000000");
            Sql.SetData("A62A01", strDate + "000000");
        }
        Sql.SetData("A62D02", strDate);
        Sql.SetData("A62T02", "000000");
        Sql.SetData("A62A02", strDate + "000000");
        Sql.SetWhere("And", "A62I02JJA61I02", "=", A61I02UV0019, true);
        strSQL += Sql.getUpdateSQL("A62") + "\r\n";
        return strSQL;
    }
    public void existCheckA62(string A61I02UV0019)
    {
        DataTable dt = new DataTable();
        string strSQL = "";
        string SQL = "select A62I02JJA61I02 from A62 where A62I02JJA61I02='" + A61I02UV0019 + "'";
        Sql.ClearQuery();
        dt = Sql.selectTable(SQL, "A62");
        if (dt == null)
        {
            Sql.SetData("A62I02JJA61I02", A61I02UV0019);
            strSQL += Sql.getInserSQL("A62") + "\r\n";
            string RtnMsg = Pub_Function.executeSQL(strSQL);
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