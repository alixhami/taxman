# Note to self - run tests from main taxman folder with the following command:
# rspec spec/lib/taxman_spec.rb

require "spec_helper"
require_relative "../../lib/taxman"

describe Taxpayer do
  context "with $0 gross income" do
    user = Taxpayer.new('single',0)

    it "calculates $0 estimated taxes" do
      expect(user.estimated_taxes).to eq(0)
    end

    it "calculates 10% marginal tax rate" do
      expect(user.marginal_rate).to eq(0.1)
    end

    it "calculates 0% average tax rate" do
      expect(user.average_rate).to eq(0)
    end
  end
end

describe Taxpayer do
  context "with taxable income under 10% bracket" do
    user = Taxpayer.new('single',15_000)

    it "uses full personal exemption" do
      expect(user.personal_exemption).to eq(4_050)
    end

    it "calculates estimated taxes" do
      expect(user.estimated_taxes).to eq(465)
    end

    it "calculates average tax rate" do
      expect(user.average_rate).to be_within(0.001).of(0.031)
    end

    it "calculates marginal tax rate" do
      expect(user.marginal_rate).to eq(0.10)
    end
  end
end

describe Taxpayer do
  context "with taxable income between 25% and 28% bracket" do
    user = Taxpayer.new('single',150_000)

    it "uses full personal exemption" do
      expect(user.personal_exemption).to eq(4_050)
    end

    it "calculates estimated taxes" do
      expect(user.estimated_taxes).to eq(32_138.75)
    end

    it "calculates average tax rate" do
      expect(user.average_rate).to be_within(0.01).of(0.21)
    end

    it "calculates marginal tax rate" do
      expect(user.marginal_rate).to eq(0.28)
    end
  end
end

describe Taxpayer do
  context "with taxable income above the top bracket" do
    user = Taxpayer.new('single',500_000)

    it "completely phases out the personal exemption" do
      expect(user.personal_exemption).to eq(0)
    end

    it "calculates estimated taxes" do
      expect(user.estimated_taxes).to eq(151_675.15)
    end

    it "calculates average tax rate" do
      expect(user.average_rate).to be_within(0.01).of(0.30)
    end

    it "calculates marginal tax rate" do
      expect(user.marginal_rate).to eq(0.396)
    end
  end
end

describe "personal exemption phaseout" do
  it "calculates correctly mid-phaseout for single status" do
    user = Taxpayer.new('single', 275_000)
    expect(user.personal_exemption).to be_within(1).of(3_483)
  end

  it "calculates correctly mid-phaseout for mfj status" do
    user = Taxpayer.new('mfj',400_000)
    expect(user.personal_exemption).to be_within(1).of(2_106)
  end

  it "calculates correctly mid-phaseout for mfs status" do
    user = Taxpayer.new('mfs',200_000)
    expect(user.personal_exemption).to be_within(1).of(2_511)
  end

  it "calculates correctly mid-phaseout for head of household status" do
    user = Taxpayer.new('head_of_household',400_000)
    expect(user.personal_exemption).to be_within(1).of(243)
  end

  it "completely phases out above the end of single/mfj/hoh threshold" do
    user = Taxpayer.new('single', 380_750)
    expect(user.personal_exemption).to eq(0)
  end

  it "completely phases out above the end of the mfs threshold" do
    user = Taxpayer.new('mfs',216_200)
    expect(user.personal_exemption).to eq(0)
  end

end
