# Name: Config
# Author: Kai Kousa
# Description: Singleton class to provide global access to settings
require "yaml"
class Config
    
    attr_reader :vreRoot, :configPath, :settings
    
    def initialize
        libPath = File.dirname(File.expand_path(__FILE__)) + "/"
        @vreRoot = File.expand_path(libPath + "../") + "/"
        @configPath = @vreRoot + "conf/"
        @settings = YAML.load_file(@configPath + "settings.yml")
    end
    private :initialize
    
    def self.instance
        if(@config == nil)
            puts "initialized config"
            @config = Config.new
        end
        @config
    end

end
