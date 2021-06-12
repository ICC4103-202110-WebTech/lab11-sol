json.extract! user, :id, :first_name, :last_name, :email, :created_at, :updated_at
unless user.address.nil?
  json.address do 
    json.extract! user.address, :id, :line1, :line2, :city 
    json.country user.address.country, :id, :name
  end
end
json.reviews user.reviews, :id, :text, :rating, :beer_id
