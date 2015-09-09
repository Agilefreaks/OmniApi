class UserBuilder
  def build(params)
    50.percent_of_the_time do
      params[:via_omnipaste] = false
    end

    user = User.create(params)

    user
  end
end
