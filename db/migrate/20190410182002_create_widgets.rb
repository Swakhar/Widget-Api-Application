class CreateWidgets < ActiveRecord::Migration[5.1]
  def change
    create_table :widgets do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.string :kind, null: false
      t.references :user,
                   foreign_key: { to_table: :users },
                   index: true,
                   null: false
    end
  end
end
