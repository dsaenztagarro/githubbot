module Vendors
  module Github
    module Responses
      class Issue
        # @param response [Sawyer::Resource]
        def initialize(response)
          @response = response
        end

        def title
          response['title']
        end
      end
    end
  end
end
