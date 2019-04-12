module API
  module V1
    module Resources
      class Widgets < Grape::API
        resource :widgets do
          desc 'Get all widgets'
            get do
              doorkeeper_authorize!
              present Widget.all, with: Entities::Widget
            end

          desc 'Get visible widget'
            params do
              optional :term, type: String
            end
            get :visible do
              widgets = Widget.visible.where("name LIKE ?", "%#{params[:term]}%")
              present widgets, with: Entities::Widget
            end

          desc 'Create a widget'
            params do
              requires :widget, type: Hash do
                requires :name,
                         type: String,
                         allow_blank: false
                requires :description,
                         type: String,
                         allow_blank: false
                requires :kind,
                         type: String,
                         allow_blank: false
              end
            end
            post do
              doorkeeper_authorize!
              current_user.widgets.create! name: params[:widget][:name],
                                           description: params[:widget][:description],
                                           kind: params[:widget][:kind]
            end

          desc 'Update widget'
            params do
              requires :widget, type: Hash do
                requires :name,
                         type: String,
                         allow_blank: false
                requires :description,
                         type: String,
                         allow_blank: false
              end
            end
            route_param :id do
              put do
                doorkeeper_authorize!
                widget = current_user.widgets.find_by(id: params[:id])
                authorize! :update, widget
                widget.update(
                    {
                        name: params[:widget][:name],
                        description: params[:widget][:description],
                    }
                ) if widget
              end
            end

          desc 'Delete widget'
            params do
              requires :id, type: Integer
            end
            delete ':id' do
              doorkeeper_authorize!
              widget = current_user.widgets.find_by(id: params[:id])
              authorize! :destroy, widget
              widget.destroy if widget
            end
        end
      end
    end
  end
end
