class CreateAttendances < ActiveRecord::Migration
  def self.up
    create_table :attendances do |t|
      t.integer :school_id
      t.date :date
      t.integer :enrollment
      t.integer :absent
      t.integer :absent_ili
      t.integer :left_early
      t.integer :left_early_ili
      t.string :enrollment_growth
      t.boolean :closed
      t.boolean :closed_flu
      t.integer :faculty_absent
      t.integer :faculty_absent_ili
      t.text :comments
      t.integer :absentee_report_id
      
      t.timestamps
    end
    
    add_index :attendances, :school_id
    add_index :attendances, :date
    add_index :attendances, [:school_id, :date]
  end

  def self.down
    drop_table :attendances
  end
end
