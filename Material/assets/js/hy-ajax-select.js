function hy_SelectHtml() {
	  var ThisID = ""; 
	  var TargetID = "";
	  var SelectedValue = ""; 	  
	  var Parame = "";
	  var TableName = "";
	  var ColumeCode ="";
	  var ColumeName ="";
	  var ColumeWhere ="";
	  var BasicWhere = "" ;
	  var BasicParame = "";
	  var PlusParame1 = "";
	  this.SelectRoute ="";	  
	  var ServiceUrl = "";   
	  
	  var clearOption = function() {	  	  
   	    $("#"+TargetID).html("");
    }
    var setSelectedValue = function(strValue) {
   	    this.SelectedValue = strValue;
    }
    this.setBaicWhere = function(strId , strValue) {
   	    BasicWhere = strId;
   	    BasicParame = strValue;   	 
    }
    this.PlusParame1 = function( strValue) {   	    
   	    PlusParame1 = strValue;   	 
    }
    var setOption = function(){    	
    	   var str = "?TableName="+TableName+"&ColumeName="+ ColumeName+"&ColumeCode="+ColumeCode+"&ColumeWhere="+ColumeWhere+"&Parame="+Parame;    	     	   
    	   if(BasicWhere!=""){    	   	    	   	
    	   	str = str + "&BasicWhere="+BasicWhere+"&BasicParame="+BasicParame;    	  
    	   	}   
    	   if(PlusParame1!=""){    	   	
    	   	str = str + "&PlusParame1="+ $("#"+PlusParame1).val();    	   	    	   	
    	   	}       	   	
    	   $("#"+ThisID).kcwAjax(ServiceUrl+str, {
               Job: "LINK",
               Response: {
                   ToExecute: false,
                   ToGoal: false,
                   ToTrigger: false
               },
               LocalEvents: {
                   success: function (Trigger, GoalTag, TriggerGoalTag, Response) {
                       /* alert(Response);  */          
                     if(Response!=""){                                                          
                            var contact = JSON.parse(Response);                                     
                            var pHtml ="";                      
                            
                            pHtml = "<option value =''>請選擇</option>";             
                           
                            for (i=0;i<contact[0].html_Select[0].value.length;i++){        
                            	   if(SelectedValue==contact[0].html_Select[0].value[i].value){
                                   pHtml += "<option value ='"+contact[0].html_Select[0].value[i].value+"' selected='selected'>"+contact[0].html_Select[0].tittle[i].value+"</option>";
                                }else{
                                
                                   pHtml += "<option value ='"+contact[0].html_Select[0].value[i].value+"'>"+contact[0].html_Select[0].tittle[i].value+"</option>";
                                }
                            }       
                            $("#"+TargetID).html(pHtml);
                      }else{
                      	    $("#"+TargetID).html("<option value =''><---請選擇--></option>");         
                      }
                   }
               }
           }); 	 	    	
    } 
    /* 上一層select欄位,承接select欄位,table,id欄位,名稱欄位,條件欄位,預選參數,路徑 */
    this.initEvent= function(strID,strTarget,strTable,strColumn1,strColumn2,strWhere,strSelected,strUrl){
    	   ThisID = strID;     
    	   TargetID = strTarget;    	   
    	   SelectedValue = strSelected;
    	   ServiceUrl = strUrl;
    	   TableName = strTable;
    	   ColumeCode = strColumn1;
    	   ColumeName = strColumn2;
    	   ColumeWhere = strWhere;
    	   $("#"+ThisID).change(function(){
    	   	     Parame = this.value;        	   	      	     
    	   	     clearOption();
               setOption();
         });         
         
         setTimeout( function() {	    
	             var getSelectedValue = $("#"+ThisID).val();	             
               if(getSelectedValue!=""){               	               	 
               	   Parame = getSelectedValue;        	   	      	     
    	         	   clearOption();
                   setOption();
               }	            
	       },400 );                  
    }
}