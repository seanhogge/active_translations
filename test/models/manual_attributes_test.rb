class ManualAttributesTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  setup do
  end

  test "manual attribute changes don't trigger translations" do
    employer = employers(:hilton)

    perform_enqueued_jobs do
      employer.update name: "new name"
    end

    assert_empty employer.translations, "An employer should not have translations after a name change".black.on_red
  end

  test "manual attributes can be set manually, and don't trigger translations or checksum updates" do
    employer = employers(:hilton)

    perform_enqueued_jobs do
      employer.name_fr = "[fr] Hilton"
    end

    assert_not_empty employer.translations, "An employer should have translations after setting a manual attribute translation".black.on_red
    assert_equal "[fr] Hilton", employer.name_fr, "The name_fr should be set to '[fr] Hilton'".black.on_red

    previous_checksum = employer.translations.first.source_checksum

    perform_enqueued_jobs do
      employer.name_fr = "[fr] a new name"
    end

    assert_equal previous_checksum, employer.translations.first.source_checksum
  end

  test "manual attributes should fall back to the regular attribute if translations don't exist" do
    employer = employers(:hilton)

    perform_enqueued_jobs do
      employer.name_fr = "[fr] Hilton"
    end

    assert_not_empty employer.translations, "An employer should have translations after setting a manual attribute translation".black.on_red
    assert_equal "[fr] Hilton", employer.name_fr, "The name_fr should be set to '[fr] Hilton'".black.on_red
    assert_equal employer.name, employer.name_es, "The name_es should be the same as the name when an es translation doesn't exist".black.on_red
  end
end
