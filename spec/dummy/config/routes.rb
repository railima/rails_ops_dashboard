# frozen_string_literal: true

Rails.application.routes.draw do
  mount RailsOpsDashboard::Engine, at: '/ops'
end
