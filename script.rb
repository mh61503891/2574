#!/usr/bin/env ruby
require 'nkf'
require 'csv'
require 'json'
require 'pry'

marker_colors = {
  '死亡事故' => '#FD7400',
  '軽傷事故' => '#BEDB39',
  '重傷事故' => '#004358'
}

map = {}
map['type'] = 'FeatureCollection'
map['features'] = []
Dir.glob('data/*.csv').each.with_index(1) do |path, path_index|
  txt = NKF.nkf('-S --cp932 -w -Lu', File.read(path))
  CSV.new(txt, headers:true).each.with_index do |row, row_index|
    next if row['名称'] !~ /全事故/
    next if row['当事者種別'] !~ /自転車/
    feature = {
      id: path_index * row_index,
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
puts JSON.pretty_generate(map)



  # binding.pry



# marker_colors = {
#   '死亡事故' => '#FD7400',
#   '軽傷事故' => '#BEDB39',
#   '重傷事故' => '#004358'
# }
#
