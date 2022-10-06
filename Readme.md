# Using shopify_api gem in Private App to pull Products or Other Resources
You want/need to run a private app on your Shopify store using the gem 'shopify-api' and the documentation is iffy and all the code you used in versions 9.5 or earlier now breaks. This will get you up and running. You can run this on a local machine, remotely on a server, or container. With a few mods you can get it running on AWS Lambda (you will need a custom Ruby runtime though look for another GIST soon on that subject).

## Details on setup
You will need to initialize your connection differently, the code below works (Mac OSX Big Sur 11.6 and Debian "Buster" with Ruby 3.1.2 for both operating systems):

```ruby
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
```
See the initialize method for mapping the @app_token and @shopname variables to the .env file, example below:


![example .env file](https://github.com/FLWallace105/shopify_private_app_demo/blob/master/image_folder/new_env_file_image.png?raw=true)


## WARNING
You cannot use your old apps that were created before Shopify's recent changes. You WILL need the "app_token" which is new from Shopify, and shown only once when you create a private app under their new system. Your old apps will still work (for now) but it is likely you will at some point need to change them. Make sure you save your app token somewhere safe!

## Connection Basics
Once you have your connection set up, this is how you get all the products, not the ".next_page?" and ".fetch_next_page" methods for the version 9.5 and below versions of the gem no longer work.

```ruby
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
```

That's pretty much it. You can now fetch products beyond the 250 limit with no issues, grab resources and do things with them. The file "images.rb" called from a Rake task will simply print the product's title and the image information. You can redirect to a file and then look for various URL patterns. [This was originally written to find how many images had .JPG as extensions instead of .jpg .]

Hopefully this can save someone time.