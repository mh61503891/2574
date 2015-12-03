mapboxgl.accessToken = 'pk.eyJ1IjoibWg2MTUwMzg5MSIsImEiOiJjaWhxbTJjOGMwNGt4dHBtMjczbzhieXZkIn0.J8-B8U-8nCtqiZ2CfxbV0g';
var position = new mapboxgl.LngLat(133.842941, 35.375086).wrap();
var map = new mapboxgl.Map({
  container: 'map',
  style: 'mapbox://styles/mapbox/streets-v8',
  center: [position.lng, position.lat],
  zoom: 8
});

var sourceObj = new mapboxgl.GeoJSONSource({
  data: 'data/all.geojson'
});

map.on('style.load', function() {
  map.addSource("markers", sourceObj);
  map.addLayer({
    "id": "markers",
    "type": "symbol",
    "source": "markers",
    "layout": {
      "icon-image": "{marker-symbol}-15",
      'icon-optional': true
    },
    "paint": {
      'icon-color': '#0000FF'
    }
  });
});


function locate() {
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) {
      lng = position.coords.longitude;
      lat = position.coords.latitude;
      var lnglat = new mapboxgl.LngLat(lng, lat).wrap();
      map.flyTo({
        center: [lnglat.lng, lnglat.lat],
        zoom: 15
      });
    });
  }
};
