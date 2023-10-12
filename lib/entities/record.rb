class Record
  def to_h
    object = {}
    self.instance_variables.each do |variable|
      object[variable.to_s.delete('@').to_sym] = self.instance_variable_get(variable)
    end
    object
  end

  def save
    delete(url)

    @created_at = fetch_current_date_time unless @created_at
    @updated_at = fetch_current_date_time

    mode = 'a+'
    write_headers = false

    data = self.to_h #{ owner:, url:, created_at:, updated_at: }
    CSV.open(base_path, mode, write_headers:, headers: data.keys) do |csv|
      csv << data.values
    end
  end

  def delete(url)
    Record.destroy(url, "#{base_path}")
  end

  def self.delete(url)
    Record.destroy(url, "#{new.base_path}")
  end

  def self.destroy(url, path)
    table = CSV.table(path)

    table.delete_if do |row|
      row[:url] == url
    end

    File.open(path, 'w') do |file|
      file.write(table.to_csv)
    end
  end

  def self.all
    table = CSV.read("#{new.base_path}", headers: true)

    table.map do |item|
      data = item.to_h.transform_keys(&:to_sym)
      self.new(**data)
    end
  end

  def fetch_current_date_time
    DateTime.parse(DateTime.now.strftime('%FT%T%:z'))
            .strftime('%d/%m/%y - %H:%M:%S %P')
  end
end
