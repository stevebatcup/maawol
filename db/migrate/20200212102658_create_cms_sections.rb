class CreateCmsSections < ActiveRecord::Migration[5.2]
  def change
    create_table :cms_sections do |t|
  		t.belongs_to	:page, index: true
  		t.belongs_to	:content_block, index: true
  		t.integer	:sort

      t.timestamps
    end
  end
end
