begin
  require 'nested_form/builder_mixin'

  module NestedForm
    class TwitterBootstrapBuilder < ::BootstrapForms::FormBuilder
      include ::NestedForm::BuilderMixin
    end
  end

  module BootstrapForms
    module Helpers
      module NestedFormHelper
        def bootstrap_nested_form_for(*args, &block)
          options = args.extract_options!.reverse_merge(:builder => NestedForm::TwitterBootstrapBuilder)
          form_options = options.deep_dup
          options[:summary_errors] = true unless form_options.has_key?(:summary_errors)
          form_options.delete(:summary_errors)

          form_for(*(args << form_options)) do |f|
            if f.object.respond_to?(:errors) and options[:summary_errors]
              f.error_messages.html_safe + capture(f, &block).html_safe
            else
              capture(f, &block).html_safe
            end
          end << after_nested_form_callbacks
        end
      end
    end
  end
rescue LoadError => e
  module BootstrapForms
    module Helpers
      module NestedFormHelper
        def bootstrap_nested_form_for(*args, &block)
          raise 'nested_form was not found. Is it in your Gemfile?'
        end
      end
    end
  end
end
