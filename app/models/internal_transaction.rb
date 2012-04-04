class InternalTransaction < ActiveRecord::Base
  belongs_to :payment  
  belongs_to :external_payment
  belongs_to :user    
end