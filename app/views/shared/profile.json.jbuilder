json.fields @profile do |p|
  json.name               p.name
  json.data_type          p.data_type
  json.optional           p.optional
  json.access             p.access
  json.description        p.description
  json.format             p.format
  json.format_description p.format_description
  json.length_hint        p.length_hint
  json.value              p.value
end
