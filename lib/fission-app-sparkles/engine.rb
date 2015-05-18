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
          :name => 'Stacks UI',
          :product_id => product.id
        )
        permission = Fission::Data::Models::Permission.create(
          :name => 'Stacks UI access',
          :pattern => '/sparkle(?!/builders).*'
        )
        unless(feature.permissions.include?(permission))
          feature.add_permission(permissions)
        end
        feature = Fission::Data::Models::ProductFeature.find_or_create(
          :name => 'Stacks Builder',
          :product_id => product.id
        )
        permission = Fission::Data::Models::Permission.create(
          :name => 'Stacks builder access',
          :pattern => '/sparkle/builders.*'
        )
        unless(feature.permissions.include?(permission))
          feature.add_permission(permission)
        end
      end

    end
  end
end
