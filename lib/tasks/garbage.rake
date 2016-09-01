namespace :db do
  namespace :garbage do

    desc 'Cleanup garbage by calling .destroy on every model marked as garbage'
    task cleanup: :environment do
      garbage_models = Spree::GarbageCleaner::Config.models_with_garbage.delete(' ').split(',').map(&:constantize)

      garbage_models.each do |model|
        results = model.destroy_garbage
        printf "Destroyed %i garbage records from %s\n", results[:destroyed].length, model
        printf "%i errors from %s\n", results[:errors].length, model
        results[:errors].each { |error| puts error }
      end
    end

    desc 'Gives some info about garbage inside the db'
    task stats: :environment do
      garbage_models = Spree::GarbageCleaner::Config.models_with_garbage.delete(' ').split(',')

      longest_model_name = garbage_models.max { |a, b| a.length <=> b.length }

      puts 'The following garbage records have been found:'
      garbage_models.each do |model|
        printf "%-#{longest_model_name.length}s ===> %i\n", model, model.constantize.garbage.count
      end
    end

  end
end
