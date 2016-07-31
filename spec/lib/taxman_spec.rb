require "spec_helper"
require_relative "../../lib/taxman"

describe "personal exemption phaseout" do
  it "uses full exemption when under threshold" do
    $filing_status = 'single'
    $gross_income = 10_000
    calc_personal_exemption
    expect($personal_exemption).to eq(4050)
  end
end

describe "personal exemption phaseout" do
  it "calculates correctly mid-phaseout" do
    $filing_status = 'single'
    $gross_income = 275_000
    calc_personal_exemption
    expect($personal_exemption).to eq(3483)
  end
end

describe "personal exemption phaseout" do
  it "completely phase out above limit" do
    $filing_status = 'single'
    $gross_income = 380750
    calc_personal_exemption
    expect($personal_exemption).to eq(0)
  end
end
