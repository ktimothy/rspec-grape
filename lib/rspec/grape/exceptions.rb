module RSpec
  module Grape
    class NoEndpointDescription < StandardError
      def message; 'Endpoint description like \'METHOD /path/to/endpoint\' is not found!'; end
    end

    class UrlParameterNotSet < StandardError
      def message; 'Url parameter is not defined!'; end
    end

    class UrlIsNotParameterized < StandardError
      def message; 'Url has no parameters'; end
    end
  end
end
