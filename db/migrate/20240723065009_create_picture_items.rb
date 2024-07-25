class CreatePictureItems < ActiveRecord::Migration
  def change
    create_table :picture_items do |t|
      t.references :user, foreign_key: true
      t.string :url
      t.boolean :first_pic, default: false

      t.timestamps
    end
  end
end
