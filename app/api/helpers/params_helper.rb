module ParamsHelper
  def declared_params
    declared(params)
  end

  def merged_params
    declared_params.merge(access_token: @current_token.token)
  end
end
