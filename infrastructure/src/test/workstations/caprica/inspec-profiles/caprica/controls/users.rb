# title 'audit users setup on caprica'

# control 'default_user_caprica' do
#     impact 1.0
#     title 'Validate groups of default user on caprica'
#     desc 'Ensure the default users group memberships are set up correctly'

#     describe user('seb') do
#         it { should exist }
#         its('groups') { should cmp ['seb', 'adm', 'sudo', 'docker']}
#     end
# end
