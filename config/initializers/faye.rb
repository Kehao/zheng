FAYE_CONFIG = YAML.load_file(File.join(Rails.root, "config/faye.yml"))[Rails.env]
FayeClient.server FAYE_CONFIG['server']
