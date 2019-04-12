RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
    mocks.syntax = :expect
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.filter_run_when_matching :focus
  config.disable_monkey_patching!

  if config.files_to_run.one?
    config.default_formatter = "doc"
  else
    config.profile_examples = 10
  end

  config.order = :random
  Kernel.srand config.seed

  config.example_status_persistence_file_path = 'spec/examples.txt'
end
