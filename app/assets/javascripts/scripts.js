

var map_latitude = "<%= @user.lat %>";
var map_longitude = "<%= @user.lng %>";
// var xyz = "monkey";

// $(window).load(function() {



$(document).on("ready", function(){

 console.log('load ajax when document starts'); 
  var ajax_loaded = (function(response) {        

    $(".page-content")

     .html($(response).filter(".page-content"));       

    $(".page-content .ajax").on("click",ajax_load);  

  
    // if ($("#map_canvas").length > 0)
    // {
      
    //   initialize_google_maps();
    //   console.log('map canvas-your address book on load'); 
    //   //  alert("value");
    // }

    // if ($("#map_canvas2").length > 0 )
    // {
    //   console.log('map canvas2-reviews on load'); 
    //   initialize_google_maps2();
      
    //   //  alert("value");
    // }



    // if ($("#leftGroups-google-map").length > 0)
    // {
    //   console.log('address bar'); 
    //    initialize_maps_address();

    // }


   });



////////////////////////////////////////////


//use the ajax function below for submitting forms



// var form_submit = (function(e) {
//   console.log('form_submit');         
//   e.preventDefault();               

//   var url = $(this).attr("action");       
//   var method = $(this).attr("method");      


//   var data = {}                 
//   $(this).find("input, textarea, select").each(function(i){
//     var name = $(this).attr("name");      
//     var value = $(this).val();          

//     data[name] =value;              
                          
//   }); 
  
//   $.ajax({                    
//     "url": url,                 
//     "type": method,      
//     "async": false,            
//     "data": data,               
//     "success": ajax_loaded,
//     "error": function () {alert("bad");}    
//   });


//     if ($("#map_canvas2").length > 0)
//     {
//       console.log('map canvas2-reviews from click'); 
//   initialize_google_maps2();
      
//     //   //  alert("value");
//     }


// });



//the function below is called by links that are described with the class 'ajax', or are in the div 'menu' 

var history = [];                 

var current_url_method;               

var ajax_load = (function(e) {  


console.log('load ajax on clicks');         
  e.preventDefault();               


  history.push(this);               
  var url =$(this).attr("href");          
  var method = $(this).attr("data-method");   

  if (current_url_method != url + method) {   
    console.log('url + method'); 
    current_url_method = url + method;      

$.ajax({                  
  url: url,               
  type: method,  
  async: false,                       
  success: ajax_loaded       
});
   }

    if ($("#map_canvas").length > 0)
    {
      console.log('ajax 2 - map_canvas is detected'); 
      initialize_google_maps();

    }


});



$("#menu a").on("click",ajax_load);
$(".ajax").on("click",ajax_load);
$("#menu a.main").trigger("click");
// $(".search-box form").on("submit", form_submit);

});















  var map;
  var markers = [];

  function initialize_google_maps() {

    console.log('initialized google maps'); 
    var currentlatlng = new google.maps.LatLng(map_latitude, map_longitude);
    var zoom = 10;
    var myOptions = {
        zoom: zoom,
        center: currentlatlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP, // ROADMAP, SATELLITE, HYBRID
        streetViewControl: false
    };
    map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
    // console.log(map); 

    var marker = new google.maps.Marker({map: map, position: currentlatlng, icon:{oppacity:0}});
   // map.setCenter(currentlatlng);
   // map.setZoom(zoom);
     // console.log(markers); 

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




///////////////////////////////////



function initialize_google_maps2() {

     console.log('google maps 2 initialized'); 
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
    console.log('end of initialize google 2 function')
// console.log("circle2");

// stop, and don't do anything else! no more loads of anything - until another button is clicked, or action called from
//somewhere else
// $.ajaxStop(function() {
//   return;
  // $(this).text( "Triggered ajaxStop handler." );
};
  

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


  // function show_markers() {
  //   // console.log("show markers"); 
  //   if (markers)
  //     for(i in markers) {
  //       markers[i].setMap(map);
  //     }
  // }

  //   function add_marker(location) {
  //     // console.log("add marker");
  //   marker = new google.maps.Marker({
  //     position: location,
  //     map: map
  //   });
  //   markers.push(marker);
  //   markers.setVisible(false);
  // }



// <!--   function initialize_markers() {
//     <%# (@reviews || []).each do |r| %>
//       <%# next unless r.lat && r.lng %>
//       position = new google.maps.LatLng(<%= r.lat %>, <%= r.lng %>);
//       add_marker(position);
//     <%# end %>
//   } -->

  $(function() {
    //this needs to be here because I get an error on homepage, 
    //if user tries to log in without being signed in to Facebook
    console.log('if map_canvas detected, load initialize maps'); 

        if ($("#map_canvas").length > 0)
    {
      console.log('map canvas detected'); 
      initialize_google_maps();
      
    }

  });

//     $(function() {
//     console.log('maps and markers2'); 
// // console.log('google maps'); 
//     initialize_google_maps2();
//     // show_markers();
//   });


  //////////////////////////////////////////////////////


  

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

    // $(function() {
    //   // console.log('maps'); 
    //     initialize_maps_address();
    //   });