
//I want to load content into the '.page-content' class, with ajax


//console.log('load ajax when document starts. This always works.');
var ajax_loaded = (function(response) {

  $(".page-content")

  .html($(response).filter(".page-content"));

  $(".page-content .ajax").on("click",ajax_load);



// on the 'Your Address Book page' and the 'Search' page,
// look for the div, map canvas. If it is there, call the maps function

if ($("#map_canvas").length > 0)
{
  // console.log('ajax 2 - map_canvas is detected');
  initialize_google_maps();

}


//on the 'Pop Something in Page', call the required functions
if ($(".leftGroups").length > 0)
{
      //start 'google maps address bar'.
      // console.log('address bar');
       initialize_maps_address();

       //start 'chosen', selection box.
      // console.log('chosen');
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
  "error": function () {alert("You are not logged in.");}
});


});

//the function below is called by links that are described
//with the class 'ajax', or are in the div 'menu'

var history = [];

// var current_url_method;

var ajax_load = (function(e) {


  //console.log('load ajax on clicks. This always works.');
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

$(document).on("ready", function(){
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
    var user_longitude = $("#user-position").attr("data-lng");
    var user_latitude = $("#user-position").attr("data-lat");

    var currentlatlng = new google.maps.LatLng(user_latitude, user_longitude);



    var zoom = 9;
    var myOptions = {
      zoom: zoom,
      center: currentlatlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP, // ROADMAP, SATELLITE, HYBRID
        streetViewControl: false,
        minZoom: 1,
        // don't want people to be able to hone in on others' addresses too specifically.
        maxZoom: 13
      };


      map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

      // if you don't want a marker, uncomment the line of code below,
      // and comment out the 3 lines after it.
// to make the markers invisible, set oppacity to zero
      var marker = new google.maps.Marker({map: map, position: currentlatlng, icon:{oppacity:0}});
    //    var marker = new google.maps.Marker({map: map, position: currentlatlng});
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

// function show_markers() {
//   // console.log("show markers");
//   if (markers)
//     for(i in markers) {
//       markers[i].setMap(map);
//     }
//   }

  // function add_marker(location) {
  //   // console.log("add marker");
  //   marker = new google.maps.Marker({
  //     position: location,
  //     map: map
  //   });
  //   markers.push(marker);
  //   markers.setVisible(true);
  // }



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

