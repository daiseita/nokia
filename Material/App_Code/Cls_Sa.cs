using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

public class Cls_Sa
{
    Dictionary<string, string> ObjTableInfo = new Dictionary<string, string>(); 
	public Cls_Sa()
	{
        ObjTableInfo.Add("D01", "D01I01XA,D01I02UV0010,D01I03CV0001,D01I04CV0001,D01I05JJD02I02,D01I06JJD03I02,D01I07JJD13I02,D01I08JJD05I02,D01I09JJD15I02,D01I10JJD05I02,D01I11JJD15I02,D01I12JJD04I02,D01I13CV0012,D01I14CV0001,D01I15JJD12I02,D01I16JJD22I02,D01I17CV0012,D01I18CV0024,D01F01NV0064,D01F02CV0064,D01F03CV0064,D01F04NT,D01F05IT,D01F06IT,D01F07IT,D01F08IT,D01IND,D01INT,D01INA,D01INP,D01UPD,D01UPT,D01UPA,D01UPP,D01UPC");        



	}
    /* 回傳欄位名稱 */
    public string  GetColumes(string TableName)
    {
        return ObjTableInfo[TableName];
    }
    
}
public class Cls_SA_Fields
{
    public Cls_SA_Fields()
    {

    }
    /* 回傳欄位長度 */
    public int GetColumeLength(string ColumeName)
    {
        string strFiledName, strType, strLen;
        strFiledName = ""; strType = ""; strLen = "";
        int thisMaxLength=1;
        int thisDot =0;
        if (ColumeName.Length >= 6) { strFiledName = ColumeName.Substring(3, 3); }
        if (ColumeName.Length >= 8) { strType = ColumeName.Substring(6,2); }
        if (ColumeName.Length >= 12) { strLen = ColumeName.Substring(8, 4); }
        
        switch (strFiledName)
        {
            case "IND": thisMaxLength = 8; break;
            case "INT": thisMaxLength = 6; break;
            case "INA": thisMaxLength = 15; break;
            case "INU": thisMaxLength = 10; break;
            case "INP": thisMaxLength = 20; break;
            case "UPD": thisMaxLength = 8; break;
            case "UPT": thisMaxLength = 6; break;
            case "UPA": thisMaxLength = 15; break;
            case "UPU": thisMaxLength = 10; break;
            case "UPP": thisMaxLength = 20; break;
            case "UPC": thisMaxLength = 8; break;                 
            default:                
                break;
        }

        switch (strType)
        {
            case "NC": thisMaxLength = Convert.ToInt32(strLen) ;break;
            case "NV": thisMaxLength = Convert.ToInt32(strLen) ;break;    
            case "NT": thisMaxLength = 9999   ;break;    
            case "CC": thisMaxLength = Convert.ToInt32(strLen) ;break;
            case "CV": thisMaxLength = Convert.ToInt32(strLen) ;break;
            case "CT": thisMaxLength = 9999   ;break;
            case "BB": thisMaxLength = 1      ;break;
            case "IB": thisMaxLength = 19     ;break;
            case "II": thisMaxLength = 8      ;break;
            case "IS": thisMaxLength = 5      ;break;
            case "IT": thisMaxLength = 3      ;break;
            case "FD": thisMaxLength = Convert.ToInt32(strLen.Substring(2));break;  
            case "FF": thisMaxLength = 53     ;break;
            case "FR": thisMaxLength = 53     ;break;
            case "FM": thisMaxLength = 19     ;break;
            case "FS": thisMaxLength = 19     ;break;
            case "TD": thisMaxLength = 24     ;break;
            case "TS": thisMaxLength = 24     ;break;
            case "UI": thisMaxLength = 8      ;break;
            case "US": thisMaxLength = 5      ;break;
            case "UV": thisMaxLength = Convert.ToInt32(strLen) ;break;
            case "UN": thisMaxLength = Convert.ToInt32(strLen) ;break;
            case "UC": thisMaxLength = Convert.ToInt32(strLen) ;break;
            case "XA": thisMaxLength = 8      ;break;
            case "XP": thisMaxLength = 8      ;break;
            case "JU": thisMaxLength = 32     ;break;
            case "JJ": thisMaxLength = 32     ;break;               
            default:
                break;
        }


        return thisMaxLength;
    }

}