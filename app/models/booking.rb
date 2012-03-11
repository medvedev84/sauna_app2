class Booking < ActiveRecord::Base    
	belongs_to :sauna
	has_one :payment
	has_many :sms_messages,
			:dependent => :destroy	
  
	scope :before, lambda {|end_time| {:conditions => ["ends_at < ?", Booking.format_date(end_time)] }}
	scope :after, lambda {|start_time| {:conditions => ["starts_at > ?", Booking.format_date(start_time)] }}

	
	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	number_regex = /^[\d]+([\d]+){0,1}$/
	
	validates :fio, :presence => true                
	validates :phone_number, :presence => true, :length   => { :maximum => 11 },  :format   => { :with => number_regex }				
	validates :email, :presence => true,
                    :format   => { :with => email_regex }						
  
  # need to override the json view to return what full_calendar is expecting.
  # http://arshaw.com/fullcalendar/docs/event_data/Event_Object/
  def as_json(options = {})
    {
      :id => self.id,
      :title => self.fio,
      :description => self.description || "",
      :start => starts_at.rfc822,
      :end => ends_at.rfc822,
	  :allDay => false,
      :recurring => false,
      :url => Rails.application.routes.url_helpers.booking_path(id)  
    }    
  end	
    
  def self.format_date(date_time)
    Time.at(date_time.to_i).to_formatted_s(:db)
  end  
end
