#include ApplicationHelper

class PagesController < ApplicationController
  def home
    @beers = Beer.all.includes(:brand).sample(10)
    @watch_list = Beer.find(helpers.beers_watchlist_beer_ids)
  end
end
