#!/usr/bin/env ruby

require 'nokogiri'
require 'open-uri'

low = ARGV[0]
high = ARGV[1]
def download url, file_name
  cmd = "curl #{url} -s -o #{file_name}"
  code = system cmd
  if (!code) 
    puts "could not download #{file_name}"
  else 
    # puts "downloaded #{file_name}"
  end
  return code
end
def download_books_from u
  puts "processing list #{u}"
  doc = Nokogiri::HTML(open(u))
  doc.xpath("//p/a[@href]").each do |book_url|
    url = book_url.text.chomp
    fn_index = url.rindex "/"
    if fn_index
      file_name = url[fn_index + 1, url.length]
      unless File.exists? file_name
        c = download url, file_name
      end
      code = system "unzip #{file_name} -d txtbooks" # unzip regardless
    else
    end
  end
end
low.upto high do |i|
  offset_url = "http://www.gutenberg.org/robot/harvest?offset=#{i}"
  download_books_from(offset_url)
end
