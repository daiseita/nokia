/*
 Ajax jQuery
 Include File:
              -- jquery131.js

 # Cearte Date: 2010/10/01
 # Update Date: 2010/11/23

 Design By: Wesley-Kung
 CopytRight: Copyright 2010 Hsien Yang Information Co., Ltd All Rights Reserved
*/
jQuery.kcwAjaxReloadBase = Array();
jQuery.kcwAjaxQueue = Array();    //AJAX執行緒
jQuery.kcwAjaxLinkBase = Array(); //LINK作業資料
jQuery.kcwAjaxCount = 0;
jQuery.kcwAjaxQueuePoint = 0;

//共同事件
jQuery.kcwAjaxPublicEvents            = jQuery.kcwAjaxPublicEvents || { };                                //事件
jQuery.kcwAjaxPublicEvents.beforeSend = jQuery.kcwAjaxPublicEvents.beforeSend || function(Trigger,GoalTag,TriggerGoalTag) { };          //Ajax 請求發出之前
jQuery.kcwAjaxPublicEvents.success    = jQuery.kcwAjaxPublicEvents.success    || function(Trigger,GoalTag,TriggerGoalTag,Response) { }; //Ajax 請求成功時 (沒任何 error)
jQuery.kcwAjaxPublicEvents.error      = jQuery.kcwAjaxPublicEvents.error      || function(Trigger,GoalTag,TriggerGoalTag) { };          //Ajax 請求發生錯誤時 (Ajax 請求不是 success，就是 error，沒都有的情況)
jQuery.kcwAjaxPublicEvents.complete   = jQuery.kcwAjaxPublicEvents.complete   || function(Trigger,GoalTag,TriggerGoalTag) { };          //不論 Ajax 請求是 success 或是 error，都會觸發 complete 事件

//-----------------------------------------------------------------
//執行Ajax(jQuery)
//-----------------------------------------------------------------
jQuery.kcwAjaxRun = function() {
  //取得執行的選項
 	for (k in jQuery.kcwAjaxQueue) {
 	  ajaxKey=k;
 	  break
 	}
  //var ajaxKey = jQuery.kcwAjaxQueuePoint;
  var options = jQuery.kcwAjaxQueue[ajaxKey];
  if (options!=null && options!="undefined") {
     //0: 未執行 1:執行中
     options.Run = options.Run || 0;
     if (options.Run==0) {
     	  jQuery.kcwAjaxQueuePoint = ajaxKey;
  	    options.SendVar["ajaxTagID"] = $(options.Trigger).attr("id");
     	  options.Run=1;     	  
     	  if (options.dataType=="undefined" || options.dataType == null || options.dataType == "") { options.dataType="html"; }     	  
        $.ajax({
          type:     options.method,
          url:      options.Page,
          data:     options.SendVar,
          dataType: options.dataType,
          beforeSend: function()    {
          	             options.LocalEvents.beforeSend(options.Trigger,options.GoalTag,options.TriggerGoalTag);
          	             jQuery.kcwAjaxPublicEvents.beforeSend(options.Trigger,options.GoalTag,options.TriggerGoalTag);
          	           },
          error:      function()    {          	
          	
          	             var strErroeTitle=window.title;
          	             window.title = "error" + window.title;
          	             $(options.Trigger).find("#ReturnMsg").kcwAjaxTipsRemove();
          	             $(options.Trigger).find("#ReturnMsg").html("請求資料發生錯誤!!");

                         if (options.Mask.Trigger==true)                     { $(options.Trigger).kcwAjaxMask("close");            }
                         if (options.Mask.Goal==true && options.GoalTag!="") { $(options.GoalTag).kcwAjaxMask("close");            }
                         if (options.Mask.Full==true)                        { $('body').kcwAjaxMask("close");                     }
 	                       if (options.Job=="SUBMIT")                          {
 	                       	  $(options.Trigger).kcwAjaxDisabledFace("");
 	                       	  if (options.GoalTag!=""&&options.GoalTag!=null)  { $(options.GoalTag).kcwAjaxDisabledFace(""); }
 	                       }
          	             options.LocalEvents.error(options.Trigger,options.GoalTag,options.TriggerGoalTag);
          	             jQuery.kcwAjaxPublicEvents.error(options.Trigger,options.GoalTag,options.TriggerGoalTag);
          	             //發生錯誤刪除執行緒
          	             //alert("complete>>"+ajaxKey+"|"+jQuery.kcwAjaxCount);
 	                       delete jQuery.kcwAjaxQueue[ajaxKey];
 	                       //執行下一個
 	                       new jQuery.kcwAjaxRun();
          	           },
          complete:   function()    {
                         if (options.Mask.Trigger==true)                     { $(options.Trigger).kcwAjaxMask("close");            }
                         if (options.Mask.Goal==true && options.GoalTag!="") { $(options.GoalTag).kcwAjaxMask("close");            }
                         if (options.Mask.Full==true)                        { $('body').kcwAjaxMask("close");                     }
 	                       if (options.Job=="SUBMIT")                          {
 	                       	  $(options.Trigger).kcwAjaxDisabledFace("");
 	                       	  if (options.GoalTag!=""&&options.GoalTag!=null)  { $(options.GoalTag).kcwAjaxDisabledFace(""); }
 	                       }
          	             options.LocalEvents.complete(options.Trigger,options.GoalTag,options.TriggerGoalTag);
          	             jQuery.kcwAjaxPublicEvents.complete(options.Trigger,options.GoalTag,options.TriggerGoalTag);
 	                       //完成後刪除執行緒
 	                       delete jQuery.kcwAjaxQueue[ajaxKey];
 	                       //執行下一個
 	                       new jQuery.kcwAjaxRun();
                         //觸發式連結處理
                         if (options.Trigger!=null) {
                         	  //alert("complete>>"+ajaxKey+"|"+jQuery.kcwAjaxCount);
                            var kcwAjaxTriggerLoad     = $(options.Trigger).attr("kcwAjaxTriggerLoad");
                            var kcwAjaxTriggerLoadFind = $(options.Trigger).attr("kcwAjaxTriggerLoadFind");
                            var tId   = $(options.Trigger).attr("id");
                            var tName = $(options.Trigger).attr("Name");
                            if (kcwAjaxTriggerLoad!="undefined" && kcwAjaxTriggerLoad!=null && kcwAjaxTriggerLoad!="") {
                            	  $(kcwAjaxTriggerLoad).kcwAjaxReload();
                            }
                            if (kcwAjaxTriggerLoadFind!="undefined" && kcwAjaxTriggerLoadFind!=null && kcwAjaxTriggerLoadFind!="") {
                            	  $(kcwAjaxTriggerLoadFind).kcwAjaxReload();
                            }
                            if (tId!="undefined" && tId!=null) {
                              var tIds = jQuery.kcwAjaxReloadBase[tId];
                              if (options.Response.ToExecute && options.Job=="LINK") { $(options.Trigger).kcwAjaxReload(options.useScrollTo); }
                              if (tIds!="undefined" && tIds!=null && tIds!="") { $(tIds).kcwAjaxReload(options.useScrollTo); }
                            }
                         }
 	                       //
          	           },
          success:    function(html) {
          	             //回覆處理
          	             if (options.Response.ToExecute)                     {
          	             	  $(options.Trigger).find("#ReturnMsg").kcwAjaxTipsRemove();
          	             	  $(options.Trigger).kcwAjaxTipsRemove();
          	             	  $(options.Trigger).find(":not(:checkbox,:radio,div,span)").css({"border":""});
          	             	  eval(html);
          	             	  //$(options.Trigger).kcwAjaxReload();
          	             }else{
          	                if (options.Response.ToGoal && options.GoalTag!="")               {
          	                	 $(options.GoalTag).kcwAjaxValue(html,options.isReload,options.useScrollTo);
          	                }
          	                if (options.Response.ToTriggerGoal && options.TriggerGoalTag!="") {
          	                	   $(options.Trigger).find(options.TriggerGoalTag).kcwAjaxValue(html,options.isReload,options.useScrollTo);
          	                }
          	                if (options.Response.ToTrigger)                     {  $(options.Trigger).kcwAjaxValue(html,options.isReload,options.useScrollTo); }
          	             }
          	             options.LocalEvents.success(options.Trigger,options.GoalTag,options.TriggerGoalTag,html);
          	             jQuery.kcwAjaxPublicEvents.success(options.Trigger,options.GoalTag,options.TriggerGoalTag,html);
                         //處理執行回覆問題 (搭配執行處理)
                      	 function setErrorMsg(strValue) {
                      	 	  if (options.Trigger!=null && options.Trigger!="undefined") {
                      	 	    if (strValue!="" && strValue!=null && strValue!="undefined") {
                                $(options.Trigger).find("#ReturnMsg").kcwAjaxTips({pos:"append",type:"alert",title:"Error",text:strValue});
                      	 	    }
                      	 	  }
                      	 }
                      	 function setNormalMsg(strValue) {
                      	 	  if (options.Trigger!=null && options.Trigger!="undefined") {
                      	 	    if (strValue!="" && strValue!=null && strValue!="undefined") {
                                $(options.Trigger).find("#ReturnMsg").kcwAjaxTips({pos:"append",type:"prompt",title:"Tips",text:strValue});
                      	 	    }
                      	 	  }
                      	 }
	                       function setAlertFaceMsg(strId,strMsg) {
	                       	  if (options.Trigger!=null && options.Trigger!="undefined") {
                      	 	     if (strMsg!="" && strMsg!=null && strMsg!="undefined") {
                                 $(options.Trigger).find("#"+strId).kcwAjaxTips({type:"alert",title:"",text:strMsg});
                      	 	     }
                      	 	  }
	                       }
	                       function setAlertFace(strId) {
	                       	  if (options.Trigger!=null && options.Trigger!="undefined") {
                      	 	     if (strId!="" && strId!=null && strId!="undefined") {
                                 $(options.Trigger).find("#"+strId+":not(:checkbox,:radio,div,span)").css({"border":"1px solid #ff0000"});
                      	 	     }
                      	 	  }
	                       };
                      }
        });
     }
  }
};
//-----------------------------------------------------------------
//格式化連結
//-----------------------------------------------------------------
jQuery.fn.kcwAjaxConve = function() {
	this.each(function() {
    var tag = this;
    $(tag).find("[kcwAjaxConve='LINK'],[kcwAjaxConve='SUBMIT']").kcwAjaxConveTag(tag);
    $(tag).find("[kcwAjaxConve='CLEAE-UP']").click(function(){ $(tag).kcwAjaxValue(""); });
    $(tag).find("[kcwAjaxConve='CLEAE-SELF']").click(function(){ $(this).kcwAjaxValue(""); });

  });
  return this;
};

// kcwAjaxConve -> LINK, SUBMIT
jQuery.fn.kcwAjaxConveTag   = function(upTag) {
  this.each(function() {
    var tag                     = this;
    var up                      = upTag;
    var options                 = new jQuery._kcwAjax(options);
    var strHref                 = $(tag).attr("href")                     || "";
    var kcwAjaxConve            = $(tag).attr("kcwAjaxConve")             || "";
    var kcwAjaxConfrim          = $(tag).attr("kcwAjaxConfrim")           || "";
    var kcwAjaxMaskTrigger      = $(tag).attr("kcwAjaxMaskTrigger")       || "1";
    var kcwAjaxMaskGoal         = $(tag).attr("kcwAjaxMaskGoal")          || "0";
    var kcwAjaxMaskFull         = $(tag).attr("kcwAjaxMaskFull")          || "0";
    var kcwAjaxTriggeTo         = $(tag).attr("kcwAjaxTriggeTo")          || ""; //SELF | UP
    var kcwAjaxReturnTo         = $(tag).attr("kcwAjaxReturnTo")          || ""; //SELF | UP
    var kcwAjaxReturnToSelfGoal = $(tag).attr("kcwAjaxReturnToSelfGoal")  || "";
    var kcwAjaxReturnToUpGoal   = $(tag).attr("kcwAjaxReturnToUpGoal")    || "";
    var kcwAjaxReturnToGoal     = $(tag).attr("kcwAjaxReturnToGoal")      || "";
    var kcwAjaxReturnToExecute  = $(tag).attr("kcwAjaxReturnToExecute")   || "";
    var kcwAjaxGetTagVarTrigger = $(tag).attr("kcwAjaxGetTagVarTrigger")   || "0";
    var kcwAjaxGetTagVarGoal    = $(tag).attr("kcwAjaxGetTagVarGoal")   || "0";

    //判斷舊系統處理
    if (strHref!="") {
	     var j1 = new RegExp("ajaxTagFunction\\(*","gi");
	     var j2 = new RegExp("ajaxTagSubmit\\(*",  "gi");
       if (j1.test(strHref)) {
       	 var arrTemp                = strHref.split("(")[1].split(")")[0].split(",");
       	 var strHref                = (arrTemp[0]==null || arrTemp[0]=="undefined") ? "" : arrTemp[0].replace(/\'/gi,"");
       	 var kcwAjaxReturnToExecute = (arrTemp[3]==null || arrTemp[3]=="undefined") ? "" : arrTemp[3].replace(/\'/gi,"");
       	 var kcwAjaxConfrim         = (arrTemp[4]==null || arrTemp[4]=="undefined") ? "" : arrTemp[4].replace(/\'/gi,"");
       }
       if (j2.test(strHref)) {
       	 var arrTemp                = strHref.split("(")[1].split(")")[0].split(",");
       	 var strHref                = (arrTemp[0]==null || arrTemp[0]=="undefined") ? "" : arrTemp[0].replace(/\'/gi,"");
       	 var kcwAjaxReturnToExecute = (arrTemp[2]==null || arrTemp[2]=="undefined") ? "" : arrTemp[2].replace(/\'/gi,"");
       	 var kcwAjaxConfrim         = (arrTemp[3]==null || arrTemp[3]=="undefined") ? "" : arrTemp[3].replace(/\'/gi,"");
       	 kcwAjaxGetTagVarTrigger = "1"
       }
       if (kcwAjaxReturnToExecute=="0") { kcwAjaxReturnToExecute=""; }
    }

    if (strHref!="" && kcwAjaxConve!="") {
    	  if (kcwAjaxGetTagVarTrigger=="1") { options.getTagVar.Trigger = true; }
    	  if (kcwAjaxGetTagVarGoal=="1")    { options.getTagVar.GoalTag = true; }
    	  //執行
	      if (kcwAjaxReturnToExecute!="")  { options.Response.ToExecute = true; }
	      //回覆至
	      if (kcwAjaxReturnTo!="")         {
	      	 options.Response.ToGoal = true;
	      	 kcwAjaxReturnTo =  kcwAjaxReturnTo.toUpperCase();
	      }
	      //回覆至上層
	      if (kcwAjaxReturnTo=="SELF")     {
	      	 options.GoalTag = tag;
	      //回覆給自己
	      }else if (kcwAjaxReturnTo=="UP") {
	      	 options.GoalTag = up;
	      }else{
	      }
	      //回覆至目標
	      if (kcwAjaxReturnToGoal!="")     {
	      	 options.Response.ToGoal        = true;
	      	 options.GoalTag                = kcwAjaxReturnToGoal;
	      }
	      //回覆至自己內的目標
	      if (kcwAjaxReturnToSelfGoal!="") {
	      	 options.Response.ToTriggerGoal = true;
	      	 options.TriggerGoalTag         = kcwAjaxReturnToSelfGoal;
	      }
	      //回覆至上層內的目標
	      if (kcwAjaxReturnToUpGoal!="")   {
	      	 options.Response.ToTriggerGoal = true;
	      	 options.TriggerGoalTag         = kcwAjaxReturnToUpGoal;
	      }
	      if (kcwAjaxMaskTrigger=="1")    { options.Mask.Trigger = true; }
	      if (kcwAjaxMaskGoal=="1")       { options.Mask.Goal    = true; }
	      if (kcwAjaxMaskFull=="1")       { options.Mask.Full    = true; }
    	  options.Job         = kcwAjaxConve.toUpperCase();
    	  options.dialog.text = kcwAjaxConfrim;
        $(tag).attr("href","#");
        if (kcwAjaxTriggeTo=="SELF") {
           $(tag).click(function() { $(tag).kcwAjax(strHref, options); });
        }else if(kcwAjaxTriggeTo=="UP") {
    	     $(tag).click(function() { $(up).kcwAjax(strHref, options);  });
        }else{
        	 $(tag).click(function() { $(up).kcwAjax(strHref, options); });
        }
    }
  });
  return this;
};
//-----------------------------------------------------------------
//存入執行緒(jQuery)
//-----------------------------------------------------------------
jQuery.kcwAjaxInQueue = function(options) {
 	jQuery.kcwAjaxQueue[jQuery.kcwAjaxCount]=options;
 	jQuery.kcwAjaxCount++;
};
//-----------------------------------------------------------------
//AJAX執行作業(jQuery)
//-----------------------------------------------------------------
jQuery.kcwAjax = function(page, options, tag ) {
  jQuery._kcwAjax(options);
  if (tag=="undefined" || tag==null) {
  	 options.Trigger = null;
  	 options.getTagVar.Trigger = false;
  	 options.Mask.Trigger = false;
  	 options.Response.ToTrigger = false;
  }else{
  	 options.Trigger = tag;
  }
	//狀態
	options.Run   = 0;
	//背景模式判斷
	if (options.MuteJob) {
     options.Mask.Trigger = false; //觸發物件顯示遮罩
	   options.Mask.Goal    = false; //目標物件顯示遮罩
	   options.Mask.Full    = false; //全畫面顯示遮罩
	   options.StatBar      = false; //狀態列
	}
	if (options.ReturnTrigger.Start)                      { options.Job = "LINK";                   }
  //取得變數
  //alert(options.getTagVar.Trigger);
	//作業模式判斷
	if (options.Job=="SUBMIT")                            { options.method = "POST";	              }
	if (options.Job=="SUBMIT")                            { options.getTagVar.Trigger=true;	        }
	if (options.Job=="SUBMIT")                            { options.Mask.Trigger = true;	          }
	if (options.getTagVar.Trigger)                        { $(tag).kcwAjaxVar(options);             }
	if (options.getTagVar.GoalTag && options.GoalTag!="") { $(options.GoalTag).kcwAjaxVar(options); }
  //alert(page);
  //alert(options.Page);
  //頁面參數分析
	if(page!=null && page!="undefined" && page!="") {
    if(page.indexOf("?")!=-1){
    	options.Page = page.split("?")[0];
      var ary=page.split("?")[1].split("&");      
      for(var i in ary){
      	 strUrlName  = ary[i].split("=")[0];
      	 strUrlValue = ary[i].split("=")[1];      	       	 
      	 if (strUrlName!=null&&strUrlName!="undefined"&&strUrlName!="") {
            options.SendVar[strUrlName] = strUrlValue;
            
         }
      }
    }else{    	
    	options.Page = page;    	
    }
  }
  //alert(options.Page);
	//將傳遞變數轉為 escape
	for (var i in options.SendVar) {
		//alert(i + "=" + options.SendVar[i]);
		options.SendVar[i]=escape(options.SendVar[i]);
	}

 	//送出觸發區塊禁止操作
 	if (options.Job=="SUBMIT" && tag!="undefined" && tag!=null) { $(tag).kcwAjaxDisabledFace("disabled"); }
 	//遮罩處理
  if (options.Mask.Trigger==true && tag!="undefined" && tag!=null) { $(tag).kcwAjaxMask("open");              }
  if (options.Mask.Goal==true && options.GoalTag!="")              { $(options.GoalTag).kcwAjaxMask("open");  }
  if (options.Mask.Full==true)                                     { $('body').kcwAjaxMask("open");           }
 	//LINK作業模式資料處理
 	if (options.Job=="LINK" && page!="" && page!=null && tag!="undefined" && tag!=null && options.Response.ToExecute==false) {
 		 var kcwAjaxLinkID = $(tag).attr("kcwAjaxLinkID");
 		 if ( kcwAjaxLinkID=="" || kcwAjaxLinkID=="undefined" || kcwAjaxLinkID == null ) {
 		    var intL2 = jQuery.kcwAjaxLinkBase.length;
 		    $(tag).attr("kcwAjaxLinkID",intL2);
 		 }else{
 		 	 var intL2 = $(tag).attr("kcwAjaxLinkID");
 		 }
 		 options.Run=0;
 		 jQuery.kcwAjaxLinkBase[intL2] = jQuery.kcwAjaxArray(options);
 	}
 	//準備執行AJAX
 	if (options.Page != "" && options.Page != "undefined" && options.Page != null) { 		
     //將資訊存入執行緒內
     jQuery.kcwAjaxInQueue(options);
     setTimeout( function() { new jQuery.kcwAjaxRun(); },100);
     //jQuery.kcwAjaxRun();
  }
};
//-----------------------------------------------------------------
//物件提示設定(選擇器) prompt |alert | question
//-----------------------------------------------------------------
//物件提示設定事件
//-----------------------------------------------------------------
jQuery.kcwAjaxTipsEvents = jQuery.kcwAjaxTipsEvents  || { };
jQuery.kcwAjaxTipsEvents.beforeSet      = jQuery.kcwAjaxTipsEvents.beforeSet  || function(tag) { };
jQuery.kcwAjaxTipsEvents.completeSet    = jQuery.kcwAjaxTipsEvents.completeSet  || function(tag) { };
jQuery.kcwAjaxTipsEvents.beforeRemove   = jQuery.kcwAjaxTipsEvents.beforeRemove  || function(tag) { };
jQuery.kcwAjaxTipsEvents.completeRemove = jQuery.kcwAjaxTipsEvents.completeRemove  || function(tag) { };
jQuery.kcwAjaxTips = function(tag,options) {
	 jQuery.kcwAjaxTipsEvents.beforeSet(tag);
   var html  = "<span class='kcwAjax-tips'>"
       html += "	<div class='kcwAjax-tips-box kcwAjax-tips-box-"+options.type+"'><span class='kcwAjax-icon kcwAjax-icon-"+options.type+"'> </span>	";
       html += "		<span class='kcwAjax-tips-title'>"+options.title+"</span>";
       html += options.text;
       html += "	</div>";
       html += "</span>";
   if (options.pos=="after") {
     $(tag).after(html);
   }else if (options.pos=="append") {
     $(tag).append(html);
   }else{

   }
   jQuery.kcwAjaxTipsEvents.completeSet(tag);
};
jQuery.fn.kcwAjaxTips = function(options) {
  options       = options || { };
  options.title = options.title || "";       //提示標題
  options.text  = options.text  || "";       //提示文字
  options.type  = options.type  || "prompt"; //提示類型
  options.pos   = options.pos   || "after";  //提示類型 after | append
  options.type.toLowerCase();
  this.each(function() {
  	var tag = this;
    jQuery.kcwAjaxTips(tag,options);
  });
};
//-----------------------------------------------------------------
//物件提示移除(選擇器)
//-----------------------------------------------------------------
jQuery.kcwAjaxTipsRemove = function(tag) {
	jQuery.kcwAjaxTipsEvents.beforeRemove(tag);
  $(tag).find(" .kcwAjax-tips").empty();
  $(tag).find(" .kcwAjax-tips").remove();
  $(tag).find("+ .kcwAjax-tips").empty();
  $(tag).find("+ .kcwAjax-tips").remove();
  jQuery.kcwAjaxTipsEvents.completeRemove(tag);
};
jQuery.fn.kcwAjaxTipsRemove = function(options) {
  this.each(function() {
  	var tag = this;
    jQuery.kcwAjaxTipsRemove(tag);
  });
};
//-----------------------------------------------------------------
//物件數據設定(選擇器)
//-----------------------------------------------------------------

//資料設定事件
jQuery.kcwAjaxValueEvents = jQuery.kcwAjaxValueEvents  || { };
jQuery.kcwAjaxValueEvents.before       = jQuery.kcwAjaxValueEvents.before  || function(tag,value) { };
jQuery.kcwAjaxValueEvents.complete     = jQuery.kcwAjaxValueEvents.complete  || function(tag,value) { };
jQuery.fn.kcwAjaxValue = function(html,ScrollGoLast,bonUseScroll) {
	  html  = html || "";
    this.each(function() {
       var tag = this;
       var elemNodeName = tag.nodeName.toLowerCase();
       jQuery.kcwAjaxValueEvents.before(tag,html);
       if (elemNodeName == "input"	|| elemNodeName == "select"	|| elemNodeName == "option") {
          $(tag).val(html);
       }else if(elemNodeName == "textarea") {
       	  $(tag).html(html);
       }else{
       	  if (bonUseScroll) {
       	      if (ScrollGoLast) {
       	      	 var intTop        = $(tag).scrollTop();
       	      	 var intTopListBox = $(tag).find("#ListBox").scrollTop();
       	      }
       	  }
       	  $(tag).html(html);
       	  //alert(bonUseScroll);
       	  if (bonUseScroll) {
       	      if (ScrollGoLast) {
       	      	if ( intTop > 0 )        {
       	      		 $(tag).scrollTo( {top:intTop+'px', left:'0px'}, 500 );
       	      	}
                if ( intTopListBox > 0 ) {
                	 	$(tag).find("#ListBox").scrollTo( {top:intTopListBox+'px', left:'0px'}, 500 );
                }
       	      }
       	  }
       	  //格式化連結
       	  $(tag).kcwAjaxConve();
       }
       jQuery.kcwAjaxValueEvents.complete(tag,html);
    });
    return this;
};
//-----------------------------------------------------------------
//取得變數(選擇器)
//-----------------------------------------------------------------
jQuery.fn.kcwAjaxVar = function(options) {
	options                        = options || {};                 //選項
	options.SendVar                = options.SendVar || {};	        //送出變數
	options.ValueSeparator         = options.ValueSeparator || ","; //複數分隔符號
  this.each(function() {
      var tag = this;      
      _getTagVar(tag, options.SendVar, options.ValueSeparator);
      //以物件取得送出變數
      function _getTagVar(tag, SendVar, Separator) {
      	var elemNodeName = tag.nodeName.toLowerCase();      	
      	var attrName     = $(tag).attr("name");      	      	
	       //取得送出變數
         if (elemNodeName == "input"	|| elemNodeName == "select"	|| elemNodeName == "option") {         	  	
            if (attrName!=""&&attrName!="undefined"&&attrName!=null) { SendVar[attrName] = $(tag).val();  }
         }else if(elemNodeName == "textarea") {
         	  if (attrName!=""&&attrName!="undefined"&&attrName!=null) { SendVar[attrName] = $(tag).html(); }
         }else{
	         //取得tag下所有變數
	         __getTagVar(tag,SendVar,"textarea",              Separator);
           __getTagVar(tag,SendVar,"input",                 Separator);
           __getTagVar(tag,SendVar,"select",                Separator);
           /* add by brian 20130725 */
           __getTagVar(tag,SendVar,"radio",                Separator);
           __getTagVar(tag,SendVar,"checkbox",                Separator);
         }
      }
      //設定區塊變數
	    function __getTagVar(tag, SendVar, selectors, Separator) {	    
	    	if (Separator=="undefined"||Separator==null) { Separator = ","; }	    	
	    	var m = $(tag).find(selectors).get();
	      for (var i in m) {
	      	 var s = $($(tag).find(selectors).get(i));
	      	 var sName  = s.attr("name");
	      	 var sType  = s.attr("type");
	      	 var sChecked  = s.attr("checked");
	      	 if (selectors=="textarea") {
	      	 	 var sValue = s.val();
	      	 }else{	      	 	
	      	 	 /* edit by brian 20130727 */
	      	 	 var sValue;
	      	 	 if(sType=="radio"){
	      	      sValue = $('input[name='+sName+']:checked').val();
	      	   }else{
	      	   	  sValue = s.val();	
	      	   }  	      	    
	      	 }	      		 
	      	 
	      	 
	      	  //var aaa = $('input[name=E01I04CV0004]:checked').val();
	      	 var elemNodeName = $(tag).find(selectors).get(i).nodeName.toLowerCase();	   	      	    		      	 
	      	 if (sName=="undefined"||sName==null||sName=="") { sName = ""; }	      	 
	      	 /* edit by brian 20130725 */	      	
	      	 if (sType=="radio" && (sChecked==true || sChecked=='checked') && sName!="") {		      	      	 	       
	      	    if (SendVar[sName]!="undefined"&&SendVar[sName]!=""&&SendVar[sName]!=null) {
	      	    	 SendVar[sName] = SendVar[sName] + Separator + sValue;	      		      	    	 
	      	    }else{
	      	    	 SendVar[sName] = sValue;	      	    	 	      	    	 
	      	    }
	      	 }
	      	  /* edit by brian 20130725 */	      
	      	  	  
	      	 if (sType=="checkbox" &&(sChecked==true || sChecked=='checked') && sName!="") {	      	 
	      	    if (SendVar[sName]!="undefined"&&SendVar[sName]!=""&&SendVar[sName]!=null) {
	      	    	 SendVar[sName] = SendVar[sName] + Separator + sValue;
	      	    }else{
	      	    	 SendVar[sName] = sValue;
	      	    }
	      	 }
	      	 if ((sType=="hidden" ||sType=="text" || elemNodeName=="textarea"  || sType=="password") && sName!="")  {
	      	    if (SendVar[sName]!="undefined"&&SendVar[sName]!=""&&SendVar[sName]!=null) {
	      	    	 SendVar[sName] = SendVar[sName] + Separator + sValue;
	      	    	 //alert("M-" + sName + "-" + sValue);
	      	    }else{
	      	    	 SendVar[sName] = sValue;
	      	    	 //alert("S-" + sName + "-" + sValue);
	      	    }
	      	 }
	      	 if (elemNodeName == "select" && sName!="") {
	      	 	  SendVar[sName] = "";	      	 	   
	      	 	  var so = $(s).find("option:selected").get();
	      	 	  for (var z in so) {
	      	 	  	sValue = $(so[z]).val();
	      	      if (SendVar[sName]!="undefined"&&SendVar[sName]!=""&&SendVar[sName]!=null) {
	      	      	 SendVar[sName] = SendVar[sName] + Separator + sValue;
	      	      }else{
	      	      	 SendVar[sName] = sValue;
	      	      }
	      	 	  }
	      	 }
	      }
	    }
  });
  return options;
};
//-----------------------------------------------------------------
//物件禁止操作作業(選擇器)
//-----------------------------------------------------------------
jQuery.fn.kcwAjaxDisabledFace = function(stat,options) {
	stat            = stat || "";
	options         = options || {};
	options.stat    = options.stat || stat;	//執行狀態 readonly | disabled | '' | auto-disabled | auto-readonly
  this.each(function() {
  	var tag = this;
  	var elemNodeName = tag.nodeName.toLowerCase();
  	var s = $(tag).attr("kcwAjaxDisabledFace");
  	if (s=="undefined" || s=="" || s==null) { s=""; }
    if (elemNodeName == "input"	|| elemNodeName == "select"	|| elemNodeName == "textarea"	|| elemNodeName == "button") {
       if (options.stat=="") {
       	  $(tag).removeAttr("kcwAjaxDisabledFace");
       	  if (s=="") {
       	     $(tag).removeAttr("readonly"); $(tag).removeAttr("disabled");
       	  }else{
       	  	 $(tag).removeAttr(s);
       	  }
       }else if (options.stat=="auto-disabled") {
       	  var d = $(tag).attr("disabled");
       	  if (d=="undefined" || d=="" || d==null) { d="true"; }else{ d=""; }
       	  if (d=="true") {
       	  	 $(tag).attr("disabled","true");
       	  	 $(tag).attr("kcwAjaxDisabledFace","disabled");
       	  }else{
       	  	 $(tag).removeAttr("disabled");
       	  	 $(tag).removeAttr("kcwAjaxDisabledFace");
       	  }
       }else if (options.stat=="auto-readonly") {
       	  var d = $(tag).attr("readonly");
       	  if (d=="undefined" || d=="" || d==null) { d="true"; }else{ d=""; }
       	  if (d=="true") {
       	  	 $(tag).attr("readonly","true");
       	  	 $(tag).attr("kcwAjaxDisabledFace","readonly");
       	  }else{
       	  	 $(tag).removeAttr("readonly");
       	  	 $(tag).removeAttr("kcwAjaxDisabledFace");
       	  }
       }else{
       	  $(tag).attr(options.stat,"true");
       	  $(tag).attr("kcwAjaxDisabledFace",options.stat);
       }
    }else{
       if (options.stat=="") {
       	  $(tag).removeAttr("kcwAjaxDisabledFace");
       	  if (s=="") {
       	     $(tag).find(":input").removeAttr("readonly");
       	     $(tag).find(":input").removeAttr("disabled");
       	     $(tag).find("select").removeAttr("readonly");
       	     $(tag).find("select").removeAttr("disabled");
       	     $(tag).find("textarea").removeAttr("readonly");
       	     $(tag).find("textarea").removeAttr("disabled");
       	     $(tag).find("button").removeAttr("readonly");
       	     $(tag).find("button").removeAttr("disabled");
       	  }else{
       	  	 $(tag).find(":input").removeAttr(s);
       	  	 $(tag).find("select").removeAttr(s);
       	  	 $(tag).find("textarea").removeAttr(s);
       	  	 $(tag).find("button").removeAttr(s);
       	  }
       }else if (options.stat=="auto-disabled") {
       	  if (s=="") {
       	  	 $(tag).attr("kcwAjaxDisabledFace","disabled");
       	     $(tag).find(":input").attr("disabled","true");
       	     $(tag).find("select").attr("disabled","true");
       	     $(tag).find("textarea").attr("disabled","true");
       	     $(tag).find("button").attr("disabled","true");
       	  }else{
       	  	 $(tag).removeAttr("kcwAjaxDisabledFace");
       	  	 $(tag).find(":input").removeAttr(s);
       	  	 $(tag).find("select").removeAttr(s);
       	  	 $(tag).find("textarea").removeAttr(s);
       	  	 $(tag).find("button").removeAttr(s);
       	  }
       }else if (options.stat=="auto-readonly") {
       	  if (s=="") {
       	  	 $(tag).attr("kcwAjaxDisabledFace","readonly");
       	     $(tag).find(":input").attr("readonly","true");
       	     $(tag).find("select").attr("readonly","true");
       	     $(tag).find("textarea").attr("readonly","true");
       	     $(tag).find("button").attr("readonly","true");
       	  }else{
       	  	 $(tag).removeAttr("kcwAjaxDisabledFace");
       	  	 $(tag).find(":input").removeAttr(s);
       	  	 $(tag).find("select").removeAttr(s);
       	  	 $(tag).find("textarea").removeAttr(s);
       	  	 $(tag).find("button").removeAttr(s);
       	  }
       }else{
       	  $(tag).attr("kcwAjaxDisabledFace",options.stat);
       	  $(tag).find(":input").attr(options.stat,"true");
       	  $(tag).find("select").attr(options.stat,"true");
       	  $(tag).find("textarea").attr(options.stat,"true");
       	  $(tag).find("button").attr(options.stat,"true");
       }
    }
  });
  return this;
};
//-----------------------------------------------------------------
//AJAX遮罩作業(選擇器)
//-----------------------------------------------------------------
jQuery.fn.kcwAjaxMask = function(stat,options) {
	stat            = stat || "";
	options         = options || {};
	options.stat    = options.stat || stat;	//執行狀態
	options.text    = options.text || "";   //顯示文字

  this.each(function() {
    var tag = this;
    var s = $(tag).attr("kcwAjaxMask");
    var b = false;
    var OC = options.stat;
    if (s=="undefined" || s=="" || s==null) { s="close"; }
    if (OC=="open") {
    	 b = true;
    }else if (OC=="close") {
       b = false;
    }else{
       if (s=="" || s=="close") { 	b = true;  }else{	b = false; }
    }
    if (b==true && s=="close") {
    	var kcwAjaxMaskPos = $(tag).css("position");
    	var kcwAjaxMaskID  = "mask" + new Date().getTime();
      var strTemp  = "<div id='"+kcwAjaxMaskID+"'>";
          strTemp +=  "<div class='kcwAjax-mask'> </div> ";
          if (options.text!="") {
             strTemp += "<div class='kcwAjax-shadow' style='right:20px; top:0px; position: absolute; font-size:12px; color:#3377aa'>"+options.text+"</div>";
          }
          strTemp +=  "<div class='kcwAjax-shadow kcwAjax-LoadingImg16' style='right:0px; top:0px; position: absolute;'> </div> ";
          strTemp += "</div>";
      $(tag).prepend(strTemp);
      $(tag).attr("kcwAjaxMask",   "open");
      $(tag).attr("kcwAjaxMaskID", kcwAjaxMaskID);
      $(tag).attr("kcwAjaxMaskPos",kcwAjaxMaskPos);
      $(tag).css("position","relative");
    }else if (b==false && s=="open") {
    	var kcwAjaxMaskPos = $(tag).attr("kcwAjaxMaskPos");
    	var kcwAjaxMaskID  = $(tag).attr("kcwAjaxMaskID");
    	$(tag).find("#"+kcwAjaxMaskID).remove();
    	$(tag).css("position",kcwAjaxMaskPos);
    	$(tag).attr("kcwAjaxMask",   "close");
    	$(tag).removeAttr("kcwAjaxMaskID");
    	$(tag).removeAttr("kcwAjaxMaskPos");
    }else {

    }
  });
  return this;
};

//-----------------------------------------------------------------
//AJAX執行對話(jQuery)   ok | cancel
//-----------------------------------------------------------------
jQuery.kcwAjaxDialog = function(options) {
  options                = options || {} ;                           //作業前對話處理
  options.title          = options.title || "訊息";                  //對話標題
  options.type           = options.type  || "confrim";               //對話類型 msg | confrim | alert
  options.text           = options.text  || "";                      //對話內容
  options.height         = options.height  || 150;
  options.width          = options.width  || 300;

  options.OK             = options.OK  || {} ;
  options.OK.text        = options.OK.text || "確定";                //確定按鈕文字
  options.OK.execute     = options.OK.execute || function() { };     //確定按鈕執行的函式

  options.CANCEL         = options.CANCEL  || {} ;
  options.CANCEL.text    = options.CANCEL.text || "取消";            //取消按鈕文字
  options.CANCEL.execute = options.CANCEL.execute || function() { }; //取消按鈕執行的函式

  var Execute = function(f,useScrollTo) {
  	                f();
  	                $("#kcwAjaxDialog div").empty();
  	                $("#kcwAjaxDialog div").remove();
  	                //var intTop  = $(document).scrollTop();
  	                //var intLeft = $(document).scrollLeft();
  	                //try {
  	                //   alert("系統測試");
  	                //	 $(document).scrollTo( {top:intTop+'px', left:intLeft+'px'}, 500 );
  	                //}


  	            };
	if (options.text == "") {
	   Execute(options.OK.execute);
	}else{
		 if($("#kcwAjaxDialog").length <= 0) {
		 	 $("body").append("<div id='kcwAjaxDialog'></div>");
		 }
		 var intT = ($(window).height() - options.height ) / 2;
		 var intL = ($(window).width()  - options.width ) / 2;

		 intT += $(document).scrollTop();

     var strHtml  = "<div class='kcwAjax-mask'> </div>";
         strHtml += "<div class='kcwAjax-shadow kcwAjax-mask-dialog' style='top:"+intT+"px; left:"+intL+"px; width:"+options.width+"px; min-height:"+options.height+"px; '>";
         strHtml += "	 <div class='kcwAjax-mask-dialog-title'> "+options.title+"</div>";
         strHtml += "	 <div class='kcwAjax-mask-dialog-desrciption kcwAjax-mask-dialog-"+options.type.toLowerCase()+"'>";
         strHtml += options.text;
         strHtml += "	 </div>";
         strHtml += "	 <div class='kcwAjax-mask-dialog-btn'>";
         strHtml += "	 	 <a href='#' id='kcwAjaxDialogOK'> "+options.OK.text+" </a>";
         if (options.type=="confrim") {
            strHtml += "	 	 <a href='#' id='kcwAjaxDialogCANCEL'> "+options.CANCEL.text+" </a>";
         }
         strHtml += "	 </div>";
         strHtml += "</div>";
     $("#kcwAjaxDialog").prepend(strHtml);
     $("#kcwAjaxDialog > .kcwAjax-mask").height( $(document).height() );
     $("#kcwAjaxDialog #kcwAjaxDialogOK").click(function(){ Execute(options.OK.execute); });
     $("#kcwAjaxDialog #kcwAjaxDialogCANCEL").click(function(){ Execute(options.CANCEL.execute); });
	}
};
//-----------------------------------------------------------------
//AJAX起始設定
//-----------------------------------------------------------------
jQuery._kcwAjax = function(options) {
	if (options                        == "undefined" || options                        == null) { options = {};	                         }
	if (options.SendVar                == "undefined" || options.SendVar                == null) { options.SendVar = { };                  } //* 送出變數
	if (options.ValueSeparator         == "undefined" || options.ValueSeparator         == null) { options.ValueSeparator = ",";           } //* 複數分隔符號
	if (options.method                 == "undefined" || options.method                 == null) { options.method = "GET";                 } //* 送出方式
	if (options.Job                    == "undefined" || options.Job                    == null) { options.Job = "LINK";                   } //* 作業模式 SUBMIT, LINK
  if (options.dialog                 == "undefined" || options.dialog                 == null) { options.dialog = {} ;                   } //* 作業前對話處理
  if (options.dialog.title           == "undefined" || options.dialog.title           == null) { options.dialog.title = "Message";       } //* 對話標題
  if (options.dialog.type            == "undefined" || options.dialog.type            == null) { options.dialog.type  = "confrim";       } //* 對話類型 msg | confrim | alert
  if (options.dialog.text            == "undefined" || options.dialog.text            == null) { options.dialog.text  = "";              } //* 對話
  if (options.dialog.OK              == "undefined" || options.dialog.OK              == null) { options.dialog.OK  = {} ;               } //* 確定按鈕
  if (options.dialog.CANCEL          == "undefined" || options.dialog.CANCEL          == null) { options.dialog.CANCEL  = {} ;           } //* 取消按鈕
	if (options.getTagVar              == "undefined" || options.getTagVar              == null) { options.getTagVar = {};                 } //* 取得物件變數選項
	if (options.getTagVar.Goal         == "undefined" || options.getTagVar.Goal         == null) { options.getTagVar.Goal = false;         } //* 目標
	if (options.getTagVar.Trigger      == "undefined" || options.getTagVar.Trigger      == null) { options.getTagVar.Trigger = false;      } //* 觸發
  if (options.MuteJob                == "undefined" || options.MuteJob                == null) { options.MuteJob  = false;               } //* 背景執行模式
  if (options.StatBar                == "undefined" || options.StatBar                == null) { options.StatBar  = false;               } //* 顯示狀態列
  if (options.GoalTag                == "undefined" || options.GoalTag                == null) { options.GoalTag  = "";                  } //* 目標物件 (選擇器 Or 物件)
  if (options.TriggerGoalTag         == "undefined" || options.TriggerGoalTag         == null) { options.TriggerGoalTag  = "";           } //* 觸發目標內物件 (選擇器 Or 物件)
  if (options.Mask                   == "undefined" || options.Mask                   == null) { options.Mask = { };                     } //* 顯示遮罩選項
  if (options.Mask.Trigger           == "undefined" || options.Mask.Trigger           == null) { options.Mask.Trigger = true;            } //* 觸發物件顯示遮罩
	if (options.Mask.Goal              == "undefined" || options.Mask.Goal              == null) { options.Mask.Goal = false;              } //* 目標物件顯示遮罩
	if (options.Mask.Full              == "undefined" || options.Mask.Full              == null) { options.Mask.Full = false;              } //* 全畫面顯示遮罩
	if (options.Response               == "undefined" || options.Response               == null) { options.Response = { };                 } //* 回覆處理選項
	if (options.Response.ToExecute     == "undefined" || options.Response.ToExecute     == null) { options.Response.ToExecute = false;     } //* 回覆為執行
	if (options.Response.ToGoal        == "undefined" || options.Response.ToGoal        == null) { options.Response.ToGoal = false;        } //* 回覆至目標物件
	if (options.Response.ToTriggerGoal == "undefined" || options.Response.ToTriggerGoal == null) { options.Response.ToTriggerGoal = false; } //* 回覆至觸發目標內物件
	if (options.Response.ToTrigger     == "undefined" || options.Response.ToTrigger     == null) { options.Response.ToTrigger = false      } //* 回覆至觸發物件
  if (options.ReturnTrigger          == "undefined" || options.ReturnTrigger          == null) { options.ReturnTrigger = { };            } //* 重覆執行執行選項
  if (options.ReturnTrigger.Start    == "undefined" || options.ReturnTrigger.Start    == null) { options.ReturnTrigger.Start = false;    } //* 重覆執行
  if (options.ReturnTrigger.RunTime  == "undefined" || options.ReturnTrigger.RunTime  == null) { options.ReturnTrigger.RunTime = 0;      } //* 重覆執行時間 (秒)
  if (options.ReturnTrigger.MaxCount == "undefined" || options.ReturnTrigger.MaxCount == null) { options.ReturnTrigger.MaxCount = 1;     } //* 重覆執行次數 (秒)
  if (options.ReturnTrigger.RunCount == "undefined" || options.ReturnTrigger.RunCount == null) { 0;                                      }


  if (options.useScrollTo == "undefined" || options.useScrollTo == null) {  options.useScrollTo = true;                                    }

                                 //* 已執行次數
  //beforeSend ? success ? error or complete
  options.LocalEvents            = options.LocalEvents || { };                                //事件
  options.LocalEvents.beforeSend = options.LocalEvents.beforeSend || function(Trigger,GoalTag,TriggerGoalTag) { };          //Ajax 請求發出之前
  options.LocalEvents.success    = options.LocalEvents.success    || function(Trigger,GoalTag,TriggerGoalTag,Response) { }; //Ajax 請求成功時 (沒任何 error)
  options.LocalEvents.error      = options.LocalEvents.error      || function(Trigger,GoalTag,TriggerGoalTag) { };          //Ajax 請求發生錯誤時 (Ajax 請求不是 success，就是 error，沒都有的情況)
  options.LocalEvents.complete   = options.LocalEvents.complete   || function(Trigger,GoalTag,TriggerGoalTag) { };          //不論 Ajax 請求是 success 或是 error，都會觸發 complete 事件
  return options;
};
//-----------------------------------------------------------------
//AJAX起始作業 (選擇器)
//-----------------------------------------------------------------
jQuery.fn.kcwAjax = function(page, options) {
  jQuery._kcwAjax(options);
  var me = this;
  options.dialog.OK.execute = function() {
     me.each(function() {
         var tag = this;
         var o =  new jQuery.kcwAjaxArray(options);
         o.SendVar = new jQuery.kcwAjaxArray(o.SendVar);
	       o.Trigger = tag;
         new jQuery.kcwAjax(page,o,tag);
     });
     if (options.ReturnTrigger.Start) {
     	  var r = options.ReturnTrigger.RunCount;
     	  var m = options.ReturnTrigger.MaxCount;
     	  var t = options.ReturnTrigger.RunTime * 1000;
     	  jQuery.kcwAjaxReturnExecute(me,r,m,t,options.useScrollTo);
     }
  };
  jQuery.kcwAjaxDialog(options.dialog);
  return this;
};

//-----------------------------------------------------------------
//AJAX起始作業 (選擇器)
//-----------------------------------------------------------------


//-----------------------------------------------------------------
//重覆執行處理(jQuery)
//-----------------------------------------------------------------
jQuery.kcwAjaxReturnExecute = function(me,r,m,t,useScrollTo) {
  jQuery.kcwAjaxReload(me,useScrollTo);
  r++;
  if (r < m || m == 0) {
    setTimeout( function() { jQuery.kcwAjaxReturnExecute(me,r,m,t,useScrollTo) },t);
  }
};
//-----------------------------------------------------------------
//重新載入函數(選擇器)
//-----------------------------------------------------------------
jQuery.fn.kcwAjaxReload = function(bonScroll) {
	var useScrollTo;
  if (bonScroll=="undefined"){ useScrollTo = true; }else{ useScrollTo = bonScroll; }
  jQuery.kcwAjaxReload(this,useScrollTo);
};
//-----------------------------------------------------------------
//重新載入函數(jQuery)
//-----------------------------------------------------------------
jQuery.kcwAjaxReload = function(me,bonScroll) {
	var useScrollTo;
	if (bonScroll=="undefined"){ useScrollTo = true; }else{ useScrollTo = bonScroll; }
  me.each(function() {
     var tag = this;
     var kcwAjaxLinkID = $(tag).attr("kcwAjaxLinkID");
     if (kcwAjaxLinkID!=null && kcwAjaxLinkID!="undefined") {
     	  var o = jQuery.kcwAjaxLinkBase[kcwAjaxLinkID];
     	  if (o!=null && o!="undefined") {
           var options = o;
           options.Run = 0;
           options.isReload = true;
           options.useScrollTo = useScrollTo;
           jQuery.kcwAjaxInQueue(options);
 	         setTimeout( function() { new jQuery.kcwAjaxRun(); },100);
        }
     }
  });
};
//-----------------------------------------------------------------
//設定觸發式載入-以頁面物件做為選擇觸發
//-----------------------------------------------------------------
jQuery.fn.kcwAjaxTriggerLoad = function(Selectors) {
	this.each(function() {
    var tag = this;
    $(tag).attr("kcwAjaxTriggerLoad",Selectors);
  });
};
//-----------------------------------------------------------------
//設定觸發式載入-以被觸發物件以下做為選擇觸發
//-----------------------------------------------------------------
jQuery.fn.kcwAjaxTriggerLoadFind = function(Selectors) {
	this.each(function() {
    var tag = this;
    $(tag).attr("kcwAjaxTriggerLoadFind",Selectors);
  });
};

jQuery.fn.kcwAjaxEscapeHref = function() {
	this.each(function() {
    var tag = this;
    var strHref = $(tag).attr("href");
    var strNewHref = "";
    //頁面參數分析
	  if(strHref!=null && strHref!="undefined" && strHref!="") {
      if (strHref.indexOf("?")!=-1){
      	 strNewHref  = strHref.split("?")[0];
      	 strNewHref +="?"
         var ary=page.split("?")[1].split("&");
         for(var i in ary){
         	 strUrlName  = ary[i].split("=")[0];
         	 strUrlValue = ary[i].split("=")[1];
         	 if (strUrlName!=null&&strUrlName!="undefined"&&strUrlName!="") {
         	 	   strNewHref = strNewHref + "&" + strUrlName+"="+strUrlValue;
           }
         }
      }else{
      	 strNewHref = strHref;
      }
    }
  });
};




//-----------------------------------------------------------------
//設定觸發式載入-比對ID永久觸發
//-----------------------------------------------------------------
jQuery.kcwAjaxTriggerLoadBasic = function(id,Selectors) {
  jQuery.kcwAjaxReloadBase[id]=Selectors;
}
//-----------------------------------------------------------------
//轉換新陣列(jQuery)
//-----------------------------------------------------------------
jQuery.kcwAjaxArray = function(arr) {
  var o = new Object;
  var a = false;
  for (k in arr) {
  	a=true;
  	if (typeof arr[k] == "object") {
  		o[k] = arr[k];
  	}else{
  	  o[k] = arr[k];
  	}
  }
  if (!a) { o = arr; }
  return o;
};
