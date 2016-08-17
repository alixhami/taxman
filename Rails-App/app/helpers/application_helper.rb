module ApplicationHelper

  # format estimated taxes to display with commas
  def dollar_format(number)
    "$" + number.ceil.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
  end

  def percentage_format(number)
    percentage = number * 100
    "#{percentage.to_i}%"
  end

end
