class DashboardsController < ApplicationController

  def index

  end
  
  private
  def process_feed(raw_feed)
    users = raw_feed.profiles.inject({}) do |hash, user|
      hash[user.uid] = user
      hash
    end
    groups = raw_feed.groups.inject({}) do |hash, group|
      hash[group.gid] = group
      hash
    end
    
    raw_feed.items.map do |item|
      if item.source_id > 0
        item.source = users[item.source_id]
      else
        item.source = groups[-item.source_id]
      end
      
      item
    end
  end
end
