module ParamsHelper
  def merged_params(params)
    declared(params).merge(access_token: @current_token.token)
  end
end
