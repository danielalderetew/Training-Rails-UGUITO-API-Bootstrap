# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rails db:seed command
# (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Admin User
FactoryBot.create(:admin_user, email: 'admin@example.com', password: 'password',
                               password_confirmation: 'password')

# Utilities
north_utility = FactoryBot.create(:north_utility, code: 1)
south_utility = FactoryBot.create(:south_utility, code: 2)

# Users
FactoryBot.create_list(:user, 20, utility: north_utility,
                                  password: '12345678', password_confirmation: '12345678')
FactoryBot.create_list(:user, 20, utility: south_utility,
                                  password: '12345678', password_confirmation: '12345678')

FactoryBot.create(:user, utility: south_utility, email: 'test_south@widergy.com',
                         password: '12345678', password_confirmation: '12345678')

FactoryBot.create(:user, utility: north_utility, email: 'test_north@widergy.com',
                         password: '12345678', password_confirmation: '12345678')

User.all.find_each do |user|
  random_books_amount = [1, 2, 3].sample
  FactoryBot.create_list(:book, random_books_amount, user: user, utility: user.utility)
  # Notes
  FactoryBot.create(:note,title: 'Una critica North!', content: 'Esta es una critica', note_type: Note.note_types[:critique], user_id: 1)
  FactoryBot.create(:note,title: 'Una reseña North!', content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas arcu risus, imperdiet laoreet ante sit amet, bibendum mollis leo. Pellentesque sagittis risus eu aliquam faucibus. Quisque mattis augue lectus, at imperdiet enim gravida non. Mauris malesuada turpis non mollis molestie. Phasellus varius varius volutpat. Donec volutpat, lorem vestibulum lacinia.', note_type: Note.note_types[:review], user_id: 2)
  FactoryBot.create(:note,title: 'Una critica South!', content: 'Esta es una critica', note_type: Note.note_types[:critique], user_id: 21)
  FactoryBot.create(:note,title: 'Una reseña South!', content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas arcu risus, imperdiet laoreet ante sit amet, bibendum mollis leo. Pellentesque sagittis risus eu aliquam faucibus. Quisque mattis augue lectus, at imperdiet enim gravida non. Mauris malesuada turpis non mollis molestie. Phasellus varius varius volutpat. Donec volutpat, lorem vestibulum lacinia. Phasellus varius varius volutpat. Donec volutpat, lorem vestibulum lacinia.', note_type: Note.note_types[:review], user_id: 22)


end
