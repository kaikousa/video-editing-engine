require 'yaml'

$configPath = File.dirname(File.expand_path(__FILE__)) + "/"
$vreRoot = File.expand_path($configPath + "../") + "/"

$settings = YAML.load_file($configPath + "settings.yml")
