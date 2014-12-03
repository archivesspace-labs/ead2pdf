#!/usr/bin/env jruby

require 'rubygems'

require "#{File.expand_path(File.dirname(__FILE__))}/../lib/AS_fop" 

ead_file = ARGV[0]
output = ARGV[1]

xslt = ARGV[2] 

if xslt
  ASFop.new(ead_file, output, xslt).to_pdf
elsif ead_file and output
  ASFop.new(ead_file, output).to_pdf
else
  puts "EAD2PDF"
  puts "Usage: java -jar ead2pdf.jar EAD_FILENAME OUTPUT_PDF_FILENAME [ XSLT_FILENAME ( optional ) ] "
end

