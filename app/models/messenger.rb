# create_table :messengers, force: :cascade do |t|
#   t.datetime :created_at, null: false
#   t.datetime :updated_at, null: false
# end

class Messenger < ActiveRecord::Base
belongs_to :dashboard

end
