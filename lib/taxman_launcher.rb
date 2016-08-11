require_relative "taxman"

# start with the user's filing status
puts "Greetings! I'm TAXMAN and I'm here to save the day!"
puts "... by estimating your 2016 Federal Income Taxes."

# determine filing status
puts "At the end of the year, will you be 'single' or 'married'?"
status_input = gets.chomp
case status_input.downcase
when "single"
  filing_status = "single"
when "married"
  filing_status = "mfj"
else
  puts "Not sure what you typed there. I'm gonna say you're single."
  filing_status = "single"
end

gross_income = 0
# get gross income
puts "How much is your yearly income? If you're married, include your spouse's income."
loop do
    income_input = gets.chomp
    begin
      gross_income = Integer(income_input)
      break
    rescue
      puts "Please enter a valid number without punctuation."
    end
end

user = Taxpayer.new(filing_status, gross_income)
puts "Your estimated 2016 income taxes are #{dollar_format(user.estimated_taxes)}"
puts "Your marginal tax rate is #{user.marginal_rate}%"
puts "Your average tax rate is #{user.average_rate}%"
