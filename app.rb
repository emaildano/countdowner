require 'sinatra/base'
require 'business_time'
require 'open-uri'
require 'json'
require 'holiday_calendar'

class Countdowner < Sinatra::Base

  get '/until/:date/:msg' do
    msg = params[:msg]
    days = business_days_until(params[:date])
    item = {
      value: days,
      text: "business days #{msg}"
    }
    result item
  end

  get '/days_until/:date/:title' do
    days = business_days_until(params[:date])

    item = {
      text: %Q|<div class="widget widget-countdown assessment" data-end="16-Jun-2014 13:00:00" data-title="Alpha Assessment" data-id="assessment">
      <h1 class="title" data-bind="title">#{params[:title]}</h1>
      <h2 class="countdown-time" data-bind="timeleft">#{days}</h2>
    </div>|,
      type: 0
    }
    result item
  end

  get '/pulls/:repo' do
    repo = params[:repo]
    github = 'https://api.github.com/repos/ministryofjustice'
    pull_requests = open("#{github}/#{repo}/pulls").read
    pr_result JSON.parse(pull_requests).count
  end

  private

  def business_days_until date
    today = Date.today
    end_date = Date.parse(date)
    en = HolidayCalendar.load(:uk)
    days = en.count_working_days_between(today, end_date)
  end

  def result item
    { "item" => [item] }.to_json
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
