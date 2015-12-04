require 'open-uri'
require 'csv'
require 'json'
require 'nkf'

def csv_to_geojson(texts)
  marker_colors = {
    '死亡事故' => '#FD7400',
    '軽傷事故' => '#BEDB39',
    '重傷事故' => '#004358'
  }
  map = {}
  map['type'] = 'FeatureCollection'
  map['features'] = []
  texts.each.with_index(1) do |text, text_index|
    CSV.new(NKF.nkf('-S --cp932 -w -Lu', text), headers:true).each.with_index do |row, row_index|
      next if row['名称'] !~ /全事故/
      next if row['当事者種別'] !~ /自転車/
      feature = {
        id: text_index * row_index,
        type: 'Feature',
        geometry: {
          type: 'Point',
          coordinates: [row['地点経度'].to_f, row['地点緯度'].to_f]
        },
        properties: row.to_h.merge({
          'marker-symbol': 'marker',
          'marker-color': marker_colors[row['事故内容']]
        })
      }
      map['features'] << feature
    end
  end
  return JSON.pretty_generate(map)
end


task :default do
  puts 'ok'
end

namespace :data do
  task :test do
    texts = [24, 25, 26].map{ |year|
      'http://db.pref.tottori.jp/opendataResearch.nsf/' \
       'e92cd7f95a94c9c249257c92000236b8/' \
       '5c2a1f59ec27a81a49257d630016cf34/$FILE/' \
       '%E4%BA%A4%E9%80%9A%E4%BA%8B%E6%95%85-(%E5%B9%B3%E6%88%90' \
        "#{year}" \
        '%E5%B9%B4).csv'
    }.map{ |url|
      open(url){ |io|io.read }
    }
    x = csv_to_geojson(texts)
    open('asserts/data.geojson', 'w'){|io| io.write(x)}
  end
end
