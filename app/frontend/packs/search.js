import { initSortButtons } from './beers.js'

(() => {
    document.addEventListener("turbolinks:load", () => {
        let searchbox = document.querySelector("#search_box");
        let searchbtn = document.querySelector("#search_button");
        let main = document.querySelector("main");

        searchbox.addEventListener("input", (ev) => {
            if (!ev.target.value.length) {
                main.style.display  = "block";
                let search_results = document.querySelector("#search_results");
                try {
                  search_results.remove();
                }
                catch(e) { } 
            }
        })

        searchbtn.addEventListener("click", (ev) => {
            ev.preventDefault();

            main.style.display = "none";

            const token = document.getElementsByName(
                "csrf-token"
            )[0].content;

            let prev_main_search = document.querySelector("#search_results");
            if (prev_main_search) {
                prev_main_search.remove();
            }

            let keywords = document.querySelector("#search_box").value;
            fetch(`/search?q=${encodeURI(keywords)}`,
                { method: 'GET', headers: { 'Content-Type' : 'text/html', 'X-CSRF-Token' : token }})
                .then((html) => {
                    html.text().then((text) =>{
                        let main_search = document.createElement("main");
                        main_search.setAttribute("id", "search_results");
                        main_search.setAttribute("class", "col-sm-10");
                        main_search.innerHTML = text;
                        main.parentNode.insertBefore(main_search, main);
                        initSortButtons();
                    })
                })
                .catch((error) => {
                    console.log("Could not get the search results, sorry");
                });
        })
    })
})()