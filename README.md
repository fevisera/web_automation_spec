# Web Automation Specification

This project automates web interactions using Selenium WebDriver and Liquid templates. The web automation steps are defined in YAML files.

## Prerequisites

- Ruby installed on your machine
- Bundler gem installed
- Chrome browser installed
- ChromeDriver installed and added to your PATH

## Installation

1. Clone the repository:
  ```sh
  git clone <repository-url>
  cd <repository-directory>
  ```

2. Install the required gems:
  ```sh
  bundle install
  ```

## Configuration

1. Create a `config.yaml` file with the necessary variables. Example:
  ```yaml
  variables:
    time_wait: "3"
  ```

2. Define your automations in `main_automation.yaml`. Example:
  ```yaml
  automations:
    - name: "Open URL and wait" 
      url: "https://<some-url>"
      variables:
        time_wait: "2"
      steps:
        - action: "wait"
          seconds: "{{ time_wait }}"
  ```

## Running the Automation

Execute the automation runner script:
```sh
ruby automation_runner.rb
```

## File Structure

- `automation_runner.rb`: Main script to run the automations.
- `main_automation.yaml`: YAML file defining the automation steps.
- `config/config.yaml`: Configuration file with variables used in the automations.

## License

This project is licensed under the MIT License.
