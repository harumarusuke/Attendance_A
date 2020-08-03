class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:show, :edit, :update, :index, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info]
  before_action :set_one_month, only: :show
  
  def index
    @users = User.paginate(page: params[:page])
    #@users = query.order(:id).page(params[:page])

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
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新に成功しました。"
      redirect_to @user
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
  
  private
  
    def set_user
      @user = User.find(params[:id]) #パラムスハッシュからユーザーを取得する
    end
  
    def user_params
      params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
    end
    
    def basic_info_params
      params.require(:user).permit(:department, :basic_time, :work_time)
    end
    
    def logged_in_user
      unless logged_in?  #unlseeはfalseで返された場合のみに中を実行する
        store_location
        flash[:danger]= "ログインしてください。"
        redirect_to login_url
      end
    end
    
    def correct_user
      @user = User.find(params[:id]) #beforeアクションでは各アクションが実行される
                                     #直前に処理がされるので@userの定義が必要
      redirect_to(root_url) unless current_user?(@user)
    end                            # 上のcurrent_user?()はセッションヘルパーメソッドから
    
    def admin_user
      redirect_to root_url unless current_user.admin?
    end
      
  
end
