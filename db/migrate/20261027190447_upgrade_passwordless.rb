# frozen_string_literal: true

# Schema changes from https://github.com/mikker/passwordless/blob/master/docs/upgrading_to_1_0.md
# Removed columns come back nullable on rollback, since existing rows have no values for them.
class UpgradePasswordless < ActiveRecord::Migration[8.1]
  def change
    add_column :passwordless_sessions, :token_digest, :string
    add_index :passwordless_sessions, :token_digest
    remove_column :passwordless_sessions, :token, :string

    add_column :passwordless_sessions, :identifier, :string
    add_index :passwordless_sessions, :identifier, unique: true

    remove_column :passwordless_sessions, :user_agent, :text
    remove_column :passwordless_sessions, :remote_addr, :string
  end
end
