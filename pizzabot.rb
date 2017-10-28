require 'discordrb'
require 'timers'
require 'yaml'

# Pizzabot by TopKek

CONFIG = OpenStruct.new YAML.load_file 'config.yaml'
bot = Discordrb::Commands::CommandBot.new token: CONFIG.token, client_id: CONFIG.client_id, prefix: CONFIG.prefix
timers = Timers::Group.new


bot.ready do |event|
    puts bot.invite_url
    pizza = false
    event.bot.game = CONFIG.game

    pizzatime = timers.every(Random.rand(5000..8000)) {
        channeltest = bot.find_channel('pizza', type: 0)
        channeltest.each do |chan|
            puts chan.id
            time = Time.now
            thour = '%02d' % time.hour
            tmin = '%02d' % time.min
            begin
                bot.send_file(chan.id, File.new( 'papa1.jpg' ), caption: "It's #{thour}:#{tmin} so its pizza time!!!!!")
            rescue Discordrb::Errors::NoPermission
                puts "Mamma mia! I don't have permission to send to the pizza channel of server: #{chan.server.name} with serverid of: #{chan.server.id} and channelid of: #{chan.id}"
            end
        end
    }
    
    loop { timers.wait }
end


bot.command(:ping) do |event|
    ping = Time.now - event.timestamp
    pingr = ping * 1000
    "Pizza here! `#{pingr.round} ms`"
end

bot.command(:invite) do |event|
    bot.send_file(event.channel.id, File.new( 'papa2.jpg' ), caption: "Mamma mia! It's not pizza time in your server yet?!? "\
    "Invite the bot with:\n<#{bot.invite_url}>\nand make a text channel called pizza!")
end

bot.command(:kill) do |event|
    break if event.user.id != CONFIG.owner
    event.respond "No more pizza time :("
    exit
end

bot.run
