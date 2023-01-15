class CreateTableGameSession < ActiveRecord::Migration[7.0]
  def change
    create_table :game_sessions, id: :uuid do |t|
      t.string :current_progress
      t.string :used_letters
      t.string :answer
      t.integer :lives
      t.timestamps
    end
  end
end
