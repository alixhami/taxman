# start with the user's filing status
puts "Greetings! I'm the TAXMAN and I'm here to save the day!"
puts "... by estimating your 2016 Federal Income Taxes."
puts "At the end of the year, will you be 'single' or 'married'?"
response = gets.chomp
case response.downcase
when "single"
  filing_status = "single"
when "married"
  filing_status = "mfj"
else
  puts "Not sure what you typed there. I'm gonna say you're single."
  filing_status = "single"
end

# get gross income
puts "How much is your yearly income? If you're married, include your spouse's income."
gross_income = gets.chomp.to_i

def calc_estimated_taxes(filing_status, gross_income)
  case filing_status  # determine tax brackets
  when "single"
    personal_exemption = 4050
    standard_deduction = 6300
    cap_10 = 9275.0
    cap_15 = 37650.0
    cap_25 = 91150.0
    cap_28 = 190150.0
    cap_33 = 413350.0
    cap_35 = 415050.0
  when "mfj"
    personal_exemption = 8100
    standard_deduction = 12600
    cap_10 = 18550.0
    cap_15 = 75300.0
    cap_25 = 151900.0
    cap_28 = 231450.0
    cap_33 = 413350.0
    cap_35 = 466950.0
  end

  # calculate taxable income
  taxable_income = gross_income - standard_deduction - personal_exemption

  # these variables store the maximum tax at each rate
  max_10 = cap_10 * 0.1
  max_15 = ((cap_15 - cap_10) * 0.15) + max_10
  max_25 = ((cap_25 - cap_15) * 0.25) + max_15
  max_28 = ((cap_28 - cap_25) * 0.28) + max_25
  max_33 = ((cap_33 - cap_28) * 0.33) + max_28
  max_35 = ((cap_35 - cap_33) * 0.35) + max_33

  # calculate estimated taxes and marginal rate
  if taxable_income <= 0
    estimated_taxes = 0
    marginal_rate = "0%"
    average_rate = "0"
  elsif taxable_income <= cap_10
    estimated_taxes = taxable_income * 0.10
    marginal_rate = "10%"
  elsif taxable_income <= cap_15
    estimated_taxes = max_10 + ((taxable_income - cap_10) * 0.15)
    marginal_rate = "15%"
  elsif taxable_income <= cap_25
    estimated_taxes = max_15 + ((taxable_income - cap_15) * 0.25)
    marginal_rate = "25%"
  elsif taxable_income <= cap_28
    estimated_taxes = max_25 + ((taxable_income - cap_25) * 0.28)
    marginal_rate = "28%"
  elsif taxable_income <= cap_33
    estimated_taxes = max_28 + ((taxable_income - cap_28) * 0.33)
    marginal_rate = "33%"
  elsif taxable_income <= cap_35
    estimated_taxes = max_33 + ((taxable_income - cap_33) * 0.35)
    marginal_rate = "35%"
  else
    estimated_taxes = max_35 + ((taxable_income - cap_35) * 0.396)
    marginal_rate = "39.6%"
  end

  average_rate ||= (estimated_taxes/gross_income*100).to_i

  puts "Your estimated 2016 income taxes are $#{estimated_taxes.to_i}"
  puts "Your marginal tax rate is #{marginal_rate}"
  puts "Your average tax rate is #{average_rate}%"
end

calc_estimated_taxes(filing_status, gross_income)
