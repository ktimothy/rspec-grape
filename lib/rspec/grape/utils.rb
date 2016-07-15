module RSpec
  module Grape
    module Utils
      HTTP_METHODS = %w[GET HEAD PUT POST DELETE OPTIONS PATCH LINK UNLINK]
      REGEXP = /(#{HTTP_METHODS.join('|')}) \/.*/

      def self.is_description_valid?(description)
        !!(description =~ REGEXP)
      end

      def self.find_endpoint_description(klass)
        ancestors = klass.ancestors.select { |a| a < RSpec::Core::ExampleGroup }
        ancestors = ancestors.select do |a|
          is_description_valid?(a.description)
        end

        raise RSpec::Grape::NoEndpointDescription unless ancestors.any?

        ancestors.last.description
      end
    end
  end
end
