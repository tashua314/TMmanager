# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# メインのサンプルユーザーを1人作成する
User.create!(:username => "ゲストユーザー",
            :email => 'guest@example.com',
            :password => "foobar",
            :password_confirmation => "foobar"
          )

def reset_id(tablename)
  connection = ActiveRecord::Base.connection()
  connection.execute("select setval('#{tablename}_id_seq',(select max(id) from #{tablename}))")
end

# # 追加のユーザーをまとめて生成する
# 99.times do |n|
#   username  = Faker::Username.username
#   email = "example-#{n+1}@railstutorial.org"
#   password = "password"
#   User.create!(username:  username,
#               email: email,
#               password:              password,
#               password_confirmation: password)
# end



#デフォルトユーザーを作る