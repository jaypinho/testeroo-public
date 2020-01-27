class ResultsController < ApplicationController

  before_action :set_result, only: [:show, :edit, :update, :destroy]

  skip_before_action :authenticate_users, only: [:generic_tester]

  def index
    if params.has_key?(:filter) && params[:filter] == 'passed'
      @results = Test.find(params[:test_id]).results.where(:passed => true).order(created_at: :desc)
    elsif params.has_key?(:filter) && params[:filter] == 'failed'
      @results = Test.find(params[:test_id]).results.where(:passed => false).order(created_at: :desc)
    else
      @results = Test.find(params[:test_id]).results.order(created_at: :desc)
    end

    respond_to do |format|
      format.html
      format.csv do
        headers['Content-Disposition'] = 'attachment; filename="testeroo_test_results.tsv"'
        headers['Content-Type'] ||= 'text/csv'
      end
    end

  end

  def new
    @result = Result.new(:test_id => params[:test_id])
  end

  def edit
    redirect_to test_results_path(@result.test) if @result.completed_at.blank? == false || @result.created_at < MAX_DAYS_ALLOWED_TO_FINISH_AN_INCOMPLETE_TEST.days.ago

    Aws.config.update({
      region: ENV['AWS_REGION'],
      credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
    })
    s3 = Aws::S3::Resource.new

    # associated_logs = s3.bucket('prod_an.live.data').object("facebook_qa_logs_version_3/facebook/display/events/2017-03-16/14/qa_logs.txt")
    associated_logs = s3.bucket('prod_an.live.data').object("facebook_qa_logs_version_3/facebook/display/events/#{@result.created_at.in_time_zone('Eastern Time (US & Canada)').strftime('%Y-%m-%d/%-k')}/qa_logs.txt")
    @logs = nil
    if associated_logs.exists?
      @logs = Array.new
      CSV.parse(Net::HTTP.get(URI.parse(associated_logs.presigned_url(:get, expires_in: 60))), headers: true, col_sep: "\t").each do |row|
        @logs << row
      end
    end
  end

  def create
    if params.has_key?(:complete_later)
      @result = Result.new(result_params.except(:passed).merge(:test_id => params[:test_id], :user_id => 1))
    else
      @result = Result.new(result_params.merge(:test_id => params[:test_id], :user_id => 1, :completed_at => DateTime.now))
    end
    respond_to do |format|
      if @result.save
        format.html { redirect_to test_results_path(@result.test) }
        # format.json { render action: 'show', status: :created, location: @result }
      else
        format.html { render action: 'new' }
        # format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if params.has_key?(:complete_later)
      revised_params = result_params.except(:passed).merge(:test_id => params[:test_id], :user_id => 1)
    else
      revised_params = result_params.merge(:test_id => params[:test_id], :user_id => 1, :completed_at => DateTime.now)
    end
    respond_to do |format|
      if @result.update(revised_params)
        format.html { redirect_to test_results_path(@result.test), notice: 'Result was successfully updated.' }
        # format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        # format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  def incomplete
    @results = Result.where(:completed_at => nil).order(created_at: :desc)
  end

  def generic_tester
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_result
    @result = Result.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def result_params
    params.require(:result).permit(:passed, :note, :jira)
  end

end
