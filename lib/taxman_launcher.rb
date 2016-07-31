require_relative "taxman"

# start with the user's filing status
puts "Greetings! I'm the TAXMAN and I'm here to save the day!"
puts "... by estimating your 2016 Federal Income Taxes."

# determine filing status
puts "At the end of the year, will you be 'single' or 'married'?"
response = gets.chomp
case response.downcase
when "single"
  $filing_status = "single"
when "married"
  $filing_status = "mfj"
else
  puts "Not sure what you typed there. I'm gonna say you're single."
  $filing_status = "single"
end

# get gross income
puts "How much is your yearly income? If you're married, include your spouse's income."
$gross_income = gets.chomp.to_i

define_bracket
calc_maximum
calc_personal_exemption
calc_estimated_taxes

puts "Your estimated 2016 income taxes are #{dollar_format($estimated_taxes)}"
puts "Your marginal tax rate is #{$marginal_rate}%"
puts "Your average tax rate is #{$average_rate}%"
