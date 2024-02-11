module RedmineCrm
  module ActsAsPriceable
    module Base
      def rcrm_acts_as_priceable(*args)
        priceable_options = args
        priceable_options << :price if priceable_options.empty?
        priceable_methods = ""
        priceable_options.each do |priceable_attr|
          priceable_methods << %(
            def #{priceable_attr.to_s}_to_s
              object_price(
                self,
                :#{priceable_attr},
                {
                  :decimal_mark => RedmineCrm::Settings::Money.decimal_separator,
                  :thousands_separator => RedmineCrm::Settings::Money.thousands_delimiter
                }
              ) if self.respond_to?(:#{priceable_attr})
            end
          )
        end

        class_eval <<-EOV
          include RedmineCrm::MoneyHelper

          #{priceable_methods}
        EOV
      end
    end
  end
end

ActiveRecord::Base.extend RedmineCrm::ActsAsPriceable::Base
