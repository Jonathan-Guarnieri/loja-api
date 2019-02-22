namespace :dev do
    desc "Popula o database com dados fictícios para testes"
    task setup: :environment do
        puts "cadastrando usuários..."
        10.times do
            User.create!(
                name: Faker::Name.unique.name,
                role: ["manager", "seller"].sample,
                login: Faker::Name.unique.first_name,
                password: Faker::Internet.password(8)
            )
        end
        puts "usuários cadastrados com sucesso!"

        puts "cadastrando contatos..."
        10.times do
            Contact.create!(
                name: Faker::Name.unique.name,
                address: Faker::Address.full_address,
                document: [CPF.generate, CNPJ.generate].sample,
                kind: ["client", "supplier"].sample
            )
        end
        puts "contatos cadastrados com sucesso!"

        puts "cadastrando telefones..."
        Contact.all.each do |contact|
          Random.rand(3).times do
            phone = Phone.create!(number: Faker::PhoneNumber.cell_phone)
            contact.phones << phone
            contact.save!
          end
        end
        puts "telefones cadastrados com sucesso!"

    end
end
