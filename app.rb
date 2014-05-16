require 'sinatra/base'
require 'business_time'
require 'open-uri'
require 'json'
require 'holiday_calendar'

class Countdowner < Sinatra::Base

  get '/' do
    'Hello world!'
  end

  post '/' do
    msg = params[:msg]
    today = Date.today
    end_date = Date.parse(params[:date])
    en = HolidayCalendar.load(:uk)
    item = { "value" => "#{en.count_working_days_between(today, end_date)}", "text" => "business days #{msg}" }
    result item
  end

  post '/pull-requests' do
    repo = params[:repo]
    github = 'https://api.github.com/repos/ministryofjustice'
    pull_requests = open("#{github}/#{repo}/pulls").read
    pr_result JSON.parse(pull_requests).count
  end

  private

  def result item
    {"item" => [{}, item, {}] }.to_json
  end

  def pr_result count
    item = { "value" => "#{count}", "text" => "open pull requests" }
    format = case count
             when 0
               [{}, {}, item]
             when 1..2
               [{}, item, {}]
             else
               [item, {}, {}]
             end
    { "item" => format }.to_json
  end
end
