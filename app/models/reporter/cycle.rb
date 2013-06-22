module Reporter 
  module Cycle
    def report_today
      report_daily(Date.today)
    end

    def report_daily(which_day)
      daily(which_day) do |options|
        report_from_record(options)
      end
    end

    def report_monthly_from_record(first_day_of_the_month)
      monthly(first_day_of_the_month) do |options|
        report_from_record(options)
      end
    end

    def report_weekly(monday_of_the_week)
      weekly(monday_of_the_week) do |options|
        report_from_daily(options)
      end
    end

    def report_monthly(first_day_of_the_month)
      monthly(first_day_of_the_month) do |options|
        report_from_daily(options)
      end
    end

    def report_yearly(first_day_of_the_year)
      monthly(first_day_of_the_year) do |options|
        report_from_daily(options)
      end
    end

    def weekly_from_day_to_day(from_day,to_day)
      monday_of_from_week = from_day.beginning_of_week
      monday_of_to_week = to_day.beginning_of_week

      begin 
        report_weekly(monday_of_from_week)
        monday_of_from_week = monday_of_from_week.next_week
      end while monday_of_from_week <= monday_of_to_week
    end

    def report_from_record(options)
      puts "report_daily_from_record should be overwrited !!"
    end

    private

    def daily(which_day)
      options = {
        micro: :daily,
        from_at: which_day.beginning_of_day,
        to_at: which_day.end_of_day
      }
      yield options
      #need log
    end

    def weekly(monday_of_the_week)
      options = {
        micro: :weekly,
        from_at: monday_of_the_week.beginning_of_day,
        to_at: monday_of_the_week.end_of_week.end_of_day,
      }
      yield options
    end

    def monthly(first_day_of_the_month)
      options = {
        micro: :monthly,
        from_at: first_day_of_the_month.beginning_of_month.beginning_of_day,
        to_at: first_day_of_the_month.end_of_month.end_of_day,
      }
      yield options
    end

    def yearly(first_day_of_the_year)
      options = {
        micro: :yearly,
        from_at: first_day_of_the_year.beginning_of_year.beginning_of_day,
        to_at: first_day_of_the_year.end_of_month.end_of_year.end_of_day,
      }
      yield options
    end
  end
end
