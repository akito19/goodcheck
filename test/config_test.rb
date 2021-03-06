require_relative "test_helper"

class ConfigTest < Minitest::Test
  ConfigLoader = Goodcheck::ConfigLoader
  Config = Goodcheck::Config

  def test_rules_for_path
    loader = ConfigLoader.new(path: nil, content: nil)

    config = Config.new(rules: [
      loader.load_rule({ id: "rule1", glob: ["**/*.rb"], message: "" }),
      loader.load_rule({ id: "rule2", glob: ["*.rb", "app/views/**/*.html.erb"], message: "" }),
      loader.load_rule({ id: "rule3", glob: ["app/**/*.rb"], message: "" }),
    ])

    assert_equal ["rule1", "rule2"], config.rules_for_path(Pathname("bar.rb"), rules_filter: []).map(&:first).map(&:id)
    assert_equal ["rule1", "rule3"], config.rules_for_path(Pathname("app/models/user.rb"), rules_filter: []).map(&:first).map(&:id)
    assert_equal ["rule2"], config.rules_for_path(Pathname("app/views/users/index.html.erb"), rules_filter: []).map(&:first).map(&:id)
  end

  def test_rules_for_path_glob_empty
    loader = ConfigLoader.new(path: nil, content: nil)

    config = Config.new(rules: [
      loader.load_rule({ id: "rule1", glob: [], message: "" }),
    ])

    assert_equal ["rule1"], config.rules_for_path(Pathname("bar.rb"), rules_filter: []).map(&:first).map(&:id)
  end

  def test_rules_for_filter
    loader = ConfigLoader.new(path: nil, content: nil)

    config = Config.new(rules: [
      loader.load_rule({ id: "rule1", glob: [], message: "" }),
      loader.load_rule({ id: "rule1.x", glob: [], message: "" }),
      loader.load_rule({ id: "rule2", glob: [], message: "" }),
    ])

    assert_equal ["rule1", "rule1.x"], config.rules_for_path(Pathname("bar.rb"), rules_filter: ["rule1"]).map(&:first).map(&:id)
  end
end
