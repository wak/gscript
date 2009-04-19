# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090411123850) do

  create_table "actions", :force => true do |t|
    t.string   "iname",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "actor_actions", :force => true do |t|
    t.integer  "actor_id",   :null => false
    t.integer  "action_id",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "actor_categories", :force => true do |t|
    t.integer  "actor_id",    :null => false
    t.integer  "category_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "actors", :force => true do |t|
    t.string   "login",                      :null => false
    t.string   "name",       :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "iname",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "g_files", :force => true do |t|
    t.integer  "actor_id",                            :null => false
    t.integer  "size",                                :null => false
    t.string   "content_type",                        :null => false
    t.string   "filename",     :default => "no_name", :null => false
    t.integer  "db_file_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.integer  "actor_id",                    :null => false
    t.string   "iname",                       :null => false
    t.string   "name",       :default => "",  :null => false
    t.integer  "ivalue",     :default => 0,   :null => false
    t.string   "svalue",     :default => "",  :null => false
    t.string   "value_type", :default => "i", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "readies", :force => true do |t|
    t.integer  "actor_id",   :null => false
    t.text     "_selection", :null => false
    t.string   "action",     :null => false
    t.text     "gscript",    :null => false
    t.text     "message",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
