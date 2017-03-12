#!/bin/ruby

require 'mysql2'

# this takes a hash of options, almost all of which map directly
# to the familiar database.yml in rails
# See http://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/MysqlAdapter.html

last_index_value = 42

client = Mysql2::Client.new(:host => "localhost", :port => "3306", :username => "root", :password => "0cretog1", :database => "openemr")

while true

    result = client.query("SELECT COUNT(*) FROM log")

    current_index_value = result.to_a.first.values.first

    if current_index_value > last_index_value

        data = client.query("SELECT height, weight, BMI, bps, bpd, temperature FROM form_vitals")

        data_array = data.to_a

        data_array.each_with_index {|val, index| puts "Wrangle #{val} => #{index} into the blockchain. " }

    end

last_index_value = current_index_value

sleep 5

end
