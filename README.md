# Lab 11: User authentication and access control.

**Names:** (enter your names here) 

In this lab assignment you will add user registration, login and logout to the Kegs & Pints application, supporting registered user and administrator roles. In addition, you will enable access control to avoid unauthorized access to resources.

## First steps

As usual, make sure your development environment is set to use Ruby version 3, and Rails 6.

If you work on the console, do not forget to switch to the proper version of Ruby and gemset:

```sh
rvm use 3@rails6 # this will work on the course's VM
```

Given that you will now run the application server (recall that formerly, you just worked with the rails console), if you work on the command line, follow these steps:

```sh
bundle install
yarn # This will install JavaScript dependencies required by the project, and you will only needed it once
rails db:migrate
rails db:seed
rails assets:clobber # it clears the public assets of the application
rails webpacker:compile # compiles Javascript and CSS assets using webpack
rails s
```

To stop the application server, enter Ctrl+C on the terminal window.

If you work with RubyMine, go to the preferences menu, then to Languages and Frameworks, and see that ruby version 3 and the rails6 gemset are selected.

## Asynchronous JavaScript and XML (AJAX)

The HTTP protocol was designed at is outset to permit request-response interaction cycles among a client and a server. The nature of such a cycle is synchronous. The client will send a request to the server (such as a GET request for an hypertext document), and the server will respond accordingly. Such an interaction will take a perceivable amount of time in most cases - ranging from a few milliseconds up to several seconds - which generally speaking, must be avoided. The way in which the WWW was conceived implied that the user would "jump" from one hypertext document to the next, for instance, when clicking on a link, or submitting a form.

Interaction with any modern web application will likely contradict the above. Clicking on a link will often modify the current page in the browser, instead of loading an entirely different one. Likewise, think about posting an update on Twitter or Facebook, or clicking on a menu in Google Docs, or Sheets.

The way in which modern web applications work is that the client may issue several asynchronous requests to a server, and have local code (JavaScript) handle responses and update the current document with the result that is obtained. This is accomplished through a web browser component/feature that was first integrated by Microsoft into a browser in the mid 2000's. Internet Explorer 7 included the [XMLHTTPRequest (XHR)](https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest) component that permits the web browser sending asynchronous requests to a server, and receive objects (serialized as XML or JSON) or bits of HTML that can be interpolated in the page that is currently displayed. Mozilla developed similar functionality, and nowadays, all major browsers support this kind of client-server interaction. The AJAX (Asynchronous JavaScript and XML) acronym summarized the combination of technologies that were initially used to implement interactive behavior in an HTML document that relied on asynchronous client-server interaction. The choice of XML at the time was popular, as it was the de facto means for data serialization in web technologies.

The XHR component can be utilized directly with JavaScript via its own [API](https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest). Up until ECMAScript 5, this was a common way of implementing AJAX. Back in those days, libraries appeared, such as [jQuery](https://jquery.com), which simplified the use of the XHR component by providing a cross-browser compatible [API](https://api.jquery.com/jquery.ajax/). Nowadays, with ECMAScript 6 onwards, there is little reason to keep on using the legacy XHR API, or even jQuery. Instead, it is preferred to use the [Fetch API](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API). In new developments, always prefer the latter. Use XHR directly only when in need to maintain legacy code.

## Working with JavaScript on Rails

We recommend that you study [this guide](https://guides.rubyonrails.org/working_with_javascript_in_rails.html) in order to deepen your understanding on how JavaScript should be used in Rails applications. The guide starts with an example on using the Fetch API, then it explains how to work with unobstrusive JavaScript, it shows how to use Rails helpers with 'remote' (AJAX) capabilities, a few implementation considerations, Turbolinks (see below), and the use of Cross-Site Request Forgery (CSRF) tokens with JavaScript (we saw some of this in the previous lab assignment).

## FontAwesome

[FontAwesome](https://fontawesome.com/) is a library that provide glyphs and icons that can be used in your application. There is a subset of the entire collection that you may use free of charge in your projects. [Here are](https://dev.to/yarotheslav/how-to-install-fontawesome-with-yarn-and-webpacker-in-rails-6-2k62) instructions on how to install FA on Rails 6, and an example on how to include icons on your pages. For this, you use the `<i>` HTML tag, and specify the icon you want to use by indicating its CSS class in the `class` attribute. 

## Turbolinks

Turbolinks (part of Rails as of version 6.1, but now superseeded by [Turbo](https://github.com/hotwired/turbo)) is a library intended for web applications based on MVC architecture with server-side rendering. Regular Rails applications match this definition. In Rails applications, Turbolinks modifies links on each page, in such way that when a link is clicked, Turbolinks automatically (asynchronously) fetches the page, swaps in its `<body>`, and merges its `<head>`. It does all of this in order to avoid the cost of a full page load.

If you need to process the page load event, without Turbolinks, the common way to do this is:

```JavaScript
window.addEventListener("load", () => {
  alert("page has loaded!");
});
```

With TurboLinks, you need to specify a different name for the event:

```JavaScript
document.addEventListener("turbolinks:load", () => {
  alert("page has loaded!");
});
```

You may see the complete list of Turbolinks events [here](https://github.com/turbolinks/turbolinks/blob/master/README.md) (find the section titled Full List of Events).

## Animals in the Zoo

In this assignment, you will need to become familiar with a few new bits and pieces in the Kegs & Pints application:

1. First, go to `app/views/beers/_beer_container.html.erb`. You will see that this partial view is used whenever we need to display a set of beers, such as in the home page (`app/views/pages/home.html.erb`), or when displaying the beers that the user has looked at previously (recall from the previous assignment). See that the `_beer_container.html.erb` partial view requires another partial view called `_beer_sort_controls.html.erb`. This latter view contains two buttons. There is a button with `btn-sort-alcvol` class that is intended to sort beers by alcoholic volume, and another button with `btn-sort-name`, which will sort beers by name. Sorting is done by modifying the current DOM tree rather than by loading a new view with the beers sorted accordingly. Now, go to `app/frontend/packs/beers.js`. You will see code that is unobstrusively attached to the buttons, so that the desired sort behavior is triggered in each case. Later on, you are asked to complete this code.
2. New search capabilities have been added to the application. Go to the application layout `app/views/layouts/application.html.erb` and see that there is a form with `nav-searchbox` class. There is unobstrusive JavaScript code that defines the behavior of the search form. Take a look at `app/frontend/packs/search.js`. See that there is an IIFE function that makes the search form in the layout completely operational. In addition, see that there is a special layout for search at `app/views/layouts/search.html.erb`. If you take a look at this layout, you will see that it is as simple as it gets. This layout is used in the `search` action in `SearchController`. The code in `search.js` will obtain search results from `SearchController::search` and insert them into the page currently displayed, _a la_ AJAX.

## Let's Roll

The graded requirements of this assignment are as follows:

1. [1.5 points] Complete the code of the `registerClickHandlerForSortButton` function at `app/frontend/packs/beers.js`. Follow the TODO indications in the code comments.
2. [2 points] Complete the code of the `initSortButtons` function in the same `beers.js` file. This function must attach event handlers to the beer sort buttons, as described in the code comments.
3. [2.5 points] Comment the implementation of search in the `app/frontend/packs/search.js` file. Explain the workings of the code from line 21 onwards.

Requirements 1 and 2 will be graded on a 1-5 scale. Requirement 3 will be graded in a 1-8 scale. 

We leave the following sections as a refresher in case you need to see generalities and examples from past assignments.

## How assets are managed in Rails

There are two ways in which _assets_, that is, images, scripts, stylesheets and other static files are managed in a Rails application. The first (and oldest) method is based on the so-called ['Asset Pipeline'](https://edgeguides.rubyonrails.org/asset_pipeline.html), based on the [sprockets gem](https://github.com/rails/sprockets) which is nowadays considered the legacy way of managing assets in Rails. What the asset pipeline does is to take all CSS stylesheets in and put them together into a large `application.css` file, for which CSS assets are optimized (we will cover this later in the course). Javascript files receive a similar treatment. This permits reducing the overall size of assets, and allows the browser to minimize the amount of downloads it takes to load application views. When you use the asset pipeline, you usually consider the following helpers and task:

* To include the compiled application stylesheet in your layouts and templates, you will call the [stylesheet_link_tag](https://apidock.com/rails/v6.1.3.1/ActionView/Helpers/AssetTagHelper/stylesheet_link_tag) helper, and when including compiled JavaScript dependencies, you will call the [javascript_include_tag](https://apidock.com/rails/ActionView/Helpers/AssetTagHelper/javascript_include_tag) helper.
* To run the asset pipeline and compile your assets, you will run:
```sh
rails assets:precompile
```

The modern (and nowadays preferred) way of managing assets in Rails depends on the [webpacker](https://www.rubydoc.info/github/rails/webpacker) gem. New projects should be based on this approach. Webpacker can be thought of as an adapter for a utility called [webpack](https://webpack.js.org/), which is part of the JavaScript ecosystem, and is installed in our Rails projects by using Yarn. [Yarn](https://yarnpkg.com/) is a JavaScript package manager (an alternative to Node Package Manager, aka, `npm`), which installs packages that are specified in the `package.json` file at `RAILS_ROOT`. Yarn will install libraries from the JavaScript ecosystem into the `node_modules` folder at `RAILS_ROOT`. Webpack provides functionality that is equivalent to that of the Asset Pipeline, and is capable of creating _packs_ of JavaScript and CSS files, that can include your own CSS and JavaScript, along with code from libraries that are installed by Yarn and that your application requires. and these are usually included in an application layout, such as `app/views/application.erb.html`.

* To include the compiled application stylesheet in your layouts and templates, you will call the [stylesheet_pack_tag](https://www.rubydoc.info/gems/webpacker/Webpacker%2FHelper:stylesheet_pack_tag) helper, and when including compiled JavaScript dependencies, you will call the [javascript_pack_tag](https://www.rubydoc.info/github/rails/webpacker/Webpacker%2FHelper:javascript_pack_tag) helper. These helpers are provided by the webpacker gem, and note the different names of these comparted to those used with the Asset Pipeline. 
* To prepare assets with webpack, use the following tasks: 
```sh
rails assets:clobber # it clears the public assets of the application
rails webpacker:compile # compiles Javascript and CSS assets using webpack
```

Webpacker is configured in the `config/webpacker.yml` file. JavaScript and CSS packs are created from files usually in `app/javascript`. In this project, the directory was renamed to `app/frontend`. We will cover this in greater depth in the following lectures.

## Bootstrap and Pagy

The starter code of this lab assignment is based on the solution to the previous one. However, it has been improved by adding the [Bootstrap 5](https://getbootstrap.com/docs/5.0/getting-started/introduction/) library as a JavaScript dependency, to improve overall appearance of different elements in the views. The method by which Bootstrap 5 has been added to the project is well described in this [tutorial](https://bootrails.com/blog/rails-bootstrap-tutorial).

The `kegsnpints.css` stylesheet continues to be used, however, it now overrides several Bootstrap styles, and has been moved to the `app/frontend/packs` folder. If you take a look at the application layout (`app/views/layouts/application.html.erb`) you will see that within the `<main>` element, bootstrap styles are used. Bootstrap is also used in several templates, for instance, in `views/beers/index.html.erb`. In the rest of the application layout, which includes the basic grid, styles from `kegsnpints.css` continue to be applied. 

If you have a look at the `/beers` path of the application, you will see that bootstrap styles have been added to the tabular display of beers. Also, notice that a gem called [Pagy](https://github.com/ddnexus/pagy) has been added to support paginating model views. You may want to see the Gemfile to check out how it was included. Also, if you have a look at `BeersController#index`, you will see how pagy is being called to prepare the paginated display of beers. Installation of pagy is quite straightforward according to the [documentation](https://ddnexus.github.io/pagy/how-to#gsc.tab=0). Furthermore, pagy has been configured to utilize bootstrap styles in this project. You may want to see this [guide](https://ddnexus.github.io/pagy/extras/bootstrap#gsc.tab=0) for details.

## Active Storage

Rails includes a nifty component for implementing file uploads, which is called [Active Storage](https://edgeguides.rubyonrails.org/active_storage_overview.html) (read the documentation, it is worth it). Active Storage is fairly easy to install and it has been enabled in the project already. If you need to enable it in another project, you will need to run a task that will create migrations necessary to support file uploads:

```sh
rails active_storage:install
rails db:migrate
```

After Active Storage is enabled, you may add files to your models. For an example, take a look at `app/models/beer.rb`. You will see that it is possible to attach a file to a beer by means of specifying the `has_one_attached` macro. It is also possible that a model is attached to many files by specifying the `has_many_attached` macro.

In a web form, you will need to use the file form element in order to support uploading files. See `app/views/beers/_form.html.erb`, line 48 for an example. In the respective controller, i.e., `BeersController`, you will see in the `beer_params` method, that the `image` parameter has been added to the call to `permit`. Then in the `create` method, line 31, you will see how the image parameter is attached to the model that is to be saved. Finally, in `app/views/beers/show.html.erb`, line 6, you will see how an image is displayed. You will notice that a model may not have an attached image, therefore, a placeholder image can be displayed. This is accomplished by calling the `attached?` method on `@beer.image`, to inspect whether the model has an attached image or not.

## Data attributes in HTML

HTML permits adding arbitrary data to elements, as a way to keep state in the frontend. This is done by adding 'data attributes' to the elements, which are named with the `data-` prefix. For an example on this, take a look at `app/views/beers/show.html.erb`. Find the div element with class `review-placeholder`. You will see that two data attributes are defined in there (i.e., the id of the beer being displayed, along with another variable called CSRF which we will explain about in the subsequent section). The values that the data attributes take are generated by the application, that is, embedded ruby code is used to generate them.

Actual values in data attributes can be retrieved through Javascript, by use of the DOM API. See `app/frontend/packs/review.js` for an example on how the div element is located using the `querySelector` and `closest` methods. The former method is utilized to locate a button with id `add_review_btn`. Then the closest div with the `review-placeholder` is found using the `closest` method. Lastly, data attributes are accessed through the `dataset` property of the element. The names of data attributes, which are specified in the markup in lowercase and with dashes, are transformed to camel case in JavaScript.

## Cross-Site Request Forgery (CSRF) tokens and Forms

Web forms can be easily vulnerable to a type of attack known as 'Cross-Site Request Forgery' if no countermeasures are implemented. In this attack, a user can be directed to an impostor form outside your application, which can be used by the attacker to collect sensitive data of yours. Then the form may (or not) be submitted to the real website without you noticing that your data has been stolen. This kind of attack is prevented by Rails, as in other web application frameworks, by using a random sequence of bytes known as a CSRF token. The way in which this works is that when a template is rendered, a `meta` element is added to the head of the actual HTML, containing a CSRF token legitimally generated by the application. Also, forms that are created with Rails' helpers, will include a hidden input field with name `authenticity_token`. Thus, whenever a form is submitted, Rails will check that the token matches the expected one, and therefore is valid. If the token is not valid, an `InvalidAuthenticityToken` exception is raised.

## Managing session variables with helper functions and JSON serialization

Session variables are stored in the `session` hash-like structure that Rails automatically manages in the application. You may store complex data structures in a session variable, provided that these are serialized in a text-based format like JSON. Rails provides two convenient functions with which it is possible to serialize and deserialize JSON data: `ActiveSupport::JSON.encode/decode` (see [documentation here](https://api.rubyonrails.org/classes/ActiveSupport/JSON.html)).

When managing session variables, it may be convenient to implement helper functions that facilitate reads and updates from/to the variables, which may include handling JSON serialization/deserialization.

If you need to call a helper from a controller action, there is a `helpers` object that provides access to all helpers. For instance, `helpers.beers_update_watchlist`. Thus, it is a good practice to name your helpers prefixing the name of the model for which the helper is intended.

## Adding custom ECMAScript to your application

We included a dynamic form to the Kegs & Pints application that permits adding reviews to beers. The form is implemented in the file `app/frontend/packs/review.js`. Note that the way in which the form is added to the document is by locating the containing div element, with class `review-placeholder`. Then, the `insertAdjacentHTML` method is called, which permits inserting HTML into the pre-existing DOM in different ways. Read the [documentation](https://developer.mozilla.org/en-US/docs/Web/API/Element/insertAdjacentHTML) for details.

The code from the `review.js` file is compiled by webpack and included in the last line of the `app/views/beers/show.html.erb` template, by using webpack's `javascript_pack_tag`. This allows including the code selectively in any views that require the review form feature, as opposed to scripts that are compiled in the `application.js` pack, which are available to all application views.

You will notice that the code in `app/frontend/packs/review.js` looks like:

```javascript
(()=>{ /* actual code */ })();
```

This is known as an Immediatly-Invoked-Function-Expression (IIFE, pronounced as 'iffy'). IFFEs are invoked as soon as they are loaded by the JavaScript engine. In the next lecture we will see that functions can be declared as function declarations, function expressions, and as arrow functions. In the case of an IFFE like the above, an arrow function is utilized, surrounded by parentheses, and then invoked - for which the last pair of parentheses is needed.

## Basic database tasks

We keep this section here in case you need to run database tasks for whatever reason.

Rails provides several database tasks that you may run on the command line whenever needed:

* `db:migrate` runs (single) migrations that have not run yet.
* `db:create` creates the database
* `db:drop` deletes the database
* `db:schema:load` creates tables and columns within the (existing) database following `schema.rb`
* `db:setup` does `db:create`, `db:schema:load`,  `db:seed`
* `db:reset` does `db:drop`, `db:setup`

Typically, you would use db:migrate after having made changes to the schema via new migration files (this makes sense only if there is already data in the database). `db:schema:load` is used when you setup a new instance of your app.

After you create a migration, do not forget to apply it to the database!

```sh
rails db:migrate
```

The following example will drop the current database and then recreate it, including initialization as specified in `db/seeds.rb`:

```sh
rails db:drop
rails db:setup
```
