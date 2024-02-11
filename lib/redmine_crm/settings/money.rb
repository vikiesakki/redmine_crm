require 'redmine_crm/settings'

module RedmineCrm
  class Settings
    class Money
      TAX_TYPE_EXCLUSIVE = 1
      TAX_TYPE_INCLUSIVE = 2

      class << self
        def default_currency
          RedmineCrm::Settings['default_currency'] || 'USD'
        end

        def major_currencies
          currencies = RedmineCrm::Settings['major_currencies'].to_s.split(',').select { |c| !c.blank? }.map(&:strip)
          currencies = %w[USD EUR GBP RUB CHF] if currencies.blank?
          currencies.compact.uniq
        end

        def default_tax
          RedmineCrm::Settings['default_tax'].to_f
        end

        def tax_type
          ((['1', '2'] & [RedmineCrm::Settings['tax_type'].to_s]).first || TAX_TYPE_EXCLUSIVE).to_i
        end

        def tax_exclusive?
          tax_type == TAX_TYPE_EXCLUSIVE
        end

        def thousands_delimiter
          ([' ', ',', '.'] & [RedmineCrm::Settings['thousands_delimiter']]).first
        end

        def decimal_separator
          ([',', '.'] & [RedmineCrm::Settings['decimal_separator']]).first
        end

        def disable_taxes?
          RedmineCrm::Settings['disable_taxes'].to_i > 0
        end
      end
    end
  end
end
