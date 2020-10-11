var today = new Date();
      
      var year = today.getFullYear();
      var month = today.getMonth() + 1;
      var date = today.getDate();
      
      document.getElementById("date").innerHTML = year + "/" + month + "/" + date;
      

      function time(){
        var now = new Date();
        document.getElementById("time").innerHTML = now.toLocaleTimeString();
      }

      time();
      
      timerID = setInterval('time()',1000);