namespace :intersection do
  desc "Create an operator from ADMIN_EMAIL and ADMIN_PASSWORD"
  task create_admin: :environment do
    email = ENV["ADMIN_EMAIL"]
    password = ENV["ADMIN_PASSWORD"]
    abort "Set ADMIN_EMAIL and ADMIN_PASSWORD" if email.blank? || password.blank?

    admin = AdminUser.create!(email: email, password: password)
    puts "Created operator #{admin.email}"
  end
end
