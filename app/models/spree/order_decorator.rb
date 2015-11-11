module Spree
  Order.class_eval do
    def self.destroy_garbage
      self.garbage.destroy_all
    end

    def self.garbage
      garbage_after = Spree::GarbageCleaner::Config.cleanup_days_interval
      timestamp_column = Spree::GarbageCleaner::Config.timestamp_column
      self.incomplete.where("#{timestamp_column} <= ?", garbage_after.days.ago)
    end

    def garbage?
      garbage_after = Spree::GarbageCleaner::Config.cleanup_days_interval
      timestamp_column = Spree::GarbageCleaner::Config.timestamp_column
      completed_at.nil? && self.send(timestamp_column) <= garbage_after.days.ago
    end
  end
end
