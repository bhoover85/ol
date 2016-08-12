module Ol
  class DB
    attr_accessor :dataset

    # Initializes the database, matching columns from the CSV.
    def initialize(db, csv)
      # Create the db and set up the table + columns, unless it already exists.
      FileUtils.mkdir_p('db')

      unless File.exist?(db)
        @dataset = Sequel.sqlite(db)

        @dataset.create_table :businesses do
          primary_key :id
          String      :uuid
          String      :name
          String      :address
          String      :address2
          String      :city
          String      :state, :size=>2
          String      :zip,   :size=>5
          String      :country
          Integer     :phone, :size=>10
          String      :website
          DateTime    :created_at
        end

        # Populate the db with CSV data.
        populate_db(db, csv)
      end

      # Select the db and return the dataset.
      @dataset = Sequel.sqlite(db)
      @dataset = @dataset[:businesses]
    end

    # Populates the database with CSV data. It is much faster to map the CSV to 
    # a hash and use Sequel's multi_insert rather than reading and inserting the 
    # CSV line by line.
    def populate_db(db, csv)
      begin
        data = CSV.open(csv, :headers => true).map { |x| x.to_h }
      rescue
        retry
      end
      
      @dataset[:businesses].multi_insert(data)
    end
  end
end