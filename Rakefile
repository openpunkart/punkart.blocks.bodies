require 'hoe'
require './lib/csvrecord/version.rb'

Hoe.spec 'csvrecord' do

  self.version = CsvRecord::VERSION

  self.summary = "csvrecord - read in comma-separated values (csv) records with typed structs / schemas"
  self.description = summary

  self.urls = ['https://github.com/csv11/csvrecord']

  self.author = 'Gerald Bauer'
  self.email = 'wwwmake@googlegroups.com'

  # switch extension to .markdown for gihub formatting
  self.readme_file  = 'README.md'
  self.history_file = 'HISTORY.md'

  self.extra_deps = [
     ['record',     '>=1.1.1'],
     ['csvreader',  '>=0.3.0']
   ]

  self.licenses = ['Public Domain']

  self.spec_extras = {
   :required_ruby_version => '>= 2.2.2'
  }

end
