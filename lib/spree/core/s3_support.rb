# frozen_string_literal: true

module Spree
  module Core
    # This module exists to reduce duplication in S3 settings between
    # the Image and Taxon models in Spree
    module S3Support
      extend ActiveSupport::Concern

      included do
        def self.supports_s3(field)
          if Spree::Config[:use_s3]
            set_attachment_attributes(field)
          else
            attachment_definitions[field].delete(:storage)
          end
        end

        def self.set_attachment_attribute_for(field, attribute_name, attribute_value)
          attachment_definitions[field][attribute_name] = attribute_value
        end

        def self.set_attachment_attributes(field)
          set_attachment_attribute_for(field, :storage, :s3)
          set_attachment_attribute_for(field, :s3_credentials, s3_credentials)
          set_attachment_attribute_for(
            field, :s3_headers, ActiveSupport::JSON.decode(Spree::Config[:s3_headers])
          )
          set_attachment_attribute_for(field, :bucket, Spree::Config[:s3_bucket])
          if config[:s3_protocol].present?
            set_attachment_attribute_for(field, :s3_protocol, Spree::Config[:s3_protocol].downcase)
          end

          # We use :s3_alias_url (virtual host url style) and set the URL on property s3_host_alias
          set_attachment_attribute_for(field, :s3_host_alias, ENV['ATTACHMENT_URL'])
          set_attachment_attribute_for(field, :url, ':s3_alias_url')
        end
        private_class_method :set_attachment_attributes

        def self.s3_credentials
          { access_key_id: Spree::Config[:s3_access_key],
            secret_access_key: Spree::Config[:s3_secret],
            bucket: Spree::Config[:s3_bucket] }
        end
        private_class_method :s3_credentials
      end
    end
  end
end
