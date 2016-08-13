class Taxpayer

  attr_accessor :gross_income
  attr_reader :estimated_taxes, :average_rate, :marginal_rate, :standard_deduction, :personal_exemption

  def initialize(filing_status,gross_income)
    @gross_income = gross_income
    @filing_status = filing_status

    case @filing_status
    	  when "single"
    	    @standard_deduction = 6300
    	    @personal_exemption = 4050
    	    @pep_threshold = 258250
          @tax_brackets = [
          	{rate: 0.10, limit: 9275.0},
          	{rate: 0.15, limit: 37650.0},
          	{rate: 0.25, limit: 91150.0},
          	{rate: 0.28, limit: 190150.0},
          	{rate: 0.33, limit: 413350.0},
          	{rate: 0.35, limit: 415050.0},
          	{rate: 0.396}
          ]
    	  when "mfj"
    	    @standard_deduction = 12600
    	    @personal_exemption = 8100
    	    @pep_threshold = 309900
    	    @tax_brackets = [
            {rate: 0.10, limit: 18550.0},
          	{rate: 0.15, limit: 75300.0},
          	{rate: 0.25, limit: 151900.0},
          	{rate: 0.28, limit: 231450.0},
          	{rate: 0.33, limit: 413350.0},
          	{rate: 0.35, limit: 466950.0},
          	{rate: 0.396}
          ]
    end

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

    # Calculate Average Rate
    if @taxable_income == 0
      @average_rate = 0
    else
      @average_rate = @estimated_taxes / @gross_income
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
