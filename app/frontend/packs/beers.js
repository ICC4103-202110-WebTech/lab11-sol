export const cmpFnAlcVol = ({dataset : { beerAlcvol : a }}, {dataset : { beerAlcvol : b }}) => b.localeCompare(a);
export const cmpFnBeerName = ({dataset : { beerName : a }}, {dataset : { beerName : b }}) => a.localeCompare(b);

export const registerClickHandlerForSortButton = (btn, dataAtt, compareFn) => {
    btn.addEventListener('click', ev => {
        Array.from(document.querySelectorAll(`div.beer-container > div[data-${dataAtt}]`))
            .sort(compareFn)
            .forEach((item) => item.parentNode.appendChild(item));
    });
}

export const initSortButtons = () => {
    let beer_lst = document.querySelector('div.beer-container');
    if (beer_lst) {
        document.querySelectorAll(".btn-sort-alcvol").forEach((element) => {
            registerClickHandlerForSortButton(
                element, 'beer-alcvol', cmpFnAlcVol);
        });
        document.querySelectorAll(".btn-sort-name").forEach((element) => {
            registerClickHandlerForSortButton(
                element, 'beer-name', cmpFnBeerName);
        });
    }
}

(() => {
    // Click handlers are registered for the event sort buttons
    document.addEventListener("turbolinks:load", (ev) => {
        initSortButtons();
    });
})();
