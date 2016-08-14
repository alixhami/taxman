require 'constants_by_filing_status'

class Taxpayer
  include Tax
  attr_accessor :gross_income
  attr_reader :estimated_taxes, :average_rate, :marginal_rate, :standard_deduction, :personal_exemption

  def initialize(filing_status,gross_income)
    @gross_income = gross_income
    @filing_status = filing_status
    @tax_brackets = BRACKETS[@filing_status.to_sym]
    @standard_deduction = STANDARD_DEDUCTION[@filing_status.to_sym]
    @pep_threshold = PEP_THRESHOLD[@filing_status.to_sym]
  end

  # personal exemption phaseout (PEP)
  # must reduce the dollar amount of exemptions by 2% for each $2500 or part of $2500 that AGI exceeds threshold
  # If AGI exceeds the theshold by more than $122,500 ($61,250 for MFS), the amount of your deduction for exemptions is reduced to zero.
  # determine default personal exemption and PEP threshold
  def personal_exemption
    if @gross_income < @pep_threshold
      # set full personal exemption amount when under threshold
      PERSONAL_EXEMPTION[@filing_status.to_sym]
    else
      # if gross income is above the phase out range, return $0 personal exemption
      if @filing_status == "mfs" && @gross_income - @pep_threshold >= 61250
        return 0
      elsif @gross_income - @pep_threshold >= 122500
        return 0
      else
        # calculate the number of multiples of $2,500 that gross income is over the threshold
  	    number_of_reductions = ((@gross_income - @pep_threshold)/2500.0).ceil
        # get total % reduction by multiplying that number of multiples by the 2% reduction percentage
        percentage_reduction = 0.02 * number_of_reductions
        # reduce the personal exemption by the total % reduction
	      return PERSONAL_EXEMPTION[@filing_status.to_sym] * (1 - percentage_reduction)
	    end
	  end
  end

	# calculate taxable income
  def taxable_income
	  if @gross_income - @standard_deduction - personal_exemption < 0
	  	0
	  else
	  	@gross_income - @standard_deduction - personal_exemption
	  end
  end

  def bracket_index
    # The following loop determines the taxpayer's marginal tax bracket
    (@tax_brackets.length).times do |i|
    	if i == 6
    		return i
    	elsif taxable_income < @tax_brackets[i][:limit]
    		return i
    		break
    	end
    end
  end

  def marginal_rate
    @tax_brackets[bracket_index][:rate]
  end

  # Calculate Marginal Income
  def marginal_income
    if bracket_index == 0
      taxable_income
    else
	    taxable_income - @tax_brackets[bracket_index-1][:limit]
    end
  end

  # Calculate Estimated Taxes
  def estimated_taxes
    if bracket_index == 0
    	marginal_income * marginal_rate
    else
    	@tax_brackets[bracket_index-1][:tax_at_limit] + (marginal_income * marginal_rate)
	  end
  end

    # Calculate Average Rate
  def average_rate
    if taxable_income == 0
      0
    else
      estimated_taxes / @gross_income
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
