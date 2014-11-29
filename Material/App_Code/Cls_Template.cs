using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text.RegularExpressions;
public class Cls_Template
{
    Cls_File oFile = new Cls_File();
    string p_templates_dir = "/template/"; 
    string p_var_tag_o = "{{";
    string p_var_tag_c = "}}";
    string thisTemplate = "";
    string p_template = "";
    List<string> thisHTMLInputTag = new List<string>();
    List<string> thisHTMLTag = new List<string>();
    Dictionary<string, string> p_variables_list = new Dictionary<string, string>();
    Dictionary<string, string> p_blocks_list = new Dictionary<string, string>();
    Dictionary<string, string> p_blocks_name_list = new Dictionary<string, string>();
    Dictionary<string, string> p_parsed_blocks_list = new Dictionary<string, string>(); 
	public Cls_Template()
	{		
	}
    /* 設定模版資料夾路徑 */
    public void SetTemplatesDir(string strUrl) {
       p_templates_dir = strUrl;     
    } 
    /* 設定模版,語系 */
    public void SetTemplateFileCharset(string strUrl, string strCharSet) 
    { 
       string pRetrun ="";
       p_template = oFile.ReadTextCharSet(p_templates_dir, strUrl, strCharSet);
       thisTemplate = p_template;
       AnalysisTemplateTag();
    }
    /* 回傳模版 */
    public string GetTemplate() { return p_template; }
    /* 設定模版變數資料 */
    public void SetVariable(string strName,string  strValue){
        if ( thisTemplate.IndexOf("{{" + strName.Trim() + "}}") > 0)
        {
            if (!p_variables_list.ContainsKey(strName)) {
                p_variables_list.Add(strName, strValue);
            }else {
                p_variables_list.Remove(strName);
                p_variables_list.Add(strName, strValue);
            }        
        }    
    }
    /* 取得模版變數資料 */
    public string   GetVariablesList() 
    {
        string pRetrun = "";      
        foreach (KeyValuePair<string, string> item in p_variables_list)
        {
            pRetrun += "<div> Key : " + item.Key.ToString() + "_value = " + p_variables_list[item.Key.ToString()] + "</div>";
        } 
        return pRetrun;
    }
    /* 模版分析報告 */
    public string AnalysisReport() {
        string pRetrun = ""; 
        if(thisHTMLInputTag.Count  > 0){
            for (int x = 0; x <= (thisHTMLInputTag.Count-1); x++)
            {
                if (pRetrun != "") { pRetrun += ","; }
                pRetrun += thisHTMLInputTag[x];
            }
        }
        if (thisHTMLTag.Count > 0)
        {
            for (int x = 0; x <= (thisHTMLTag.Count - 1); x++)
            {
                if (pRetrun != "") { pRetrun += ","; }
                pRetrun += thisHTMLTag[x];
            }
        }
        return pRetrun;
    }
    /* 模版分析 */
    private void AnalysisTemplateTag() {
        string[] strInput = new string[] { "text", "password", "submit", "button", "hidden" };
        string[] strTag = new string[] { "div", "span", "textarea", "font", "p" };
        thisHTMLInputTag.Clear();
        foreach (string input in strInput) {
            if (thisTemplate.IndexOf((".html_"+input+"}}").ToUpper()) >0)
            {
                thisHTMLInputTag.Add(input.ToUpper());
            }        
        }
        thisHTMLTag.Clear();
        foreach (string html in strTag)
        {
            if (thisTemplate.IndexOf((".html_" + html + "}}").ToUpper()) > 0)
            {
                thisHTMLTag.Add(html.ToUpper());
            }
        }        
    }
    /* 模版輸出 */
    public string  GetOutput() {
        string pattern = "(" + p_var_tag_o + ")([^}]+)" + p_var_tag_c;
        Regex regex = new Regex(pattern, RegexOptions.IgnoreCase );
        Match match = regex.Match(p_template);        
        string strTag;
        while (match.Success)
        {            
            strTag = match.ToString(); strTag = strTag.Substring(2, (strTag.Length - 4));
            if (p_variables_list.ContainsKey(strTag))
            {                                
                Regex reg = new Regex(match.ToString(), RegexOptions.IgnoreCase);
                p_template = reg.Replace(p_template, p_variables_list[strTag]);
            }          
            match = match.NextMatch();
        }
        pattern = "(__)([_a-z0-9]+)__";
        Regex rge = new Regex(pattern, RegexOptions.IgnoreCase);
        p_template = rge.Replace(p_template, "");
        return p_template;
    }

    /* 設定模版變數的 HTML 輸入控制項物件資料(類別,代碼,資料,長度) */
    public void SetVariable_HTML_INPUT(string strSort,string strName,string strValue,int intLength) { 
        string strKey = strName + ".HTML_" + strSort;
        string strOut = "<input type='" + strSort.ToLower() + "' id='" + strName + "' class='" + strName + "' name='" + strName + "'  value='" + strValue + "'  ";
        if (intLength > 0) { strOut += "maxlength='" + intLength.ToString() + "'"; }      
        strOut+= ">";
        //p_variables_list.Add(strKey, strOut);
        SetVariable(strKey, strOut);
    }
    /* 設定模版變數的 HTML 標記式資料(類別,代碼,資料,長度) */
    public void SetVariable_HTML_TAG(string strSort, string strName, string strValue, int intLength){ 
        //string  strCheck = "[SELECT][OPTION][TEXTAREA][BUTTON]";
        string  strTag = strSort.ToUpper();
        string  strKey = strName + ".HTML_" + strSort;
        //int iCheck = strCheck.IndexOf("[" + strSort + "]");
        string strOut;
        strOut = "<" + strTag +  " id='" + strName + "' class='" + strName + "' name='" + strName + "'";
        if (intLength > 0) { strOut += "maxlength='" + intLength.ToString() + "'"; }
        strOut += ">" + strValue + "</" + strSort + ">";
        //p_variables_list.Add(strKey, strOut);
        SetVariable(strKey, strOut);
    }
    /* 設定模版變數標籤 */
    public void SetVariable_HTML(string strName, string strValue, int intLength)
    {
        strValue = strValue.Replace("<", "&lt;");
        strValue = strValue.Replace(">", "&gt;");
        strValue = strValue.Replace("''", "&quot;");
        for (int x = 0; x <= (thisHTMLInputTag.Count - 1); x++)
        {
            SetVariable_HTML_INPUT(thisHTMLInputTag[x], strName, strValue, intLength);
        }
        for (int x = 0; x <= (thisHTMLTag.Count - 1); x++)
        {
            SetVariable_HTML_TAG(thisHTMLTag[x], strName, strValue, intLength);
        }

        SetVariable(strName, strValue);
    }
    /* 設定模版變數的 HTML OPTION 選單物件資料需配合下拉式選單 (代碼,說明,比對資料,輸入資料) */
    public void SetVariable_HTML_OPTION(string strId, string strTitle, string strValue1, string strValue2) {
        strValue2 = strValue2.Replace("<", "&lt;");
        strValue2 = strValue2.Replace(">", "&gt;");
        strValue2 = strValue2.Replace("''", "&quot;");
        string pId = strId + ".HTML_SELECT_OPTION";
        string strObj = "<option value='" + strValue2 + "'";
        if (strValue1.Trim() == strValue2.Trim()) { strObj += "selected"; }
        strObj += " >" + strTitle + "</option>";
        if (!p_variables_list.ContainsKey(pId)) {
            p_variables_list.Add(pId, strObj);
        }else {
            string strLastContent = p_variables_list[pId] + strObj;
            p_variables_list[pId] = strLastContent;
        }
    }
    /* 設定模版變數的 HTML OPTION 下拉式選單物件資料 (代碼) */
    public void SetVariable_HTML_SELECT(string strId){
        string pId = strId + ".HTML_SELECT";
        string pOid = strId + ".HTML_SELECT_OPTION";
        string strOption = "";
        string strValue="";
        if (p_variables_list.ContainsKey(pOid)) { strOption = p_variables_list[pOid]; }
        strOption = "<option value=''>請選擇</option>" + strOption;
        strValue = "<SELECT name='" + strId + "' id='" + strId + "' class='" + strId + "'>" + strOption + "</SELECT>";
        SetVariable(pId, strValue);
    }
    /* 設定模版變數的 HTML RADIO 輸入控制項物件區塊式資料(代碼,說明,比對資料,輸入資料) */
    public void SetVariable_HTML_RADIO(string strId , string strTitle,string strValue1,string strValue2) {
        strValue2 = strValue2.Replace("<", "&lt;");
        strValue2 = strValue2.Replace(">", "&gt;");
        strValue2 = strValue2.Replace("''", "&quot;");
        string pId = strId + ".HTML_RADIO";
        string strObj = "<input type='radio'' name='" + strId + "' class='" + strId + "' value='" + strValue2 + "'";
        if (strValue1.Trim() == strValue2.Trim()) { strObj += "checked"; }
        strObj += " >" + strTitle + " ";
        AppendHtmlTag(pId ,strObj ,"span",strId);
    }
    /* 設定附加模版變數 HTML 標記的資料(代碼,內容,HTML標記,HTML ID */
    public void AppendHtmlTag(string  pId, string  strObj,string  pHtml, string  strId) {
        string strOption = ""; string strTemp1, strTemp2;
        if (p_variables_list.ContainsKey(pId)) { strOption = p_variables_list[pId]; }
        strTemp1 = "<" + pHtml + " id='" + strId + "'>";
        strTemp2 = "</" + pHtml + ">";
        string pCompare = "";
        if (strOption != "") {pCompare=strOption.Substring(0, strTemp1.Length);  }
        if (pCompare == strTemp1){
            strOption = strOption.Substring(strTemp1.Length, (strOption.Length -(strTemp1.Length + strTemp2.Length)));
        }
        strOption = strTemp1 + strOption + strObj + strTemp2;
        if (!p_variables_list.ContainsKey(pId))
        {
            p_variables_list.Add(pId, strOption);
        }else {
            p_variables_list[pId] = strOption;
        }
    }

    /* 設定區塊 */
    public void  UpdateBlock (string inBlockName) {        
        string pattern = @"<!--\s+BEGIN\s+(" + inBlockName + @")\s+-->([\s\S.]*)<!--\s+END\s+\1\s+-->";
        Regex regex = new Regex(pattern, RegexOptions.IgnoreCase);
        Match match = regex.Match(p_template);        
        string strOut="";
        while (match.Success)
        {
            strOut = match.ToString();   
            match = match.NextMatch();
        }
        int iStart, iEnd;
        iStart = strOut.IndexOf("-->") + 3;
        iEnd = strOut.IndexOf("<!-- END");
        strOut = strOut.Substring(iStart, iEnd - iStart);
        if (p_blocks_list.ContainsKey(inBlockName))
        {                   
            p_blocks_list.Remove(inBlockName);
            p_blocks_name_list.Remove(inBlockName);            
        }
        p_blocks_list.Add(inBlockName, strOut);
        p_blocks_name_list.Add(inBlockName, inBlockName);
        p_template = regex.Replace(p_template, "__" + inBlockName + "__");
        string abc = "";
    }
    /* 貼上區塊 */
    public void ParseBlock(string inBlockName){
        string strOut = GetBlock(inBlockName);

        /* block 中之 block處理 */
        string pattern = "(__)([_a-z0-9]+)__";
        Regex regex = new Regex(pattern, RegexOptions.IgnoreCase);
        Match match = regex.Match(strOut);
        while (match.Success)
        {
            string pChild_BlockName = match.ToString();
            pChild_BlockName = pChild_BlockName.Substring(2, (pChild_BlockName.Length - 4));
            if (p_parsed_blocks_list.ContainsKey(pChild_BlockName))
            {
                strOut = regex.Replace(strOut, p_parsed_blocks_list[pChild_BlockName]);
                p_parsed_blocks_list.Remove(pChild_BlockName);
            }else{
               pattern = "__"+pChild_BlockName+"__"; 
               Regex rge = new Regex(pattern, RegexOptions.IgnoreCase);
               strOut = rge.Replace(strOut, "");
            }            
            match = match.NextMatch();
        }
        string strLastContent = "";
        /* 第二次以後block處理 */
        if (p_parsed_blocks_list.ContainsKey(inBlockName))
        {
            strLastContent = p_parsed_blocks_list[inBlockName] + strOut;
            p_parsed_blocks_list.Remove(inBlockName);
            p_parsed_blocks_list[inBlockName] = strLastContent;

        }else {
            p_parsed_blocks_list[inBlockName] = strOut;            
        }
        pattern = "__" + inBlockName + "__";
        Regex rge2 = new Regex(pattern, RegexOptions.IgnoreCase);
        Match match2 = rge2.Match(p_template);
        while (match2.Success)
        {
            strOut = GetParsedBlock(inBlockName);
            pattern = "__" + inBlockName + "__";
            Regex rge3 = new Regex(pattern, RegexOptions.IgnoreCase);
            p_template = rge3.Replace(p_template, strOut + "__" + inBlockName + "__");
            match2 = match2.NextMatch();
        }

    }
    /* 取得輸出暫存區塊(複數&填入標籤) */
    private string GetParsedBlock(string inBlockName)  {
        if (p_parsed_blocks_list.ContainsKey(inBlockName)){
            string strOut = p_parsed_blocks_list[inBlockName];
            strOut = ParseBlockVars(strOut);
            p_parsed_blocks_list.Remove(inBlockName);
            return strOut;            
        }else{
            return "<!--__" + inBlockName + "__-->";
        }
    }
    /* 取得暫存區塊 */
    private string GetBlock(string inBlockName) {
        if (p_blocks_list.ContainsKey(inBlockName)){
            string strOut = p_blocks_list[inBlockName];
            strOut = ParseBlockVars(strOut);

            return strOut;
        }else{
            return "<!--__" + inBlockName + "__-->";
        }
    }
    /* 填入最新標籤 */
    private string ParseBlockVars(string strContent){
        string pattern = "(" + p_var_tag_o + ")([^}]+)" + p_var_tag_c;
        Regex regex = new Regex(pattern, RegexOptions.IgnoreCase);
        Match match = regex.Match(strContent);
        string strTag;
        while (match.Success)
        {
            strTag = match.ToString(); strTag = strTag.Substring(2, (strTag.Length - 4));
            if (p_variables_list.ContainsKey(strTag))
            {
                Regex reg = new Regex(match.ToString(), RegexOptions.IgnoreCase);
                strContent = reg.Replace(strContent, p_variables_list[strTag]);
            }
            match = match.NextMatch();
        }
        return strContent;
    }


    /* 取出標籤中字串 */
    public string CutTagValue()
    {
        string pattern = @"(<CameraIP JSONType='Value'>)([\s\S.]*)" + "</CameraIP>";
        Regex regex = new Regex(pattern, RegexOptions.IgnoreCase);
        Match match = regex.Match(p_template);
        string strTag;
        while (match.Success)
        {
            strTag = match.ToString(); 
            
            match = match.NextMatch();
        }        
        return "";
    }

}