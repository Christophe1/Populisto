

    Jennifer Collins: 53.3926005 -6.1272155
    Christophe Harris: 53.3918838 -6.1282583

    Richard
      user_latitude="53.3431365";
  user_longitude="-6.2619567";

Christophe
   user_latitude="53.3431365";
  user_longitude="-6.2619567";

  var map;
  var markers = [];

  function initialize_google_maps() {
    var currentlatlng = new google.maps.LatLng(48.8, 2.12);
    var zoom = 9;
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
        radius: 9000,
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
    // markers.setVisible(false);
  }

<!--   function initialize_markers() {
    <%# (@reviews || []).each do |r| %>
      <%# next unless r.lat && r.lng %>
      position = new google.maps.LatLng(<%= r.lat %>, <%= r.lng %>);
      add_marker(position);
    <%# end %>
  } -->

  $(function() {
    initialize_google_maps();
    initialize_markers();
    show_markers();
  });

//   google.maps.event.trigger(map, 'resize');
// });








/////////////////////////////////////////////////////////






<script type="text/javascript">

// $(document).ready(function(){

//$(document).on("redraw_map", function(){

  var map;
  var markers = [];

  function initialize_google_maps() {
    var currentlatlng = new google.maps.LatLng(<%= @user.lat %>, <%= @user.lng %>);
    var zoom = <%= @kms_range %> > 9 ? 9 : 10;
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
        radius: <%= @kms_range %>*1000,
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
    // markers.setVisible(false);
  }

  function initialize_markers() {
    <% (@reviews || []).each do |r| %>
      <% next unless r.lat && r.lng %>
      position = new google.maps.LatLng(<%= r.lat %>, <%= r.lng %>);
      add_marker(position);
    <% end %>
  }

  $(function() {
    initialize_google_maps();
    initialize_markers();
    show_markers();
  });

//   google.maps.event.trigger(map, 'resize');
// });







<script type="text/javascript">

    // $('.review-comments-example').live('click', function(e) {
    //     $.modal('<div class="perfect-review-example"><%= I18n.t('write_review.perfect_example') %></div>', {closeHTML : '<a id="popup_close" href="#"><%= I18n.t('write_review.close_popup_text') %></a>', overlayClose : true})
    // });

    function initialize_google_maps() {
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
        initialize_google_maps();
    });

</script>







//////
//////
//////


// <div id="foo" data-lat="<%= @user.lat %>">Books are coming soon!</div>
// var map_latitude = $("#foo").data("lat");
// <div id="foo2" data-lng="<%= @user.lng %>">Books are coming soon!</div>
// var map_longitude = $("#foo2").data("lng");

// var map_latitude = "<%= @user.lat %>";
// var map_longitude = "<%= @user.lng %>";
// var xyz = "monkey";

// $(window).load(function() {



  $(document).on("ready", function(){

//I want to load content into the '.page-content' class, with ajax

console.log('load ajax when document starts. This always works.'); 
var ajax_loaded = (function(response) {        

  $(".page-content")

  .html($(response).filter(".page-content"));       

  $(".page-content .ajax").on("click",ajax_load); 



// on the 'Your Address Book page', call the function to show the map
if ($("#map_canvas").length > 0)
{
  console.log('ajax 2 - map_canvas is detected'); 
  initialize_google_maps();

}



//on the 'Search Results Page', call the function to show the map
if ($("#map_canvas2").length > 0)
{
  console.log('map canvas2-reviews from click'); 
  initialize_google_maps2();

} 


//on the 'Pop Something in Page', call the required functions
if ($(".leftGroups").length > 0)
{
      //start 'google maps address bar'. A work around because rails doesn't
       //render it directly, from reviews/index
       console.log('address bar'); 
       initialize_maps_address();

       //start 'chosen', selection box. A work around because rails doesn't
       //render it directly, from reviews/index
       console.log('chosen'); 
       initialize_chosen();

     }




   });

//use the ajax function below for submitting forms

var form_submit = (function(e) {
  console.log('form_submit is working. This always works.');         
  e.preventDefault();               

  var url = $(this).attr("action");       
  var method = $(this).attr("method");      


  var data = {}                 
  $(this).find("input, textarea, select").each(function(i){
    var name = $(this).attr("name");      
    var value = $(this).val();          

    data[name] =value;              

  }); 
//call the ajax_loaded function
$.ajax({                    
  "url": url,                 
  "type": method,                
  "data": data,               
  "success": ajax_loaded,
 // function{$('html, body').animate({ scrollTop: 0 }, 0);}
  "error": function () {alert("bad");}    
});






});

//the function below is called by links that are described 
//with the class 'ajax', or are in the div 'menu' 

var history = [];                 

var current_url_method;               

var ajax_load = (function(e) {  


  console.log('load ajax on clicks. This always works.');         
  e.preventDefault();               


  history.push(this);               
  var url =$(this).attr("href");          
  var method = $(this).attr("data-method");   

  // if (current_url_method != url + method) {   
  //   console.log('You got to the url + method part. But sometimes I dont get this far.'); 
  //   current_url_method = url + method;      

  $.ajax({                  
    url: url,               
    type: method,  
    // async: false,                       
    success: ajax_loaded
    // $('html, body').animate({ scrollTop: 0 }, 0);       
  });
   // }

 });


//monitor for clicks from menu div, or with
//the ajax class, or the 'submit button'.
//why the trigger?

$("#menu a").on("click",ajax_load);
$(".ajax").on("click",ajax_load);
$("#menu a.main").trigger("click");
$(".search-box form").on("submit", form_submit);


});



//////////////////////////////////////////////////////



//Functions below



/////////////////////////////////////////////////////


$(function() {
    // this needs to be here because when user first enters Populisto!
    // no links have been clicked, ajax isn't triggered, so we get a blank
    // map page. 

    if ($("#map_canvas").length > 0)
    {
      // console.log('map canvas detected'); 
      initialize_google_maps();
      
    }

  });



var map;
var markers = [];




function initialize_google_maps() {

  console.log('initialized google maps'); 
    // console.log("#lat2"); 
    // console.log(lng2); 
    var currentlatlng = new google.maps.LatLng(user_latitude, user_longitude);
    // var currentlatlng = new google.maps.LatLng(<%#=raw @user.lat %>, <%#=raw @user.lat %>);
    // var currentlatlng = new google.maps.LatLng(53.404, -6.136);
    var zoom = 10;
    var myOptions = {
      zoom: zoom,
      center: currentlatlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP, // ROADMAP, SATELLITE, HYBRID
        streetViewControl: false
      };
      map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

      var marker = new google.maps.Marker({map: map, position: currentlatlng, icon:{oppacity:0}});

      var circle = new google.maps.Circle({
        map: map,
        fillOpacity: 0,
        strokeWeight: 2,
        strokeOpacity: 0.7,
        radius: 10000,
      });
      circle.bindTo('center', marker, 'position');
    }




    function initialize_google_maps2() {

     console.log('google maps 2 initialized'); 
     var currentlatlng = new google.maps.LatLng(53.404, -6.136);
     var zoom = 10;
     var myOptions = {
      zoom: zoom,
      center: currentlatlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP, // ROADMAP, SATELLITE, HYBRID
        streetViewControl: false
      };
      map = new google.maps.Map(document.getElementById("map_canvas2"), myOptions);

      var marker = new google.maps.Marker({map: map, position: currentlatlng, icon:{oppacity:0}}); 

      var circle = new google.maps.Circle({
        map: map,
        fillOpacity: 0,
        strokeWeight: 2,
        strokeOpacity: 0.7,
        radius: 10000,
      });

      circle.bindTo('center', marker, 'position');
      console.log('end of initialize google 2 function')

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



    // $('.review-comments-example').live('click', function(e) {
    //     $.modal('<div class="perfect-review-example"><%= I18n.t('write_review.perfect_example') %></div>', {closeHTML : '<a id="popup_close" href="#"><%= I18n.t('write_review.close_popup_text') %></a>', overlayClose : true})
    // });

function initialize_maps_address() {
  var input = document.getElementById('review_address');
  var options = { types: ['geocode'] };

  autocomplete = new google.maps.places.Autocomplete(input, options);

  google.maps.event.addListener(autocomplete, 'place_changed', function() {
    var place = autocomplete.getPlace();
    $('#review_lat').val(place.geometry.location.lat());
    $('#review_lng').val(place.geometry.location.lng());
  });

}

function initialize_chosen() {
  $("select.chosen").each(function () {
    $(this).attr('data-placeholder', $(this).attr('placeholder'));
  }).chosen();

  $('a.back').click(function(){
    parent.history.back();
    return false;
  });
}




