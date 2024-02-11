module RedmineCrm
  class Settings
    SECTIONS = {
      'money' => { id: :money, label: :label_redmine_crm_money, partial: 'money' }
    }.freeze

    class << self
      def initialize_gem_settings
        return if !Object.const_defined?('Setting') || Setting.respond_to?(:plugin_redmine_crm)

        if Setting.respond_to?(:define_setting)
          Setting.send(:define_setting, 'plugin_redmine_crm', 'default' => default_settings, 'serialized' => true)
        elsif Setting.respond_to?(:available_settings)
          Setting.available_settings['plugin_redmine_crm'] = { 'default' => default_settings, 'serialized' => true }
          Setting.class.send(:define_method, 'plugin_redmine_crm', -> { Setting['plugin_redmine_crm'] })
          Setting.class.send(:define_method, 'plugin_redmine_crm=', lambda do |val|
            setting = find_or_default('plugin_redmine_crm')
            setting.value = val || ''
            @cached_settings['plugin_redmine_crm'] = nil
            setting.save(validate: false)
            setting.value
          end)
        end
        @settings_initialized
      end

      # Use apply instead attrs assign because it can rewrite other attributes
      def apply=(values)
        initialize_gem_settings unless @settings_initialized

        Setting.plugin_redmine_crm = Setting.plugin_redmine_crm.merge(values)
      end

      def values
        initialize_gem_settings unless @settings_initialized
        Object.const_defined?('Setting') ? Setting.plugin_redmine_crm : {}
      end

      def [](value)
        initialize_gem_settings unless @settings_initialized
        return Setting.plugin_redmine_crm[value] if Object.const_defined?('Setting')

        nil
      end

      private

      def default_settings
        {}
      end
    end
  end
end
