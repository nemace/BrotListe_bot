require 'telegram_bot'
require 'sqlite3'

# read token from token file
token_file = File.open("verry_secret_token.sec")
token = token_file.gets(45)

# open database
db = SQLite3::Database.new("database.db")
puts db.get_first_value("SELECT SQLITE_VERSION()")

db.execute("CREATE TABLE IF NOT EXISTS Log(NachrichtId INT PRIMARY KEY, BenutzerId INT, Von TEXT, Datum INT, Befehl TEXT, Gekauft BIT)")
# Select Count(NachrichtId) From 

# creating and running bot
bot = TelegramBot.new(token: token)
bot.get_updates(fail_silently: true) do |message|
	puts "@#{message.from.username}: #{message.text}"
	command = message.get_command_for(bot)

	message.reply do |reply|
	case command
	when /start/i
		reply.text = "Ich zähle Brötchen! mit 'bestellen' kannst du dir ein Brötchen bestellen, mit 'abbestellen' bestellst du es wieder ab. Und jetzt lass mich wieder in Ruhe"
	when /hilfe/i
		reply.text = "Ich zähle Brötchen! mit 'bestellen' kannst du dir ein Brötchen bestellen, mit 'abbestellen' bestellst du es wieder ab. Und jetzt lass mich wieder in Ruhe"
	when /bezahlen/i
		anzahl_broetchen = db.get_first_value("SELECT Count(BenutzerId) FROM Log WHERE BenutzerId=#{message.from.id}")
		reply.text = "#{message.from.first_name}, bezahl gefälligst deine #{anzahl_broetchen} Brötchen, aber zügig!"
	when /kaufen/i
		anzahl_einkauf = db.get_first_value("SELECT Count(BenutzerId) FROM Log WHERE Datum > #{message.date.to_time.to_i-24*3600} AND Gekauft=0")
		reply.text = "Ey #{message.from.first_name}, heute müssen #{anzahl_einkauf} Brötchen gekauft werden"
	when /gekauft/i
		db.execute("UPDATE Log SET Gekauft=1")
		reply.text = "Nächstes mal bitte schneller! \xF0\x9F\x99\x84"
	when /bestellen/i
		db.execute("INSERT INTO Log VALUES(#{message.id},#{message.from.id},'#{message.from.first_name}',#{message.date.to_time.to_i},'p',0)")
		reply.text = "Ein Brötchen mehr für #{message.from.first_name}"
	when /abbestellen/i
		reply.text = "Geh und stirb, abbestellt wird hier nicht!"
	else
		reply.text = "Was #{command}, du Hurensohn?"
	end
	puts "sending #{reply.text.inspect} to @#{message.from.username}"
	reply.send_with(bot)
	end
end
