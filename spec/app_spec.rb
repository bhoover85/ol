require 'spec_helper'

describe 'App' do
  include Rack::Test::Methods

  def app
    Ol::App
  end

  let(:db)      { 'db/test.sqlite3' }
  let(:csv)     { 'files/5k_businesses.csv' }
  let(:dataset) { Ol::DB.new(db, csv).dataset }
  let(:total)   { dataset.count }

  it 'selects csv file' do
    expect(File).to exist(csv)
  end

  describe 'get /' do
    it 'redirects to /businesses' do
      get '/'
      expect(last_response).to be_redirect
      expect(last_response.location).to include '/businesses'
    end
  end

  describe 'get /businesses' do
    context 'without parameters' do
      let(:page)       { 1 }
      let(:per_page)   { 50 }
      let(:businesses) { dataset.order(:id).extension(:pagination)
                      .paginate(page, per_page) }

      it 'gets a list of businesses' do
        get '/businesses'
        expect(businesses).to_not be_nil
      end
      
      it 'returns a json object' do
        get '/businesses'
        expect(last_response).to be_json
      end

      it 'does not return an error' do
        get '/businesses'
        expect(last_response.body).to_not match(/error/)
      end
    end

    context 'with all parameters' do
      context 'in valid range' do
        let(:page)       { 1 }
        let(:per_page)   { 50 }
        let(:businesses) { dataset.order(:id).extension(:pagination)
                        .paginate(page, per_page) }

        it 'gets a list of businesses' do
          get '/businesses', { :page => page, :per_page => per_page }
          expect(businesses).to_not be_nil
        end

        it 'returns a json object' do
          get '/businesses'
          expect(last_response).to be_json
        end

        it 'does not return an error' do
          get '/businesses'
          expect(last_response.body).to_not match(/error/)
        end
      end
    end

    context 'with parameter' do
      context 'page not in valid range' do
        let(:page)     { 0 }
        let(:per_page) { 50 }

        it 'returns an error' do
          get '/businesses', { :page => page, :per_page => per_page }
          expect(last_response.body).to match(/error/)
        end
      end

      context 'per_page not in valid range' do
        let(:page)     { 1 }
        let(:per_page) { 0 }

        it 'returns an error' do
          get '/businesses', { :page => page, :per_page => per_page }
          expect(last_response.body).to match(/error/)
        end
      end
    end
  end

  describe 'get /businesses/:id' do
    context 'with a valid id' do
      let(:id) { 0 }
      let(:business) { dataset[:id => id] }
      
      it 'returns a business' do
        get '/businesses/:id'
        expect(business).to_not be_nil
      end
    end

    context 'with an invalid id' do
      it 'returns an error' do
        get '/businesses/-1'
        expect(last_response.body).to match(/error/)
      end
    end
  end
end