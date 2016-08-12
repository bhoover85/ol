require 'spec_helper'

describe 'DB' do
  include Rack::Test::Methods

  def app
    Ol::App
  end

  let(:db)      { 'db/test.sqlite3' }
  let(:csv)     { 'files/5k_businesses.csv' }
  let(:dataset) { Ol::DB.new(db, csv).dataset }

  describe 'initialize' do
    it 'creates the db' do
      expect(File).to exist(db)
    end
  end

  describe 'populate_db' do
    it 'populates db with csv data' do
      expect(dataset).to_not be_nil
    end
  end
end