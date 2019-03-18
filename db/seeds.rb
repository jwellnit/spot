# seed the application w/ some essentials

Rake::Task['spot:roles:default'].invoke
Rake::Task['hyrax:default_admin_set:create'].invoke
Rake::Task['hyrax:default_collection_types:create'].invoke

# create a depositor user
deposibot = User.find_or_create_by(email: 'dss@lafayette.edu') do |bot|
  bot.display_name = 'DeposiBot'
end
