require 'mylastfm'
class DashboardController < ApplicationController

  before_action :authenticate_user!

  def index
    api_key=ENV['API_KEY']
    if api_key.nil?
      api_key='XXXXXXXXXXXX'
    end
    connection = LastFM.connect(api_key)
    # album.search
    # artist.search
    # tag.search
    # track.search
    # venue.search
    if !params['search'].nil?
      limit=50
      @artist_hash = connection.get_search_from_artist(params['search'],'page'=>params[:page],'limit'=>limit)
      puts @artist_hash
      @search_term= @artist_hash['results']['opensearch:Query']['searchTerms']
      @total_results=@artist_hash['results']['opensearch:totalResults']
      @no_of_pages=@total_results.to_i / limit
      @artist_list=@artist_hash['results']['artistmatches']['artist']
    end

  end

end
