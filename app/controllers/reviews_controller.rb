class ReviewsController < ApplicationController
    def create
        @review = Review.new(review_params)
        respond_to do |format|
          if @review.save!
            @beer = Beer.find(params[:beer_id])
            if params[:redirect_beer]
                format.html { redirect_to @beer, notice: "Your review was successfully added." }
            end
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @brewery.errors, status: :unprocessable_entity }
          end
        end
    end

    private
    # Only allow a list of trusted parameters through.
    def review_params
      params.require(:review).permit(:id, :user_id, :beer_id, :text, :rating, :redirect_beer, :_destroy)
    end
end
