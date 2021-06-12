(()=>{
    let btn = document.querySelector("#add_review_btn")
    if (btn) {
        btn.addEventListener("click", (ev) => {
            let beerReviewPath = btn.closest("div.review-placeholder").dataset.beerReviewPath;
            let beerId = btn.closest("div.review-placeholder").dataset.beerId;
            let div = btn.closest("div");
            let csrf = document.querySelector('meta[name="csrf-token"]').content;
            div.insertAdjacentHTML('afterbegin', `
            <div class="col-6 mt-2 mb-2">
                <p>Write a review for this beer:</p>
                <form action="${beerReviewPath}" method="post" class="form">
                    <input type="hidden" name="authenticity_token" value="${csrf}">
                    <input type="hidden" name="review[user_id]" value="1">
                    <input type="hidden" name="review[beer_id]" value="${beerId}">
                    <input type="hidden" name="redirect_beer" value="true">
                    <div class="form-group">
                        <label for="review[text]">Text</label>
                        <textarea name="review[text]" required="required" autofocus class="form-control"></textarea>
                    </div>
                    <div class="form-group mt-2">
                        <label for="review[rating]">Rating</label>
                        <input type="number" required="required" name="review[rating]" min="1" max="5" step=".5">
                    </div>
                    <div class="form-group">
                        <input type="submit" value="Submit Review" class="mt-2 btn btn-primary mb-2">
                    </div>
                </form>
            </div>
            <div class="col"></div>`);
            ev.stopPropagation();
            ev.target.remove();
        });
    }
})();
