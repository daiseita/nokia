using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

public class Cls_CodeTransfer
{   
    Dictionary<string, string> ObjData = new Dictionary<string, string>();
    public string DataValue = "";
    public Cls_CodeTransfer()
	{
        ImportData("A10I04CV0001", "B", "啟用");
        ImportData("A10I04CV0001", "S", "停用");
        ImportData("A13I03CV0001", "B", "啟用");
        ImportData("A13I03CV0001", "S", "停用");
        ImportData("A12I04CV0001", "B", "啟用");
        ImportData("A12I04CV0001", "S", "停用");
        ImportData("A12I03CV0001", "A", "供應商");
        ImportData("A12I03CV0001", "B", "承包商");
        ImportData("A12I03CV0001", "C", "");
        ImportData("A11I03CV0001", "B", "啟用");
        ImportData("A11I03CV0001", "S", "停用");
        ImportData("A19I03CV0001", "B", "啟用");
        ImportData("A19I03CV0001", "S", "停用");
        ImportData("A20I03CV0001", "B", "啟用");
        ImportData("A20I03CV0001", "S", "停用");

        ImportData("A20I05CV0001", "V", "Nokia User");
        ImportData("A20I05CV0001", "", "");
        ImportData("A20I06CV0001", "V", "客戶聯絡人");
        ImportData("A20I06CV0001", "", "");
        ImportData("A20I07CV0001", "V", "包商聯絡人");
        ImportData("A20I07CV0001", "", "");
        ImportData("A20I08CV0001", "V", "系統管理者");
        ImportData("A20I08CV0001", "", "");
        ImportData("A30I03CV0001", "B", "啟用");
        ImportData("A30I03CV0001", "S", "停用");

        ImportData("A31I03CV0001", "B", "啟用");
        ImportData("A31I03CV0001", "S", "停用");
        ImportData("A31I05CV0001", "L", "Local");
        ImportData("A31I05CV0001", "G", "Global");
        ImportData("A31I05CV0001", "", "");
        ImportData("A31I06CV0001", "V", "3G系統");
        ImportData("A31I06CV0001", "", "");
        ImportData("A31I07CV0001", "V", "4G系統");
        ImportData("A31I07CV0001", "", "");
        ImportData("A31I08CV0001", "V", "序號件");
        ImportData("A31I08CV0001", "", "");
        ImportData("A31I09CV0001", "V", "可分裝");
        ImportData("A31I09CV0001", "", "");
        ImportData("A31I10CV0001", "V", "品項零件");
        ImportData("A31I10CV0001", "", "");

        ImportData("A61I07CV0001", "L", "Local");
        ImportData("A61I07CV0001", "G", "Global");
        ImportData("A61I08CV0001", "3", "3G系統");
        ImportData("A61I08CV0001", "4", "4G系統");
        ImportData("A61I09CV0001", "V", "品項零件");
        ImportData("A61I09CV0001", "", "");
        
    }
    public void setting()
    {
        
        
    }
        
    /* 資料放入物件 */
    public void ImportData(string item, string key, string value)
    {
        string strTemp = item + "_" + key; 
        ObjData.Add(strTemp, value);         
    }
    /* 按key轉換後回傳 */
    public string ExportData(string key, string value)
    {
        try
        {
            string StrId = key + "_" + value;
            if (ObjData[StrId] != "")
            {
                return ObjData[StrId];
            }
            else
            {
                return "";
            }

        }
        catch {
            string check = key;
            return "";
        }
    }

   
}