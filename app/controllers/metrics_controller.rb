class MetricsController < ApplicationController

  before_action :set_metric, only: [:show, :edit, :update, :destroy]

  before_action :dont_delete_occupied_test_slots, only: [:update]

  def index
    @metrics = Metric.all
    respond_to do |format|
      format.html
      format.csv do
        headers['Content-Disposition'] = 'attachment; filename="testeroo_metrics.tsv"'
        headers['Content-Type'] ||= 'text/csv'
      end
    end

  end

  def show
    @metric = Metric.find(params[:id])
    @metric_tests_array = Array.new
  end

  def new
    @metric = Metric.new
  end

  def edit
  end

  def create
    @metric = Metric.new(metric_params)
    respond_to do |format|
      if @metric.save
        format.html { redirect_to metrics_path }
        # format.json { render action: 'show', status: :created, location: @result }
      else
        format.html { render action: 'new' }
        # format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @metric.update(metric_params)
        format.html { redirect_to metric_path(@metric), notice: 'Metric was successfully updated.' }
        # format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        # format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_metric
    @metric = Metric.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def metric_params
    params.require(:metric).permit(:name, :definition, :ad_format, :environment, :test_slots_count, :suite_id, :metric_type, :max_days_since_last_passed_test)
  end

  def dont_delete_occupied_test_slots
    if params[:metric][:test_slots_count].to_i < @metric.test_slots_count && @metric.assignments.where('test_slot > ?', params[:metric][:test_slots_count].to_i).count > 0
      redirect_to metric_path(@metric), notice: "You can only remove empty test slots. To remove test slots that contain tests, first remove the tests from the slot and then remove the slot itself."
    end
  end

end
