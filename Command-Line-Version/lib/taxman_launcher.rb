$LOAD_PATH.unshift '.'
require 'taxman'

# start with the user's filing status
puts "Greetings! I'm TAXMAN and I'm here to save the day!"
puts "... by estimating your 2016 Federal Income Taxes."

# determine filing status
puts "At the end of the year, will you be 'single' or 'married'?"
status_input = gets.chomp
case status_input.downcase
when "single"
  puts "Do you qualify as 'Head of Household'?\n(A) Yes\n(B) No\n(C) What's That??"
  single_status_input = gets.chomp
  case single_status_input.upcase
  when "A"
    filing_status = "head_of_household"
  when "B"
    filing_status = "single"
  when "C"
  else
    puts "I didn't understand that input. Let's just use the default 'Single' filing status."
    filing_status = "single"
  end
when "married"
  puts "Do you want to calculate the tax on\n(A) Your Income or \n(B) Both Incomes?"
  married_status_input = gets.chomp
  case married_status_input.upcase
  when "A"
    filing_status = "mfs"
  when "B"
    filing_status = "mfj"
  else
    puts "I didn't understand that input. Let's try the calculation with just your income."
    filing_status = "mfs"
  end
else
  puts "Not sure what you typed there. I'm gonna say you're single."
  filing_status = "single"
end

gross_income = 0
# get gross income
if filing_status == "mfj"
  puts "How much is your yearly income, including your spouse?"
else
  puts "How much is your yearly income?"
end

# loop to get a valid income amount
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
puts "Your marginal tax rate is #{percentage_format(user.marginal_rate)}"
puts "Your average tax rate is #{percentage_format(user.average_rate)}"
