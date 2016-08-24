module Ol
  class App < Sinatra::Base
    
    before do
      content_type :json

      @business = Business.new
    end

    get '/' do
      redirect to('/businesses')
    end

    get '/businesses/' do
      redirect to('/businesses')
    end

    # Fetches list of businesses with pagination. Businesses are sorted by id  
    # and default to 50 per page. The page and per_page parameters can be 
    # overriden by passing them in with the request. Output is a JSON object.
    #    /business?page=3
    #    /business?per_page=100
    #    /business?page=3&per_page=100
    get '/businesses' do
      page     = (params['page'] || 1).to_i
      per_page = (params['per_page'] || 50).to_i

      # Make sure per_page is within valid range from 1..total
      unless @business.check_per_page(per_page)
        halt 400, { :error => 
          "Please use a per_page value between 1 and #{@business.total}"
        }.to_json
      end

      # Make sure page being selected is within valid range from 1..total_pages.
      unless @business.check_total_pages(page, per_page)
        halt 400, { :error => 
          "Please use a page value between 1 and #{@business.total_pages(per_page)}"
        }.to_json
      end
      
      # Return all businesses
      @business.get_all_businesses(page, per_page)
    end

    # Fetches specific business. Output is a JSON object.
    get '/businesses/:id' do
      id  = params[:id].to_i

      unless @business.check_business(id)
        @business.get_business(id)
      else
        halt 400, { :error => "No result found for id #{id}" }.to_json
      end
    end

    # Error when no routes are found.
    not_found do
      halt 404, { :error => "Not found" }.to_json
    end

  end
end