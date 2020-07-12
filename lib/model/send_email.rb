require 'net/smtp'

class Email
  FROM_EMAIL = ENV['GOOGLE_USERNAME']
  PASSWORD = ENV['GOOGLE_PASS']
  TO_EMAIL = ''

  def user_ia(user_email_address)
    TO_EMAIL.replace(user_email_address)
  end

  def send_email(message_info)
    if message_info.to_s.length < 3
      puts "\nWe couldn't send an email, since we couldn't fetch any results.\n"
      sleep(3)
      Menu.new.run
    else
      smtp = Net::SMTP.new 'smtp.gmail.com', 587
      smtp.enable_starttls
      message = <<~END_OF_MESSAGE
        From: #{FROM_EMAIL}
        To: #{TO_EMAIL}
        MIME-Version: 1.0
        Content-type: text/html
        Subject: Mail From CLI Project
        <p> Here's the info you requested!</p>
        <p>Restaurant name:#{message_info[:title]},</p>
        <p>Restaurant type:#{message_info[:type]},</p>
        <p>Restaurant address:#{message_info[:address]},</p>
        <p>Restaurant's rating is:#{message_info[:rating]}, with a total of #{message_info[:review_count]} reviews so far</p>
      END_OF_MESSAGE

      smtp.start('received-from-goes-here', FROM_EMAIL, PASSWORD, :plain)
      smtp.send_message(message, FROM_EMAIL, TO_EMAIL)
      smtp.finish
  end
  end
end
