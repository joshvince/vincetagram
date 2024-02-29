# frozen_string_literal: true

class AddSequenceToPosts < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      ALTER TABLE posts ADD COLUMN seq INTEGER;
      ALTER SEQUENCE post_seq OWNED BY posts.seq;
      ALTER TABLE posts ALTER COLUMN seq SET DEFAULT nextval('post_seq');
    SQL
  end

  def down
    execute <<-SQL
      ALTER SEQUENCE post_seq OWNED BY NONE;
      ALTER TABLE posts ALTER COLUMN seq SET NOT NULL;
    SQL
  end
end
