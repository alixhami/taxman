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
  	  	]
  	}

  STANDARD_DEDUCTION = {
    single: 6300,
    mfj: 12600
  }

  PERSONAL_EXEMPTION = {
    single: 4050,
    mfj: 8100
  }

  PEP_THRESHOLD = {
    single: 258250,
    mfj: 309900
  }

end
