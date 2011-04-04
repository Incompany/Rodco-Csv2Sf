require 'rubygems'
require 'sinatra'
require 'excelsior'
require 'rforce'

set :username , 'salesforce@rodcocr.com'
set :password, 'company1'


get '/' do
  content_type 'text/html', :charset => 'utf-8'
    ENV['SHOWSOAP'] = 'true'

      binding = RForce::Binding.new \
         'https://www.salesforce.com/services/Soap/u/20.0'

       binding.login \
        username , password
   
   rows = []
   
   
    Excelsior::Reader.rows(File.open('/Users/roberto/Proyectos/Rodco/svn/ruby/csv2sf/productos.csv', 'rb')) do |row|
     rows << row
   end


    productos=[]
    rows.each do |producto|
      producto = {:type,'Producto__c',
                  :CodigoExterno__c,    producto[0], 
                  :NombreWeb__c,      producto[1] , 
                  :Descripcion__c , producto[2] }
      productos.push(producto)
    end
      
      
        while productos.length > 0
          upsert = [];
          upsert.push(:externalIDFieldName,'CodigoExterno__c');
          while upsert.length < 390  && productos.length > 0
            upsert.push(:sObjects)
            upsert.push(productos.pop)
          end
          binding.upsert upsert
        end
        
        
      
     
           
   
 

 
end

