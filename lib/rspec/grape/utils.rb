module RSpec
  module Grape
    module Utils
      HTTP_METHODS = %w[GET HEAD PUT POST DELETE OPTIONS PATCH LINK UNLINK]
      DESCRIPTION_REGEXP = /(#{HTTP_METHODS.join('|')}) \/.*/
      PARAMS_REGEXP = /(\/:([^\/]*))/

      def self.is_description_valid?(description)
        !!(description =~ DESCRIPTION_REGEXP)
      end

      def self.find_endpoint_description(klass)
        ancestors = klass.ancestors.select { |a| a < RSpec::Core::ExampleGroup }
        ancestors = ancestors.select do |a|
          is_description_valid?(a.description)
        end

        raise RSpec::Grape::NoEndpointDescription unless ancestors.any?

        ancestors.first.description
      end

      def self.url_param_names(url)
        url.scan(PARAMS_REGEXP).map { |a| a[1].to_sym }
      end
    end
  end
end
