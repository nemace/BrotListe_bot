require 'telegram_bot'
require 'sqlite3'

# read token from token file
token_file = File.open("verry_secret_token.sec")
token = token_file.gets(45)

# open database
db = SQLite3::Database.new("database.db")
puts db.get_first_value("SELECT SQLITE_VERSION()")

db.execute("CREATE TABLE IF NOT EXISTS Brote(BenutzerId INT PRIMARY KEY, Name TEXT, Anzahl INT)")
db.execute("CREATE TABLE IF NOT EXISTS Log(NachrichtId INT PRIMARY KEY, Von TEXT, Datum INT, Befehl TEXT)")

stm = db.prepare("SELECT Anzahl FROM Brote WHERE BenutzerId=?")

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
		reply.text = "Ein Brötchen mehr für #{message.from.first_name}(#{message.from.id})."
		stm.bind_param(1,message.from.id)
		if (value = stm.execute())
			value = value + 1
		else
			value = 1
		end
		puts value
	when /m/i
		reply.text = "Ein Brötchen weniger für #{message.from.first_name}(#{message.from.id})."
	else
		reply.text = "Was #{command}, du Hurensohn?"
	end
	puts "sending #{reply.text.inspect} to @#{message.from.username}"
	reply.send_with(bot)
	end
end
