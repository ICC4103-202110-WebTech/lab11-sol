class SearchController < ApplicationController
  def search
    @beers = Beer.where("name LIKE ?",
                          "%#{Beer.sanitize_sql_like(params[:q])}%")
    @brands = Brand.where("name LIKE ?",
                          "%#{Brand.sanitize_sql_like(params[:q])}%")
    @breweries = Brewery.where("name LIKE ?",
                          "%#{Brewery.sanitize_sql_like(params[:q])}%")
    render layout: "search"
  end
end
