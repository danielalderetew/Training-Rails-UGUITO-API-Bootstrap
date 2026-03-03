ActiveAdmin.register Book do
  includes :utility, :user

  permit_params :utility_id, :user_id, :genre, :author,
                :image, :title, :publisher, :year

  filter :utility
  filter :user, as: :select, collection: -> { User.order(:email).pluck(:email, :id) }
  filter :genre
  filter :author

  index do
    selectable_column
    id_column
    column :utility
    column :user
    column :genre
    column :author
    column :image
    column :title
    column :publisher
    column :year
    actions
  end

  show do
    attributes_table do
      row :id
      row :utility
      row :user
      row :genre
      row :author
      row :image
      row :title
      row :publisher
      row :year
    end
  end

  form do |f|
    f.inputs do
      f.input :utility
      f.input :user,
              as: :select,
              collection: -> { User.order(:email).pluck(:email, :id) }
      f.input :genre
      f.input :author
      f.input :image
      f.input :title
      f.input :publisher
      f.input :year
      f.actions
    end
  end
end
