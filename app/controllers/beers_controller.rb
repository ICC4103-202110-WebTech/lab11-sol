#include ApplicationHelper

class BeersController < ApplicationController
  before_action :set_beer, only: %i[ show edit update destroy ]

  # GET /beers or /beers.json
  def index
    if params.has_key?(:brand_id)
      @brand = Brand.find(params[:brand_id])
      @pagy, @beers = pagy(Beer.where(brand_id: params[:brand_id]))
    else
      @pagy, @beers = pagy(Beer.all)
    end
  end

  # GET /beers/1 or /beers/1.json
  def show
    helpers.beers_update_watchlist(params[:id])
    @reviews = Review.where(beer: Beer.find(params[:id]))
  end

  def purge_wl
    session[:watch_list] = "{}"
    respond_to do |format|
      flash[:notice] = "Beers watch list purged!"
      format.html { redirect_to root_path }
    end
  end

  # GET /beers/new
  def new
    @beer = Beer.new
    @beer.reviews.build
  end

  # GET /beers/1/edit
  def edit
  end

  # POST /beers or /beers.json
  def create
    @beer = Beer.new(beer_params)
    @beer.image.attach(params[:image])

    respond_to do |format|
      if @beer.save
        format.html { redirect_to @beer, notice: "Beer was successfully created." }
        format.json { render :show, status: :created, location: @beer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /beers/1 or /beers/1.json
  def update
    respond_to do |format|
      if @beer.update(beer_params)
        format.html { redirect_to @beer, notice: "Beer was successfully updated." }
        format.json { render :show, status: :ok, location: @beer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beers/1 or /beers/1.json
  def destroy
    @beer.destroy
    respond_to do |format|
      format.html { redirect_to beers_url, notice: "Beer was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_beer
      @beer = Beer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def beer_params
      params.require(:beer).permit(
        :name, :brand_id, :style, :hop, :yeast, :malts, :ibu, :alcohol, :blg, :image,
        { reviews_attributes: [:id, :text, :rating, :user_id ] })
    end
end
