module YamlAwsSync
  class InstallGenerator < Rails::Generators::Base
    def create_files
      create_file 'config/aws/folders.yml', [
          '# Absolute aws3 paths',
          '# - uploads/catalog/typical_work/image/',
          '# - uploads/slide/image/',
          ''
      ].join("\n")

      create_file 'config/aws/tables.yml', [
        "# Example using regex",
        "# type:  !ruby/regexp '/^catalog_/'",
        "",
        "# Example",
        "# import only tables defined bellow",
        "# tables:",
        "#   - catalog_decoration_formulas",
        "#   - catalog_decoration_images",
        ''
      ].join("\n")
    end
  end
end
