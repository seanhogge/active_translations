module ActiveTranslations
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path("templates", __dir__)

      def self.next_migration_number(dirname)
        next_migration_number = current_migration_number(dirname) + 1
        ActiveRecord::Migration.next_migration_number(next_migration_number)
      end

      def copy_migration
        migration_template "create_translations.rb", "db/migrate/create_translations.rb"
      end

      def copy_initializer
        template "active_translations.rb", "config/initializers/active_translations.rb"
      end

      def show_readme
        readme "README" if behavior == :invoke
      end
    end
  end
end
