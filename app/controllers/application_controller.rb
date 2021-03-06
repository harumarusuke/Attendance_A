class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  $days_of_the_week = %w{日 月 火 水 木 金 土}
  
  def set_user
    @user = User.find(params[:id]) #パラムスハッシュからユーザーを取得する
  end
  
  def logged_in_user
    unless logged_in?  #unlseeはfalseで返された場合のみに中を実行する
      store_location
      flash[:danger]= "ログインしてください。"
      redirect_to login_url
    end
  end
  
  def admin_user
    redirect_to root_url unless current_user.admin?
  end
  
  def correct_user
    @user = User.find(params[:id]) #beforeアクションでは各アクションが実行される
                                   #直前に処理がされるので@userの定義が必要
    if !current_user.admin?
      redirect_to(root_url) unless current_user?(@user)
    end                            # 上のcurrent_user?()はセッションヘルパーメソッドから
  end                           

  # ページ出力前に1ヶ月分のデータの存在を確認・セットします。
  def set_one_month 
    @first_day = params[:date].nil? ? Date.current.beginning_of_month : params[:date].to_date
    #下の５行を上の１行に。
    #if params[:date].nil?
    #@first_day = Date.current.beginning_of_month
    #else
    #@first_day = params[:date].to_date
    #end
    
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day] # 対象の月の日数を代入します。
    # ユーザーに紐付く一ヶ月分のレコードを検索し取得します。
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)

    unless one_month.count == @attendances.count # それぞれの件数（日数）が一致するか評価します。
      ActiveRecord::Base.transaction do # トランザクションを開始します。
        # 繰り返し処理により、1ヶ月分の勤怠データを生成します。
        one_month.each { |day| @user.attendances.create!(worked_on: day) }
      end
      @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    end

  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "ページ情報の取得に失敗しました、再アクセスしてください。"
    redirect_to root_url
  end
end