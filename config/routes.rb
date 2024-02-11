# frozen_string_literal: true

Rails.application.routes.draw do
  match 'redmine_crm/settings/:id', to: 'redmine_crm#settings', as: 'redmine_crm_settings', via: [:get, :post]
end
