class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # def as_json(options = {})
  #   json = super(options)
  #   json[:minha_chave] = fone || "Telefone nao cadastrado"
  #   json
  # end

end
