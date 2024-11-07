require 'yaml'
require 'selenium-webdriver'
require 'liquid'

# Load configuration and variables
config = YAML.load_file('config/config.yaml')
automations = YAML.load_file('main_automation.yaml')['automations']

def process_yaml(file_path, variables)
  content = File.read(file_path)
  template = Liquid::Template.parse(content)
  template.render(variables)
end

# Initialize WebDriver
options = Selenium::WebDriver::Chrome::Options.new
driver = Selenium::WebDriver.for :chrome, options: options

begin
  automations.each do |automation|
    puts "Running automation: #{automation['name']}"
    template = Liquid::Template.parse(automation['url'])
    automation_url = template.render(config['variables'] || {})
    driver.navigate.to automation_url

    automation_variables = automation['variables'] || {}
    config_variables = config['variables'] || {}
    merged_variables = config_variables.merge(automation_variables).merge('url' => automation_url)

    if automation['include']
      steps_yaml = process_yaml(automation['include'], merged_variables)
      steps = YAML.safe_load(steps_yaml)['steps']
    else
      steps = automation['steps'] || []
    end

    steps.each do |step|
      step = step.transform_values { |v| Liquid::Template.parse(v).render(merged_variables) if v.is_a?(String) }

      case step['action']
      when 'input'
        element = driver.find_element(css: step['selector'])
        element.send_keys(step['value'])
      when 'click'
        driver.find_element(css: step['selector']).click
      when 'wait_for'
        Selenium::WebDriver::Wait.new(timeout: step['timeout'] / 1000.0).until do
        driver.find_element(css: step['selector'])
        end
      when 'navigate'
        puts "Navigating to URL: #{step['value']}"
        driver.navigate.to step['value']
      when 'wait'
        puts "Waiting for #{step['seconds']} seconds"
        sleep(step['seconds'].to_i)
      else
        puts "Unknown action: #{step['action']}"
      end
    end
  end
ensure
  driver.quit
end
