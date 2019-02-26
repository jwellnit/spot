# frozen_string_literal: true
#
# Sets up the helper methods needed to make our lives easier when accessing attributes
# from the presenter/solr_document layer.
#
# @example
#   pub = Publication.create(title: ['A great work'])
#   document = SolrDocument.new(pub.to_solr)
#   puts document.title
#   # => 'A great work'
#   puts document['title_tesim']
#   # => ['A great work']
#
# @todo Remove {.attribute} definition when Hyrax upgrades to Blacklight >=7
# @todo Split out common work-type definitions vs. custom vs. collections
module Spot
  module SolrDocumentAttributes
    extend ActiveSupport::Concern

    # rubocop:disable Metrics/BlockLength
    included do
      attribute :abstract,               ::Blacklight::Types::Array, 'abstract_tesim'
      attribute :academic_department,    ::Blacklight::Types::Array, 'academic_department_tesim'
      attribute :admin_set,              ::Blacklight::Types::String, 'admin_set_tesim'
      attribute :bibliographic_citation, ::Blacklight::Types::Array, 'bibliographic_citation_tesim'
      attribute :contributor,            ::Blacklight::Types::Array, 'contributor_tesim'
      attribute :date_available,         ::Blacklight::Types::Array, 'date_available_ssim'
      attribute :date_issued,            ::Blacklight::Types::Array, 'date_issued_ssim'
      attribute :depositor,              ::Blacklight::Types::String, 'depositor_ssim'
      attribute :description,            ::Blacklight::Types::Array, 'description_tesim'
      attribute :division,               ::Blacklight::Types::Array, 'division_tesim'
      attribute :editor,                 ::Blacklight::Types::Array, 'editor_tesim'
      attribute :identifier,             ::Blacklight::Types::Array, 'identifier_ssim'
      attribute :keyword,                ::Blacklight::Types::Array, 'keyword_tesim'
      attribute :language,               ::Blacklight::Types::Array, 'language_ssim'
      attribute :language_label,         ::Blacklight::Types::Array, 'language_label_ssim'
      attribute :license,                ::Blacklight::Types::Array, 'license_ssim'
      attribute :organization,           ::Blacklight::Types::Array, 'organization_tesim'
      attribute :physical_medium,        ::Blacklight::Types::Array, 'physical_medium_tesim'
      attribute :place,                  ::Blacklight::Types::Array, 'place_ssim'
      attribute :place_label,            ::Blacklight::Types::Array, 'place_label_ssim'
      attribute :related_resource,       ::Blacklight::Types::Array, 'related_resource_ssim'
      attribute :resource_type,          ::Blacklight::Types::Array, 'resource_type_tesim'
      attribute :rights_statement,       ::Blacklight::Types::Array, 'rights_statement_ssim'
      attribute :rights_statement_label, ::Blacklight::Types::Array, 'rights_statement_label_ssim'
      attribute :source,                 ::Blacklight::Types::Array, 'source_tesim'
      attribute :sponsor,                ::Blacklight::Types::Array, 'sponsor_tesim'
      attribute :subject,                ::Blacklight::Types::Array, 'subject_tesim'
      attribute :subtitle,               ::Blacklight::Types::Array, 'subtitle_tesim'
      attribute :title,                  ::Blacklight::Types::Array, 'title_tesim'
      attribute :title_alternative,      ::Blacklight::Types::Array, 'title_alternative_tesim'
    end
    # rubocop:enable Metrics/BlockLength

    module ClassMethods
      def attribute(name, type, field)
        define_method name do
          type.coerce(self[field])
        end
      end
    end
  end
end
