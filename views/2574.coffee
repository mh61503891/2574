mapboxgl.accessToken = "#{mapbox_access_token}"

position = new mapboxgl.LngLat(133.842941, 35.375086).wrap()

map = new mapboxgl.Map {
  container: 'map'
  style: 'mapbox://styles/mapbox/streets-v8'
  center: position.toArray()
  zoom: 8
}

source = new mapboxgl.GeoJSONSource {data: 'data.geojson'}

map.on 'style.load', ->
  map.addSource('markers', source)
  map.addLayer {
    id: 'markers'
    type: 'symbol'
    source: 'markers'
    layout: {
      'icon-image': '{marker-symbol}-15'
      'icon-optional': true
    }
    paint: {
      'icon-color': '#0000FF'
    }
  }

@locate = ->
  if navigator.geolocation
    navigator.geolocation.getCurrentPosition (position) ->
      lng = position.coords.longitude
      lat = position.coords.latitude
      lnglat = new mapboxgl.LngLat(lng, lat).wrap()
      map.flyTo {
        center: lnglat.toArray()
        zoom: 14
      }
