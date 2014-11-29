function ajaxDialog(strUrl) {
  //亂數產生DIV
  var maxNum = 999;
  var minNum = 100;
  var IdNum  = Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum;
  var tDate  = new Date();
  var TadId  = "ajaxDialogBox" + (tDate.getMonth()+1) + "l" + tDate.getDate() + "l" + tDate.getFullYear() + IdNum;
  if (document.getElementById("ajaxDialogBox")==null) {
  	$("body").append("<div id='ajaxDialogBox'></div>");
  }  
  $("#ajaxDialogBox").append("<div id='"+TadId+"' class='ajaxDialogFaceBox' style='display:none'></div>");
  this.DialogId  = TadId;
  this.AjaxURL   = strUrl;
  this.Methods   = this.Methods || "destroy";
  this.options   = {};
  this.setOptions = function(options) {
  	                  options = options || {};
                      this.options = options;
                    };
  this.Init       = function() {
  	                   ajaxTagFunction(this.AjaxURL,this.DialogId,1,0);                       
  	                   //$("#"+this.DialogId).dialog(this.Methods);
  	                   $("#"+this.DialogId).dialog(this.options);
  	                   $("#"+this.DialogId).bind( "dialogclose",function(event, ui) { $("#"+TadId).remove();  });  	                              
  	                };
  	                
  	               
}

function ajaxSelectHTML(strTag) {
	 this.arrPath       = Array();
 	 this.arrAbout      = Array();
 	 this.arrAboutIndex = Array();
 	 this.arrSelected   = Array();
 	 this.TagZone       = strTag;

   //清除所屬下拉式選單
   var clearOption = function(strId,objZone,arrAbout,arrIndex,intLevel) {
   	 var objSelect = objZone.getElementsByTagName("SELECT");
   	 var intIndex = arrIndex[strId];
   	 if (intIndex!="undefined" && intIndex!=null && intLevel <= 7) {
   	    for (i=0;i<objSelect.length;i++) {
   	    	 for (x=1;x<arrAbout[intIndex].length;x++) {
   	    	 	 if (objSelect[i].id == arrAbout[intIndex][x] && objSelect[i].id!="") {
   	    	 	 	  objSelect[i].options.length = 0;
   	    	 	 	  clearOption(objSelect[i].id,objZone,arrAbout,arrIndex,intLevel);
   	    	 	 }
   	    	 }
   	    }
   	 }
   }
   //取得變數
   var ajax_Event_Var = function(ajax,objZone,arrAbout,arrIndex) {
   	 var objSelect = objZone.getElementsByTagName("SELECT");
   	 for (i=0;i<objSelect.length;i++) {
   	 	 for (x=0;x<arrAbout.length;x++) {
   	 	 	 if (objSelect[i].id == arrAbout[x][0] && objSelect[i].id!="") {
   	 	 	 	  ajax.encVar(objSelect[i].id, escape(objSelect[i].value));
   	 	 	 }
   	 	 }
   	 }
   }
   //回覆 arrResponse = array()
 	 var ajax_Event_Retrun = function(strId,ajax,objZone,arrAbout,arrIndex,arrSelected) {
 	 	                        var intTemp=0;
 	 	                        var objVar=Array();
 	 	                        var objSelect = objZone.getElementsByTagName("SELECT");
   	                        var intIndex = arrIndex[strId];
   	                        if (intIndex!="undefined" && intIndex!=null) {
   	                           for (i=0;i<objSelect.length;i++) {
   	                           	 for (x=1;x<arrAbout[intIndex].length;x++) {
   	                           	 	 if (objSelect[i].id == arrAbout[intIndex][x] && objSelect[i].id!="") {
   	                           	 	 	 objVar[objVar.length]=objSelect[i];
   	                           	 	 	 objSelect[i].options[objSelect[i].options.length]=setOption("","請選擇");
   	                           	 	 }
   	                           	 }
   	                           }
   	                        }
 	                          eval(ajax.response);
 	                          for (x=0;x<arrResponse.length;x++) {
 	                            for (i=0;i<objVar.length;i++) {
 	                            	 intTemp = objVar[i].options.length;
 	                            	 objVar[i].options[intTemp]=setOption(arrResponse[x][0],arrResponse[x][1]);
 	                            	 if (arrSelected[objVar[i].id]!="undefined" && arrSelected[objVar[i].id]!=null && arrSelected[objVar[i].id]==arrResponse[x][0]) {
 	                            	 	 objVar[i].options[intTemp].selected=true;
 	                            	 }
 	                            }
 	                          }
 	                         };
 	 //設定下拉式清單
 	 var setOption = function(strId,strValue) {
                      var newOption=new Option;
                      newOption.value=strId;
                      newOption.text=strValue;
                      return newOption;
 	 	               };
 	 //設定AJAX事件
 	 var ajax_Event = function(objTag,objZone,arrAbout,arrIndex,arrPath,arrSelected) {
 	 	                  var strPath = arrPath[objTag.id];
 	 	                  clearOption(objTag.id,objZone,arrAbout,arrIndex,0); 	                  
 	                    var ajax = new sack();
                      ajax.method = "POST";
                      ajax.requestFile = strPath;
                      ajax_Event_Var(ajax,objZone,arrAbout,arrIndex);
                      ajax.encVar(objTag.id, escape(objTag.value));
                      ajax.onCompletion    = function() {
                      	                        ajax_Event_Retrun(objTag.id,ajax,objZone,arrAbout,arrIndex,arrSelected);
                                             };
                      ajax.runAJAX();
 	 	                }
 	 //設定路徑
 	 this.setPath = function(strTagId,strPath) {
 	 	                this.arrPath[strTagId] = strPath;
 	 	              };
 	 //設定駐點
 	 this.setSelected = function(strTagId,strValue) {
 	 	                this.arrSelected[strTagId] = strValue;
 	 	              };
 	 //設定關係
 	 this.setTagAbout = function(strUpId,strId) {
 	                    	 var intIndex;
 	                    	 if (this.arrAboutIndex[strUpId]=="undefined" || this.arrAboutIndex[strUpId]==null) {
 	                    	   this.arrAboutIndex[strUpId]=this.arrAbout.length;
 	                    	   intIndex=this.arrAbout.length;
 	                    	 }else{
 	                    	 	 intIndex = this.arrAboutIndex[strUpId]
 	                    	 }
 	                    	 if (this.arrAbout[intIndex]=="undefined" || this.arrAbout[intIndex]==null) {
 	                    	 	 this.arrAbout[intIndex]=Array(strUpId,strId);
 	                    	 }else{
 	                    	 	 this.arrAbout[intIndex].push(strId);
 	                    	 }
 	                    };
 	 //建立物件事件
 	 this.initEvent = function() {
 	 	                  if (this.TagZone!="") {
                         var objZone=document.getElementById(this.TagZone);
                      }else{
                      	 var objZone=document;
                      }                      
 	                    if (objZone!=null) {
 	                    	 var arrAbout;
 	                    	 var arrIndex;
 	                    	 var arrPath;
 	                       var objSelect = objZone.getElementsByTagName("SELECT");
                         for (i=0;i<objSelect.length;i++) {
                         	  if (objSelect[i].id!="") {
                         	    if (this.arrAboutIndex[objSelect[i].id]!="undefined" && this.arrAboutIndex[objSelect[i].id]!=null) {
                         	    	arrIndex    = this.arrAboutIndex;
                         	    	arrAbout    = this.arrAbout;
                         	    	arrPath     = this.arrPath;
                         	    	arrSelected = this.arrSelected;
                         	    	strTagZone  = this.TagZone;                         	    	
                         	    	$(objSelect[i]).change(
                                                 function() {
                         	    		                       ajax_Event(this,objZone,arrAbout,arrIndex,arrPath,Array());
                         	    		              });
                         	      if (objSelect[i].value!="") { ajax_Event(objSelect[i],objZone,arrAbout,arrIndex,arrPath,arrSelected); }
                         	    }
                         	  }
                         }
 	                    }
 	                  };



}