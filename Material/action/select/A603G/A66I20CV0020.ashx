﻿<%@ WebHandler Language="C#" Class="Select" %>

using System;
using System.Web;
using System.Data;
using System.Collections.Generic;
public class Select : IHttpHandler {

    
    public void ProcessRequest(HttpContext context)
    {
        List<RootObject> Root = new List<RootObject>(); 
        List<HtmlSelect> Select = new List<HtmlSelect>();
        Cls_Request oValue = new Cls_Request();
        Cls_SQL Sql = new Cls_SQL();
        DataTable dt = new DataTable();
        Cls_SA_Fields saFiled = new Cls_SA_Fields();
        string Rtn = "";
        oValue.setRequestGet("TableName,ColumeName,ColumeCode,ColumeWhere,Parame,BasicWhere,BasicParame,PlusParame1");
        string TableName, ColumeName, ColumeCode, ColumeWhere, Parame, BasicWhere, BasicParame, PlusParame1;
        TableName = oValue.Data("TableName");
        ColumeName = oValue.Data("ColumeName");
        ColumeCode = oValue.Data("ColumeCode");
        ColumeWhere = oValue.Data("ColumeWhere");
        Parame = oValue.Data("Parame");
        BasicWhere = oValue.Data("BasicWhere");
        BasicParame = oValue.Data("BasicParame");
        PlusParame1 = oValue.Data("PlusParame1");
        string SQL = "select  " + ColumeCode + "," + ColumeName + " from " + TableName + " where " + ColumeWhere + "='" + Parame + "'";
        if (BasicWhere != "") { SQL += " and " + BasicWhere + "='" + BasicParame + "'"; }
        SQL = "select count(A66I20CV0020)cnt ,A66I20CV0020 from A66  where A66I11CV0001='A' and A66I07CV0001='G' and A66I20CV0020<>'' and A66I04JJA31I02='" + Parame + "' and A66I05JJA19I02='" + PlusParame1 + "' group by A66I20CV0020";
        dt = Sql.selectTable(SQL, TableName);

        if (dt!=null && ColumeWhere != "")
        {
            List<TittleSelect> select01_Tittile = new List<TittleSelect>();
            List<ValueSelect> select01_Value = new List<ValueSelect>();
            for (int i = 0; i < dt.Rows.Count ; i++)
            {
                select01_Tittile.Add(new TittleSelect { value = dt.Rows[i][1].ToString() });
                select01_Value.Add(new ValueSelect { value = dt.Rows[i][0].ToString() });
            }
            Select.Add(new HtmlSelect
            {
                tittle = select01_Tittile,
                value = select01_Value
            });
            Root.Add(new RootObject {  html_Select = Select });

            string Json = JsonHelper.JsonSerializer(Root);
            context.Response.ContentType = "text/plain";
            context.Response.Write(Json);
        }
        else {
            context.Response.ContentType = "text/plain";
            context.Response.Write("");
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

public class TittleSelect
{
    public string value { get; set; }
}

public class ValueSelect
{
    public string value { get; set; }
}
public class HtmlSelect
{
    public List<TittleSelect> tittle { get; set; }
    public List<ValueSelect> value { get; set; }
}
public class RootObject
{
    
    public List<HtmlSelect> html_Select { get; set; }
   
}