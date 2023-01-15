require 'faraday'

class AdapterRandomWord
  def self.conn
    @@conn ||= Faraday.new(url: ENV['ADAPTER_RANDOM_WORD_URL'], headers: {'Content-Type' => 'application/json'}) do |config|
      config.request :json
      config.response :json
      config.adapter Faraday.default_adapter
    end
  end

  def self.random_word(payload)
    p payload
    body = conn.get('randomWord', payload).body
    # p body
    body['word']
  end
end
