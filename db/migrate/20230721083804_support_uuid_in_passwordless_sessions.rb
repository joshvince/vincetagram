# frozen_string_literal: true

class SupportUuidInPasswordlessSessions < ActiveRecord::Migration[7.0]
  def change
    if index_exists? :authenticatable_type,
                     :authenticatable_id
      remove_index :passwordless_sessions,
                   column: %i[authenticatable_type authenticatable_id]
    end
    remove_column :passwordless_sessions, :authenticatable_id
    add_column :passwordless_sessions, :authenticatable_id, :uuid
    add_index :passwordless_sessions, %i[authenticatable_type authenticatable_id], name: 'authenticatable'
  end
end
