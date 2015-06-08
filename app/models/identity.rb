# create_table :identities, force: :cascade do |t|
#   t.integer  :user_id
#   t.string   :provider
#   t.string   :uid
#   t.datetime :created_at, null: false
#   t.datetime :updated_at, null: false
# end
#
# add_index :identities, [:user_id], name: :index_identities_on_user_id, using: :btree

class Identity < ActiveRecord::Base
  belongs_to :user
  validates :uid, :provider, :presence => true
  validates_uniqueness_of :uid, :scope => :provider

  def self.find_for_oauth(auth)
    find_or_create_by(uid: auth.uid, provider: auth.provider)
  end
end
