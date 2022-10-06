require 'dotenv'
require 'active_record'
require 'shopify_api'
require 'sinatra/activerecord/rake'

require_relative 'images'

#require 'active_record/railties/databases.rake'

Dotenv.load


namespace :pull_shopify do
    desc 'Pull down all Marika products and Images'
    task :get_products do |t|
       
        ImageFix::ShopifyGetter.new.shopify_get_all_resources
    end

end