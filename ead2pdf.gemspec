Gem::Specification.new do |s|
  s.name             = 'ead2pdf'
  s.version          = '0.0.3'

  s.authors          = ['Chris Fitzpatrick']
  s.date             = '2014-12-02'
  s.description      = 'Export EADs into PDFs'
  s.homepage         = 'http://archivesspace.org'
  s.require_paths    = ['lib','bin']
  s.rubygems_version = '1.8.24'
  s.summary          = 'EADs into PDFs'
  s.add_runtime_dependency 'saxon-xslt'
  s.files            = Dir.glob("{bin,lib}/**/*")
  #s.licenses        = ['MIT']

  s.executables      = ['ead2pdf-main.rb']
end
