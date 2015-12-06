mapboxgl.accessToken = "#{mapbox_access_token}"
dishoge = 0.25

source = new mapboxgl.GeoJSONSource {
  data: {type: 'FeatureCollection', features: []}
}
centerPointSource = new mapboxgl.GeoJSONSource {
  data: {type: 'FeatureCollection', features: []}
}
data = {}

xhr = new XMLHttpRequest()
xhr.open('GET', encodeURI('data.geojson'))
xhr.onload = ->
  if xhr.status == 200
    data = JSON.parse(xhr.responseText)
    source.setData(data)
xhr.send()

position = new mapboxgl.LngLat(133.842941, 35.375086).wrap()

map = new mapboxgl.Map {
  container: 'map'
  style: 'mapbox://styles/mapbox/streets-v8'
  center: position.toArray()
  zoom: 8
}


ion.sound {
  sounds: [{name: 'voice'} ]
  volume: 0.5
  path: "/"
  preload: true
}

if not /iPhone|iPad|iPod|Android/.test(navigator.userAgent)
  map.addControl(new mapboxgl.Navigation())

map.on 'move', ->
  center = turf.point(map.getCenter().toArray())
  buf = turf.buffer(center, dishoge, 'kilometers')
  count = turf.count(buf, data, 'pt_count')
  centerPointSource.setData(buf)

map.on 'style.load', ->
  map.batch (batch) ->
    map.addSource('markers', source)
    map.addSource('ccc', centerPointSource)
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
    map.addLayer {
      source: 'ccc'
      id: 'ccc-1'
      type: 'fill'
      paint: {
        'circle-radius': 8
        'fill-color': 'blue'
        'fill-opacity': 0.25
      }
    }


@test = ->
  center = turf.point(map.getCenter().toArray())
  console.log 'center', center
  buf = turf.buffer(center, 0.5, 'kilometers')
  count = turf.count(buf, data, 'pt_count')
  console.log 'buf', buf
  centerPointSource.setData(buf)
  console.log count.features[0].properties.pt_count


paintCenter = (buffer) ->
  centerPointSource.setData(buffer)
@check = ->
  center = turf.point(map.getCenter().toArray())
  buffer = turf.buffer(center, dishoge, 'kilometers')
  count = turf.count(buffer, data, 'pt_count').features[0].properties.pt_count
  paintCenter(buffer)
  if count > 0
    ion.sound.play('voice')

# マップの中心を現在地にする
@locate = ->
  return if not navigator.geolocation
  navigator.geolocation.getCurrentPosition (position) ->
    coords = [position.coords.longitude, position.coords.latitude]
    target = new mapboxgl.LngLat.convert(coords).wrap().toArray()
    map.flyTo {
      center: target
      zoom: 14
    }

naviEaseLocate = ->
  return if not navigator.geolocation
  navigator.geolocation.getCurrentPosition (position) ->
    btn = document.getElementById('navi-button')
    btn.innerHTML = 'ナビ:ON'
    coords = [position.coords.longitude, position.coords.latitude]
    target = new mapboxgl.LngLat.convert(coords).wrap().toArray()
    map.easeTo {
      center: target
      zoom: 14
    }

# ナビ
say = true
@naviCheck = ->
  center = turf.point(map.getCenter().toArray())
  buffer = turf.buffer(center, dishoge, 'kilometers')
  count = turf.count(buffer, data, 'pt_count').features[0].properties.pt_count
  paintCenter(buffer)
  naviEaseLocate()
  if count > 0
    if say
      ion.sound.play('voice')
      say = false
  else
    say = true

isNaviMode = false
naviFuncId = null
naviId = null
naviFunc = ->
  @naviCheck()

@navi = ->
  if isNaviMode
    btn = document.getElementById('navi-button')
    btn.innerHTML = 'ナビ:OFF'
    btn.style.background = '#ee8a65'
    window.clearInterval(naviFuncId)
  else
    btn = document.getElementById('navi-button')
    btn.innerHTML = '現在地取得中'
    btn.style.background = '#1F8A70'
    naviFuncId = window.setInterval(naviFunc, 3000)
    isNaviMode = true
