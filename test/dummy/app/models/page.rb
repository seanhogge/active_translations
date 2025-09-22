class Page < ApplicationRecord
  translates :title, :heading, :subhead, :content, into: %i[es fr], only: :published?
end
