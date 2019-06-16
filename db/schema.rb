# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20190615221125) do

  create_table "domain_names", force: :cascade do |t|
    t.string  "value",           limit: 255, null: false
    t.integer "organization_id", limit: 4
  end

  add_index "domain_names", ["organization_id"], name: "index_domain_names_on_organization_id", using: :btree

  create_table "organizations", force: :cascade do |t|
    t.string  "url",            limit: 255
    t.string  "external_id",    limit: 255
    t.string  "name",           limit: 255
    t.string  "details",        limit: 255
    t.boolean "shared_tickets",             default: false
    t.string  "created_at",     limit: 255
  end

  create_table "tags", force: :cascade do |t|
    t.string  "value",       limit: 255, null: false
    t.integer "source_id",   limit: 4
    t.string  "source_type", limit: 255
  end

  add_index "tags", ["source_id"], name: "index_tags_on_source_id", using: :btree

  create_table "tickets", force: :cascade do |t|
    t.string  "_id",             limit: 255,                   null: false
    t.string  "url",             limit: 255
    t.string  "external_id",     limit: 255
    t.string  "created_at",      limit: 255
    t.string  "type",            limit: 255
    t.string  "subject",         limit: 255
    t.text    "description",     limit: 65535
    t.string  "priority",        limit: 255
    t.string  "status",          limit: 255
    t.integer "submitter_id",    limit: 4
    t.integer "assignee_id",     limit: 4
    t.integer "organization_id", limit: 4
    t.boolean "has_incidents",                 default: false
    t.string  "due_at",          limit: 255
    t.string  "via",             limit: 255
  end

  add_index "tickets", ["assignee_id"], name: "index_tickets_on_assignee_id", using: :btree
  add_index "tickets", ["organization_id"], name: "index_tickets_on_organization_id", using: :btree
  add_index "tickets", ["submitter_id"], name: "index_tickets_on_submitter_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string  "url",             limit: 255
    t.string  "external_id",     limit: 255
    t.string  "name",            limit: 255
    t.string  "alias",           limit: 255
    t.string  "created_at",      limit: 255
    t.boolean "active",                      default: true
    t.boolean "verified",                    default: true
    t.boolean "shared",                      default: false
    t.string  "locale",          limit: 255
    t.string  "timezone",        limit: 255
    t.string  "last_login_at",   limit: 255
    t.string  "email",           limit: 255
    t.string  "phone",           limit: 255
    t.string  "signature",       limit: 255
    t.integer "organization_id", limit: 4
    t.boolean "suspended",                   default: false
    t.string  "role",            limit: 255
  end

  add_index "users", ["organization_id"], name: "index_users_on_organization_id", using: :btree

end
