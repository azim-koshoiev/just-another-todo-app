2.times do |i|
    User.create(email: "user-#{i+1}@example.com", password: "password", password_confirmation: "password")
end

User.all.each do |user|
    2.times do |i|
        user.projects.create(title: "Project #{i+1} for #{user.email}")
    end
end
