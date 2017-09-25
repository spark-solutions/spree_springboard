module SpreeSpringboard
  module Generators
    class InstallGenerator < Rails::Generators::Base

      class_option :auto_run_migrations, type: :boolean, default: false

      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=spree_springboard'
      end

      def add_schedule
        create_file 'config/schedule.rb' unless File.exist?('config/schedule.rb')
        append_file 'config/schedule.rb' do
          "\nevery 5.minutes do\n  runner 'SpreeSpringboard::CreateGiftCardJob.perform_later'\nend\n"
        end
      end

      def run_migrations
        run_migrations = options[:auto_run_migrations] || ['', 'y', 'Y'].include?(ask 'Would you like to run the migrations now? [Y/n]')
        if run_migrations
          run 'bundle exec rake db:migrate'
        else
          puts 'Skipping rake db:migrate, don\'t forget to run it!'
        end
      end
    end
  end
end
