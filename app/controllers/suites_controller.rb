class SuitesController < ApplicationController

  before_action :set_suite, only: [:show, :edit, :update, :destroy]

  def index
    @suites = Suite.all

    respond_to do |format|
      format.html
      format.csv do
        headers['Content-Disposition'] = 'attachment; filename="testeroo_suites.tsv"'
        headers['Content-Type'] ||= 'text/csv'
      end
    end

  end

  def show
    @suite = Suite.find(params[:id])
  end

  def new
    @suite = Suite.new
  end

  def edit
  end

  def create
    @suite = Suite.new(suite_params)
    respond_to do |format|
      if @suite.save
        format.html { redirect_to suites_path }
        # format.json { render action: 'show', status: :created, location: @result }
      else
        format.html { render action: 'new' }
        # format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @suite.update(suite_params)
        format.html { redirect_to suites_path, notice: 'Suite was successfully updated.' }
        # format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        # format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_suite
    @suite = Suite.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def suite_params
    params.require(:suite).permit(:name, :max_days_since_last_passed_test)
  end

end
