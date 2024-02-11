class RedmineCrmController < ApplicationController
  layout 'admin'

  before_action :require_admin
  require_sudo_mode :settings if respond_to?(:require_sudo_mode)

  def settings
    @section = RedmineCrm::Settings::SECTIONS[params[:id]]
    return render_404 unless @section

    if request.post?
      setting =
        if params[:settings].present?
          params[:settings].respond_to?(:to_unsafe_hash) ? params[:settings].to_unsafe_hash : params[:settings]
        else
          {}
        end
      RedmineCrm::Settings.apply = setting
      flash[:notice] = l(:notice_successful_update)
      redirect_to redmine_crm_settings_path(@section[:id])
    else
      @settings = RedmineCrm::Settings.values
    end
    @section_tabs = RedmineCrm::Settings::SECTIONS.map { |_n, s| { name: s[:id], partial: s[:partial], label: s[:label] } }
  end
end
