require 'sinatra'
require 'net/smtp'

get '/mailer' do

  message = <<-END.split("\n").map!(&:strip).join("\n")
  From: Private Person <from@mailtrap.io>
  To: A Test User <to@mailtrap.io>
  Subject: Hello world!

  This is a test message from audience stream.
  END

  Net::SMTP.start('mailtrap.io',
                2525,
                'mailtrap.io',
                '30203e90b0e47a600', '04ac6b5291528c', :cram_md5) do |smtp|
  smtp.send_message message, 'to@mailtrap.io',
                             'from@mailtrap.io'
  end
end