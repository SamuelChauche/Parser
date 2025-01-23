# frozen_string_literal: true
require 'mechanize'
require 'nokogiri'

class MairieScraper # rubocop:disable Style/Documentation
  BASE_URL = 'https://lannuaire.service-public.fr'

  # Liste des URLs pour chaque page de mairies
  VAL_DOISE_PAGES = [
    "#{BASE_URL}/navigation/ile-de-france/val-d-oise/mairie",
    "#{BASE_URL}/navigation/ile-de-france/val-d-oise/mairie?page=2",
    "#{BASE_URL}/navigation/ile-de-france/val-d-oise/mairie?page=3",
    "#{BASE_URL}/navigation/ile-de-france/val-d-oise/mairie?page=4",
    "#{BASE_URL}/navigation/ile-de-france/val-d-oise/mairie?page=5",
    "#{BASE_URL}/navigation/ile-de-france/val-d-oise/mairie?page=6",
    "#{BASE_URL}/navigation/ile-de-france/val-d-oise/mairie?page=7"
  ].freeze

  # Méthode pour récupérer les URLs des mairies sur une page donnée
  def self.get_townhall_urls(page) # rubocop:disable Metrics/MethodLength
    townhall_data = []
    links = page.search('//*[@id="main"]/div/div/div/article/div[3]/ul/li/div/div/p/a')

    if links.empty?
      puts 'Aucun lien trouvé sur cette page.'
    else
      links.each do |link|
        town_name = link.text.strip # Extraire le nom de la mairie
        town_url = link['href'] # Extraire l'URL de la mairie
        townhall_data << { name: town_name, url: town_url }
      end
    end

    townhall_data
  end

  # Méthode pour récupérer l'email d'une mairie à partir de son URL
  def self.get_townhall_email(townhall) # rubocop:disable Metrics/MethodLength
    agent = Mechanize.new
    page = agent.get(townhall[:url])
    email_element = page.at('//*[@id="contentContactEmail"]/span[2]/a')

    if email_element
      email = email_element.text.strip
      puts "Email trouvé pour la mairie de #{townhall[:name]} : #{email}"
      { name: townhall[:name], email: email }
    else
      puts "Aucun email trouvé pour la mairie de #{townhall[:name]}"
      { name: townhall[:name], email: nil }
    end
  end

  # Méthode pour récupérer toutes les mairies et leurs emails à partir des pages spécifiées
  def self.get_all_townhall_emails # rubocop:disable Metrics/MethodLength,Naming/AccessorMethodName
    agent = Mechanize.new
    townhall_emails = []

    VAL_DOISE_PAGES.each do |page_url|
      puts "Page chargée : #{page_url}"

      # Charger la page depuis l'URL dans VAL_DOISE_PAGES
      page = agent.get(page_url)

      # Récupérer les URLs des mairies depuis la page actuelle
      townhall_data = get_townhall_urls(page)
      townhall_data.each do |townhall|
        result = get_townhall_email(townhall)
        townhall_emails << result if result[:email] # Ajouter uniquement si un email est trouvé
      end
    end

    townhall_emails
  end
end

# Exécution du programme principal
townhall_emails = MairieScraper.get_all_townhall_emails

# Sauvegarder les résultats dans un fichier texte
File.open('emails_mairies.txt', 'w') do |file|
  file.puts '=== LISTE DES MAIRIES ET LEURS EMAILS ==='
  townhall_emails.each do |entry|
    file.puts "#{entry[:name]}: #{entry[:email]}"
  end
end

puts "Les résultats ont été sauvegardés dans le fichier 'emails_mairies.txt'."
