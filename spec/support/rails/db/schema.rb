ActiveRecord::Schema.define do
  self.verbose = false

  create_table :users do |t|
    t.string :name
  end

  create_table :posts do |t|
    t.integer :user_id
    t.string :title
    t.timestamps
  end

end
