class CreateSkillLevels < ActiveRecord::Migration[5.0]
  def change
    create_table :skill_levels do |t|
      t.string :name
      t.timestamps
    end

    create_table :courses_skill_levels, id: false do |t|
      t.belongs_to :course, index: true
    	t.belongs_to :skill_level, index: true
    end

  end
end
