using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
using System.Text;
public class Cls_File
{
    /* 網站根目錄 */
    public string  MapPath =  System.Web.HttpContext.Current.Server.MapPath("~");
    
    
    public Cls_File()
	{
		//
		// TODO: 在此加入建構函式的程式碼
		//
	}


    /* 建立檔案 */
    public bool CreatFile(string strUrl,string strName)
    {        
        string FilePath = MapPath + strUrl + "/" + strName;        

        FileStream fileStream = new FileStream(FilePath, FileMode.Create);
        fileStream.Close();   //切記開了要關,不然會被佔用而無法修改喔!!! 
        return File.Exists(FilePath);
    }
    /* 建立語系檔案 */
    public bool CreatFileCharSet(string strUrl, string strName,string strContent,string strCharset)
    {
        string FilePath = MapPath + strUrl + "/" + strName;
        DeleteFile(strUrl, strName);
        File.AppendAllText(FilePath, strContent, System.Text.Encoding.GetEncoding(strCharset));
        return File.Exists(FilePath);
    }
    /* 檔案是否存在  未存在是否建立 */
    public bool FileExist(string strUrl, string strName,bool strBoolean)
    {
         

        bool pReturn;
        string FilePath = MapPath + strUrl + "/" + strName;           
        if (!File.Exists(FilePath)) {
            pReturn = false;
            if (strBoolean == true) {                
                CreatFile(strUrl, strName);
                pReturn = File.Exists(FilePath);
            }
        }
        else {
            pReturn = true;
        }       
        
        return pReturn;
    }
    /* 刪除檔案 */
    public void DeleteFile(string strUrl, string strName)
    {
        string FilePath = MapPath + strUrl + "/" + strName;
        File.Delete(FilePath);        
    }
    /* 寫入資料 */
    public void WriteTextCharSet(string strUrl, string strName,string strData,string strCharSet, bool strAppend)
    {
        string FilePath = MapPath + strUrl + "/" + strName;
        /* strAppend寫入法式　由資料尾端補上or重新寫入 */
        using (StreamWriter sw = new StreamWriter(FilePath, strAppend, System.Text.Encoding.GetEncoding(strCharSet)))
        {
            sw.Write(strData);
            sw.Dispose();
        }
    }
    /* 讀取資料 */
    public string ReadTextCharSet(string strUrl, string strName, string strCharSet)
    {
        string FilePath = MapPath + strUrl + "/" + strName;
        String  pReturn,Language;
        if (strCharSet != "")
        {
            Language = strCharSet;
        } else {
            Language = "UTF-8"; 
        }
        using (StreamReader sr = new StreamReader(FilePath, System.Text.Encoding.GetEncoding(Language)))
        {
             pReturn = sr.ReadToEnd();
             sr.Dispose();
        }        
        return pReturn;
    }

    /* 建立文件夾 */
    public bool CreatFolder(string strUrl)
    {
        string FolderPath = MapPath + strUrl ;
        DirectoryInfo di = new DirectoryInfo(FolderPath);
        di.Create();

        return di.Exists;
    }

    /* 文件夾是否存在  未存在是否建立 */
    public bool FolderExist(string strUrl, bool strBoolean)
    {
        bool pReturn;
        string FolderPath = MapPath + strUrl;
        DirectoryInfo di = new DirectoryInfo(FolderPath);
        if (!di.Exists) {
            pReturn = false;
            if (strBoolean == true) {
                CreatFolder(strUrl);
                pReturn = true;
            }
        }else {
            pReturn = true;
        }
        return pReturn;
    }
    /* 刪除文件夾 */
    public void DeleteFolder(string strUrl)
    {
        string FolderPath = MapPath + strUrl;
        DirectoryInfo di = new DirectoryInfo(FolderPath);
        di.Delete();        
    }
    /* 取得資料夾中檔案資訊　回傳為一個陣列　需用foreach ( FileInfo file in Filse) 將資料倒出　     
          Array Filse = oFile.GetFiles("/template/");
          foreach ( FileInfo file in Filse)
          {                         
              Response.Write("<script language='JavaScript'>alert('" + file.Length  + "');</script>");
          }
    */
    public Array GetFiles(string strUrl)
    {
        string FolderPath = MapPath + strUrl;
        Array pReturn;       
        DirectoryInfo Folder = new DirectoryInfo(FolderPath);
        FileInfo[] Files = Folder.GetFiles();
        pReturn = Files;
        return pReturn;
    }
    /* 取得資料夾中文件夾資訊　回傳為一個陣列 
            Array Folders = oFile.GetFolders(strUrl);            
            foreach (DirectoryInfo folder in Folders)
            {
                string FolderName = folder.Name;
            }         
         */
    public Array GetFolders(string strUrl)
    {
        string FolderPath = MapPath + strUrl;
        Array pReturn;
        DirectoryInfo Folders = new DirectoryInfo(FolderPath);
        DirectoryInfo[] Folder = Folders.GetDirectories();
        pReturn = Folder;
        return pReturn;

    }
}