require 'active_record'
require 'action_view'

require 'redmine_crm/version'
require 'redmine_crm/engine'

require 'redmine_crm/settings'
require 'redmine_crm/settings/money'

require 'redmine_crm/acts_as_list/list'
require 'redmine_crm/acts_as_taggable/tag'
require 'redmine_crm/acts_as_taggable/tag_list'
require 'redmine_crm/acts_as_taggable/tagging'
require 'redmine_crm/acts_as_taggable/rcrm_acts_as_taggable'
require 'redmine_crm/acts_as_viewed/rcrm_acts_as_viewed'
require 'redmine_crm/acts_as_votable/rcrm_acts_as_votable'
require 'redmine_crm/acts_as_votable/rcrm_acts_as_voter'
require 'redmine_crm/acts_as_votable/vote'
require 'redmine_crm/acts_as_votable/voter'
require 'redmine_crm/acts_as_draftable/rcrm_acts_as_draftable'
require 'redmine_crm/acts_as_draftable/draft'
require 'redmine_crm/acts_as_priceable/rcrm_acts_as_priceable'

require 'redmine_crm/currency'
require 'redmine_crm/helpers/tags_helper'
require 'redmine_crm/money_helper'
require 'redmine_crm/colors_helper'

require 'liquid'
require 'redmine_crm/liquid/filters/base'
require 'redmine_crm/liquid/filters/arrays'
require 'redmine_crm/liquid/filters/colors'
require 'redmine_crm/liquid/drops/issues_drop'
require 'redmine_crm/liquid/drops/news_drop'
require 'redmine_crm/liquid/drops/projects_drop'
require 'redmine_crm/liquid/drops/users_drop'
require 'redmine_crm/liquid/drops/time_entries_drop'
require 'redmine_crm/liquid/drops/attachment_drop'
require 'redmine_crm/liquid/drops/issue_relations_drop'

require 'redmine_crm/helpers/calendars_helper'
require 'redmine_crm/helpers/external_assets_helper'
require 'redmine_crm/helpers/form_tag_helper'
require 'redmine_crm/assets_manager'

require 'redmine_crm/compatibility/application_controller_patch'
require 'redmine_crm/compatibility/routing_mapper_patch'
require 'redmine_crm/patches/liquid_patch' unless BigDecimal.respond_to?(:new)

module RedmineCrm
  GEM_NAME = 'redmine_crm'.freeze
end

if defined?(ActiveRecord::Base)
  ActiveRecord::Base.send :include, RedmineCrm::ActsAsList::List
  ActiveRecord::Base.extend(RedmineCrm::ActsAsVotable::Voter)
  ActiveRecord::Base.extend(RedmineCrm::ActsAsVotable::Votable)
end

RedmineCrm::AssetsManager.install_assets

if defined?(ActionView::Base)
  ActionView::Base.send :include, RedmineCrm::CalendarsHelper
  ActionView::Base.send :include, RedmineCrm::ExternalAssetsHelper
  ActionView::Base.send :include, RedmineCrm::FormTagHelper
end

def requires_redmine_crm(arg)
  def compare_versions(requirement, current)
    raise ArgumentError.new('wrong version format') unless check_version_format(requirement)

    requirement = requirement.split('.').collect(&:to_i)
    requirement <=> current.slice(0, requirement.size)
  end

  def check_version_format(version)
    version =~ /^\d+.?\d*.?\d*$/m
  end

  arg = { version_or_higher: arg } unless arg.is_a?(Hash)
  arg.assert_valid_keys(:version, :version_or_higher)

  current = RedmineCrm::VERSION.split('.').map { |x| x.to_i }
  arg.each do |k, req|
    case k
    when :version_or_higher
      raise ArgumentError.new(':version_or_higher accepts a version string only') unless req.is_a?(String)

      unless compare_versions(req, current) <= 0
        Rails.logger.error "\033[31m[ERROR]\033[0m Redmine requires redmine_crm gem version #{req} or higher (you're using #{RedmineCrm::VERSION}).\n\033[31m[ERROR]\033[0m Please update with 'bundle update redmine_crm'." if Rails.logger
        abort "\033[31mRedmine requires redmine_crm gem version #{req} or higher (you're using #{RedmineCrm::VERSION}).\nPlease update with 'bundle update redmine_crm'.\033[0m"
      end
    when :version
      req = [req] if req.is_a?(String)
      if req.is_a?(Array)
        unless req.detect { |ver| compare_versions(ver, current) == 0 }
          abort "\033[31mRedmine requires redmine_crm gem version #{req} (you're using #{RedmineCrm::VERSION}).\nPlease update with 'bundle update redmine_crm'.\033[0m"
        end
      elsif req.is_a?(Range)
        unless compare_versions(req.first, current) <= 0 && compare_versions(req.last, current) >= 0
          abort "\033[31mRedmine requires redmine_crm gem version between #{req.first} and #{req.last} (you're using #{RedmineCrm::VERSION}).\nPlease update with 'bundle update redmine_crm'.\033[0m"
        end
      else
        raise ArgumentError.new(':version option accepts a version string, an array or a range of versions')
      end
    end
  end
  true
end
