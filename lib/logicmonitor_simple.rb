#!/usr/bin/env ruby
#
# Simple LogicMonitor API library
#
# Author: Michael Mittelstadt (<meek@getsatisfaction.com>)
# Version: 0.1.0
#
# Usage:
#
# lm = Logicmonitor::Simple.new("yourdomain", "username", "password")
#
# hg = lm.get_host_groups()
# web_hosts = lm.get_hosts("host_group_id" => 123)
#
# all arguments and names are taken from the LogicMonitor API (http://help.logicmonitor.com/developers-guide/),
# with camelCase changed to snake_case for both method and argument names

require 'awrence'
require 'curb'
require 'multi_json'


class Logicmonitor
    class Simple
        def initialize(domain, username, password)
            @domain   = domain
            @username = username
            @password = password
            @cookies  = []
            self.sign_in({ 'c' => @domain, 'u' => @username, 'p' => @password })
        end

        def method_missing(method, *args)
            method = method.to_s.split('_').each_with_index.map { |e,i| i>0 ? e.capitalize : e }.join
            http_args = args[0].to_camelback_keys.map do |k,v|
              if v.is_a? Array
                  v = v.join(',')
              end
              "#{k}=#{v}"
            end.join('&') rescue []
            g = Curl.get("https://#{@domain}.logicmonitor.com/santaba/rpc/#{method}?#{http_args}") do |http|
                if @cookies.size > 0
                    http.headers['Cookie'] = @cookies.join('; ')
                end
            end

            if @cookies.empty?
                @cookies = g.header_str.scan(/^Set-Cookie: ([^\r]+)?\r/m)
            end

            if g.status.to_i > 399
                raise "Received unexpected HTTP status #{g.status} Response Body: #{g.body_str}"
            end

            res = MultiJson.load(g.body_str) or raise Logicmonitor::Simple::Error "Received invalid JSON from LogicMonitor"
            if res['status'] && res['status'].to_i > 200
                raise "Error from LogicMonitor - #{res['errmsg']}"
            end
            res
        end
    end
end
