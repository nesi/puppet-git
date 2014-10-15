require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'

exclude_paths = [
  'spec/**/*',
  'pkg/**/*',
  'tests/**/*'
]

PuppetSyntax.exclude_paths = exclude_paths

Rake::Task[:lint].clear
PuppetLint::RakeTask.new :lint do |config|
  # Pattern of files to ignore
  config.ignore_paths = exclude_paths

  # List of checks to disable
  config.disable_checks = [
    '80chars',
    'class_parameter_defaults',
    'class_inherits_from_params_class',
    'autoloader_layout'
  ]

  # Should the task fail if there were any warnings, defaults to false
  config.fail_on_warnings = true

  # Print out the context for the problem, defaults to false
  config.with_context = true

  # Format string for puppet-lint's output (see the puppet-lint help output
  # for details
  config.log_format = "%{path}:%{linenumber}:%{check}:%{KIND}:%{message}"

  # Compare module layout relative to the module root
  # config.relative = true
end

desc 'Check for ruby syntax errors.'
task :validate_ruby_syntax do
  ruby_parse_command = 'ruby -c'
  Dir['spec/**/*.rb'].each do |path|
   sh "#{ruby_parse_command} #{path}"
  end
end

desc 'Check for evil line endings.'
task :check_line_endings do
  Dir['spec/**/*.rb', 'tests/**/*.rb', 'manifests/**/*.pp'].each do |path|
   sh "file #{path}|grep -v CRLF"
  end
end

# vim:ft=ruby