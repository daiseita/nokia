
function TodoCrtl($scope) {  
	$scope.name = "Anna";  
	$scope.tel = "12345678";  
  $scope.newItem = "";  
  $scope.todoList = [{ label: "買牛奶" }, { label: "繳電話費" }];  
  $scope.addItem = function() {  
       if(this.newItem) {  
           this.todoList.push({label:this.newItem});  
           this.newItem = "";  
       }
   
  }
  $scope.ttt = function() {  
  
         alert(123);
        ajaxTagFunction("model/index.ashx", "Main", 1, 0);
      }       
}  

