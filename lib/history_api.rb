# To change this template, choose Tools | Templates
# and open the template in the editor.

module HistoryApi
  def self.history(param)
     usr = param[:user]
#     commands = usr.commands
     arr = self::create_data(usr.commands)
     output = self::create_hsh(arr)
  end

  def self.history_days_ago(param)
    usr = param[:user]
    arr = param[:attr].split
    x = arr.first.to_i
    arr = self::create_data(usr.commands.where("commands.created_at >= :start_date AND commands.created_at <= :end_date",
                                                                        {:start_date => x.days.ago, :end_date => Time.now}))
    output = self::create_hsh(arr)
#    out = "showing history for #{day} days ago"
  end

  def self.history_weeks_ago(param)
    usr = param[:user]
    arr = param[:attr].split
    x = arr.first.to_i
    arr = self::create_data(usr.commands.where("commands.created_at >= :start_date AND commands.created_at <= :end_date",
                                                                        {:start_date => x.weeks.ago, :end_date => Time.now}))
    output = self::create_hsh(arr)
  end

  def self.history_hours_ago(param)
    usr = param[:user]
    arr = param[:attr].split
    x = arr.first.to_i
    arr = self::create_data(usr.commands.where("commands.created_at >= :start_date AND commands.created_at <= :end_date",
                                                                        {:start_date => x.hours.ago, :end_date => Time.now}))
   output = self::create_hsh(arr)
  end

  def self.history_months_ago(param)
    usr = param[:user]
    arr = param[:attr].split
    x = arr.first.to_i
    arr = self::create_data(usr.commands.where("commands.created_at >= :start_date AND commands.created_at <= :end_date",
                                                                        {:start_date => x.months.ago, :end_date => Time.now}))
    output = self::create_hsh(arr)
  end

  private

  def self.create_data(inputs)
     arr = []
    inputs.find_each do |i|
      hsh =  {}
      hsh[:name] = i.name
      hsh[:date] = i.created_at
      arr << hsh
    end
     arr.sort {|x,y| y[:date] <=> x[:date] }
#     arr
  end

  def self.create_hsh(data)
    output = {}
    output[:data] = data
    output[:partial] = 'history_result'
    output
  end


 
end
