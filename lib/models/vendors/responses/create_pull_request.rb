module Vendors
  module Responses
    class CreatePullRequest
      attr_reader :status, :error

      def initialize(status:, args:, local_repo:, platform_repo:, response:, error:)
        @status = status
        @args = args
        @local_repo = local_repo
        @platform_repo = platform_repo
        @response = response
        @error = error
      end

      def as_json
        { args: @args,
          local_repo: @local_repo.as_json,
          platform_repo: @platform_repo.as_json,
          response: @response.as_json }
      end
    end
  end
end
