/*
 Ajax Function (Old)
 Include File:
              -- jquery131.js
              -- hy-ajax.js

 # Cearte Date: 2010/01/01
 # Update Date: 2010/01/16
 # Update Date: 2010/11/23

 Design By: Wesley-Kung
 CopytRight: Copyright 2010 Hsien Yang Information Co., Ltd All Rights Reserved
*/
 jQuery.kcwAjaxTriggerLoadBasic("AxajFace" , "#AxajList" );
 jQuery.kcwAjaxTriggerLoadBasic("AxajFace1", "#AxajList1");
 jQuery.kcwAjaxTriggerLoadBasic("AxajFace2", "#AxajList2");
 jQuery.kcwAjaxTriggerLoadBasic("AxajFace3", "#AxajList3");
 jQuery.kcwAjaxTriggerLoadBasic("AxajFace4", "#AxajList4");
 jQuery.kcwAjaxTriggerLoadBasic("AxajList2", "#AxajList1");
 jQuery.kcwAjaxTriggerLoadBasic("AxajList3", "#AxajList2");
 jQuery.kcwAjaxTriggerLoadBasic("AxajList4", "#AxajList3");
 jQuery.kcwAjaxTriggerLoadBasic("DialogFace","#DialogList");
 /* 設定AJAX重載函式 */
 function ajaxReloadTag(strTagId) {
   $("#"+strTagId).kcwAjaxReload();
 }
 /* 設定AJAX送出函式 */
 function ajaxTagLinkSubmit(strPage,strTagId,bonJs,strConfrim,bonRun,bonScrool) {
 	 var options = jQuery._kcwAjax(options);
 	 options.Mask.Trigger = true;
 	 options.Job = "LINK";
 	 options.getTagVar.Trigger = true;
 	 options.page = strPage;
 	 if (bonScrool=="undefined" || bonScrool==null){
 	 	 options.useScrollTo=true;
 	 }else{
 	 	 options.useScrollTo=bonScrool;
 	 }
 	 //alert(strPage);
 	 if (bonJs=="1") {
 	 	  options.Response.ToExecute=true;
 	 	  options.Response.ToGoal=false;
 	 	  options.Response.ToTrigger=false;
 	 }else{
 	 	  options.Response.ToExecute=false;
 	 	  options.Response.ToGoal=false;
 	 	  options.Response.ToTrigger=true;
 	 }
 	 if (strConfrim!=null&&strConfrim!="undefined") {
 	    options.dialog.text = strConfrim;
 	 }

   $("#"+strTagId).kcwAjax(strPage,options);
 }
 /* 設定AJAX送出函式 */
 function ajaxTagSubmit(strPage,strTagId,bonJs,strConfrim,bonRun) {
 	 var options = jQuery._kcwAjax(options);
 	 options.Mask.Trigger = true;
 	 options.Job = "SUBMIT";
 	 options.getTagVar.Trigger = true;
 	 options.page = strPage;
 	 //alert(strPage);
 	 if (bonJs=="1") {
 	 	  options.Response.ToExecute=true;
 	 	  options.Response.ToGoal=false;
 	 	  options.Response.ToTrigger=false;
 	 }else{
 	 	  options.Response.ToExecute=false;
 	 	  options.Response.ToGoal=false;
 	 	  options.Response.ToTrigger=true;
 	 }
 	 if (strConfrim!=null&&strConfrim!="undefined") {
 	    options.dialog.text = strConfrim;
 	 }

   $("#"+strTagId).kcwAjax(strPage,options);
 }
 /* AJAX函數-取得函式 */
 function ajaxTagFunction(strPage,strTagId,strShowLoading,bonJs,strConfrim,bonScrool) {
 	 var options = { };
 	 options.Job = "LINK";
 	 options.Response = { };
 	 options.dialog = { };
 	 options.Mask = { };
 	 if (bonScrool=="undefined" || bonScrool==null){
 	 	 options.useScrollTo=true;
 	 }else{
 	 	 options.useScrollTo=bonScrool;
 	 }
 	 if (strShowLoading=="1") {
 	    options.Mask.Trigger = true;
 	 }else{
 	 	  options.Mask.Trigger = false;
 	 }
 	 if (bonJs=="1") {
 	 	  options.Response.ToExecute=true;
 	 	  options.Response.ToGoal=false;
 	 	  options.Response.ToTrigger=false;
 	 }else{
 	 	  options.Response.ToExecute=false;
 	 	  options.Response.ToGoal=false;
 	 	  options.Response.ToTrigger=true;
 	 }
 	 if (strConfrim!=null&&strConfrim!="undefined") { 	 	  
 	    options.dialog.text = strConfrim;
 	 }
   $("#"+strTagId).kcwAjax(strPage,options);
 }
 /* 設定物件資料 */
 function setObjectContent(strId,strValue) {
   $("#"+strId).kcwAjaxValue(strValue);
 }
 /* 強制訊息視窗 */
 function alertMsg(strValue) { 	  	
   jQuery.kcwAjaxDialog({title:"Alert",type:"alert",text:strValue});
   
 }
 /* 訊息視窗 */
 function RtnMsg(strId,strValue) { 	
 	
 	 $("#"+strId).html(strValue);
}

