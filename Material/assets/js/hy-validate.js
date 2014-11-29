jQuery.Hy_Validate = Array();
jQuery.Hy_Validate_Default = function(tag,options) {
                      $("input").each(function() { 
                      	    var pTittle = $(this).attr("tittle");    
                      	    if(pTittle!=""&&pTittle!=undefined){                      	    	   
                      	         $(this).addClass("Useless").css("color","#8a8a8a");;
                                 $(this).val(pTittle);
                                 $(this).focusin(function(){
                                     if( $(this).val()==pTittle){
                                     	$(this).val('');   $(this).removeClass("Useless").css("color","#000");    
                                     	$(this).addClass("Used");                                               
                                     }
                                 });
                                 $(this).focusout(function(){
                                      if( $(this).val()==''){
                                      	$(this).val(pTittle); $(this).addClass("Useless").css("color","#8a8a8a");      
                                      	$(this).removeClass("Used");                                   
                                      }  
                                 });
                          }
                      });             
                                   
                                                                                                                                                
                      var ColumnSetting = function(TagID,columns,classN) { 	
                      	      var TagArray = columns.split(",");
                              for (var i=0;i<TagArray.length;i++)
                              {                                   
                                  $(TagID + " ."+TagArray[i]).addClass(classN);                 
                              }
                      
                      }
                      
                      /* 語系載入 */                      
                      function GetCookie(name) {
                          var nameEQ = name + "=";
                          var ca = document.cookie.split(';');           
                          for (var i = 0; i < ca.length; i++) {
                              var c = ca[i];
                              while (c.charAt(0) == ' ') {
                                  c = c.substring(1, c.length);
                              }
                              if (c.indexOf(nameEQ) == 0) {       //如果含有我?要的name  
                                  return unescape(c.substring(nameEQ.length, c.length));
                              }
                          }
                          return false;
                      }
                      var planguage = GetCookie("Language");
                      if(planguage!="" && planguage!=undefined){
                           planguage = planguage.replace("LangTYpe=","");              
                           if(planguage!="tw" && planguage!="cn" && planguage && "jp" && planguage && "en"){
                              	planguage ="tw";
                           }
                      }else{
                      	   planguage ="tw";
                      }
                      switch(planguage)
                      {
                      case "tw":
                        jQuery.Hy_Validate["Language01"]="欄位不可空白!!";
                        jQuery.Hy_Validate["Language02"]="不可使用中文!!";
                        jQuery.Hy_Validate["Language03"]="僅能輸入英文!!";
                        jQuery.Hy_Validate["Language04"]="僅能輸入數字!!";
                        jQuery.Hy_Validate["Language05"]="僅能輸入英文,數字!!";
                        jQuery.Hy_Validate["Language06"]="僅能輸入英文,數字,符號!!";
                        jQuery.Hy_Validate["Language07"]="Url格式不符!!";
                        jQuery.Hy_Validate["Language08"]="身份証號碼格式不符!!";
                        jQuery.Hy_Validate["Language09"]="Mail格式不符!!";
                        jQuery.Hy_Validate["Language10"]="電話格式不符!";
                        jQuery.Hy_Validate["Language11"]="驗証資料有誤!";                        
                        break;
                      case "cn":
                        jQuery.Hy_Validate["Language01"]="栏位不可空白!!";
                        jQuery.Hy_Validate["Language02"]="不可使用中文!!";
                        jQuery.Hy_Validate["Language03"]="仅能输入英文!!";
                        jQuery.Hy_Validate["Language04"]="仅能输入数字!!";
                        jQuery.Hy_Validate["Language05"]="仅能输入英文,数字!!";
                        jQuery.Hy_Validate["Language06"]="仅能输入英文,数字,符号!!";
                        jQuery.Hy_Validate["Language07"]="Url格式不符!!";
                        jQuery.Hy_Validate["Language08"]="身份证号码格式不符!!";
                        jQuery.Hy_Validate["Language09"]="Mail格式不符!!";
                        jQuery.Hy_Validate["Language10"]="电话格式不符!";
                        jQuery.Hy_Validate["Language11"]="验证资料有误!";
                        break;
                      case "en":
                        jQuery.Hy_Validate["Language01"]="required field";
                        jQuery.Hy_Validate["Language02"]="can not use Chinese";
                        jQuery.Hy_Validate["Language03"]="English Only";
                        jQuery.Hy_Validate["Language04"]="";
                        jQuery.Hy_Validate["Language05"]="";
                        jQuery.Hy_Validate["Language06"]="";
                        jQuery.Hy_Validate["Language07"]="";
                        jQuery.Hy_Validate["Language08"]="";
                        jQuery.Hy_Validate["Language09"]="";
                        jQuery.Hy_Validate["Language10"]="";
                        jQuery.Hy_Validate["Language11"]="";
                        break;
                      case "jp":
                        jQuery.Hy_Validate["Language01"]="必須フィールド";
                        jQuery.Hy_Validate["Language02"]="中国語禁止";
                        jQuery.Hy_Validate["Language03"]="英語のみ";
                        jQuery.Hy_Validate["Language04"]="";
                        jQuery.Hy_Validate["Language05"]="";
                        jQuery.Hy_Validate["Language06"]="";
                        jQuery.Hy_Validate["Language07"]="";
                        jQuery.Hy_Validate["Language08"]="";
                        jQuery.Hy_Validate["Language09"]="";
                        jQuery.Hy_Validate["Language10"]="";
                        jQuery.Hy_Validate["Language11"]="";
                        break;    
                      default:
                        
                      }
                      if(options.Column_Require!=''){ ColumnSetting(options.id,options.Column_Require,"Require");}
                      if(options.Column_Numeric!=''){ ColumnSetting(options.id,options.Column_Numeric,"ValidateNumric");}
                      if(options.Column_English!=''){ColumnSetting(options.id,options.Column_English,"ValidateEnglish");}
                      if(options.Column_Symbol!=''){ColumnSetting(options.id,options.Column_Symbol,"ValidateSymbol");}
                      if(options.Column_NumericEnglish!=''){ColumnSetting(options.id,options.Column_NumericEnglish,"ValidateNumricEnglish");}                      
                      if(options.Column_NumericEnglishSymbol!=''){ColumnSetting(options.id,options.Column_NumericEnglishSymbol,"ValidateNumricEnglishSymbol");}
                      if(options.Column_NoChinese!=''){ColumnSetting(options.id,options.Column_NoChinese,"ValidateNoChinese");}       
                      if(options.Column_Mail!=''){ColumnSetting(options.id,options.Column_Mail,"ValidateMail");}  
                      if(options.Column_Url!=''){ColumnSetting(options.id,options.Column_Url,"ValidateUrl");}  
                      if(options.Column_PersonalID!=''){ColumnSetting(options.id,options.Column_PersonalID,"ValidatePersonalID");}  
                      if(options.Column_Phone!=''){ColumnSetting(options.id,options.Column_Phone,"ValidatePhone");}
                      if(options.Column_DblCheck!=''){ColumnSetting(options.id,options.Column_DblCheck,"ValidateDblCheck");}
                      jQuery.Hy_Validate["option"] = options;         
                      jQuery.Hy_Validate["id"] = tag;                 

                      
                  };                                                              
/* 選擇器導入的函數 */              
jQuery.fn.Hy_Validate = function (options) {
	if (options == "undefined" ||   options == null) {		 options = {};	}
	if (options.id == "undefined"                   || options.id == null)                      {		 options.id = ""; }               /* id */
	if (options.Column_Require == "undefined"       || options.Column_Require == null)          {		 options.Column_Require = ""; }   /* 必需欄位 */
	if (options.Column_Numeric ==  "undefined"       || options.Column_Numeric == null)           {		 options.Column_Numeric = "";  }   /* 僅數字 */
	if (options.Column_English == "undefined"       || options.Column_English == null)          {		 options.Column_English = ""; }   /* 僅英文 */
	if (options.Column_Symbol == "undefined"        || options.Column_Symbol == null)           {		 options.Column_Symbol = ""; }    /* 僅符號 */
	if (options.Column_NumericEnglish == "undefined" || options.Column_NumericEnglish == null)    {		 options.Column_NumericEnglish = ""; }   /* 僅英文數字 */	
	if (options.Column_NumericEnglishSymbol == "undefined" || options.Column_NumericEnglishSymbol == null)    {		 options.Column_NumericEnglishSymbol = ""; }   /* 僅英文數字符號 */
	if (options.Column_NoChinese == "undefined"     || options.Column_NoChinese == null)        {		 options.Column_NoChinese = ""; }       /* 排除中文 */
	if (options.Column_Mail == "undefined"          || options.Column_Mail == null)        {		 options.Column_Mail = ""; }           /* mail欄位 */
	if (options.Column_Url == "undefined"           || options.Column_Url == null)         {		 options.Column_Url = ""; }            /* url欄位 */
	if (options.Column_PersonalID == "undefined"    || options.Column_PersonalID == null)       {		 options.Column_PersonalID = "";}  /* 身份証欄位 */
	if (options.Column_Phone == "undefined"         || options.Column_Phone == null)       {		 options.Column_Phone = ""; }              /* 室內電話 */		
	if (options.Column_DblCheck == "undefined"      || options.Column_DblCheck == null)    {		 options.Column_DblCheck = ""; }           /* 雙重驗証 */			  	  
	this.each(function() {
    var tag = this;
    jQuery.Hy_Validate_Default(tag,options);
  });
};




/* 表單驗証 */
 function Hy_FormValidate() { 	 	
 	   var options = jQuery.Hy_Validate["option"] ;     
 	   var TagID = options.id; 	 	   
 	   var Permission = true; 
 	   $(".Useless").val("");
 	   $(".ValidateMsg").remove(); 	   
 	  
 	   
     $( TagID +" .Require" ).each(function() {     	     	
           if(this.value==''){                      	
             	$(this).parent().append("<span class='ValidateMsg' >"+jQuery.Hy_Validate["Language01"]+"</span>");      
             	Permission = false;       	
           }                      
     });
     
     $(TagID + " .ValidateNoChinese" ).each(function() {
           if(this.value!=''){
           	  var pattern  = "[\u4e00-\u9fa5]";
	            var regex = new RegExp(pattern,'g');	                             	                             
	            var Bool = regex.test(this.value);
           	  if(Bool){
             	   $(this).parent().append("<span class='ValidateMsg' >"+jQuery.Hy_Validate["Language02"]+"</span>");
             	   Permission = false;
              }
           }
     });
     
      $( TagID + " .ValidateEnglish" ).each(function() {
           if(this.value!=''){
           	  var pattern  = "^[a-zA-Z]*$";
	            var regex = new RegExp(pattern,'g');	                             	                             
	            var Bool = regex.test(this.value);
           	  if(!Bool){
             	   $(this).parent().append("<span class='ValidateMsg' >"+jQuery.Hy_Validate["Language03"]+"</span>");
             	   Permission = false;
              }
           }
     });
     
     $( TagID +" .ValidateNumric" ).each(function() {
           if(this.value!=''){
           	  var pattern  = "^[0-9]*$";
	            var regex = new RegExp(pattern,'g');	                             	                             
	            var Bool = regex.test(this.value);
           	  if(!Bool){
             	   $(this).parent().append("<span class='ValidateMsg' >"+jQuery.Hy_Validate["Language04"]+"</span>");
             	   Permission = false;
              }
           }           
     });
     
     $( TagID +" .ValidateNumricEnglish" ).each(function() {
           if(this.value!=''){
           	  var pattern  = "^[a-zA-Z0-9]*$";
	            var regex = new RegExp(pattern,'g');	                             	                             
	            var Bool = regex.test(this.value);
           	  if(!Bool){
             	   $(this).parent().append("<span class='ValidateMsg' >"+jQuery.Hy_Validate["Language05"]+"</span>");
             	   Permission = false;
              }
           }
     });
     
     $( TagID +" .ValidateNumricEnglishSymbol" ).each(function() {
           if(this.value!=''){
           	  var pattern  = "^[^\u4e00-\u9fa5]*$";
	            var regex = new RegExp(pattern,'g');	                             	                             
	            var Bool = regex.test(this.value);
           	  if(!Bool){
             	   $(this).parent().append("<span class='ValidateMsg' >"+jQuery.Hy_Validate["Language06"]+"</span>");
             	   Permission = false;
              }
           }
     });
     
     $( TagID +" .ValidateUrl" ).each(function() {
           if(this.value!=''){
           	  var pattern  = "^(http|https|ftp)\://[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(:[a-zA-Z0-9]*)?/?([a-zA-Z0-9\-\._\?\,\'/\\\+&amp;%\$#\=~])*$";
	            var regex = new RegExp(pattern,'g');	                             	                             
	            var Bool = regex.test(this.value);
           	  if(!Bool){
             	   $(this).parent().append("<span class='ValidateMsg' >"+jQuery.Hy_Validate["Language07"]+"</span>");
             	   Permission = false;
              }
           }
     });
     
     $( TagID +" .ValidatePersonalID" ).each(function() {
           if(this.value!=''){
           	  var pattern  = "^[A-Z]{1}[0-9]{9}$";
	            var regex = new RegExp(pattern,'g');	                             	                             
	            var Bool = regex.test(this.value);
           	  if(!Bool){
             	   $(this).parent().append("<span class='ValidateMsg' >"+jQuery.Hy_Validate["Language08"]+"</span>");
             	   Permission = false;
              }
           }
     });
     
     $( TagID + " .ValidateMail" ).each(function() {
           if(this.value!=''){
           	 var strEmail = this.value; 
             emailRule = /^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z]+$/;             
             if(strEmail.search(emailRule)!= -1){                 
             }else{
                 $(this).parent().append("<span class='ValidateMsg' >"+jQuery.Hy_Validate["Language09"]+"</span>");    
                 Permission = false;   
             }           	           	           	                          	                             	            
           }
     });
     
     $( TagID +" .ValidatePhone" ).each(function() {
           if(this.value!=''){
           	  var pattern  = "^[0][1-9]{1,2}-([0-9]{7,8})+((#([0-9]){1,5}){0,1})$";
	            var regex = new RegExp(pattern,'g');	                             	                             
	            var Bool = regex.test(this.value);
           	  if(!Bool){
             	   $(this).parent().append("<span class='ValidateMsg' >"+jQuery.Hy_Validate["Language10"]+"</span>");
             	   Permission = false;
              }
           }
     });
     
     if(options.Column_DblCheck!=""){
     	     var pArray = options.Column_DblCheck;     	         
     	         pArray = pArray.split(","); 
     	         for (i=0;i<pArray.length;i++)
               {
               	  var valueA = $( "."+pArray[i] ).val(); 
               	  var valueB = $( "."+pArray[i]+"_Match" ).val();                    	 
               	  if(valueA!=valueB){
               	  	  $(TagID + " ."+pArray[i] ).parent().append("<span class='ValidateMsg' >"+jQuery.Hy_Validate["Language11"]+"</span>");
               	  	  Permission = false;
               	  }
               }     	
     }
     
     $(TagID +" .ValidateMsg").css({
     	  "font-size":"12px",
     	  "color":"#ff0000"
     	})     	
 	 return Permission;
}




