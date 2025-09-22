class Category < ApplicationRecord
  translates :name, :short_name, into: %i[es fr]
end
