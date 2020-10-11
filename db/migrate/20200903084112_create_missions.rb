class CreateMissions < ActiveRecord::Migration[6.0]
  def change
    create_table :missions do |t|
      t.integer :user_id
      t.text    :content
      t.string  :penalty
      t.datetime   :deadline
      t.integer :completed
      t.timestamps
    end
  end
end


