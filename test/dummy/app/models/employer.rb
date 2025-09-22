class Employer < ApplicationRecord
  translates :profile_html, manual: :name, into: %i[es fr]
end
