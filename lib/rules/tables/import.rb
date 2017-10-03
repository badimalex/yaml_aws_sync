class ImportRules

  def self.apply(file_name)
    @import_rules = YAML::load File.open("config/aws/tables.yml")
    return unless @import_rules
    if self.args_console_passed?
      self.apply_console_rules(file_name)
    else
      @file_name = file_name
      self.send 'clean_by_tables' if @import_rules['tables'].present?
      self.send 'clean_by_regex' if @import_rules['type'].present?
    end
  end

  def self.args_console_passed?
    ARGV[1].present? && ARGV[1].include?('tables=')
  end

  def self.apply_console_rules(file_name)
    args = ARGV[1].dup
    args.slice!('tables=')
    tables = args.split(',')

    Dir["db/#{file_name}/*"].each do |f|
      name = File.basename(f)
      name.slice! '.yml'
      should_skip = tables.include? name
      FileUtils.rm(f) unless should_skip
    end
  end

  def self.clean_by_regex
    Dir["db/#{@file_name}/*"].each do |f|
      should_skip = File.basename(f) =~ @import_rules['type']
      FileUtils.rm(f) unless should_skip
    end
  end

  def self.clean_by_tables
    Dir["db/#{@file_name}/*"].each do |f|
      name = File.basename(f)
      name.slice! '.yml'
      should_skip = @import_rules['tables'].include? name
      FileUtils.rm(f) unless should_skip
    end
  end

end
