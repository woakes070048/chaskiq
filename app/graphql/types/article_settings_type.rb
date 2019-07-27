module Types
  class ArticleSettingsType < Types::BaseObject
    field :id, Int, null: true
    field :subdomain, String, null: true
    field :site_title, String, null: true
    field :site_description, String, null: true
    field :website, String, null: true
    field :google_code, String, null: true

    field :color, String, null: true
    field :logo, String, null: true
    field :header_image, String, null: true
    field :header_image_large, String, null: true
    field :facebook, String, null: true
    field :twitter, String, null: true
    field :linkedin, String, null: true
    field :credits, String, null: true
    field :langs, String, null: true

    field :translations, [Types::JsonType], null: true

    field :available_languages, [Types::JsonType], null: true

    def available_languages
      object.translations.map(&:locale)
    end

    def logo
      return "" unless object.logo_blob.present?

      Rails.application.routes.url_helpers.rails_representation_url(
        object.logo.variant(resize_to_limit: [300, 100]).processed, 
      only_path: true)
    end

    def header_image
      return "" unless object.header_image_blob.present?
      Rails.application.routes.url_helpers.rails_representation_url(
        object.header_image.variant(resize_to_limit: [100, 100]).processed, 
      only_path: true)
    end

    def header_image_large
     options = {
       :resize=>"1280x600^", 
       :gravity=>"center", 
       :crop=>"1280x600+0+0", 
       :strip=>true, 
       :quality=>"86"
      }

      return "" unless object.header_image_blob.present?
      Rails.application.routes.url_helpers.rails_representation_url(
        object.header_image.variant(options).processed, 
      only_path: true)
    end



    field :articles, Types::PaginatedArticlesType, null: true do
      argument :page, Integer, required: true
      argument :per, Integer, required: false, default_value: 20
    end

    def articles(page:, per:)
      object.app.articles.page(page).per(per)
    end

    field :articles_uncategorized, Types::PaginatedArticlesType, null: true do
      argument :page, Integer, required: true
      argument :per, Integer, required: false, default_value: 20
    end

    def articles_uncategorized(page: , per:)
      object.app.articles.without_collection.page(page).per(per)
    end

    field :article, Types::ArticleType, null: true do
      argument :id, String, required: true
    end

    def article(id:)
      object.app.articles.friendly.find(id)
    end

    field :collections, [Types::CollectionType], null: true do
    end

    def collections
      object.app.article_collections
    end

    field :collection, Types::CollectionType, null: true do
      argument :id, String, required: true
    end

    def collection(id:)
      object.app.article_collections.friendly.find(id)
    end

  end
end