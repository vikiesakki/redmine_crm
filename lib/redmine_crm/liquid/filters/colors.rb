require 'liquid'

module RedmineCrm
  module Liquid
    module Filters
      module Colors
        def darken_color(input, value=0.4)
          RedmineCrm::ColorsHelper.darken_color(input, value.to_f)
        end

        def lighten_color(input, value=0.6)
          RedmineCrm::ColorsHelper.lighten_color(input, value.to_f)
        end

        def contrasting_text_color(input)
          RedmineCrm::ColorsHelper.contrasting_text_color(input)
        end

        def hex_color(input)
          RedmineCrm::ColorsHelper.hex_color(input)
        end

        def convert_to_brightness_value(input)
          RedmineCrm::ColorsHelper.convert_to_brightness_value(input)
        end

      end
      ::Liquid::Template.register_filter(RedmineCrm::Liquid::Filters::Colors)
    end
  end
end
