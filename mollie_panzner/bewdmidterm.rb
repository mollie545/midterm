
require 'pry'
require 'rest-client'
require 'json'
 
puts 'Which kind of cultral institution would you like to search?'
requested_institution = gets.strip
 
# Define the URL that we want to fetch, put .json at end of URL in browser to view JSON
url = "https://data.cityofnewyork.us/api/views/733r-da8r/rows.json"
 
# Fetch the URL and store it in a variable called response
# Essentially went to google chrome asked for specific variable and got response returned back to us
response = RestClient.get(url)
 
# Convert the response from javascript object notation to Ruby
parsed_response = JSON.parse(response)

columns = parsed_response['meta']['view']['columns'].map do |column|
  column['name']
end

cultural_institutions = parsed_response['data'].map do |institution|
  hash = {}
  columns.each_with_index do |column, i|
    hash[column] = institution[i]
  end
  hash
end

filtered_institutions = cultural_institutions.select do |institution|
  institution['Organization Name'].downcase.include? requested_institution.downcase
end

#here's a list of results that i have not yet defined contents of
results = []

# iterate through all filtered_institutions
filtered_institutions.each do |filtered_institution|

  # Let's create two variables:
  # 1. name, which will access the 'Organization Name' attribute from the hash
  name = filtered_institution["Organization Name"]

  # 2. address, which will access the 'Preferred...' attribute from the hash
  address = filtered_institution["Preferred Address Line 1"]

  # This line create a new hash result to hold two keys: :name, :address and
  result = {name: name, address: address}

  # Lastly, this line will add the new hash into the empty `results` array
  results << result

end

# Let's check our work, this will iterate over each of the posts and display
results.each do |result|
  puts "Name: #{result[:name]}"
  puts "Address: #{result[:address]}"
  puts
end
