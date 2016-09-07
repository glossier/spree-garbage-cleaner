class Spree::GarbageCleanerConfiguration < Spree::Preferences::Configuration
  preference :models_with_garbage, :any, default: 'Spree::Order'
  preference :timestamp_column, :string, default: 'created_at'
  preference :cleanup_days_interval, :integer, default: 14
  preference :batch_size, :integer, default: 100
end
