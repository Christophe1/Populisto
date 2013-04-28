// var map_latitude = <%= @user.lat %>
// var map_longitude = <%= @user.lng %>


$(document).on("ready", function(){

	var ajax_loaded = (function(response) {				
													
		$(".page-content")

			.html($(response).filter(".page-content"));				

		$(".page-content .ajax").on("click",ajax_load);	


//////////////////////////////////////////////////////

			

		if ($("#map_canvas").length)
		{
		 	initialize_google_maps();

		  //  alert("value");
		}



	});

////////////////////////////////////////////




var form_submit = (function(e) {					
	e.preventDefault();								

	var url = $(this).attr("action");				
	var method = $(this).attr("method");			


	var data = {}									
	$(this).find("input, textarea, select").each(function(i){
		var name = $(this).attr("name");			
		var value = $(this).val();					

		data[name] =value;							
													
	});	
	
	$.ajax({										
		"url": url,									
		"type": method,								
		"data": data,								
		"success": ajax_loaded,
		"error": function () {alert("bad");}		
	});
});


var history = [];									

var current_url_method;								

var ajax_load = (function(e) {						
	e.preventDefault();								


	history.push(this);								

	var url =$(this).attr("href");					
	var method = $(this).attr("data-method");		
	
	if (current_url_method != url + method) {		
		current_url_method = url + method;			
		
		$.ajax({									
			"url": url,								
			"type": method,                         
			"success": ajax_loaded,					
		});
	 }
});

$("#menu a").on("click",ajax_load);
		
$("#menu a.main").trigger("click");
$(".search-box form").on("submit", form_submit);
// $("#t_and_c").trigger("click");


});


///////////////////////////////////////////



  var map;
  var markers = [];

  function initialize_google_maps() {
    var currentlatlng = new google.maps.LatLng(48.8, 2.12);
    var zoom = 10;
    var myOptions = {
        zoom: zoom,
        center: currentlatlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP, // ROADMAP, SATELLITE, HYBRID
        streetViewControl: false
    };
    map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

    var marker = new google.maps.Marker({map: map, position: currentlatlng, icon:{oppacity:0}});
    map.setCenter(currentlatlng);
    map.setZoom(zoom);

    var circle = new google.maps.Circle({
        map: map,
        fillOpacity: 0,
        strokeWeight: 2,
        strokeOpacity: 0.7,
        radius: 10000,
    });
    circle.bindTo('center', marker, 'position');

  }

  function show_markers() {
    if (markers)
      for(i in markers) {
        markers[i].setMap(map);
      }
  }

  function add_marker(location) {
    marker = new google.maps.Marker({
      position: location,
      map: map
    });
    markers.push(marker);
    markers.setVisible(false);
  }

// <!--   function initialize_markers() {
//     <%# (@reviews || []).each do |r| %>
//       <%# next unless r.lat && r.lng %>
//       position = new google.maps.LatLng(<%= r.lat %>, <%= r.lng %>);
//       add_marker(position);
//     <%# end %>
//   } -->

  $(function() {
    initialize_google_maps();
    show_markers();
  });
