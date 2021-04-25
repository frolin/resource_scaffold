# frozen_string_literal: true

require 'generators/resource_scaffold/generator_helpers'
require "rails/generators/resource_helpers"

module ResourceScaffold
  module Generators
    # Custom scaffolding generator
    class ControllerGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers

      include ResourceScaffold::Generators::GeneratorHelpers
      check_class_collision suffix: "Controller"

      class_option :helper, type: :boolean
      class_option :admin, type: :boolean
      class_option :orm, banner: "NAME", type: :string, required: true,
                   desc: "ORM to generate the controller for"
      class_option :api, type: :boolean,
                   desc: "Generates API controller"

      class_option :skip_routes, type: :boolean, desc: "Don't add routes to config/routes.rb."

      source_root File.expand_path('../templates', __FILE__)

      desc "Generates controller, controller_spec and views for the model with the given NAME."

      def copy_controller_and_spec_files
        if admin?
          template "controller.rb", File.join("app/controllers/admin", "#{controller_file_name}_controller.rb")
        else
          template "controller.rb", File.join("app/controllers/", "#{controller_file_name}_controller.rb")
        end
      end

      def add_resource_route
        return if options[:actions].present?
        if admin?
          inject_into_file 'config/routes.rb', after: "namespace :admin do\n" do
            "\t\tresources :#{file_name.pluralize}\n"
          end

        else
          route "resources :#{file_name.pluralize}", namespace: regular_class_path
        end
      end

      def copy_view_files
        if admin?
          directory_path = File.join("app/views/admin", controller_file_path)
        else
          directory_path = File.join("app/views", controller_file_path)
        end

        empty_directory directory_path

        view_files.each do |file_name|
          template "views/#{file_name}.html.erb", File.join(directory_path, "#{file_name}.html.erb")
        end
      end

    end
  end
end