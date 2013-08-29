//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require chosen.jquery
//= require gmaps4rails/gmaps4rails.base
//= require gmaps4rails/gmaps4rails.bing
//= require gmaps4rails/gmaps4rails.googlemaps
//= require gmaps4rails/gmaps4rails.mapquest
//= require gmaps4rails/gmaps4rails.openlayers

$(function() {
    $("select.chosen").each(function () {
        $(this).attr('data-placeholder', $(this).attr('placeholder'));
    }).chosen();

    $('a.back').click(function(){
        parent.history.back();
        return false;
    });
});

