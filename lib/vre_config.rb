# Name: Config
# Author: Kai Kousa
# Description: Singleton class to provide global access to settings
require "yaml"
class VREConfig
    
    attr_reader(:vre_root, :config_path, :settings)
    
    def initialize
        lib_path = File.dirname(File.expand_path(__FILE__)) + "/" #../VideoRenderingEngine/lib/
        @vre_root = File.expand_path(lib_path + "../") + "/" #../VideoRenderingEngine/
        @config_path = @vre_root + "conf/" #../VideoRenderingEngine/conf/
        @settings = YAML.load_file(@config_path + "settings.yml")
    end
    private :initialize
    
    def self.instance
        if(@config == nil)
            @config = VREConfig.new
        end
        @config
    end

end
