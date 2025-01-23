# frozen_string_literal: true

require 'pry'
require 'dotenv'
require 'rubygems'
require 'nokogiri'
require 'open-uri'

#récupération de la page 
def scrape_coinmarketcap # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
  url = 'https://coinmarketcap.com/all/views/all/'
  doc = Nokogiri::HTML(URI.open(url))

  # Utilisation des chemins XPath 
  names = doc.xpath('//*[@id="__next"]/div[2]/div[2]/div/div[1]/div/div[2]/div[3]/div/table/tbody/tr/td[3]').map(&:text)
  prices = doc.xpath('//*[@id="__next"]/div[2]/div[2]/div/div[1]/div/div[2]/div[3]/div/table/tbody/tr/td[5]').map(&:text)

  results = []
#triage des cryptos
  names.each_with_index do |name, index|
    results << { name: name, price: prices[index] }
  end
  results.first(20)
end
#mise en page 
crypto_data = scrape_coinmarketcap
crypto_data.each do |result|
  puts "Name: #{result[:name]}, Price: #{result[:price]}"
end

scrape_coinmarketcap
