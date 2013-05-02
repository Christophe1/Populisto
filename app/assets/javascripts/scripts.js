




var map_latitude = "<%= @user.lat %>";
var map_longitude = "<%= @user.lng %>";
// var xyz = "monkey";


$(document).on("ready", function(){
 console.log('load ajax'); 
	var ajax_loaded = (function(response) {				
													
		$(".page-content")

			.html($(response).filter(".page-content"));				

		$(".page-content .ajax").on("click",ajax_load);	


//////////////////////////////////////////////////////

			
//call the function at the bottom of the page and show the map
		if ($("#map_canvas").length)
		{
      console.log('map canvas'); 
		 	initialize_google_maps();

		  //  alert("value");
		}

        if ($("#map_canvas22").length)
    {
      console.log('map canvas22'); 
      initialize_google_maps2();

      //  alert("value");
    }


		if ($("#leftGroups-google-map").length)
		{
      console.log('address bar'); 
		 	initialize_maps_address();

		}



	});

////////////////////////////////////////////




var form_submit = (function(e) {
  console.log('form_submit');					
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
console.log('load ajax2'); 				
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
$(".ajax").on("click",ajax_load);
		
$("#menu a.main").trigger("click");
$(".search-box form").on("submit", form_submit);
// $("#t_and_c").trigger("click");


});


///////////////////////////////////////////



  var map;
  var markers = [];

  function initialize_google_maps() {
    var currentlatlng = new google.maps.LatLng(map_latitude, map_longitude);
    var zoom = 10;
    var myOptions = {
        zoom: zoom,
        center: currentlatlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP, // ROADMAP, SATELLITE, HYBRID
        streetViewControl: false
    };
    map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

    var marker = new google.maps.Marker({map: map, position: currentlatlng, icon:{oppacity:0}});
   // map.setCenter(currentlatlng);
   // map.setZoom(zoom);

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
    console.log('maps and markers'); 
// console.log('google maps'); 
    initialize_google_maps();
    show_markers();
  });


  //////////////////////////////////////////////////////


  function initialize_google_maps2() {
    var currentlatlng = new google.maps.LatLng(map_latitude, map_longitude);
    var zoom = 10;
    var myOptions = {
        zoom: zoom,
        center: currentlatlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP, // ROADMAP, SATELLITE, HYBRID
        streetViewControl: false
    };
    map = new google.maps.Map(document.getElementById("map_canvas22"), myOptions);

    var marker = new google.maps.Marker({map: map, position: currentlatlng, icon:{oppacity:0}});
   // map.setCenter(currentlatlng);
   // map.setZoom(zoom);

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
    console.log('maps and markers'); 
// console.log('google maps'); 
    initialize_google_maps();
    show_markers();
  });

  //////////////////////////////////////



    // $('.review-comments-example').live('click', function(e) {
    //     $.modal('<div class="perfect-review-example"><%= I18n.t('write_review.perfect_example') %></div>', {closeHTML : '<a id="popup_close" href="#"><%= I18n.t('write_review.close_popup_text') %></a>', overlayClose : true})
    // });

    function initialize_maps_address() {
      // console.log('map address'); 
      var input = document.getElementById('review_address');
      var options = { types: ['geocode'] };

      autocomplete = new google.maps.places.Autocomplete(input, options);

      google.maps.event.addListener(autocomplete, 'place_changed', function() {
        var place = autocomplete.getPlace();
        $('#review_lat').val(place.geometry.location.lat());
        $('#review_lng').val(place.geometry.location.lng());
      });

    }

    $(function() {
      // console.log('maps'); 
        initialize_maps_address();
      });


