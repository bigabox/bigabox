ActiveAdmin.register CurrencyCode do
  # menu :parent => "Setting",:priority => 6
  menu false
  
  controller do
  
    def new
    @currency_code=CurrencyCode.new
    end
    
  end

end
