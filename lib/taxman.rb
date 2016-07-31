# determine tax brackets
def define_bracket
  case $filing_status
  when "single"
    $standard_deduction = 6300
    $cap_10 = 9275.0
    $cap_15 = 37650.0
    $cap_25 = 91150.0
    $cap_28 = 190150.0
    $cap_33 = 413350.0
    $cap_35 = 415050.0
  when "mfj"
    $standard_deduction = 12600
    $cap_10 = 18550.0
    $cap_15 = 75300.0
    $cap_25 = 151900.0
    $cap_28 = 231450.0
    $cap_33 = 413350.0
    $cap_35 = 466950.0
  end
end

# these variables store the maximum tax at each rate
def calc_maximum
  $max_10 = $cap_10 * 0.1
  $max_15 = (($cap_15 - $cap_10) * 0.15) + $max_10
  $max_25 = (($cap_25 - $cap_15) * 0.25) + $max_15
  $max_28 = (($cap_28 - $cap_25) * 0.28) + $max_25
  $max_33 = (($cap_33 - $cap_28) * 0.33) + $max_28
  $max_35 = (($cap_35 - $cap_33) * 0.35) + $max_33
end

def calc_personal_exemption
  # personal exemption phaseout (PEP)
  # must reduce the dollar amount of exemptions by 2% for each $2500 or part of $2500 that AGI exceeds threshold
  # If AGI exceeds the theshold by more than $122,500, the amount of your deduction for exemptions is reduced to zero.

  # determine default personal exemption and PEP threshold
  case $filing_status
  when "single"
    $personal_exemption = 4050
    $pep_threshold = 258250
  when "mfj"
    $personal_exemption = 8100
    $pep_threshold = 309900
  end

  if $gross_income > $pep_threshold
    number_of_reductions = (($gross_income - $pep_threshold)/2500.0).ceil
    percentage_reduction = 0.02 * number_of_reductions
    if $gross_income - $pep_threshold >= 122500
      $personal_exemption = 0
    else
      $personal_exemption *= 1 - percentage_reduction
    end
  end
end

def calc_estimated_taxes
  # calculate taxable income
  taxable_income = $gross_income - $standard_deduction - $personal_exemption

  # calculate estimated taxes and marginal rate
  if taxable_income <= 0
    $estimated_taxes = 0
    $marginal_rate = "0"
    $average_rate = "0"
  elsif taxable_income <= $cap_10
    $estimated_taxes = taxable_income * 0.10
    $marginal_rate = "10"
  elsif taxable_income <= $cap_15
    $estimated_taxes = $max_10 + ((taxable_income - $cap_10) * 0.15)
    $marginal_rate = "15"
  elsif taxable_income <= $cap_25
    $estimated_taxes = $max_15 + ((taxable_income - $cap_15) * 0.25)
    $marginal_rate = "25"
  elsif taxable_income <= $cap_28
    $estimated_taxes = $max_25 + ((taxable_income - $cap_25) * 0.28)
    $marginal_rate = "28"
  elsif taxable_income <= $cap_33
    $estimated_taxes = $max_28 + ((taxable_income - $cap_28) * 0.33)
    $marginal_rate = "33"
  elsif taxable_income <= $cap_35
    $estimated_taxes = $max_33 + ((taxable_income - $cap_33) * 0.35)
    $marginal_rate = "35"
  else
    $estimated_taxes = $max_35 + ((taxable_income - $cap_35) * 0.396)
    $marginal_rate = "39.6"
  end

  # calculate average rate if not assigned above
  $average_rate ||= ($estimated_taxes/$gross_income*100).to_i
end

# format estimated taxes to display with commas
def dollar_format(number)
  "$" + number.ceil.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
end
