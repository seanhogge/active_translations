Rails.application.routes.draw do
  mount ActiveTranslation::Engine => "/active_translation"
end
