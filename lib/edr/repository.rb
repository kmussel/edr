require_relative 'registry'

module Edr
  module Repository
    def delete model
      data_class.destroy data(model)
    end

    def delete_by_id id
      data_class.destroy(data_class.get!(id))
    end

    def find id
      model_class.new(data_class.get!(id))
    end

    def all
      data_class.find_all.map do |data|
        model_class.new(data)
      end
    end

    protected

    def data model
      model._data
    end

    def set_model_class model_class, options
      if options[:root]
        singleton_class.send :define_method, :data_class do
          Registry.data_class_for(model_class).to_adapter
        end

        singleton_class.send :define_method, :model_class do
          model_class
        end
      end
    end

    private

    def where attrs
      data_class.find_all(attrs).map do |data|
        model_class.new(data)
      end
    end
  end
end