class AssignmentsController < ApplicationController

  before_action :set_assignment, only: [:show, :edit, :update, :destroy]

  def index
    @assignments = Assignment.all
  end

  def create
    puts assignment_params
    @assignment = Assignment.new(assignment_params)
    respond_to do |format|
      if @assignment.save
        format.html { redirect_to metric_path(@assignment.metric) }
        # format.json { render action: 'show', status: :created, location: @result }
      else
        format.html { render action: 'new' }
        # format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @assignment.destroy
    respond_to do |format|
      format.html { redirect_to metric_path(@assignment.metric) }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_assignment
    @assignment = Assignment.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def assignment_params
    params.require(:assignment).permit(:metric_id, :test_id, :test_slot)
  end

end
