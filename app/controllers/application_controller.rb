class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :set_brands
  before_action :set_user
  
  private
  def set_user
    @user = User.first
  end

  def set_brands
    @top_brands = Brand.all.limit(10)
  end
end
