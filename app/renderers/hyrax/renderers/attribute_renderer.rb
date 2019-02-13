# frozen_string_literal: true
#
# Rewriting the Hyrax AttributeRenderer to better suit how we're
# displaying metadata.
module Hyrax
  module Renderers
    class AttributeRenderer
      include ActionView::Helpers::UrlHelper
      include ActionView::Helpers::TranslationHelper
      include ActionView::Helpers::TextHelper
      include ConfiguredMicrodata

      attr_reader :field, :values, :options

      # @param [Symbol] field
      # @param [Array] values
      # @param [Hash] options
      def initialize(field, values, options = {})
        @field = field
        @values = values
        @options = options
      end

      # Draw the table row for the attribute
      def render
        return '' if values.blank? && !options[:include_empty]

        markup = []
        vals = Array(values)
        attributes = microdata_object_attributes(field).merge(class: "attribute attribute-#{field}")

        vals.each_with_index do |value, index|
          markup << '<tr>'
          markup << %(<th rowspan="#{vals.size}">#{label}</th>) if index.zero?
          markup << %(<td#{html_attributes(attributes)}>#{attribute_value_to_html(value)}</td>)
          markup << '</tr>'
        end

        markup.join.html_safe
      end

      private

        # @return [String]
        def label
          label_text = translated_field_label
          return label_text unless options[:show_help_text]

          label_with_help_text(label_text)
        end

        def translated_field_label
          translate(:"blacklight.search.fields.#{work_type_label_key}.show.#{field}",
                    default: [
                      :"blacklight.search.fields.show.#{field}",
                      :"blacklight.search.fields.#{field}",
                      options.fetch(:label, field.to_s.humanize)
                    ])
        end

        # @param attributes [Hash]
        # @return [String]
        def html_attributes(attributes)
          buffer = []
          attributes.each do |k, v|
            buffer << " #{k}"
            buffer << %(="#{v}") if v.present?
          end
          buffer.join
        end

        # @return [String]
        def attribute_value_to_html(value)
          if microdata_value_attributes(field).present?
            "<span#{html_attributes(microdata_value_attributes(field))}>#{li_value(value)}</span>"
          else
            li_value(value)
          end
        end

        # @param val [#to_s]
        # @return [String]
        def li_value(val)
          auto_link(ERB::Util.h(val.to_s))
        end

        # @return [String]
        def label_with_help_text(label_text)
          return label_text unless help_text
          %(
            #{label_text}
            <span
              class="fa fa-question-circle-o"
              data-toggle="popover"
              data-content="#{help_text}"
              data-trigger="hover click"
            ></span>
          )
        end

        # @return [String, nil]
        def help_text
          translate(:"simple_form.hints.defaults.#{field.downcase}", default: nil)
        end

        # @return [String, nil]
        def work_type_label_key
          options[:work_type] ? options[:work_type].underscore : nil
        end
    end
  end
end
