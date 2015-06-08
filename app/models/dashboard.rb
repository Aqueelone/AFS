# create_table :dashboards, force: :cascade do |t|
#   t.integer  :user_id
#   t.integer  :messenger_id
#   t.datetime :created_at,   null: false
#   t.datetime :updated_at,   null: false
# end

class Dashboard < ActiveRecord::Base
belongs_to :user
end
