# frozen_string_literal: true

# All setup done just call
# TwilioService.new.send_whatsapp_message(to: "+916205244673", "message": "my message")
# will require subscription so skipping it

require 'twilio-ruby'

class TwilioService
  ACCOUNT_SID = ENV['TWILIO_ACCOUNT_SID']
  AUTH_TOKEN  = ENV['TWILIO_AUTH_TOKEN']

  def initialize
    @client = Twilio::REST::Client.new(ACCOUNT_SID, AUTH_TOKEN)
  end

  def send_whatsapp_message(to:, message:)
    return { success: false, error: 'Missing phone number or message' } if to.blank? || message.blank?

    begin
      greeting = "Dear Hiring Team,\n\n"
      subject = "Subject: *React.js*, *Ruby on Rails* or *Fulltack Developer*\n\n"
      text = "I hope you're doing well. I'm currently exploring new opportunities and would greatly appreciate a referral if there are any relevant openings in your organization.\n\n"
      description = "I have *3 years* of experience specializing in *Ruby on Rails*, *JavaScript*, and *ReactJS*. I am passionate about building scalable and efficient applications and would love the opportunity to contribute my skills to a dynamic team.\n\n"
      current_location = "*Current Location*: Gurugram, Haryana\n\n"
      resume = "*Attached Resume* - https://drive.google.com/file/d/1jCbNSuPa_gOjMc7KrPuwlajndeJW3CMv/view?usp=sharing\n\n"
      regards = "I would be grateful for any recommendations or insights you can share. Looking forward to hearing from you!.\n\n Best regards,\n*Pawan Kumar*"

      message = greeting + subject + text + description + current_location + resume + regards
      @client.messages.create(
        from: 'whatsapp:+14155238886',
        to: "whatsapp:#{to}",
        body: message
      )
    rescue Twilio::REST::TwilioError => e
      Rails.logger.error "Twilio Error: #{e.message}"
      { success: false, error: e.message }
    end
  end
end

# TwilioService.new.send_whatsapp_message(to: "+916205244673", "message": "my message", media_url: "https://drive.google.com/file/d/1jCbNSuPa_gOjMc7KrPuwlajndeJW3CMv/view?usp=drive_link")
