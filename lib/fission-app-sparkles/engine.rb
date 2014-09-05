module FissionApp
  module Sparkles
    class Engine < ::Rails::Engine

      # Ensure sparkles is registered as a valid product. Register
      # features and permissions to allow access to general usage and
      # builder.
      config.to_prepare do |config|
        product = Fission::Data::Models::Product.find_or_create(
          :name => 'Sparkle',
          :vanity_dns => 'sparkleformation.io'
        )
        feature = Fission::Data::Models::ProductFeature.find_or_create(
          :name => 'sparkle_ui',
          :product_id => product.id
        )
        unless(feature.permissions_dataset.where(:name => 'sparkle_ui_access').count > 0)
          feature.add_permission(
            :name => 'sparkle_ui_access',
            :pattern => '/sparkle(?!/builders).*'
          )
        end
        feature = Fission::Data::Models::ProductFeature.find_or_create(
          :name => 'sparkle_builder',
          :product_id => product.id
        )
        unless(feature.permissions_dataset.where(:name => 'sparkle_builder_access').count > 0)
          feature.add_permission(
            :name => 'sparkle_builder_access',
            :pattern => '/sparkle/builders.*'
          )
        end

      end

    end
  end
end
