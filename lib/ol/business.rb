module Ol
  class Business
    attr_accessor :dataset

    def initialize
      db  = 'db/businesses.sqlite3'
      csv = 'files/50k_businesses.csv'
      
      # Create db from input CSV (unless it already exists) and grab the dataset
      @dataset = DB.new(db, csv).dataset
    end

    def get_all_businesses(page, per_page)
      businesses = @dataset.order(:id).extension(:pagination)
                    .paginate(page, per_page)

      # Add metadata and return JSON response.
      { :page => page, :per_page => per_page, :total => total, 
        :total_pages => total_pages(per_page), :businesses => businesses.to_a
      }.to_json
    end

    def get_business(id)
      @dataset[:id => id].to_json
    end

    def check_business(id)
      @dataset[:id => id].nil?
    end
    
    def check_per_page(per_page)
      per_page.between?(1, self.total)
    end
    
    def check_total_pages(page, per_page)
      page.between?(1, self.total_pages(per_page))
    end

    def total
      @dataset.count
    end

    def total_pages(per_page)
      (total/per_page).ceil
    end

  end
end