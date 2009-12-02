class CreateIliReports < ActiveRecord::Migration
  def self.up
    create_table :ili_reports do |t|
      t.integer :school_id
      t.string :temperature
      t.date :onset_date
      t.boolean :in_school_at_onset
      t.string :grade
      t.string :zip
      t.string :gender
      t.string :student_name
      t.string :parent_name
      t.string :address
      t.date :birthdate
      t.string :race
      t.string :phone
      t.string :doctor_name
      t.string :doctor_address
      t.boolean :confirmed_by_physician
      t.string :diagnosis
      t.string :treatment
      t.boolean :released_for_return_to_school

      t.timestamps
    end
    
    add_index :ili_reports, :school_id
    add_index :ili_reports, :onset_date
    add_index :ili_reports, [:school_id, :onset_date]
    
    add_column :school_districts, :hipaa_agreement, :boolean
    add_index :school_districts, :hipaa_agreement
  end

  def self.down
    drop_table :ili_reports
    remove_column :school_districts, :hipaa_agreement
  end
end
