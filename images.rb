#images.rb
require 'dotenv'
require 'httparty'
require 'shopify_api'
require 'active_record'
require 'sinatra/activerecord'
#require 'logger'
require 'sendgrid-ruby'
require 'sinatra'


Dotenv.load
Dir[File.join(__dir__, 'lib', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'models', '*.rb')].each { |file| require file }

module ImageFix
  class ShopifyGetter
    include SendGrid
    

    def initialize
      @shopname = ENV['SHOPIFY_SHOP_NAME']
      @api_key = ENV['SHOPIFY_API_KEY']
      @password = ENV['SHOPIFY_API_PASSWORD']
      @secret = ENV['SHOPIFY_SHARED_SECRET']
      @app_token = ENV['APP_TOKEN']

      
    end

    def shopify_get_all_resources
   
    puts "Starting all shopify resources download"
    

    puts "#{@shopname}, #{@app_token}"


      ShopifyAPI::Context.setup(
        api_key: "DUMMY",
        api_secret_key: @app_token,
        scope: "DUMMY",
        host_name: "DUMMY",
        private_shop: "#{@shopname}.myshopify.com",
        session_storage: ShopifyAPI::Auth::FileSessionStorage.new,
        is_embedded: false, 
        is_private: true, 
        api_version: "2022-07"
        
      )

      product_count = ShopifyAPI::Product.count()
      puts "product_count = #{product_count.inspect}"

      puts "We have #{product_count.body['count']} products in Store now"


      
      
      num_products = 0

      
      
      client = ShopifyAPI::Clients::Rest::Admin.new()

      response = client.get(path: "products", query: { limit: 250 })

      #puts response.inspect
      
      

      loop do
        
        temp_prods = response.body['products']

        temp_prods.each do |tp|
          puts "***************"
          puts tp['title']
          puts "------------"
          puts tp['images']
          puts "----------"
          num_products += 1

        end

        break unless response.next_page_info
        response =  client.get(path: "products", query: { limit: 250, page_info: response.next_page_info })
      end

      puts "We have download #{num_products} products which matches product_count of #{product_count.body['count']} products"

    end

  end
end