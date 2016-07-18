require 'importer_destinations'
CSV.generate { |csv|
  columns = ImporterDestinations.new(current_user.customer).columns.values.select{ |data| data[:required] != I18n.t('destinations.import_file.format.deprecated') }
  csv << columns.collect{ |data| data[:title] }
  csv << columns.collect{ |data|
    data[:format] + (!data[:required] || data[:required] != I18n.t('destinations.import_file.format.required') ?
    ' (' + (data[:required] ? data[:required] : I18n.t('destinations.import_file.format.optionnal')) + ')' :
    '')
  }
}
