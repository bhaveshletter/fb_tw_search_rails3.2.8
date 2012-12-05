require 'cgi'
class SearchController < ApplicationController

  def search
    if request.xhr?
    	unless params[:search_cont].nil?
        @search_cont = CGI::escape(params[:search_cont])
        if params[:prev] != "0"          
          @pg = params[:prev].to_i
          @pg_prev = @pg
          unless $fb_search_glob["data"].blank?
            uri_fb = URI.parse($fb_search_glob["paging"]["previous"])
            @fb_search = $fb_search_glob = MultiJson.decode(open(uri_fb).read)
          else
            @fb_search = { "data" => [] }
          end
        elsif params[:next] != "0"          
          @pg = params[:next].to_i
          @pg_next = @pg+=1
          unless $fb_search_glob["data"].blank?
            uri_fb = URI.parse($fb_search_glob["paging"]["next"])
            @fb_search = $fb_search_glob = MultiJson.decode(open(uri_fb).read)
          else
            @fb_search = { "data" => [] }
          end
        else
          @pg = 1
          #uri_fb = URI.parse("https://graph.facebook.com/search?q=#{@search_cont}&limit=5")
          uri_fb = URI.parse("https://graph.facebook.com/search?q=#{@search_cont}")
          @fb_search = $fb_search_glob = MultiJson.decode(open(uri_fb).read)
        end
    	  #uri_tw = URI.parse("http://search.twitter.com/search.json?q=#{@search_cont}&page=#{@pg}&rpp=5")
        uri_tw = URI.parse("http://search.twitter.com/search.json?q=#{@search_cont}&page=#{@pg}")
        @tw_search = MultiJson.decode(open(uri_tw).read)
        @pg = @pg_prev.nil? ? (@pg_next.nil? ? @pg : @pg_next) : @pg_prev
        respond_to do |format|
          format.js { }
        end
    	end
    end
  end

end
