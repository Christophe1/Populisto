
var map;
var markers = [];

function initialize_google_maps() {

    var user_longitude = $("#user-position").attr("data-lng");
    var user_latitude = $("#user-position").attr("data-lat");

    var currentlatlng = new google.maps.LatLng(user_latitude, user_longitude);



    var zoom = 10;
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
      // and remove comments on the 3 lines after it.
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