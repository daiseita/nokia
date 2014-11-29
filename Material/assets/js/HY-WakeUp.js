var LastMoveTime = Date.now();
var HyWaker ;
var WakeUpTimer =300000;
$(document).mousemove(function(e){ LastMoveTime = Date.now();  });
$(document).keydown(function(e)  { LastMoveTime = Date.now();  });
$(document).mousedown(function(e){ LastMoveTime = Date.now();  });
 function setWakeUp(){
         HyWaker = setInterval(function () {
         	   var num;
         	   num = parseInt(Date.now()) - parseInt( LastMoveTime);
         	   if(num > WakeUpTimer){
         	       alert('閒置');
         	       LastMoveTime = Date.now();
         	   }
         	  
             }, WakeUpTimer);
    }
               
 //setWakeUp();