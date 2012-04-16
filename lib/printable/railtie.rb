class Printable::Railtie < Rails::Railtie
	config.printable = ActiveSupport::OrderedOptions.new

	initializer "printable.logger" do
	  ActiveSupport.on_load(:printable) { self.logger ||= Rails.logger }
	end
end