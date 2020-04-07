class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.string :name, index: true
      t.text :description
      t.timestamps
    end

    create_table :categories_lessons, id: false do |t|
      t.belongs_to :category, index: true
    	t.belongs_to :lesson, index: true
    end
  end
end
