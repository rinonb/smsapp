class SmsContract < Dry::Validation::Contract
  params do
    required(:text).filled(:string)
    required(:sender).filled(:string)
    required(:receiver).filled(:string)
  end

  rule(:sender) do
    phone_number = Phonelib.parse(value)
    if phone_number.invalid?
      key.failure(' is not a valid phone number')
    else
      values[:sender] = phone_number.e164
    end
  end

  rule(:receiver) do
    phone_number = Phonelib.parse(value)
    if phone_number.invalid?
      key.failure(' is not a valid phone number')
    else
      values[:receiver] = phone_number.e164
    end
  end
end
