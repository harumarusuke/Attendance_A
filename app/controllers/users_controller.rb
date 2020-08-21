class UsersController < ApplicationController
  before_action :set_user, only: [:user_all_office, :show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:user_all_office, :show, :edit, :update, :index, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:index,:destroy, :edit_basic_info, :update_basic_info]
  before_action :set_one_month, only: [:show, :user_all_office]

  def index
    @users = User.all
    if params[:name].present?
      @users = @users.get_by_name params[:name]
    end
    if params[:id].present?
      @user = User.find_by(id: @users.id)
    else
      @user = User.new
    end
    #@users = User.all
    #if params[:id].present?
      #@user = User.find(params[:id])
    #else
      #@user = User.new
    #end
  end
  
  def csv_import
    if params[:file].blank?
      flash[:danger] = "CSVファイルを選択して下さい。"
      redirect_to users_url(@user)
    else
      User.import(params[:file])
      flash[:success] = "CSVファイルをインポートしました"
      redirect_to users_url(@user)
    end
  end
  
  def show        #Date.current当日取得　biginning_of_monthはRailsのメソッド
    #@first_day = Date.current.beginning_of_month
    #@last_day = @first_day.end_of_month #end_of_monthは当月の終日を取得(30日,31日は判断してくれる)
    @worked_sum = @attendances.where.not(started_at: nil).count
  end
  
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end
  
  def edit
    
  end
  
  def update
    if @user.update_attributes(basic_a_info_params)
      flash[:success] = "#{@user.name}の情報を更新しました。"
      redirect_to users_url(@user)
    else
      render :edit
    end
  end
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end
  
  def edit_basic_info
  end
  
  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      flash[:danger] = "#{@user.name}の更新に失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end
  
  def update_a_info
    if @user.update_attributes(basic_a_info_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      flash[:danger] = "#{@user.name}の更新に失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end
  
  def user_all_office
    @users = Attendance.all.includes(:user) 
  end
  
  def basic_information
  end 
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
    end
    
    def basic_info_params
      params.require(:user).permit(:department, :basic_time, :work_time)
    end
    
    def basic_a_info_params
      params.require(:user).permit(:name, :email, :affiliation, :employee_number, :uid,
                     :password, :basic_work_time, :designated_work_start_time, :designated_work_end_time)
    end
end
