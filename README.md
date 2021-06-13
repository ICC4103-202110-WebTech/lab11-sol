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

## Authentication with Devise

Devise is the most widely used authentication solution with Rails applications. It is easy to setup and quickly implement all the basic features, such as registration, confirmation, log in, password recovery, etc. 
The starter code of this lab assignment already contains Devise, i.e., the `rails generate devise:install` task has been already run. In addition, you may check out the project `Gemfile` and see that Devise has been already added for you. The `User` model has been already modified to be usable with Devise, by running the `rails generate devise User` generator command. See the latest migration that has been added by this generator under the `db/migrate` directory. You will notice how the `User` model is modified to support fields necessary for authentication, such as `password` and `password_confirmation`. 

Devise is usable in your web application in the following ways:

1. It provides a set of routes and helpers with by which you can link Devise's actions from your own views, such as sign in, sign out, sign up, etc. Devise's model generator modifies the `config/routes.rb` file. You will find a line that says `devise_for :users`. What this does, is to add a set of routes (and helpers) to your application that makes possible to access Devise's features (actions). Run `rails routes` in the command line and see for your self all of the Devise's actions under the `devise` namespace:
```ruby
new_user_session GET      /users/sign_in(.:format)        devise/sessions#new
user_session POST         /users/sign_in(.:format)        devise/sessions#create
destroy_user_session DELETE   /users/sign_out(.:format)   devise/sessions#destroy
...
```
A link to the first action above (gets the sign in form), is obtainable by calling `new_user_session_path`. Thus, a link can be easily generated by calling Rails' `link_to` helper:
```ruby
link_to('Sign in', new_user_session_path)
```
You have to be careful when creating a link for `sign_out` as this is intended to be a destructive operation. The `delete` method is used with it:
```ruby
link_to('Sign out', destroy_user_session_path, method: :delete)
```
2. It generates a set of views necessary for all its different modules, including registration. The task that generates views, `rails generate devise:views`, has been already executed for you. Go to the `app/views/devise` directory and see that sets of views are generated per module. Should you need to customize user login (sign in) and logout (sign out), the respective view templates are in the `sessions` directory. The templates related to user registration are kept in the `registrations` directory. All of the views are quite raw and you can improve them by applying the pertaining CSS styles.
3. Provides helpers that can be used to see whether a user has signed in (`user_signed_in?`), get the user that is currently logged in (`current_user`), the session (`user_session`), etc.
4. Provides filters that can ensure that a user signs in before they can access specific controller actions. The filter that is used for this is `before_action`. If the model that is handled by Devise is `User`, then, the way to add the filter to your controllers is as follows:
```ruby
before_action :authenticate_user!
```
In addition, you may restrict the actions for which authentication is necessary in each controller:
```ruby
before_action :authenticate_user!, only: %i[new create edit update]
```
5. Devise will support a few user model fields by default, including `email` and `password`. If you need your model to include other fields - as it is the case with the current lab assignment - you will need to add the other permitted parameters, so that sign up and model editing forms support them. The lazy way of doing this is to permit the additional parameters in `ApplicationController`:

```
class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, address_attributes: [:country, :state, :city, :area, :postal_code]])
  end
end
```
6. Whenever a Devise-controlled model (e.g. `User`) is created, the password field will be hashed (encrypted) automatically for you. In this assignment, you will need to create an administrator user in the seeds file. You can specify the password field as plain text when calling `User.create!`.

See more examples and further explanation in the official [documentation](https://github.com/heartcombo/devise).

## Access control with CanCanCan

CanCanCan is an access control solution that works quite well and saves a lot of time and effort. To use this gem, the first step is to add it to the `Gemfile` - which has been done for you already -. Then, you need to run a task that will create the ability class, `rails g cancan:ability`. After that, you will find the ability class at `app/models/ability.rb`. The ability class will add access control features to each role. Basically, you may define capabilities for non-registered users, registered users, and administrators. To distinguish an administrator from a registered user, you may simply use a boolean flag in the `User` model:

```ruby
class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Post, public: true

    if user.present?  # additional permissions for logged in users (they can read their own posts)
      can :read, Post, user_id: user.id

      if user.admin?  # additional permissions for administrators
        can :read, Post
      end
    end
  end
end
```

As with Devise, there are several helpers that you use to allow content to be displayed in views per type of user. For example:

```rb
<% if can? :read, @post %>
  <%= link_to "View", @post %>
<% end %>
```

The `can?` helper is used in views and requires the name of the operation or set of operations that you want to protect. The `manage` set of operations will cover `new`, `create`, `edit`, `update` and `delete`. You may protect all operations by using `all`.

[documentation](https://github.com/CanCanCommunity/cancancan)

## Don't worry, be happy

The graded requirements of this assignment are as follows:

1. [1.0 point] Edit the migration by which the `users` table is created in the database. Add a column named `admin`, with boolean type, and default value `false`. Edit the application seeds file, so that after models are created with factories, an administrative user with email `admin@admin.com` and password `123123123` is created. You may need to run `rails db:drop` (delete the database), `rails db:migrate` (create the database run all migrations) and `rails db:seed` tasks for this to work.
2. [] Follow indication in the 
1. [1.5 points] Modify the application layout, so that in the area in which the welcome message is displayed (i.e., div with class `session-status`), sign in and sign up links appear if a user has not logged in. If a user has logged in, then, the sign in and sign up links must disappear, and instead, 'sign out' and 'my account' links must be displayed.
2. [1.5 points] Run CanCanCan's ability generator, i.e., `rails g cancan:ability`. Edit the ability at `app/models/ability.rb`. Ensure that an administrative user 

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
