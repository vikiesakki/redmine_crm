ActiveRecord::Schema.define version: 0 do

  create_table :attachments, force: true do |t|
    t.integer :container_id
    t.string :container_type, limit: 30
    t.string :filename, default: "", null: false
    t.string :disk_filename, default: "", null: false
    t.bigint :filesize, default: 0, null: false
    t.string :content_type, default: ""
    t.string :digest, limit: 64, default: "", null: false
    t.integer :downloads, default: 0, null: false
    t.integer :author_id, default: 0, null: false
    t.timestamp :created_on
    t.string :description
    t.string :disk_directory
  end

  create_table :drafts, force: true do |t|
    t.string :target_type
    t.integer :target_id
    t.references :project
    t.references :user
    t.references :parent, polymorphic: true
    t.binary :data
    t.datetime :updated_at
  end

  create_table "tags", :force => true do |t|
    t.column "name", :string
  end

  create_table "taggings", :force => true do |t|
    t.column "tag_id", :integer
    t.column "taggable_id", :integer
    t.column "taggable_type", :string
    t.column "created_at", :datetime
  end

  create_table "users", :force => true do |t|
    t.column "name", :string
    t.column "language", :string
  end

  create_table "issue_relations", :force => true do |t|
    t.column "issue_from_id", :integer
    t.column "issue_to_id", :integer
    t.column "relation_type", :string
    t.column "delay", :integer
  end

  create_table "issues", :force => true do |t|
    t.integer  "project_id"
    t.column "subject", :string
    t.column "description", :string
    t.column "closed", :boolean
    t.column "cached_tag_list", :string
    t.column "user_id", :integer
    t.column "author_id", :integer
    t.column "views", :integer, :default => 0
    t.column "total_views", :integer, :default => 0
  end

  create_table "votes", :force => true do |t|
    t.references "votable", :polymorphic => true
    t.references "voter", :polymorphic => true

    t.boolean "vote_flag"
    t.string "vote_scope"
    t.integer "vote_weight"
    t.string "vote_ip"

    t.timestamps
  end

  create_table "news", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "author_id"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "identifier"
    t.integer  "status"
  end

  create_table :voters, :force => true do |t|
    t.string :name
  end

  create_table :not_voters, :force => true do |t|
    t.string :name
  end

  create_table :votables, :force => true do |t|
    t.string :name
  end

  create_table :votable_voters, :force => true do |t|
    t.string :name
  end

  create_table :sti_votables, :force => true do |t|
    t.string :name
    t.string :type
  end

  create_table :sti_not_votables, :force => true do |t|
    t.string :name
    t.string :type
  end

  create_table :not_votables, :force => true do |t|
    t.string :name
  end

  create_table :votable_caches, :force => true do |t|
    t.string :name
    t.integer :cached_votes_total
    t.integer :cached_votes_score
    t.integer :cached_votes_up
    t.integer :cached_votes_down
    t.integer :cached_weighted_total
    t.integer :cached_weighted_score
    t.float :cached_weighted_average

    t.integer :cached_scoped_test_votes_total
    t.integer :cached_scoped_test_votes_score
    t.integer :cached_scoped_test_votes_up
    t.integer :cached_scoped_test_votes_down
    t.integer :cached_scoped_weighted_total
    t.integer :cached_scoped_weighted_score
    t.float :cached_scoped_weighted_average
  end

  create_table :viewings, :force => true do |t|
    t.column :viewer_id,   :integer
    t.column :viewed_id,   :integer
    t.column :viewed_type, :string
    t.column :ip, :string, :limit => '24'
    t.column :created_at, :datetime
  end
end
