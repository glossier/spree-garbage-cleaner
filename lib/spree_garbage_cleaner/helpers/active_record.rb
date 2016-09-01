module SpreeGarbageCleaner
  module Helpers
    module ActiveRecord
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def destroy_garbage
          destroyed = []
          errors = []

          self.garbage.find_each(:batch_size => Spree::GarbageCleaner::Config.batch_size) do |r|
            begin
              destroyed << r.destroy
            rescue => e
              errors << "Error on ID: #{r.id}, #{e}"
            end
          end

          { destroyed: destroyed, errors: errors }
        end
      end
    end
  end
end
