module Tax
  BRACKETS = {
  		single: [
  	  	{rate: 0.10, limit: 9275.0},
  	  	{rate: 0.15, limit: 37650.0},
  	  	{rate: 0.25, limit: 91150.0},
  	  	{rate: 0.28, limit: 190150.0},
  	  	{rate: 0.33, limit: 413350.0},
  	  	{rate: 0.35, limit: 415050.0},
  	  	{rate: 0.396}
  	  	],
  	  mfj: [
  	  	{rate: 0.10, limit: 18550.0},
  	  	{rate: 0.15, limit: 75300.0},
  	  	{rate: 0.25, limit: 151900.0},
  	  	{rate: 0.28, limit: 231450.0},
  	  	{rate: 0.33, limit: 413350.0},
  	  	{rate: 0.35, limit: 466950.0},
  	  	{rate: 0.396}
      ],
      mfs: [
        {rate: 0.10, limit: 9275.0},
  	  	{rate: 0.15, limit: 37650.0},
  	  	{rate: 0.25, limit: 75950.0},
  	  	{rate: 0.28, limit: 115725.0},
  	  	{rate: 0.33, limit: 206675.0},
  	  	{rate: 0.35, limit: 233475.0},
  	  	{rate: 0.396}
      ],
      head_of_household: [
        {rate: 0.10, limit: 13250.0},
  	  	{rate: 0.15, limit: 50400.0},
  	  	{rate: 0.25, limit: 130150.0},
  	  	{rate: 0.28, limit: 210800.0},
  	  	{rate: 0.33, limit: 413350.0},
  	  	{rate: 0.35, limit: 441000.0},
  	  	{rate: 0.396}
      ]
  	}

  # For each filing status, the loop below loop below calculates the cumulative
  # maximum tax due if the taxpayer's taxable income was exactly at the bracket limit.
  BRACKETS.each do |key,val|
  	6.times do |i|
  		if i == 0
  			val[i][:tax_at_limit] = val[i][:rate] * val[i][:limit]
  		else
  			val[i][:tax_at_limit] = val[i-1][:tax_at_limit] + (val[i][:rate] * (val[i][:limit] - val[i-1][:limit]))
  		end
  	end
  end

  STANDARD_DEDUCTION = {
    single: 6300,
    mfj: 12600,
    mfs: 6300,
    head_of_household: 9300
  }

  PERSONAL_EXEMPTION = {
    single: 4050,
    mfj: 8100,
    mfs: 4050,
    head_of_household: 4050
  }

  PEP_THRESHOLD = {
    single: 258250,
    mfj: 309900,
    mfs: 154950,
    head_of_household: 284050
  }

end
