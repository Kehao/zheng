module StatisticsHelper
  # 浮点数换算成百分数(即*100), 由于浮点数运算实际会存在误差，可能会是小数点后有很多位，所以需要小数点后精度的控制
  #
  # === Example
  #   经过一系列运算后显示为0.7的小数 * 100后可能会变成 70.00000000001
  def percentage(f, precision = 0)
    (f * 100).round(precision)
  end

  # 浮点数转换为百分数字符串显示
  #
  # === Example
  #   0.7 => "70%"
  #   0.85 => "85%"
  def percentage_desc(f, precision = 2)
    "#{percentage(f, precision)}%"
  end

  def global_statistics_path(options)
    statistics_path(options.merge(:scope=>:court))
  end

  def basic_statistics_path(options)
    statistics_path(options.merge(:scope=>:basic))
  end

  def business_statistics_path(options)
    statistics_path(options.merge(:scope=>:business))
  end
end
