module Vendors
  class Platform
    class << self
      MAPPINGS = {
        'github.com' => 'Github'
      }.freeze

      def for_url(url)
        platform_name = MAPPINGS[hostname_for(url)]
        klass_name = Vendors.const_get("#{platform_name}::Platform")
        klass_name.new
      end

      def hostname_for(url)
        match = /git@(?<hostname>.*):(.*).git/.match(url)
        match['hostname']
      end
    end
  end
end
