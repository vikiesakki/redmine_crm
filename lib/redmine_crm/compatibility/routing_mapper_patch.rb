module RedmineCrm
  module Patches
    module RoutingMapperPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          alias_method :constraints_without_redmine_crm, :constraints
          alias_method :constraints, :constraints_with_redmine_crm
        end
      end

      module InstanceMethods
        def constraints_with_redmine_crm(options = {}, &block)
          return constraints_without_redmine_crm(options, &block) unless options.is_a?(Hash)

          options[:object_type] = /.+/ if options[:object_type] && options[:object_type].is_a?(Regexp)
          constraints_without_redmine_crm(options, &block)
        end
      end
    end
  end
end

unless ActionDispatch::Routing::Mapper.included_modules.include?(RedmineCrm::Patches::RoutingMapperPatch)
  ActionDispatch::Routing::Mapper.send(:include, RedmineCrm::Patches::RoutingMapperPatch)
end
