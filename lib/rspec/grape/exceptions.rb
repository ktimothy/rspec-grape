module RSpec
  module Grape
    class NoEndpointDescription < StandardError
      def message; 'Endpoint description like \'METHOD /path/to/endpoint\' is not found!'; end
    end
  end
end
