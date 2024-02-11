# frozen_string_literal: true

module RedmineCrm
  module Hooks
    class ViewsLayoutsHook < Redmine::Hook::ViewListener
      def view_layouts_base_html_head(_context = {})
        stylesheet_link_tag(:calendars, plugin: 'redmine_crm') +
        stylesheet_link_tag(:money, plugin: 'redmine_crm')
      end
    end
  end
end
