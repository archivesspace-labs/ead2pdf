require 'java'
require 'stringio'

Dir.glob("#{File.expand_path(File.dirname(__FILE__))}/../lib/*.jar").each do |jar|
  require jar
end

require 'saxon-xslt'

java_import Java::org::apache::fop::apps::FopFactory
java_import Java::org::apache::fop::apps::Fop
java_import Java::org::apache::fop::apps::MimeConstants



class ASFop

  import javax.xml.transform.stream.StreamSource
  import javax.xml.transform.TransformerFactory
  import javax.xml.transform.sax.SAXResult 


  attr_accessor :source
  attr_accessor :xslt
  attr_accessor :file

  def initialize(source, output= nil,  xslt = nil )
   abort("#{source} not found") unless File.exists?(source) 
    puts "source XML=#{source}"
    puts "output=#{output}"
   @source = source 
   @xml = IO.read(source)
   @output = output.nil? ? "#{source}.pdf" : output 
   @file = xslt
   
   if xslt.nil?
    @file =File.join( File.dirname(__FILE__) ,'as-ead-pdf.xsl').gsub("\\", "/" ) 
    @xslt = File.read( file, system_id: @file )
   else
    @xslt = File.read( xslt ) 
   end

   @file = "jar:file:" + file if @file =~ /\.jar!/  # it seems to need this prefix to resolve from jarfile
   puts "xsl=#{@file}"
  
  end


  def to_fo
    transformer = Saxon.XSLT(@xslt, system_id: @file )
    transformer.transform(Saxon.XML(@xml)).to_s
  end

  def to_pdf
    begin 
      fo = StringIO.new(to_fo).to_inputstream  
      
      out = File.new(@output, 'w')
      fopfac = FopFactory.newInstance
      baseurl=File.dirname(File.dirname(@file))
      puts "BaseURL=#{baseurl}"
      fopfac.setBaseURL( baseurl ) # Need to set BaseURL to resolve images from jarfile
      fop = fopfac.newFop(MimeConstants::MIME_PDF, out.to_outputstream)
      
      transformer = TransformerFactory.newInstance.newTransformer()
      res = SAXResult.new(fop.getDefaultHandler)

      transformer.transform(StreamSource.new(fo), res)
      puts "PDF created for #{@source} at #{@output}" 
    ensure
      out.rewind 
      out.close
    
    end 
       
  end

end
