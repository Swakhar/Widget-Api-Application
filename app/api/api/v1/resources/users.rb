module API
  module V1
    module Resources
      class Users < Grape::API
        resource :users do
          desc 'Get current user profile'
            get :me do
              doorkeeper_authorize!
              present current_user, with: Entities::User
            end

          desc 'Check email'
            params do
              requires :email, type: String
            end
            get :email do
              user = User.find_by(email: params[:email])
              { available: true } if user
            end

          desc 'Get specific user profile'
            params do
              requires :id, type: Integer, desc: 'User id.'
            end
            route_param :id do
              get do
                doorkeeper_authorize!
                user = User.find(params[:id])
                present user, with: Entities::User
              end
            end

          desc 'Create user.'
          params do
            requires :user, type: Hash do
              requires :email,
                       type: String,
                       allow_blank: false
              requires :password,
                       type: String,
                       allow_blank: false
              requires :username,
                       type: String,
                       allow_blank: false
              requires :firstname,
                       type: String,
                       allow_blank: false
              requires :lastname,
                       type: String,
                       allow_blank: false
            end
          end
          post do
            User.create! email: params[:user][:email],
                         password: params[:user][:password],
                         username: params[:user][:username],
                         firstname: params[:user][:firstname],
                         lastname: params[:user][:lastname]
          end

          desc 'Update user.'
            params do
              requires :user, type: Hash do
                requires :username,
                         type: String,
                         allow_blank: false
              end
            end
            put :me do
              doorkeeper_authorize!
              current_user.update(
                  {
                      username: params[:user][:username]
                  }
              )
            end

          desc 'Change Password.'
            params do
              requires :user, type: Hash do
                requires :current_password,
                         type: String,
                         allow_blank: false

                requires :new_password,
                         type: String,
                         allow_blank: false
              end
            end
            post '/me/password' do
              doorkeeper_authorize!
              current_user.update_with_password(
                  {
                      current_password: params[:user][:current_password],
                      password: params[:user][:new_password]
                  }
              )
            end

          desc 'Reset Password.'
            params do
              requires :user, type: Hash do
                requires :email,
                         type: String,
                         allow_blank: false
              end
            end

            post '/reset_password' do
              user = User.find_by(email: params[:user][:email])
              return unless user

              new_password = Devise.friendly_token.first(7)
              ResetPasswordMailer.reset_password(params[:user][:email], new_password).deliver_now
              user.update({password: new_password})
            end

          desc 'Get visible widget of current user'
            params do
              optional :term, type: String
            end
            get '/me/widgets' do
              doorkeeper_authorize!
              widgets = current_user.widgets.where("name LIKE ?", "%#{params[:term]}%")
              present widgets, with: Entities::Widget
            end

          desc 'Get visible widget of another user'
            params do
              optional :term, type: String
            end
            route_param :id do
              get '/widgets' do
                doorkeeper_authorize!
                user = User.find(params[:id])
                widgets = if user.email == current_user.email
                            user.widgets.where("name LIKE ?", "%#{params[:term]}%")
                          else
                            user.widgets.visible.where("name LIKE ?", "%#{params[:term]}%")
                          end
                present widgets, with: Entities::Widget
              end
            end
        end
      end
    end
  end
end
