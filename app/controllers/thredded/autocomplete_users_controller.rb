# frozen_string_literal: true

module Thredded
  class AutocompleteUsersController < Thredded::ApplicationController
    MAX_RESULTS = 20

    def index
      authorize_creating Thredded::PrivateTopicForm.new(user: thredded_current_user).private_topic
      users = users_by_prefix
      render json: {
        results: users.map { |user| user_to_autocomplete_result(user) }
      }
    end

    protected

    def user_to_autocomplete_result(user)
      {
        id: user.id,
        name: user.send(Thredded.user_name_column),
        display_name: user.send(Thredded.user_display_name_method),
        avatar_url: Thredded.avatar_url.call(user)
      }
    end

    private

    def users_by_prefix
      query = request.url.split('=').last.strip
      if query.length >= Thredded.autocomplete_min_length
        DbTextSearch::CaseInsensitive.new(users_scope, Thredded.user_name_column).prefix(query)
          .where.not(id: thredded_current_user.id)
          .limit(MAX_RESULTS)
      else
        []
      end
    end

    def users_by_ids
      ids = params[:ids].to_s.split(',')
      if ids.present?
        users_scope.where(id: ids)
      else
        []
      end
    end

    def users_scope
      thredded_current_user.thredded_can_message_users
    end
  end
end
