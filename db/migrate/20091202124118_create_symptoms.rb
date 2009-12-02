class CreateSymptoms < ActiveRecord::Migration
  def self.up
    create_table :symptoms do |t|
      t.string :name
      t.timestamps
    end
    
    create_table :ili_reports_symptoms, :id => false do |t|
      t.integer :ili_report_id, :symptom_id
    end
  end

  def self.down
    drop_table :symptoms
  end
end
