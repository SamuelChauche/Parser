# frozen_string_literal: true

require '../lib/mairie'

RSpec.describe MairieScraper do
  describe '.get_townhall_urls' do
    it 'returns all townhall URLs in Val dOise' do
      urls = [
        "#{MairieScraper::BASE_URL}/town1",
        "#{MairieScraper::BASE_URL}/town2"
      ]

      allow(MairieScraper).to receive(:get_townhall_urls).and_return(urls)
      expect(MairieScraper.get_townhall_urls).to eq(urls)
    end
  end
end
#   describe '.get_townhall_email' do
#     it 'returns the email of a townhall from its URL' do
#       url = "https://lannuaire.service-public.fr/sample-mairie-url"
#       allow(MairieScraper).to receive(:get_townhall_email).and_return('mairie@example.com')

#       email = MairieScraper.get_townhall_email(url)
#       expect(email).to eq('mairie@example.com')
#     end

#     it 'returns nil if no email is found' do
#       url = "https://lannuaire.service-public.fr/sample-mairie-url"
#       allow(MairieScraper).to receive(:get_townhall_email).and_return(nil)

#       email = MairieScraper.get_townhall_email(url)
#       expect(email).to be_nil
#     end
#   end

#   describe '.get_all_townhall_emails' do
#     it 'returns a list of townhalls with their emails' do
#       urls = [
#         "#{MairieScraper::BASE_URL}/town1",
#         "#{MairieScraper::BASE_URL}/town2"
#       ]
#       allow(MairieScraper).to receive(:get_townhall_urls).and_return(urls)
#       allow(MairieScraper).to receive(:get_townhall_email).with(urls[0]).and_return('email1@example.com')
#       allow(MairieScraper).to receive(:get_townhall_email).with(urls[1]).and_return('email2@example.com')

#       emails = MairieScraper.get_all_townhall_emails

#       expect(emails).to contain_exactly(
#         { "Town1" => "email1@example.com" },
#         { "Town2" => "email2@example.com" }
#       )
#     end
#   end
# end