# ActiveTranslation

ActiveTranslation lets you easily translate ActiveRecord models. With a single line added to that model, you can declare
which columns, which locales, and what constraints to allow or prevent translation.


## Installation

Add the gem to your gemfile:

```ruby
gem "active_translation", git: "https://github.com/seanhogge/active_translation"
```

And then bundle:

```bash
bundle
```

Run the installer to add a migration and initializer:

```ruby
rails generate active_translation:install
```

Migrate your primary database:

```ruby
rails db:migrate
```


## Usage

The first step is to configure your Google credentials. ActiveTranslation uses the Google Translate API in the background for translation. This is a bit more than just an API key.

The general idea is:

1. Create a project at console.cloud.google.com
1. In “APIs & Services” > “Library” look for “Cloud Translation API”
1. Create a Service Account and download the JSON key file
1. Ensure billing is enabled, and all the other prerequisites that Google requires
1. Extract the necessary data from that JSON file and plug those values into `config/initializers/active_translation.rb` by setting the appropriate environment variables

Feel free to change the names of the environment variables, or to alter that initializer to assign those keys however you like. At Talentronic, we have an `APIConnection` model we use for stuff like that so we grab the credentials from there and assign them.

That's the hard part!

To any ActiveRecord model, add `translates` with a list of columns that should be translated, a list of locales and any constraints.

Simplest form:

```ruby
translates :content, into: %i[es fr de]
```

### Only Constraints

An `only` constraint will prevent translating if it returns `false`.

If you have a boolean column like `published`, you might do:

```ruby
translates :content, into: %i[es fr de], only: :published?
```

Or you can define your own method that returns a boolean:

```ruby
translates :content, into: %i[es fr de], only: :record_should_be_translated?
```

Or you can use a simple Proc:

```ruby
translates :content, into: %i[es fr de], only: -> { content.length > 10 }
```

### Unless Constraints

These work exactly the same as the `only` constraint, but the logic is flipped. If the constraint returns `true` then no translating will take place.

### Constraint Compliance

If your record is updated such that either an `only` or `unless` constraint is toggled, this will trigger the addition _or removal_ of translation data. The idea here is that the constraint controls whether a translation should _exist_, not whether a translation should be performed.

This means if you use a constraint that frequently changes value, you will be paying for half of all change events.

This is intentional. Translations are regenerated any time one of the translated attributes changes. But what about something like a `Post` that shouldn't be translated until it's published? There's no sense in translating it dozens of times as it's edited, but clicking the “publish” button doesn't update the translatable attributes.

So ActiveTranslation watches for the constraint to change so that when the `Post` is published, the translation is performed with no extra effort.

Likewise, if the constraint changes the other way, translations are removed since ActiveTranslation will no longer be keeping those translations up-to-date. Better to have no translation than a completely wrong one.


## Contributing

Fork the repo, make your changes, make a pull request.

                                                                                                              n
## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
