//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require_self
//= require_tree .

jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")} 
})


    	
function showMap(start,end) {
    var directionDisplay;
    directionsDisplay = new google.maps.DirectionsRenderer();
    var directionsService = new google.maps.DirectionsService();
    var map;
   
    var chicago = new google.maps.LatLng(41.850033, -87.6500523);
    var myOptions = {
      zoom:7,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      center: chicago
    }
    map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

//var start = "53718";
//var end = "53719";
    var request = {
      origin: start, 
      destination: end,		
      travelMode: google.maps.DirectionsTravelMode.DRIVING
    };
    directionsService.route(request, function(response, status) {
      if (status == google.maps.DirectionsStatus.OK) {
        directionsDisplay.setDirections(response);
      }
    });
	directionsDisplay.setMap(map);
  }
   
  function showTraffic(){
  	var myLatlng = new google.maps.LatLng(34.04924594193164, -118.24104309082031);
  	var myOptions = {
    	zoom: 13,
    	center: myLatlng,
    	mapTypeId: google.maps.MapTypeId.ROADMAP
  }

  	var map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

 	var trafficLayer = new google.maps.TrafficLayer();
  	trafficLayer.setMap(map);
  	
  }   
  
  

