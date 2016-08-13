require "constants_by_filing_status.rb"

class Taxpayer
  include Tax
  attr_accessor :gross_income
  attr_reader :estimated_taxes, :average_rate, :marginal_rate, :standard_deduction, :personal_exemption

  def initialize(filing_status,gross_income)
    @gross_income = gross_income
    @filing_status = filing_status
    @tax_brackets = BRACKETS[@filing_status.to_sym]
    @standard_deduction = STANDARD_DEDUCTION[@filing_status.to_sym]
    @personal_exemption = PERSONAL_EXEMPTION[@filing_status.to_sym]
    @pep_threshold = PEP_THRESHOLD[@filing_status.to_sym]

    # personal exemption phaseout (PEP)
    # must reduce the dollar amount of exemptions by 2% for each @2500 or part of @2500 that AGI exceeds threshold
    # If AGI exceeds the theshold by more than @122,500, the amount of your deduction for exemptions is reduced to zero.

    # determine default personal exemption and PEP threshold
	  if @gross_income > @pep_threshold
	    number_of_reductions = ((@gross_income - @pep_threshold)/2500.0).ceil
	    percentage_reduction = 0.02 * number_of_reductions
	    if @gross_income - @pep_threshold >= 122500
	      @personal_exemption = 0
	    else
	      @personal_exemption *= 1 - percentage_reduction
	    end
	  end

	  # calculate taxable income
	  if @gross_income - @standard_deduction - @personal_exemption < 0
	  	@taxable_income = 0
	  else
	  	@taxable_income = @gross_income - @standard_deduction - @personal_exemption
	  end

    # For each bracket, the loop below calculates the tax due if the taxpayer's
    # taxable income was exactly at the bracket limit. This shortens the ultimate
    # calculation of estimated taxes, because only the tax on the income above
    # the highest bracket will need to be calculated for each taxpayer.


    (@tax_brackets.length-1).times do |i|
    	if i == 0
    		@tax_brackets[i][:tax_at_limit] = @tax_brackets[i][:rate] * @tax_brackets[i][:limit]
    	else
    		@tax_brackets[i][:tax_at_limit] = @tax_brackets[i-1][:tax_at_limit] + (@tax_brackets[i][:rate] * (@tax_brackets[i][:limit] - @tax_brackets[i-1][:limit]))
    	end
    end

    # The following loop determines the taxpayer's marginal tax bracket
    (@tax_brackets.length).times do |i|
    	if i == 6
    		@bracket_index = i
    	elsif
    		@taxable_income < @tax_brackets[i][:limit]
    		@bracket_index = i
    		break
    	end
    end

    # Define Marginal Income
    if @bracket_index == 0
      @marginal_income = @taxable_income
    else
	    @marginal_income = @taxable_income - @tax_brackets[@bracket_index-1][:limit]
    end

    # Define Marginal Rate
    @marginal_rate = @tax_brackets[@bracket_index][:rate]

    # Calculate Estimated Taxes
    if @bracket_index == 0
    	@estimated_taxes = @marginal_income * @marginal_rate
    else
    	@estimated_taxes = @tax_brackets[@bracket_index-1][:tax_at_limit] + (@marginal_income * @marginal_rate)
	  end
  end

    # Calculate Average Rate
  def average_rate
    if @taxable_income == 0
      0
    else
      @estimated_taxes / @gross_income
    end
  end
  
end

# format estimated taxes to display with commas
def dollar_format(number)
  "$" + number.ceil.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
end

def percentage_format(number)
  percentage = number * 100
  "#{percentage.to_i}%"
end
