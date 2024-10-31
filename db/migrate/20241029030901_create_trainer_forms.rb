class CreateTrainerForms < ActiveRecord::Migration[5.2]
  def change
    create_table :trainer_forms do |t|
      t.string :name
      t.string :membership_number
      t.date :date_of_birth
      t.string :reasons
      t.string :phone
      t.text :medical_conditions
      t.text :additional_notes

      t.timestamps
    end
  end
end
