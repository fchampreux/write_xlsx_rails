require 'action_controller'

if Rails.version.to_f >= 5
  unless Mime[:xlsx]
  	Mime::Type.register 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', :xlsx
  end
else
  unless defined? Mime::XLSX
    Mime::Type.register 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', :xlsx
  end
end

ActionController::Renderers.add :xlsx do |filename, options|
  unless formats.include?(:xlsx) || Rails.version < '3.2'
    formats[0] = :xlsx
  end

  if filename =~ /^\/([^\/]+)\/(.+)$/
    options[:prefixes][0] = $1
    filename = $2
  end
  options[:template] = filename

  disposition = options.delete(:disposition) || 'attachment'
  download_name = options.delete(:filename) || filename
  download_name += ".xlsx" unless download_name =~ /\.xlsx$/

  send_data render_to_string(options), filename: download_name, type: Mime[:xlsx], disposition: disposition
end
