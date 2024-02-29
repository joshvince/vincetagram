# frozen_string_literal: true

class CreatePostSequence < ActiveRecord::Migration[7.0]
  def up
    execute 'CREATE SEQUENCE post_seq;'
  end

  def down
    execute 'DROP SEQUENCE post_seq;'
  end
end
