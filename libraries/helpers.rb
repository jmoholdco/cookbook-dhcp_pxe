module DhcpPxeCookbook
  module Helpers
    def valid_domain_regex
      /\S+\.(#{tld_list.join('|')})$/
    end

    private

    def tld_list
      @list ||= File.read(
        File.expand_path('../../files/default/tlds.txt', __FILE__)
      ).split("\n").drop_while { |a| a =~ /^#/ }
      @list.map(&:downcase)
    end
  end
end
