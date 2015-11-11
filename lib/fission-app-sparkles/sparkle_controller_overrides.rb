module SparkleControllerOverrides

  def stacks_api
    result = nil
    if(params[:confp])
      current_user.session[:sparkles_conf] = params[:confp]
    end
    if(current_user.session[:sparkles_conf])
      route_config = RouteConfig.find_by_name(current_user.session[:sparkles_conf])
      if(route_config && route_config.route.account == current_user.run_state.current_account)
        o_config = route_config.merged_configuration[:stacks]
        unless(o_config.empty?)
          result = memoize(o_config.to_smash.checksum, :direct) do
            provider = Sfn::Provider.new(
              :provider => o_config[:provider],
              :miasma => o_config[:credentials],
              :logger => Rails.logger,
              :async => true,
              :fetch => true,
              :stack_expansion_interval => 90,
              :stack_list_interval => 60
            )
            provider.connection.data[:stack_types] = (
              [
                provider.connection.class.const_get(:RESOURCE_MAPPING).detect do |klass, info|
                  info[:api] == :orchestration
                end.first
              ] + ['Custom::JackalStack']
            ).compact.uniq
            provider
          end
        end
      end
    end
    unless(result)
      raise "Failed to set valid remote API provide credentials!"
    end
    result
  end

end

unless(Sparkle::StacksController.ancestors.include?(SparkleControllerOverrides))
  Sparkle::StacksController.send(:include, SparkleControllerOverrides)
end
