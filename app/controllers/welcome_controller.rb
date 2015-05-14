require 'mylastfm'
class WelcomeController < ApplicationController

  def index

    if !params['search'].nil?
      limit=10
      @artist_hash = lastfm_connection.get_search_from_artist(params['search'],'page'=>params[:page],'limit'=>limit)
      puts @artist_hash
      @search_term= @artist_hash['results']['opensearch:Query']['searchTerms']
      @total_results=@artist_hash['results']['opensearch:totalResults']
      @no_of_pages=@total_results.to_i / limit
      @artist_list=@artist_hash['results']['artistmatches']['artist']

      if user_signed_in?
        search=SearchHistory.find_or_initialize_by(user: current_user,keyword:params['search'])
        search.update_attributes(updated_at:Time.now)
        search.save!
      end
    end
  end

  def show
    if params['name']
      @artist_info=lastfm_connection.get_getinfo_from_artist(params['name'])
      @artist_basic_info=@artist_info['artist']
      @artist_suggestions=@artist_info['artist']['similar']['artist']
      if @artist_suggestions.is_a?(Hash)
        @artist_suggestions=[@artist_suggestions]
      end
      @artist_tags=@artist_info['artist']['tags']['tag']
      if @artist_tags.is_a?(Hash)
        @artist_tags=[@artist_tags]
      end
      @artist_bio=@artist_info['artist']['bio']
      @artist_top_tracks=lastfm_connection.get_gettoptracks_from_artist(params['name'],:limit => 5)
      @artist_top_tracks_info=@artist_top_tracks['toptracks']['track']
      if @artist_top_tracks_info.is_a?(Hash)
        @artist_top_tracks_info=[@artist_top_tracks_info]
      end

    end
  end

  def search_history
    @search_history=SearchHistory.where(user: current_user)
  end
  private
  def lastfm_connection
    api_key=ENV['API_KEY']
    if !api_key.nil?
      LastFM.connect(api_key)
    end
  end
end
