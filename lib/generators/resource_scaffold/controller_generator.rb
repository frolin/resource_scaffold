# frozen_string_literal: true

require 'generators/resource_scaffold/generator_helpers'
require "rails/generators/resource_helpers"

module ResourceScaffold
  module Generators
    # Custom scaffolding generator
    class ControllerGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers
      # include ResourceScaffold::Generators::GeneratorHelpers
      check_class_collision suffix: "Controller"

      class_option :helper, type: :boolean
      class_option :orm, banner: "NAME", type: :string, required: true,
                         desc: "ORM to generate the controller for"
      class_option :api, type: :boolean,
                         desc: "Generates API controller"

      class_option :skip_routes, type: :boolean, desc: "Don't add routes to config/routes.rb."

      argument :attributes, type: :array, default: [], banner: "field:type field:type"

      source_root File.expand_path('../templates', __FILE__)

      desc "Generates controller, controller_spec and views for the model with the given NAME."

      def copy_controller_and_spec_files
        template "controller.rb", File.join("app/controllers", "#{controller_file_name}_controller.rb")
      end

    end
  end
end