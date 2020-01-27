class TestsController < ApplicationController

  before_action :set_test, only: [:show, :edit, :update, :destroy]

  def index
    if params.has_key?(:priority)
      unpassed_tests = []
      Metric.all.each do |metric|
        for i in 1..metric.test_slots_count
          if metric.did_this_test_slot_pass(i) == false
            unpassed_tests << Test.joins(:assignments).select('tests.id').where(assignments: {:metric_id => metric.id, :test_slot => i}).pluck('tests.id')
          end
        end
      end
      unpassed_tests.flatten!
      unpassed_tests_ranked = Hash.new(0)
      unpassed_tests.each do |v|
        unpassed_tests_ranked[v] += 1
      end
      unpassed_tests_ranked = Hash[unpassed_tests_ranked.sort_by{|k, v| v}.reverse].map {|y,z| y}
      @tests = Test.where("id in (?)", unpassed_tests_ranked).sort_by { |x| unpassed_tests_ranked.index x.id }
    else
      @tests = Test.all
    end

    respond_to do |format|
      format.html
      format.csv do
        headers['Content-Disposition'] = 'attachment; filename="testeroo_tests.tsv"'
        headers['Content-Type'] ||= 'text/csv'
      end
    end

  end

  def new
    @test = Test.new
  end

  def edit
  end

  def create
    @test = Test.new(test_params)
    respond_to do |format|
      if @test.save
        format.html { redirect_to tests_path }
        # format.json { render action: 'show', status: :created, location: @result }
      else
        format.html { render action: 'new' }
        # format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @test.update(test_params)
        format.html { redirect_to tests_path, notice: 'Test was successfully updated.' }
        # format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        # format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  def import
    if request.post? && params.has_key?(:test)
      params[:test].each do |new_test|
        @new_test = Test.new(:description => new_test.split("|")[0].gsub("<p>", "").gsub('</p>', "\n\n").gsub("<br>", "\n").strip, :expected_result => new_test.split("|")[1].gsub("<p>", "").gsub('</p>', "\n\n").gsub("<br>", "\n").strip, :test_link => new_test.split("|")[2])
        @new_test.save
      end
      redirect_to tests_path
    elsif request.post?
      require 'csv'
      csv = File.read(params[:file].path).gsub(/\r\n/, "\r")
      @csv_tests = CSV.parse(csv, row_sep: "\r")
    else
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_test
    @test = Test.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def test_params
    params.require(:test).permit(:description, :expected_result, :test_link)
  end

end
