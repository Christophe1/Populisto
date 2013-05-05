var map_latitude = "<%= @user.lat %>";
var map_longitude = "<%= @user.lng %>";

function a_message() 
{ 
alert('I came from an external script! Ha, Ha, Ha!!!!'); 
}

$(document).on("ready", function(){
 


//////////////////////////////////////////////////////

			
//call the function at the bottom of the page and show the map
		if ($("#map_canvas").length)
		{
      
		 	initialize_google_maps();
      console.log('map canvas-your address book'); 
		  //  alert("value");
		}

    if ($("#map_canvas2").length)
    {
      
      initialize_google_maps2();
      console.log('map canvas2-reviews'); 
      //  alert("value");
    }



		// if ($("#leftGroups-google-map").length)
		// {
  //     console.log('address bar'); 
		//  	initialize_maps_address();

		// }



	});


var map;
  var markers = [];

  function initialize_google_maps() {

    console.log('map canvas again'); 
    var currentlatlng = new google.maps.LatLng(map_latitude, map_longitude);
    var zoom = 10;
    var myOptions = {
        zoom: zoom,
        center: currentlatlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP, // ROADMAP, SATELLITE, HYBRID
        streetViewControl: false
    };
    map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
    console.log(map); 

    var marker = new google.maps.Marker({map: map, position: currentlatlng, icon:{oppacity:0}});
   // map.setCenter(currentlatlng);
   // map.setZoom(zoom);
     console.log(markers); 

    var circle = new google.maps.Circle({
        map: map,
        fillOpacity: 0,
        strokeWeight: 2,
        strokeOpacity: 0.7,
        radius: 10000,
    });
    console.log("definition of circle"); 
    circle.bindTo('center', marker, 'position');
console.log("circle2");
  }

  function show_markers() {
    console.log("show markers"); 
    if (markers)
      for(i in markers) {
        markers[i].setMap(map);
      }
  }

    function add_marker(location) {
      console.log("add marker");
    marker = new google.maps.Marker({
      position: location,
      map: map
    });
    markers.push(marker);
    markers.setVisible(false);
  }



  function initialize_google_maps2() {

    // console.log('map canvas again'); 
    var currentlatlng = new google.maps.LatLng(map_latitude, map_longitude);
    var zoom = 10;
    var myOptions = {
        zoom: zoom,
        center: currentlatlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP, // ROADMAP, SATELLITE, HYBRID
        streetViewControl: false
    };
    map = new google.maps.Map(document.getElementById("map_canvas2"), myOptions);
    // console.log("definition of map"); 

    var marker = new google.maps.Marker({map: map, position: currentlatlng, icon:{oppacity:0}});
   // map.setCenter(currentlatlng);
   // map.setZoom(zoom);
     // console.log("definition of marker"); 

    var circle = new google.maps.Circle({
        map: map,
        fillOpacity: 0,
        strokeWeight: 2,
        strokeOpacity: 0.7,
        radius: 10000,
    });
    // console.log("definition of circle"); 
    circle.bindTo('center', marker, 'position');
// console.log("circle2");
  }