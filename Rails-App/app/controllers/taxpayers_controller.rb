class TaxpayersController < ApplicationController
  def index
  end

  def new
  end

  def create
    @taxpayer = Taxpayer.new(taxpayer_params)
#    render plain: @taxpayer.estimated_taxes

#    @taxpayer.save
#    redirect_to @taxpayer
  end

  private

  def taxpayer_params
    params.require(:taxpayer).permit(:filing_status, :gross_income)
  end

end
