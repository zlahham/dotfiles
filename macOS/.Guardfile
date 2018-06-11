notification :tmux,
             display_message: true,
             timeout: 5, # in seconds
             default_message_format: '%s >> %s',
             success_message_format: 'SUCCESS!!!👻 👊 ⚡️ 🍻 %s >> %s',
             failed_message_format: 'FAILURE!!! 😔 💀 🙀 👨‍💻 %s >> %s',
             line_separator: ' > ', # since we are single line we need a separator
             color_location: 'status-left-bg', # to customize which tmux element will change color

             # Other options:
             default_message_color: 'black',
             success: 'green',
             failure: 'red',
             pending: 'yellow',

             # Notify on all tmux clients
             display_on_all_clients: false

group :red_green_refactor, halt_on_fail: false do
  guard :rspec, cmd: 'spring rspec' do
    watch('spec/spec_helper.rb')                        { 'spec' }
    watch('config/routes.rb')                           { 'spec/routing' }
    watch('app/controllers/application_controller.rb')  { 'spec/controllers' }
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
    watch(%r{^app/(.*)(\.erb|\.haml|\.slim)$})          { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
    watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
  end
end
