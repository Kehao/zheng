class RooExcel
  include Enumerable  

  attr_accessor :data,:row_start
  attr_accessor :importer

  def row_start
    @row_start || 2
  end

  def initialize(importer,path)
    @data =
      if File.extname(path) =~ /(lsx)$/ 
        Roo::Excelx.new path
      else
        Roo::Excel.new path
      end
    @data.default_sheet = @data.sheets.first 
    @importer = importer
  end

  def lines_count
    @data.last_row - row_start + 1
  end

  def title
    @data.row(row_start - 1) 
  end

  def each
    row_start.upto(@data.last_row) do |line_num|
      yield @data.row(line_num) 
    end
  end

  def each_row
    each do |row|
      yield row

      unless importer.row_valid? 
        importer.row_temp(row)
      end

    end
  end

end
