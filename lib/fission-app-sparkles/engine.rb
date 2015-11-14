module FissionApp
  module Sparkles
    class Engine < ::Rails::Engine

      # Ensure sparkles is registered as a valid product. Register
      # features and permissions to allow access to general usage and
      # builder.
      config.to_prepare do |config|

        require_dependency 'fission-app-sparkles/sparkle_stacks_controller_overrides'

        product = FissionApp.init_product(:sparkle)

        feature = Fission::Data::Models::ProductFeature.find_or_create(
          :name => 'Stacks UI',
          :product_id => product.id
        )
        permission = Fission::Data::Models::Permission.find_or_create(
          :name => 'Stacks UI access',
          :pattern => '/sparkle(?!/builders).*'
        )
        unless(feature.permissions.include?(permission))
          feature.add_permission(permission)
        end
        feature = Fission::Data::Models::ProductFeature.find_or_create(
          :name => 'Stacks Builder',
          :product_id => product.id
        )
        permission = Fission::Data::Models::Permission.find_or_create(
          :name => 'Stacks builder access',
          :pattern => '/sparkle/builders.*'
        )
        unless(feature.permissions.include?(permission))
          feature.add_permission(permission)
        end

      end

      class ViewHelper
        extend ActionView::Helpers
        extend ActionView::Helpers::UrlHelper
      end

      # Add job detail entry for stack if available
      config.after_initialize do
        FissionApp::Jobs.custom_job_details.push(
          proc{|job|
            if(job.payload.get(:data, :stacks, :name))
              [
                [
                  'Remote Stack',
                  ViewHelper.link_to(
                    job.payload.get(:data, :stacks, :name),
                    Rails.application.routes.url_helpers.sparkle_stack_path(
                      Base64.urlsafe_encode64(
                        job.payload.fetch(:data, :stacks, :id, 'UNKNOWN').to_s
                      ),
                      :confp => job.payload.fetch(:data, :router, :route_config, 'UNKNOWN')
                    )
                  )
                ]
              ]
            end
          }
        )
      end

      def fission_navigation(product, current_user)
        if(product.internal_name == 'sparkle')
          Smash.new('Stacks' => Rails.application.routes.url_helpers.sparkle_stacks_path)
        else
          Smash.new
        end
      end

    end
  end
end
