class Ahoy::Store < Ahoy::Stores::ActiveRecordTokenStore
  def exclude?
    bot? || request.ip == "109.131.95.254" 
  end
end
