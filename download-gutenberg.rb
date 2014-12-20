#!/usr/bin/env ruby

require 'nokogiri'

low = ARGV[0]
high = ARGV[1]

low.upto high do |i|
  offset_url = "http://www.gutenberg.org/robot/harvest?offset=#{i}&filetypes\[\]=txt"
  offset_file_name = "#{i}.html"
  curl_cmd = "curl #{offset_url} -o #{offset_file_name}"
  curl_ok = system curl_cmd
  if (curl_ok)
    download_books_from(offset_file_name)
  else
    puts "curl failed for offset: #{i}"
  end
end

