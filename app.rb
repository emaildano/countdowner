require 'sinatra/base'
require 'business_time'

class Countdowner < Sinatra::Base

  get '/' do
    'Hello world!'
  end

  post '/' do
    msg = params[:msg]
    today = Date.today
    end_date = Date.parse(params[:date])
    item = { "value" => "#{today.business_days_until(end_date)}}", "text" => "#{msg}" }
    {"root" => {"item" => [{}, item, {}] } }.to_json
  end
end
