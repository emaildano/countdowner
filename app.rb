require 'sinatra/base'
require 'business_time'
require 'open-uri'
require 'json'
require 'holiday_calendar'
require 'pivotal-tracker'

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

  get '/days_until/:date/:title/:style' do
    days = business_days_until(params[:date])

    item = {
      text: %Q|<div class="widget widget-countdown #{params[:style]}">
      <h1 class="title" data-bind="title">#{params[:title]}</h1>
      <h2 class="countdown-time" data-bind="timeleft">#{days} day#{days > 1 ? 's' : ''}</h2>
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

  get '/pivotal/accepted-stories/:project_id' do
    project_id = params[:project_id]
    PivotalTracker::Client.token = ENV['PIVOTAL']
    pro = PivotalTracker::Project.find(project_id)
    accepted_stories PivotalTracker::Iteration.current(pro)
  end

  private

  def business_days_until date
    today = Date.today
    end_date = Date.parse(date)
    en = HolidayCalendar.load(:uk)
    days = en.count_working_days_between(today, end_date)
  end

  def accepted_stories sprint
    stories = sprint.stories.map(&:current_state)
    max = stories.count
    accepted = stories.count("accepted")

    { "item" => "#{accepted}",
      "max"  => { "text" => "Max stories", "value" => "#{max}" },
      "min"  => { "text" => "Min stories", "value" => "0" }
    }.to_json
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
