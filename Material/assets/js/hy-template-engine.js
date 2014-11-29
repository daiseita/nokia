jQuery.Hy_Template_Engine = Array();
Hy_Template_Engine_ColumeInput = Array();         
Hy_Template_Engine_ColumeSelect = Array();     
Hy_Template_Engine_ColumeRadio = Array();     
Hy_Template_Engine_ColumeCheckbox = Array();   
Hy_Template_Engine_ColumeParame = Array();   
Hy_Template_Engine_UpdateBlock_List = Array();
jQuery.Hy_Template_Engine = function(tag,options) {
                          jQuery.Hy_Template_Engine ["option"] = options;   
                          jQuery.Hy_Template_Engine ["id"] = tag;
                          jQuery.Hy_Template_Engine ["SerialNumber"]=0; 
                           /* 載入模版 */
                          var Hy_Template_Engine_Load_Template = function(tag,options) {                            	    
                                $(tag).kcwAjax(options.TemplateUrl,{
                       	          Job:"LINK",
                       	          Response: {
	  	                            	         ToExecute: false, ToGoal: false,  ToTrigger: false
	  	                            },
                       	          LocalEvents: {
                       	          	success: function(Trigger,GoalTag,TriggerGoalTag,Response) {
                       	          		          /*  alert(Response);  */
                                                if(Response!=""&&Response!=undefined){  
                                                	  jQuery.Hy_Template_Engine["Template"] = Response;                                                  	                                            	  
                                                	  jQuery.Hy_Template_Engine["SourceTemplate"] = Response; 
                                                	  Hy_Template_Engine_Load_JData(tag,options);       
                                                	  var obj = new Hy_Template_Engine_Producer();                                              	  
                                                	  obj.Hy_Template_Engine_ColumeRecord(tag,options);                                                   
                                                }                                           
                       	          		       }
                       	            }
                       	        }); 	 	                          	    
                          }	    
                          
                          /* 載入資料-初始載入 */
                          var Hy_Template_Engine_Load_JData = function(tag,options) {  
                          	    var str = options.JsonDataUrl+"?type=default&PageNum="+options.PageNum+"&ThisPage="+options.ThisPage;
                                $(tag).kcwAjax(str,{
                       	          Job:"LINK",
                       	          Response: {
	  	                            	         ToExecute: false, ToGoal: false,  ToTrigger: false
	  	                            },
                       	          LocalEvents: {
                       	          	success: function(Trigger,GoalTag,TriggerGoalTag,Response) {
                       	          		          /*  alert(Response);  */
                                                if(Response!=""&&Response!=undefined){  
                                                	  jQuery.Hy_Template_Engine["Json"] = Response;     
                                                	  var Json = jQuery.Hy_Template_Engine["Json"];
                                                    var contact = JSON.parse(Json);                                                        
                                                    jQuery.Hy_Template_Engine["contact"] = contact;   
                                                    jQuery.Hy_Template_Engine ["SerialNumber"] = parseInt(jQuery.Hy_Template_Engine["contact"][0].page_Info.DataFrom);
                                                    //alert(jQuery.Hy_Template_Engine["contact"][0].tag_pareme.parame[0].value)                                                                                                                                                                                         
                                                    /* 模板處理 */            
                                                    var obj = new Hy_Template_Engine_Producer();                                             
                                                    jQuery.Hy_Template_Engine["Template"] = obj.Hy_Template_Engine_Analysis(jQuery.Hy_Template_Engine["Template"],0);                                                    
                                                    obj.Hy_Template_Engine_UpdateBlock_Procedure();
                                                                 //alert(contact[0].html_input[3].colume[7].value);                                    
                                                    $(tag).html(jQuery.Hy_Template_Engine["Template"]);
                                                    
                                                    /* 分頁資訊處理 */    
                                                    obj.Hy_Template_Engine_Write_PageInfo();   
                                                }                                           
                       	          		       }
                       	            }
                       	        }); 	 	
                          	  
                          }
                                                                                                                                                                           	                
                         
              
              
                           Hy_Template_Engine_Load_Template(tag,options);
              
                            
                          
 };      
 
  /* 模版產生器 */
  var Hy_Template_Engine_Producer = function() { 
  	
  	                  /* 模板欄位記錄 */         	        
                         this.Hy_Template_Engine_ColumeRecord = function(tag,options) {    
                         	               /* 一般欄位設定 */
                                  	       var ColumeName_Input = options.ColumeName_Input;
                                  	       var pArray_Input = ColumeName_Input.split(",");
                                  	       for (var i=0;i<pArray_Input.length;i++)
                                          {
                                              Hy_Template_Engine_ColumeInput[pArray_Input[i]] = i;                              
                                          }
                                          /*  select欄位設定 */              
                                           if(options.ColumeName_Select!=""){           
                                  	         var ColumeName_Select = options.ColumeName_Select;
                                  	         var pArray_Select = ColumeName_Select.split(",");
                                  	         jQuery.Hy_Template_Engine["Select_Colume_Count"] = pArray_Select.length;
                                  	          for (var a=0;a<pArray_Select.length;a++)
                                              {
                                              	   	 
                                                  Hy_Template_Engine_ColumeSelect[pArray_Select[a]] = a;                                                             
                                              }
                                  	       }else{
                                  	         jQuery.Hy_Template_Engine["Select_Colume_Count"] = 0;
                                  	       }                                    	       
                                  	      
                                          /*  Radio欄位設定 */
                                          if(options.ColumeName_Radio!=""){
                                             var ColumeName_Radio = options.ColumeName_Radio;
                                  	          var pArray_Radio = ColumeName_Radio.split(",");
                                  	          jQuery.Hy_Template_Engine["Radio_Colume_Count"] = pArray_Radio.length;                                  	        
                                  	          for (var d=0;d<pArray_Radio.length;d++)
                                             {
                                                 Hy_Template_Engine_ColumeRadio[pArray_Radio[d]] = d;                                                                                                                                                              
                                             }
                                          }else{
                                          	  jQuery.Hy_Template_Engine["Radio_Colume_Count"] = 0;
                                          }   
                                          /*  Checkbox欄位設定 */
                                          if(options.ColumeName_Checkbox!=""){
                                             var ColumeName_Checkbox = options.ColumeName_Checkbox;
                                  	          var pArray_Checkbox = ColumeName_Checkbox.split(",");
                                  	          jQuery.Hy_Template_Engine["Checkbox_Colume_Count"] = pArray_Checkbox.length;                                  	        
                                  	          for (var r=0;r<pArray_Checkbox.length;r++)
                                             {
                                                 Hy_Template_Engine_ColumeCheckbox[pArray_Checkbox[r]] = r;                                                                                                                                                              
                                             }
                                          }else{
                                          	  jQuery.Hy_Template_Engine["Checkbox_Colume_Count"] = 0;
                                          }   
                                          /*  參數欄位設定 */
                                          if(options.ColumeName_Parame!=""){
                                             var ColumeName_Parame = options.ColumeName_Parame;
                                  	          var pArray_Parame= ColumeName_Parame.split(",");
                                  	          jQuery.Hy_Template_Engine["Parame_Colume_Count"] = pArray_Parame.length;                                  	        
                                  	          for (var x=0;x<pArray_Parame.length;x++)
                                             {                                             	
                                                 Hy_Template_Engine_ColumeParame[pArray_Parame[x]] = x;                                                                                                                                                              
                                             }
                                          }else{
                                          	  jQuery.Hy_Template_Engine["Parame_Colume_Count"] = 0;
                                          }   
                                          
                                          /*  UpdateBlock設定 */
                                          var UpdateBlockName = options.UpdateBlockName;
                                          if(UpdateBlockName!=""){
                                             var pArray_UpdateBlock = UpdateBlockName.split(",");                                             
                                             if(pArray_UpdateBlock.length>0){                                           	
                                                    for (var s=0;s<pArray_UpdateBlock.length;s++)
                                                    {
                                                        Hy_Template_Engine_UpdateBlock_Cut(pArray_UpdateBlock[s]);
                                                    } 
                                             }
                                          }
                                         
                         }         	           	                           
             
             /* UpdateBlock模版暫存 */
             var Hy_Template_Engine_UpdateBlock_Cut = function(tag) {      
             	             var iTemplate =jQuery.Hy_Template_Engine["Template"] ;	                             	                             
	                         var pattern  = "<!--\\s+BEGIN\\s+(" + tag + ")\\s+-->([\\s\\S.]*)<!--\\s+END\\s+\\1\\s+-->";
	                         var regex = new RegExp(pattern,'g');	                             	                             
	                         var Tag_Array = regex.exec(iTemplate);
	                         Hy_Template_Engine_UpdateBlock_List[tag] = Tag_Array[0].replace("<!-- BEGIN "+tag+" -->","");
	                         Hy_Template_Engine_UpdateBlock_List[tag] = Hy_Template_Engine_UpdateBlock_List[tag].replace("<!-- END  "+tag+" -->","");
	                         iTemplate = iTemplate.replace(Tag_Array[0],"__"+tag+"__");	                         
	                         jQuery.Hy_Template_Engine["Template"] = iTemplate;
	                         jQuery.Hy_Template_Engine["Template_Blocked"] = iTemplate;	                         
             }	
              /* UpdateBlock模版處理 */
             this.Hy_Template_Engine_UpdateBlock_Procedure = function() { 
             	             options = jQuery.Hy_Template_Engine ["option"];
             	             var strBlockTag =  options.UpdateBlockName;   
             	             if(strBlockTag !=""){
             	                 var pArray = strBlockTag.split(",");
             	                 var pHtml = ""
             	                 for( var i  in pArray){             	            
             	                 	   var strTemplate =  Hy_Template_Engine_UpdateBlock_List[pArray[i]];                      	                 	       
             	                 	   if(jQuery.Hy_Template_Engine["contact"][0].html_input.length > 0 ) {
             	                 	       for (var s=0;s<jQuery.Hy_Template_Engine["contact"][0].html_input.length;s++)                                              
                                       {                               	
                                          pHtml += Hy_Template_Engine_Analysis(strTemplate,s);                                                                   
                                       } 
                                   }
             	                 	   
             	                 	   var BlockTag = "__"+pArray[i]+"__";
             	                 	   var iTemplate = jQuery.Hy_Template_Engine["Template"];
             	                 	   var block_reg=new RegExp(BlockTag,"g");                                       
                                   iTemplate=iTemplate.replace(block_reg,pHtml);
                                   jQuery.Hy_Template_Engine["Template"] = iTemplate;                              
                                   pHtml = ""
             	                 }
             	             }
             	  
             }
                     	  
             /* 模板分析 strTemplate:模版區塊 strRow:資料來源筆數碼 */
             this.Hy_Template_Engine_Analysis = function(strTemplate,strRow) {                      	
             	                 var iTemplate = strTemplate ;	                     	                                                       	     
	                             var pattern = "(" + "{{" + ")([^}]+)" + "}}";
                               var regex = new RegExp(pattern,'g');
                               var Tag_Array = iTemplate.match(regex);
                               /* tag轉換 */
                               iTemplate = Hy_Template_Engine_Tag_Procedure(iTemplate,Tag_Array,strRow);                                                             
	                             //alert(iTemplate);
	                             return iTemplate;
             }           	  
             /* 模板分析 strTemplate:模版區塊 strRow:資料來源筆數碼 */
             var Hy_Template_Engine_Analysis = function(strTemplate,strRow) {                      	
             	                 var iTemplate = strTemplate ;	                     	                                                       	     
	                             var pattern = "(" + "{{" + ")([^}]+)" + "}}";
                               var regex = new RegExp(pattern,'g');
                               var Tag_Array = iTemplate.match(regex);
                               /* tag轉換 */
                               iTemplate = Hy_Template_Engine_Tag_Procedure(iTemplate,Tag_Array,strRow);                                                             
	                             //alert(iTemplate);
	                             return iTemplate;
             } 
             /* 模版Tag-參數處理 */     
             var  Hy_Template_Engine_Tag_Procedure = function(strTemplate,Tag_Array,strRow) {
             	                  var iTemplate =strTemplate ;	  
                  	            var Tag_Array = Tag_Array;
                  	            for( var i  in Tag_Array){
                                   var pTagName = Tag_Array[i].replace(/[{}]/g,"");                                   
                                   var pHtml =  Hy_Template_Engine_Tag_To_Html(pTagName,strRow);                                    
                                   //if(pHtml!=""){                                                                                  
                                        var temp_reg=new RegExp(Tag_Array[i],"g");                                       
                                        iTemplate=iTemplate.replace(temp_reg,pHtml);
                                   //}     
                                }
                                
                  	            return iTemplate;                  	            
             }                     
              var  Hy_Template_Engine_Tag_To_Html = function(strTag,strRow) {              	               
              	                options = jQuery.Hy_Template_Engine ["option"];              	                
              	                var pArray = strTag.split(".HTML_");
              	                
              	                var Rtn = "";              	                            	                   	                
              	                if(pArray.length >1){
              	                	 var pCol = Hy_Template_Engine_ColumeInput[pArray[0]];                     	                	                 	                	 
              	                	 if(pCol!=undefined && jQuery.Hy_Template_Engine["contact"][0].html_input.length > 0){              	                	    
              	                      var strValue = jQuery.Hy_Template_Engine["contact"][0].html_input[strRow].colume[pCol].value;               	                      
              	                      if(options.TemplateType =="List"){ strValue = "";}     
              	                             	                     	                      
              	                      switch(pArray[1])
                                      {
                                      case "TEXT":                                                                       
                                        Rtn = Hy_Template_Engine_Tag_Text(pArray[0],strValue);
                                        break;
                                      case "TEXTAREA":
                                        Rtn = Hy_Template_Engine_Tag_TextArea(pArray[0],strValue);
                                        break;
                                      case "RADIO":
                                        Rtn = Hy_Template_Engine_Tag_Radio(pArray[0],strValue);
                                        break;  
                                      case "SELECT":
                                        Rtn = Hy_Template_Engine_Tag_Select(pArray[0],strValue);
                                        break;   
                                      case "CHECKBOX":
                                       
                                        Rtn = Hy_Template_Engine_Tag_Checkbox(pArray[0],strValue,strRow);
                                        break;      
                                      case "PARAME":
                                        Rtn = Hy_Template_Engine_Tag_Parame(pArray[0],strValue);
                                        break;        
                                      default:                                                                        
                                      }
                                   }else{                                             
                                   	  switch(pArray[1])
                                      {                                      
                                      case "RADIO":
                                        Rtn = Hy_Template_Engine_Tag_Radio(pArray[0],"");
                                        break;   
                                      case "SELECT":
                                        Rtn = Hy_Template_Engine_Tag_Select(pArray[0],"");
                                        break;     
                                      case "CHECKBOX":
                                       
                                        Rtn = Hy_Template_Engine_Tag_Checkbox(pArray[0],"",strRow);
                                        break;         
                                      case "PARAME":                                      	
                                        Rtn = Hy_Template_Engine_Tag_Parame(pArray[0],strValue);
                                        break;        
                                      default:                                                                        
                                      }                                                   	                                     	  
                                   }
              	                }else{
              	                	 var pCol = Hy_Template_Engine_ColumeInput[pArray[0]];            
              	                	 if (jQuery.Hy_Template_Engine["contact"][0].page_Info.DataCount <=0) {
              	               	      return "";
              	               	   }  	                	               	     
              	               	   if(strTag=="Serial"){
              	                	    Rtn = jQuery.Hy_Template_Engine ["SerialNumber"];
              	                	    jQuery.Hy_Template_Engine ["SerialNumber"] += 1;
              	                	 }else{                          	                	 	      	           
              	                	 	  /* 一般tag  {{tag}} */   	 	   
              	                	    Rtn = jQuery.Hy_Template_Engine["contact"][0].html_input[strRow].colume[pCol].value;
              	                	 }
              	                }
              	               
              	                
              	                
              	                return Rtn;
              }
              var  Hy_Template_Engine_Tag_Text = function(strTag,strValue) {              	
              	                var pHtml = "<input type='text' id='"+strTag+"' name='"+strTag+"' value='"+strValue+"'>";              	    
              	                return pHtml;              	              	   
              }
              var  Hy_Template_Engine_Tag_TextArea = function(strTag,strValue) {
              	                var pHtml = "<textarea id='"+strTag+"' name='"+strTag+"' rows='4' cols='30'>"+strValue+"</textarea>"
              	                return pHtml;              	              	
              }
              var  Hy_Template_Engine_Tag_Radio = function(strTag,strValue) {
              	                var pRow = Hy_Template_Engine_ColumeRadio[strTag];
              	                var pHtml = "";
              	                if(jQuery.Hy_Template_Engine["contact"][0].html_Radio.length > 0) {
              	                   for( var i=0;i<jQuery.Hy_Template_Engine["contact"][0].html_Radio[pRow].tittle.length;i++){
              	                   	  var pValue = jQuery.Hy_Template_Engine["contact"][0].html_Radio[pRow].value[i].value;
              	                   	  var pTittle = jQuery.Hy_Template_Engine["contact"][0].html_Radio[pRow].tittle[i].value;
              	                   	  if(strValue==pValue){
              	                   	     pHtml +="<input type='radio' id='"+strTag+"' name='"+strTag+"' value='"+pValue+"' checked /> " +pTittle;
              	                   	  }else{
              	                   		   pHtml +="<input type='radio' id='"+strTag+"' name='"+strTag+"' value='"+pValue+"' /> " +pTittle;
              	                   		}              	   	                	   	  
              	                   }              	   
              	                }
              	                return pHtml;              	              	
              }
              var  Hy_Template_Engine_Tag_Select = function(strTag,strValue) {              	
              	                var pRow = parseInt(Hy_Template_Engine_ColumeSelect[strTag]);
              	                var pHtml = "<select id='"+strTag+"' name='"+strTag+"'>";                        	                
              	                pHtml += "<option value=''>  請選擇  </option>";           
              	                if(jQuery.Hy_Template_Engine["contact"][0].html_Select.length > 0) {         
              	                	
              	                  for( var i=0;i<jQuery.Hy_Template_Engine["contact"][0].html_Select[pRow].tittle.length;i++){
              	                  	
              	                  	  var pValue = jQuery.Hy_Template_Engine["contact"][0].html_Select[pRow].value[i].value;
              	                  	  var pTittle = jQuery.Hy_Template_Engine["contact"][0].html_Select[pRow].tittle[i].value;
              	                  	  if(strValue==pValue){
              	                  	  	 pHtml += "<option value='"+pValue+"' SELECTED >"+pTittle+"</option>";
              	                  	  }else{
              	                  	     pHtml += "<option value='"+pValue+"'>"+pTittle+"</option>";	
              	                  	  }              	   	                	   	  
              	                  }
              	                }
              	                pHtml += "</select>";              	                   
              	                return pHtml;              	              	
              } 
               var  Hy_Template_Engine_Tag_Checkbox = function(strTag,strValue,strRow) {               	
               	                if(jQuery.Hy_Template_Engine["contact"][0].html_Checkbox.length > 0) {  
               	                	var pHtml = "";
               	                  for( var i=0;i<jQuery.Hy_Template_Engine["contact"][0].html_Checkbox.length ;i++){
              	                    var pValue = jQuery.Hy_Template_Engine["contact"][0].html_Checkbox[i].value;
              	                    var pTittle = jQuery.Hy_Template_Engine["contact"][0].html_Checkbox[i].tittle;                  	                   
              	                    if(strValue==pValue) {
              	                       pHtml += "<input type='Checkbox' name='"+strTag+"' checked value='"+pValue+"'>"+pTittle;
              	                    }else{
              	                    	 pHtml += "<input type='Checkbox' name='"+strTag+"' value='"+pValue+"'>"+pTittle;
              	                    }                 	                            	                                 	                    
              	                  } 
              	                  return pHtml;     
              	                }          	              	
              } 
               var  Hy_Template_Engine_Tag_Parame = function(strTag,strValue) {                  	 	     	
               	                var pRow = parseInt(Hy_Template_Engine_ColumeParame[strTag]);               	                
              	                var pValue = jQuery.Hy_Template_Engine["contact"][0].tag_pareme.parame[pRow].value;                      	                   	                            	                        	                   
              	                return pValue;              	              	
              } 
              /* 分頁資料 */
             this.Hy_Template_Engine_Write_PageInfo = function() { 
  	                            var options= jQuery.Hy_Template_Engine ["option"];
              	                var PageCount =jQuery.Hy_Template_Engine["contact"][0].page_Info.PageCount;
              	                var DataCount =jQuery.Hy_Template_Engine["contact"][0].page_Info.DataCount; 
              	                var DataFrom =jQuery.Hy_Template_Engine["contact"][0].page_Info.DataFrom; 
              	                var DataEnd =jQuery.Hy_Template_Engine["contact"][0].page_Info.DataEnd; 
              	                var ThisPage =jQuery.Hy_Template_Engine["contact"][0].page_Info.ThisPage; 
              	                var PageNum =jQuery.Hy_Template_Engine["contact"][0].page_Info.PageNum; 
              	                $("#JsTem-PageCountTag").html(PageCount);    options.PageCount = PageCount;
              	                $("#JsTem-DataCountTag").html(DataCount);    options.DataCount = DataCount;
              	                $("#JsTem-DataFromTag").html(DataFrom);      options.DataFrom = DataFrom;
              	                $("#JsTem-DataEndTag").html(DataEnd);        options.DataEnd = DataEnd;
              	                $("#JsTem-ThisPageTag").html(ThisPage);      options.ThisPage = ThisPage;
              	                $("#JsTem-PageNumTag").html(PageNum);        options.PageNum = PageNum;      
              	                $("#JsTem-ThisPageInput").val(ThisPage);    
              	                              	                              	                              	                              	                              	                
              	                jQuery.Hy_Template_Engine ["option"] = options;      	
              }                  
  	
  	
  }
  
  var Hy_Template_Engine_Reload_JData = function() { 
  	
  	                            var tag = jQuery.Hy_Template_Engine ["id"];  	                        
  	                            var options= jQuery.Hy_Template_Engine ["option"];  	
  	                            jQuery.Hy_Template_Engine["Template"] = jQuery.Hy_Template_Engine["Template_Blocked"];
  	                            var SearchString = "";
  	                            var SearchArray = options.SearchColume;
  	                            SearchArray = SearchArray.split(",");
  	                            
  	                            for (var i=0;i<SearchArray.length;i++)
                                {     
                                	    var pValue =  $("#"+SearchArray[i]).val();
                                	    if(pValue!=""){
                                          SearchString += "&"+ SearchArray[i] + "="+  pValue;                                              
                                          SearchArray[SearchArray[i]] =pValue;        
                                      }else{
                                      	  SearchArray[SearchArray[i]] = "";
                                      }    
                                }  	                            
  	                            var str = options.JsonDataUrl+"?PageNum="+options.PageNum+"&ThisPage="+options.ThisPage+SearchString;  	                            
  	                            
                                $(tag).kcwAjax(str,{
                       	          Job:"LINK",
                       	          Response: {
	  	                            	         ToExecute: false, ToGoal: false,  ToTrigger: false
	  	                            },
                       	          LocalEvents: {
                       	          	success: function(Trigger,GoalTag,TriggerGoalTag,Response) {
                       	          		          /*  alert(Response);  */
                                                if(Response!=""&&Response!=undefined){  
                                                	  jQuery.Hy_Template_Engine["Json"] = Response;     
                                                	  var Json = jQuery.Hy_Template_Engine["Json"];
                                                    var contact = JSON.parse(Json);    
                                                    jQuery.Hy_Template_Engine["contact"] = contact;                                                           
                                                    jQuery.Hy_Template_Engine ["SerialNumber"] = parseInt(jQuery.Hy_Template_Engine["contact"][0].page_Info.DataFrom);                                                                                                                                                
                                                    /* 模板處理 */            
                                                    var obj = new Hy_Template_Engine_Producer();                                             
                                                    jQuery.Hy_Template_Engine["Template"] = obj.Hy_Template_Engine_Analysis(jQuery.Hy_Template_Engine["Template"],0);                                                    
                                                    obj.Hy_Template_Engine_UpdateBlock_Procedure();                                                                                    
                                                    $(tag).html(jQuery.Hy_Template_Engine["Template"]);
                                                    
                                                    /* 分頁資訊處理 */    
                                                    obj.Hy_Template_Engine_Write_PageInfo();   
                                                    
                                                    for (var a=0;a<SearchArray.length;a++)
                                                    {     
                                                    	    if(SearchArray[SearchArray[a]]!=""){
                                                    	       var pValue = SearchArray[SearchArray[a]];
                                                    	       $("#"+SearchArray[a]).val(pValue);
                                                    	    
                                                    	    }                                                    	   
                                                    }  	      
                                                }                                           
                       	          		       }
                       	            }
                       	        }); 	 	
  	
  }
 
                
/* 選擇器導入的函數 */              
jQuery.fn.Hy_Template_Engine = function (options) {
	if (options == "undefined" || options == null) {		 options = {};	}
	if (options.TemplateType == "undefined"      || options.TemplateType == null)     {		 options.TemplateType = "List"; }   /* 模板種類  List / Upd 有放入預設值  */
	if (options.TemplateUrl == "undefined"       || options.TemplateUrl == null)      {		 options.TemplateUrl = ""; }        /* 模板來源  */
	if (options.JsonDataUrl == "undefined"       || options.JsonDataUrl == null)      {		 options.JsonDataUrl = ""; }        /* 資料來源  */		
	if (options.ColumeName_Input == "undefined"  || options.ColumeName_Input == null) {		 options.ColumeName_Input = ""; }   /* 欄位名稱資料-input   */	
	if (options.ColumeName_Radio == "undefined"  || options.ColumeName_Radio == null) {		 options.ColumeName_Radio = ""; }   /* 欄位名稱資料-Radio   */	
	if (options.ColumeName_Select == "undefined" || options.ColumeName_Select == null){		 options.ColumeName_Select = ""; }  /* 欄位名稱資料-select  */	
	if (options.ColumeName_Checkbox == "undefined" || options.ColumeName_Checkbox == null){		 options.ColumeName_Checkbox = ""; }  /* 欄位名稱資料-checkbox  */	
	if (options.ColumeName_Parame == "undefined" || options.ColumeName_Parame == null){		 options.ColumeName_Parame = ""; }  /* 欄位名稱資料-傳遞參數  */	
	if (options.RowReapeat == "undefined"        || options.RowReapeat == null)       {		 options.RowReapeat = true; }       /* 是否reapeat Block區塊*/	
	if (options.ThisPage == "undefined"          || options.ThisPage == null)         {		 options.ThisPage = 1; }            /* 換頁參數--目前頁碼  */
	if (options.PageNum == "undefined"           || options.PageNum == null)          {		 options.PageNum = 20; }            /* 換頁參數--每頁筆數  */
	if (options.PageFrom == "undefined"          || options.PageFrom == null)         {		 options.PageFrom = 1; }            /* 資料儲存頁碼參數--儲存起始頁  */
	if (options.PageEnd == "undefined"           || options.PageEnd == null)          {		 options.PageEnd = 10; }            /* 資料儲存頁碼參數--儲存結束頁  */
	if (options.PageCount == "undefined"         || options.PageCount == null)        {		 options.PageCount = ""; }          /* 換頁參數--總頁數  */
	if (options.DataCount == "undefined"         || options.DataCount == null)        {		 options.DataCount = ""; }          /* 換頁參數--資料總筆數  */
	if (options.DataFrom == "undefined"          || options.DataFrom == null)         {		 options.DataFrom = ""; }           /* 換頁參數--開始筆數  */
	if (options.DataEnd == "undefined"           || options.DataEnd == null)          {		 options.DataEnd = ""; }            /* 換頁參數--結束筆數  */
	if (options.UpdateBlockName == "undefined"   || options.UpdateBlockName == null)  {		 options.UpdateBlockName = "List1"; }      /* Repeat標籤名稱  */
	if (options.SearchColume == "undefined"      || options.SearchColume == null)     {		 options.SearchColume = ""; }       /* 條件式查詢欄位  */
	
	
	  
	this.each(function() {
    var tag = this;
    jQuery.Hy_Template_Engine(tag,options);
  });
};      

        /*  --------------------------------------------------------------------------------------------------------------------------------------
        //var Json = '[{"html_Radio":[{"tittle":[{"value":"radio名稱1"},{"value":"radio稱2"}],"value":[{"value":"radio1"},{"value":"radio2"}]}],"html_Select":[{"tittle":[{"value":"下拉式名稱1"},{"value":"下拉式名稱2"},{"value":"下拉式名稱3"}],"value":[{"value":"下拉式參數1"},{"value":"下拉式參數2"},{"value":"下拉式參數3"}]}],"html_input":[{"colume":[{"value":"欄位01-內容"},{"value":"欄位02-內容"},{"value":"欄位03-內容"},{"value":"欄位04-內容"}]},{"colume":[{"value":"欄位01-內容2"},{"value":"欄位02-內容2"},{"value":"欄位03-內容2"},{"value":"欄位04-內容2"}]}]}]';
        //var contact = JSON.parse(Json);
        //contact[0].html_Select.length  select 數量
        //contact[0].html_Select[0].tittle.length select下拉選單內選項數量
        //contact[0].html_Select[0].value[0].value select 下拉式選單value
        //contact[0].html_Select[0].tittle[0].value select 下拉式選單tittle

        //contact[0].html_input.length input 資料筆數
        //contact[0].html_input[1].colume.length  欄位數量
        //contact[0].html_input[1].colume[3].value  第二筆第四欄位   
        
        //jQuery.Hy_Template_Engine["contact"][0].tag_pareme.parame.length 參遞參數數量                          
        --------------------------------------------------------------------------------------------------------------------------------------------*/
                                        
       
  var Hy_Template_Engine_PageMove_Request = function(strType) { 
  	                               var options= jQuery.Hy_Template_Engine ["option"];  	                               
  	                               switch(strType)
                                      {
                                      case "First":                                                                                                                   
                                            options.ThisPage =1;
                                        break;
                                      case "Prev":
                                            var page = parseInt(options.ThisPage)-1;
                                            if(page<1){page = 1;}
                                            options.ThisPage = page;
                                        break;
                                      case "Next":
                                            var page = parseInt(options.ThisPage)+1;
                                            if(page>parseInt( options.PageCount)){page = parseInt( options.PageCount);}
                                            options.ThisPage = page;
                                        break;  
                                      case "Last":                                        
                                             
                                            options.ThisPage = options.PageCount;
                                        break;    
                                      case "This":                                        
                                            var page = parseInt(options.ThisPage);                                            
                                            options.ThisPage = page;
                                        break;      
                                      default:
                                            if( $.isNumeric(strType )==false){alert('頁碼錯誤!');}
                                            var page = parseInt(strType); 
                                            if(page>parseInt( options.PageCount)){page = parseInt( options.PageCount);}    
                                            if(page<1){page = 1;}                                       
                                            options.ThisPage = page;                                                                      
                                      }  	   
                                      jQuery.Hy_Template_Engine ["option"] = options;
                                      Hy_Template_Engine_Reload_JData();
  }     
       
       
                                        
                                        
                                        














