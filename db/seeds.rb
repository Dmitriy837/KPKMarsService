# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

connection = ActiveRecord::Base.connection
ActiveRecord::Base.connection.execute("

INSERT INTO users (id, login, password_hash, password_salt) VALUES
(1,'admin', '$2a$10$3VejRP355hX/Ucs809uZf.iaW9ViOLlTsCt1rUDGXP3DQT4x0PEmi', '$2a$10$3VejRP355hX/Ucs809uZf.'),
(2,'testAdmin', '$2a$10$3VejRP355hX/Ucs809uZf.iaW9ViOLlTsCt1rUDGXP3DQT4x0PEmi', '$2a$10$3VejRP355hX/Ucs809uZf.')
")