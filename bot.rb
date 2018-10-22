require 'telegram_bot'

# read token from token file
token_file = File.open("verry_secret_token.sec")
token = '' + token_file.gets(45)

# creating and running bot
bot = TelegramBot.new(token: token)
bot.get_updates(fail_silently: true) do |message|
	puts "@#{message.from.username}: #{message.text}"
	command = message.get_command_for(bot)

	message.reply do |reply|
	case command
	when /start/i
		reply.text = "Ich zähle Brötchen! mit 'p' kannst du dir ein Brötchen bestellen, mit 'm' bestellst du es wieder ab."
	when /hilfe/i
		reply.text = "Ich zähle Brötchen! mit 'p' kannst du dir ein Brötchen bestellen, mit 'm' bestellst du es wieder ab."
	when /show/i
		reply.text = "Ich zähle Brötchen! mit 'p' kannst du dir ein Brötchen bestellen, mit 'm' bestellst du es wieder ab."
	when /p/i
		reply.text = "Ein Brötchen für #{message.from.first_name}(#{message.from.id})."
	else
		reply.text = "WTF"
	end
	puts "sending #{reply.text.inspect} to @#{message.from.username}"
	reply.send_with(bot)
	end
end
