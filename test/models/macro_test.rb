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

  test "a model with an only constraint is translated when it's toggled to true, and untranslated when toggled to false" do
    page = pages(:home_page)

    perform_enqueued_jobs do
      page.update title: "new title"
    end

    assert_empty page.translations, "A page that isn't published shouldn't be translated".black.on_red

    perform_enqueued_jobs do
      page.update published: true
    end

    assert_not_empty page.translations, "A page should be translated if the only constraint changes to true".black.on_red

    page.reload

    perform_enqueued_jobs do
      page.update published: false
    end

    assert_empty page.translations, "Toggling the only constraint to false should destroy existing translations".black.on_red
  end

  test "a model with an unless constraint is translated when it's toggled to false, and untranslated when toggled to true" do
    job = jobs(:chef)

    perform_enqueued_jobs do
      job.update title: "new title"
    end

    assert_empty job.translations, "A job that isn't posted shouldn't be translated".black.on_red

    perform_enqueued_jobs do
      job.update posted_status: "posted"
    end

    assert_not_empty job.translations, "A job should be translated if the unless constraint changes to false".black.on_red

    job.reload

    perform_enqueued_jobs do
      job.update posted_status: "expired"
    end

    assert_empty job.translations, "Toggling the unless constraint to true should destroy existing translations".black.on_red
  end

  test "creating a new translatable record creates translations" do
    employer = perform_enqueued_jobs do
      Employer.create(name: "Hyatt", profile_html: "<p>A great hotel</p>")
    end

    assert_not_empty employer.translations, "Creating a new employer with profile_html should generate translations".black.on_red
  end

  test "creating a new translatable record with blank values does not trigger translation" do
    employer = perform_enqueued_jobs do
      Employer.create(name: "Hyatt", profile_html: nil)
    end

    assert_empty employer.translations, "Creating a new employer with no profile_html should not trigger translations".black.on_red
  end
end
