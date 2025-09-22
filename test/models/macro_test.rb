class MacroTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  setup do
  end

  test "a model has_many translations when the translates macro is added" do
    category = categories(:admin)

    assert_empty category.translations, "SETUP: the category record should start with no translations".black.on_yellow
    perform_enqueued_jobs do
      category.update name: "administrative"
    end

    assert_not_empty category.translations, "The category should have translations after updating the name".black.on_red
    assert_equal "[es] #{category.name}", category.name(locale: :es), "The category should have an es translation after updating the name".black.on_red
    assert_equal "[fr] #{category.name}", category.name(locale: :fr), "The category should have an fr translation after updating the name".black.on_red
    assert category.fr_translation, "The category should have an fr_translation after updating the name".black.on_red
    assert category.es_translation, "The category should have an es_translation after updating the name".black.on_red
  end

  test "a model is not translated when a non-translated attribute changes" do
    category = categories(:admin)

    assert_empty category.translations, "SETUP: the category record should start with no translations".black.on_yellow

    perform_enqueued_jobs do
      category.update path: :asdf
    end

    assert_empty category.translations, "The category record should not have translations after updating the path".black.on_red
    assert_nil category.fr_translation, "The category should have an fr_translation after updating the name".black.on_red
    assert_nil category.es_translation, "The category should have an es_translation after updating the name".black.on_red
  end
end
