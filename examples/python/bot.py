import telebot

token = "2044669873:AAF7nlp10LVIOtiNH42F2E5tji2CrWOC_CE"

bot = telebot.TeleBot(token)

@bot.message_handler(content_types=['text'])
def send_echo(message):
 bot.send_message(message.chat.id, "Fucking shit!!! " + message.text)

bot.infinity_polling() 
