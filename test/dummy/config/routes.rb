Rails.application.routes.draw do
  mount ActiveTranslations::Engine => "/active_translations"
end
