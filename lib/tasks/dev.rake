namespace :dev do
    desc "Popula o database com dados fictícios para testes"
    task setup: :environment do
        puts "cadastrando usuários..."
        10.times do
            User.create!(
                name: Faker::Name.unique.name,
                role: ["manager", "seller"].sample,
                email: Faker::Internet.email,
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
            phone = Phone.create!(number: "49 9-9940-7410")
            contact.phones << phone
            contact.save!
          end
        end
        puts "telefones cadastrados com sucesso!"

        puts "cadastrando produtos..."
        10.times do
            Product.create!(
                name: Faker::Name.unique.name,
                purchase_price: Random.rand(1.00...2.00).round(2),
                sale_price: Random.rand(3.00...4.00).round(2),
                amount: Random.rand(0...100)
            )
        end
        puts "produtos cadastrados com sucesso!"

    end
end
