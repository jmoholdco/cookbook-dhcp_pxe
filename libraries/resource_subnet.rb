require 'chef/resource'
require 'chef/mixin/securable'

class Chef
  class Resource
    class DhcpSubnet < Chef::Resource
      include Chef::Mixin::Securable
      include DhcpPxeCookbook::Helpers

      default_action :create
      allowed_actions :create, :modify, :remove

      def initialize(name, run_context = nil)
        super
        @subnet_id = name
        @authoritative = true
      end

      def domain(arg = nil)
        set_or_return(
          :domain,
          arg,
          kind_of: String,
          regex: valid_domain_regex
        )
      end

      def name_servers(arg = nil)
        set_or_return(
          :name_servers,
          arg,
          kind_of: [Array, String]
        )
      end

      def max_lease_time(arg = nil)
        set_or_return(
          :max_lease_time,
          arg,
          kind_of: [String, Fixnum],
          default: '7200'
        )
      end

      def default_lease_time(arg = nil)
        set_or_return(
          :default_lease_time,
          arg,
          kind_of: [String, Fixnum],
          default: '600'
        )
      end

      def authoritative(arg = nil)
        set_or_return(
          :authoritative,
          arg,
          kind_of: [TrueClass, FalseClass],
          default: true
        )
      end

      def subnet_id(arg = nil)
        set_or_return(
          :subnet_id,
          arg,
          kind_of: String
        )
      end
    end
  end
end
