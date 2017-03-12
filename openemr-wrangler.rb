#!/bin/ruby

# Listen for changes in a MySQL db
# When a change is detected, wrangle data into a blockchain ledger

require 'mysql2'
require 'excon'
require 'json'

# this takes a hash of options, almost all of which map directly
# to the familiar database.yml in rails
# See http://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/MysqlAdapter.html

last_index_value = 61

client = Mysql2::Client.new(:host => "localhost", :port => "3306", :username => "root", :password => "0cretog1", :database => "openemr")

# connection = Excon.new(
# 'http://ce018849.ngrok.io/mineblock',
# :instrumentor => ActiveSupport::Notifications
# )

while true

    result = client.query("SELECT COUNT(*) FROM log")

    current_index_value = result.to_a.first.values.first

    if current_index_value > last_index_value

        data = client.query("SELECT height, weight, BMI, bps, bpd, temperature, date FROM form_vitals ORDER BY date DESC LIMIT 2")

        current = data.to_a.first
        previous = data.to_a.last

        current.merge!(previous)

        # same = current & previous
        #
        # same.each { |x| current.reject! { |elem| elem == x} }

        Excon.post('http://ce01884d.ngrok.io/mineblock', :body => {:data => current}.to_json, :headers => { "Content-Type" => "application/json" });

    end

last_index_value = current_index_value

sleep 5

end
