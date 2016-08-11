# determine tax brackets
# make a dictionary cap[10] = 9275 or cap[:10]
# taxpayer class holds methods
# => attr_reader and attr_accessor for calculation outputs needed in the launcher
# =>  means you can read and access something

# create giant class of taxpayer
# class variables
class Taxpayer
  attr_accessor :filing_status, :gross_income
  attr_reader :estimated_taxes, :average_rate, :marginal_rate, :standard_deduction, :personal_exemption

  def initialize(filing_status, gross_income)
      @filing_status = filing_status
      @gross_income = gross_income

      @bracket_limits = Hash.new(0)
	  case @filing_status
	  when "single"
	    @standard_deduction = 6300
	    @personal_exemption = 4050
	    @pep_threshold = 258250
	    @bracket_limits[10] = 9275.0
	    @bracket_limits[15] = 37650.0
	    @bracket_limits[25] = 91150.0
	    @bracket_limits[28] = 190150.0
	    @bracket_limits[33] = 413350.0
	    @bracket_limits[35] = 415050.0
	  when "mfj"
	    @standard_deduction = 12600
	    @personal_exemption = 8100
	    @pep_threshold = 309900
	    @bracket_limits[10] = 18550.0
	    @bracket_limits[15] = 75300.0
	    @bracket_limits[25] = 151900.0
	    @bracket_limits[28] = 231450.0
	    @bracket_limits[33] = 413350.0
	    @bracket_limits[35] = 466950.0
    end

	  # these variables store the maximum tax at each rate
	  @max_10 = @bracket_limits[10] * 0.1
	  @max_15 = ((@bracket_limits[15] - @bracket_limits[10]) * 0.15) + @max_10
	  @max_25 = ((@bracket_limits[25] - @bracket_limits[15]) * 0.25) + @max_15
	  @max_28 = ((@bracket_limits[28] - @bracket_limits[25]) * 0.28) + @max_25
	  @max_33 = ((@bracket_limits[33] - @bracket_limits[28]) * 0.33) + @max_28
	  @max_35 = ((@bracket_limits[35] - @bracket_limits[33]) * 0.35) + @max_33

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
	  @taxable_income = @gross_income - @standard_deduction - @personal_exemption

	  # calculate estimated taxes and marginal rate
	  if @taxable_income <= 0
	    @estimated_taxes = 0
	    @marginal_rate = 0
	    @average_rate = 0
	  elsif @taxable_income <= @bracket_limits[10]
	    @estimated_taxes = @taxable_income * 0.10
	    @marginal_rate = 10
	  elsif @taxable_income <= @bracket_limits[15]
	    @estimated_taxes = @max_10 + ((@taxable_income - @bracket_limits[10]) * 0.15)
	    @marginal_rate = 15
	  elsif @taxable_income <= @bracket_limits[25]
	    @estimated_taxes = @max_15 + ((@taxable_income - @bracket_limits[15]) * 0.25)
	    @marginal_rate = 25
	  elsif @taxable_income <= @bracket_limits[28]
	    @estimated_taxes = @max_25 + ((@taxable_income - @bracket_limits[25]) * 0.28)
	    @marginal_rate = 28
	  elsif @taxable_income <= @bracket_limits[33]
	    @estimated_taxes = @max_28 + ((@taxable_income - @bracket_limits[28]) * 0.33)
	    @marginal_rate = 33
	  elsif @taxable_income <= @bracket_limits[35]
	    @estimated_taxes = @max_33 + ((@taxable_income - @bracket_limits[33]) * 0.35)
	    @marginal_rate = 35
	  else
	    @estimated_taxes = @max_35 + ((@taxable_income - @bracket_limits[35]) * 0.396)
	    @marginal_rate = 39.6
	  end

	  # calculate average rate if not assigned above
	  @average_rate ||= (@estimated_taxes/@gross_income*100).to_i
	end
end

# format estimated taxes to display with commas
def dollar_format(number)
  "$" + number.ceil.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
end
