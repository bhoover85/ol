module Ol
  class App < Sinatra::Base
    attr_accessor :page
    
    db  = 'db/businesses.sqlite3'
    csv = 'files/50k_businesses.csv'
    
    before do
      content_type :json

      # Create db from input CSV (unless it already exists) and grab the dataset
      @dataset = DB.new(db, csv).dataset
    end

    get '/' do
      redirect to('/businesses')
    end

    # Fetches list of businesses with pagination. Businesses are sorted by id and 
    # default to 50 businesses per page. The page and per_page parameters can be 
    # overridden by passing them in with the request. Output is JSON object.
    #    /business?page=3
    #    /business?per_page=100
    #    /business?page=3&per_page=100
    get '/businesses' do
      page     = (params['page'] || 1).to_i
      per_page = (params['per_page'] || 50).to_i
      
      # Get total count of rows and make sure per_page is within valid range 
      # from 1..total.
      total = @dataset.count

      unless per_page.between?(1, total)
        halt 400, 
          { :error => "Please use a per_page value between 1 and #{total}"
          }.to_json
      end

      # Make sure page being selected is within valid range from 1..total_pages.
      # Get list of businesses sorted by id and paginated.
      total_pages = (total/per_page).ceil
      
      if page.between?(1, total_pages)
        businesses = @dataset.order(:id).extension(:pagination)
                      .paginate(page, per_page)

        # Add metadata and return JSON response.
        { :page => page, :per_page => per_page, :total => total, 
          :total_pages => total_pages, :businesses => businesses.to_a
        }.to_json
      else
        halt 400, 
          { :error => "Please use a page value between 1 and #{total_pages}"
          }.to_json
      end
    end

    # Fetches specific business. Output is JSON object.
    get '/businesses/:id' do
      id  = params[:id].to_i

      # Make sure row being selected exists and return JSON response.
      unless @dataset[:id => id].nil?
        @dataset[:id => id].to_json
      else
        halt 400,
        { :error => "No result found for id #{id}"
        }.to_json
      end
    end

    # Error when no routes are found.
    not_found do
      halt 404, { :error => "Not found" }.to_json
    end

  end
end