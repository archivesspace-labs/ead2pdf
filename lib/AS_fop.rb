require 'java'
require 'saxon-xslt'
require 'stringio'

Dir.glob("#{File.expand_path(File.dirname(__FILE__))}/../lib/*.jar").each do |jar|
  require jar
end

java_import Java::org::apache::fop::apps::FopFactory
java_import Java::org::apache::fop::apps::Fop
java_import Java::org::apache::fop::apps::MimeConstants



class ASFop

  import javax.xml.transform.stream.StreamSource
  import javax.xml.transform.TransformerFactory
  import javax.xml.transform.sax.SAXResult 


  attr_accessor :source
  attr_accessor :xslt

  def initialize(source, output= nil,  xslt = File.join( File.dirname(__FILE__), '../lib' ,'as-ead-pdf.xsl')  )
    abort("#{source} not found") unless File.exists?(source) 
    puts source
    puts output
   @source = source 
   @xml = IO.read(source)
   @output = output.nil? ? "#{source}.pdf" : output 
   
   @xslt = File.read( xslt, system_id: File.join( File.dirname(__FILE__), '../lib' ,'as-ead-pdf.xsl') )
   # WHAT A HACK! but you can't pass in a URI as a variable? jeezus.  
   # @xslt.gsub!('<xsl:include href="as-helper-functions.xsl"/>', "<xsl:include href='#{File.join(File.dirname(__FILE__), '../lib', 'as-helper-functions.xsl')}'/>" ) 
  end


  def to_fo
    transformer = Saxon.XSLT(@xslt)
    transformer.transform(Saxon.XML(@xml)).to_s
  end

  def to_pdf
    begin 
      fo = StringIO.new(to_fo).to_inputstream  
      
      out = File.new(@output, 'w') 
      fop = FopFactory.newInstance.newFop(MimeConstants::MIME_PDF, out.to_outputstream)
      
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
