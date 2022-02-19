# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require "open-uri"

def image_fetcher
  URI.parse(FFaker::Avatar.image(nil, "100x100")).open
end

def create_lunch(year, month)
  puts "Seeding lunch  year: #{year}, month: #{month}"
  return if Lunch.where(year: year, month: month).exists?

  MysteryPartnerSelectionService.call year: year, month: month
end

seed_avatars = ENV["SEED_AVATARS"] == "true"

puts "Seeding employees #{"with avatars" if seed_avatars}"

Employee::DEPARTMENTS.each do |department|
  puts "Seeding department '#{department}'"

  Employee.transaction do
    10.times do |i|
      employee = Employee.create! name: "#{FFaker::Name.first_name} #{FFaker::Name.last_name}",
        department: department

      if seed_avatars
        employee.photo.attach({
          io: image_fetcher,
          filename: "#{department}_#{i}_avatar.jpg"
        })
      end
    end
  end
end

previous_year = Time.now.prev_year.year

(1..12).each do |month|
  create_lunch previous_year, month
end

create_lunch Time.now.year, Time.now.month
