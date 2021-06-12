class Beer < ApplicationRecord
  validates :name, presence: true

  belongs_to :brand
  has_many :countries, through: :brand
  has_many :breweries, through: :brand
  has_many :reviews
  has_many :users, through: :reviews
  has_one_attached :image

  accepts_nested_attributes_for :reviews
end
