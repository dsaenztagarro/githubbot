module Vendors
  module Github
    module Responses
      class CreatePullRequest
        # @param resource [Sawyer::Resource]
        def initialize(resource)
          @resource = resource
        end

        private attr_reader :resource

        public

        def title
          resource[:title]
        end

        def body
          resource[:body]
        end

        def source_branch
          resource[:head][:ref]
        end

        def target_branch
          resource[:base][:ref]
        end

        def html_url
          resource[:_links][:html]
        end

        def as_json
          {
            title: title,
            body: body,
            source_branch: source_branch,
            target_branch: target_branch,
            name: name,
            html_url: html_url
          }
        end
      end
    end
  end
end
