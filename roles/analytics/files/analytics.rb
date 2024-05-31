#!/usr/bin/env ruby
# frozen_string_literal: true

# Original script: https://github.com/woodruffw/snippets/blob/master/vbnla/vbnla
# Taken from: https://blog.yossarian.net/2023/12/24/You-dont-need-analytics-on-your-blog#fnref:browser

require "json"
require "net/http"
require "uri"

IGNORE_PATTERNS = ["/robots.txt",
                    "*hub?access_token*",
                    "/api*",
                    "/login",
                    "/ocs/v2.php*",
                    "/remote.php/dav/*",
                    "/favicon.ico",
                    "/.env",
                    "/.git*",
                    "/sitemap.xml"]

LOGFORMAT = /
  (?<ip>.+)
  \s
  -
  \s
  (?<user>.+)
  \s
  \[(?<time>.+)\]
  \s
  "(?<method>\S+)\s(?<req>\S+)\s(?<proto>\S+)"
  \s
  (?<stat>\d{3})
  \s
  (?<size>\d+)
  \s
  "(?<ref>.*)"
  \s
  "(?<ua>.*)"
/x.freeze

N = ENV.fetch("N", 10).to_i

def pretty_print(hist)
  hist.to_a.max_by(N, &:last).map { |e| "#{e[0]} -> #{e[1]}" }.join("\n\t")
end

def pretty_print_ip(hist)
  hist.to_a.max_by(N, &:last).map do |e|
    country = country_of(e[0])
    "#{e[0]} (#{country}) -> #{e[1]}"
  end.join("\n\t")
end

def country_of(ip_address)
  response = Net::HTTP.get_response(URI("https://ipapi.co/#{ip_address}/country/"))
  return "Unknown" unless response.is_a?(Net::HTTPSuccess)
  response.body.strip
end

hist = Hash.new { |hash, key| hash[key] = Hash.new(0) }
lines = 1

$stdin.each_line do |line|
  lines += 1
  hsh = LOGFORMAT.match(line).named_captures rescue next

  hsh["ref"] = "No Referrers" if hsh["ref"] == "-"

  hsh.each do |k, v|
    hist[k][v] += 1
  end
end

hist["req"].reject! { |req| IGNORE_PATTERNS.any? { |pat| File.fnmatch?(pat, req) } }

puts <<~SUMMARY
  Total requests: #{lines}
  Unique IPs: #{hist["ip"].size}
  Top #{N} IPs:
  \t#{pretty_print_ip(hist["ip"])}

  Top #{N} UAs:
  \t#{pretty_print(hist["ua"])}

  Top #{N} requests:
  \t#{pretty_print(hist["req"])}

  Top #{N} referrers:
  \t#{pretty_print(hist["ref"])}
SUMMARY
