json.extract! beer, :id, :name, :style, :hop, :yeast, :malts, :ibu, :alcohol, :blg, :created_at, :updated_at
json.url beer_url(beer, format: :json)
