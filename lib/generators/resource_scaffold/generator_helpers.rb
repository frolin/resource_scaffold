module ResourceScaffold
  module Generators
    # Some helpers for generating scaffolding
    module GeneratorHelpers
      attr_accessor :options, :attributes

      private

      def view_files
        %w(index new edit _form show)
      end

      def model_columns_for_attributes
        class_name.constantize.columns.reject do |column|
          column.name.to_s =~ /^(id|user_id|created_at|updated_at)$/
        end
      end

      def editable_attributes
        attributes ||= model_columns_for_attributes.map do |column|
          Rails::Generators::GeneratedAttribute.new(column.name.to_s, column.type.to_s)
        end
      end

      def controller_methods(dir_name)
        all_actions.map do |action|
          read_template("#{dir_name}/#{action}.rb")
        end.join("n").strip
      end

      def read_template(relative_path)
        ERB.new(File.read(source_path(relative_path)), nil, '-').result(binding)
      end

      def source_path(relative_path)
        File.expand_path(File.join("../templates/", relative_path), __FILE__)
      end

      def admin?
        options['admin']
      end
    end
  end
end