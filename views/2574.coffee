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
  map.batch (batch) ->
    map.addSource('markers', source)
    map.addLayer {
      source: 'markers'
      id: 'markers-b'
      type: 'circle'
      paint: {
        'circle-radius': 8
        'circle-color': '#DBC300'
      }
      filter: ['==', '事故内容', '軽傷事故']
    }
    map.addLayer {
      source: 'markers'
      id: 'markers-c'
      type: 'circle'
      paint: {
        'circle-radius': 8
        'circle-color': '#FF9807'
      }
      filter: ['==', '事故内容', '重傷事故']
    }
    map.addLayer {
      source: 'markers'
      id: 'markers-a'
      type: 'circle'
      paint: {
        'circle-radius': 8
        'circle-color': '#FD3E00'
      }
      filter: ['==', '事故内容', '死亡事故']
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
