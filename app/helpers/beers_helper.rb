module BeersHelper
    def beers_update_watchlist(id)
        # Initialize the watch list if it has not been created
        session[:watch_list] ||= "{}"
    
        watch_list = ActiveSupport::JSON.decode(session[:watch_list])
        if not watch_list.include?(id)
          watch_list[id] = 1
        else
          watch_list[id] += 1
        end
        session[:watch_list] = ActiveSupport::JSON.encode(watch_list)
      end
    
    def beers_watchlist_beer_ids
        session[:watch_list] ||= "{}"
        watch_list = ActiveSupport::JSON.decode(session[:watch_list])
        beer_ids = watch_list.map{ |id, count| id }
    end

    def beers_watchlist_empty?
        session[:watch_list].nil? || beers_watchlist_beer_ids.length() == 0
    end
end
