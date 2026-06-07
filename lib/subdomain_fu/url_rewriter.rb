require 'action_dispatch/routing/route_set'

module SubdomainFuUrlForMonkeyPatch
  def url_for(options, route_name = nil, url_strategy = UNKNOWN, method_name = nil, reserved = ActionDispatch::Routing::RouteSet::RESERVED_OPTIONS)
    if SubdomainFu.needs_rewrite?(options[:subdomain], (options[:host] || (@request && @request.host_with_port))) || options[:only_path] == false
      options[:only_path] = false if SubdomainFu.override_only_path?
      options[:host] = SubdomainFu.rewrite_host_for_subdomains(options.delete(:subdomain), options[:host] || (@request && @request.host_with_port))
    else
      options.delete(:subdomain)
    end

    super(options, route_name, url_strategy, method_name, reserved)
  end
end

module ActionDispatch
  module Routing
    class RouteSet #:nodoc:
      prepend SubdomainFuUrlForMonkeyPatch
    end
  end
end
