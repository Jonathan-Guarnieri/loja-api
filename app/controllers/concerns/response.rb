module Response
  def json(object, status = :ok, fields: nil)
    render json: object.as_json(only: fields), status: status
  end
end
