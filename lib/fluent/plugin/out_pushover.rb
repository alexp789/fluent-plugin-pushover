class Fluent::PushoverOutput < Fluent::Output
  Fluent::Plugin.register_output('pushover', self)

  config_param :account_token, :string
  config_param :user_key, :string
  config_param :priority, :integer

  PUSHOVER_ENDPOINT = 'https://api.pushover.net/1/messages.json'

  # Define `log` method for v0.10.42 or earlier
  unless method_defined?(:log)
    define_method("log") { $log }
  end

  def initialize
    super
    require 'uri'
    require 'net/http'
  end

  def configure(conf)
    super

  end

  def emit(tag, es, chain)
    es.each do |time, record|
      send(record)
    end

    chain.next
  end

  def send(message)
    begin
      response = Net::HTTP.post_form(URI.parse(PUSHOVER_ENDPOINT), {'token' => @account_token, 'user' => @user_key, 'priority' => priority, 'message' => message})
    rescue => e
      log.error "Pushover error: #{e.message}"
    end
  end
end
