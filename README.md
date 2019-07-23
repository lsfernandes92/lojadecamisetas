# RoR 4 - Baby Steps

> *Documento de fixação do meu aprendizado em Ruby on Rails 4.
O mesmo foi baseado no curso "Ruby on Rails 4: do zero à web" da plataforma de cursos online da Alura.*

Esse carinha será uma simulação de uma loja de camisetes. Para isso será apresentado os conceitos de MVC que o framework nos oferece. Usei também a integração com banco de dados SQLite e o bootstrap para a parte visual da página.

Ao finalizarmos nosso site, seremos capazes de criar listagens, fazer buscas, remover e alterar produtos, reaproveitando o formulário e fazer validações.

## Instalação

#### MacOS

Por default o mac já vem com o Ruby instalado. Para tirar proveito do Rails basta instalar a gem do mesmo com o comando `gem install rails`.

#### Windows

Existe uma forma bem bacanuda de instalar o Ruby/Rails usando o [Chocolatey](https://chocolatey.org/). Ele é um gerenciador de pacotes para o Windows muito massa! Recomendo dar uma olhada. Porém na hora de instalar tive uns problemas de dependências que não foram instaladas. Na falta de paciência instalei baixando o **.exe** do próprio site do [Ruby](https://rubyinstaller.org/downloads/). Esse carinha configurou o Ruby e o Rails sem dores de cabeça.

## Criando projeto e iniciando o servidor

Para criar um projeto basta entrar na pasta de preferência e dar um `rails new <nome_do_projeto>`.

A saída irá ser algo parecido com isso:

```
    ...
    create  app
    create  app/assets/config/manifest.js
    create  app/assets/javascripts/application.js
    create  app/assets/javascripts/cable.js
    create  app/assets/stylesheets/application.css
    create  app/channels/application_cable/channel.rb
    create  app/channels/application_cable/connection.rb
    create  app/controllers/application_controller.rb
    create  app/helpers/application_helper.rb
    create  app/jobs/application_job.rb
    create  app/mailers/application_mailer.rb
    create  app/models/application_record.rb
    create  app/views/layouts/application.html.erb
    create  app/views/layouts/mailer.html.erb
    create  app/views/layouts/mailer.text.erb
    create  app/assets/images/.keep
    create  app/assets/javascripts/channels
    create  app/assets/javascripts/channels/.keep
    create  app/controllers/concerns/.keep
    create  app/models/concerns/.keep
    create  bin
    create  bin/bundle
    create  bin/rails
    create  bin/rake
    ...
```

Logo após o Rails irá baixar a dependências do pejeto que se localiza no arquivo **Gemfile**.

> O arquivo **Gemfile** é o responsável por listar todas as dependências que o projeto necessita. Qualquer momento ele pode ser modificado para atender outras bibliotecas ou plugins necessário para o projeto em determinado momento. Caso ele for atualizado, o comando `bundle install` deverá executado para que as novas dependências sejam instaladas.

Após feitos os passos acima basta iniciar o servidor rails com `rails server` aka `rails s` e acessar o link **http://localhost:3000**. Se a página inicial do rails for apresentada, sucesso! Você passou upou de level.

## Criando página inicial

Para dar inicio a loja de camisetas, criarei a primeira view chamada **index.html.erb** (a extensão **".erb"** é responsável por executar código ruby) no seguinte caminho **<nome_projeto>/app/views**.

Meu **index.html.erb**:
```
<% if  flash[:notice] %>
  <div class="alert alert-success">
    <%= flash[:notice] %>
  </div>
<% end %>

<table class="table table-bordered">
    <thead>
        <tr>
            <th>Nome</th>
            <th>Descrição</th>
            <th>Preço</th>
            <th></th>
            <th></th>
        </tr>
    </thead>
    <tbody>
      <%= render @produtos_por_nome %>
    </tbody>
</table>

<table class="table table-bordered">
    <thead>
        <tr>
            <th>Nome</th>
            <th>Descrição</th>
            <th>Preço</th>
            <th></th>
            <th></th>
        </tr>
    </thead>
    <tbody>
      <%= render @produtos_por_preco %>
    </tbody>
</table>

```

## Arquivo route.rb

Para que o Rails reconheça nosso index recém criado, necessitamos configurar um rota no arquivo **<nome_projeto>/config/routes.rb**. Dentro desse arquivo definimos como queremos que o URL de nossas views seja chamada no browser e quem será responsável(Controller) por aglomerar as funções de uma página.

Arquivo **routes.rb**:
```
  Rails.application.routes.draw do
      get "produtos" => "produtos#index"
  end
```

Exemplificando:

`get "[o nome que queremos para a URL]" => "[nome do Controller]#[nome da página]"`


#### Resources

Afim de não ficar repetindo todas as rotas que iremos criar posteriormente(criar, alterar, excluir e buscar), o Rails nos disponibiliza uma convenção para criarmos elas de forma mais simples e sem precisa ficar repetindo esse padrão. Quem é responsável por isso é o **resources**, que deve ser especificado da seguinte maneira:

Arquivo **routes.rb**:
```
Rails.application.routes.draw do
  resources :produtos, only: [:new, :create, :destroy, :edit, :update]
  get "produtos/busca" => "produtos#busca", as: :busca_produto
  root "produtos#index"
end
```

Note que:
- O **resources** foi usado para todas as rotas **/produtos** atribuindo o símbolo **:produtos**
- O **only:** é uma propriedade para que eu determine qual rota eu quero que ele crie pra mim, senão o Rails cria um monte de rotas desnecessárias
- As rotas que irei usar são as **new, create, destroy, edit e update**. Todas passadas como um símbolo para dentro de um Array da propriedade **only:**. São elas também que irão para o meu  **produtos_controller.rb**.
- A rota **/new** será responsável por entrar na página de criação e a **/create** efetivará a inserção, assim como a **/edit** entrará na página de edição e o **/update** fará a alteração.
- A rota de **/busca** ainda assim tem de ser criada na mão. (Ainda não sei porque :D)
- **root "produtos#index"** com isso tornei meu **localhost:3000** minha página inicial.

## Classe Controller e agrupando regras de negócio

Criar o Controller basta executar o comando `rails generate controller produtos` ("produtos", por padrão do rails, o nome do recurso sempre no plural quando se trata de *controllers*). Nesse momento uma pasta **produtos** será criada em nossa parta **app/views**. Vamos mover nosso **index.html.erb** para a pasta **produtos** para melhor organização.

A classe de controle terá a função implementar comportamentos a cada requisição de página, ou seja, para cada rota criada no **routes.rb**, deve existir uma método de mesmo nome na classe de controller.

A classe de modelo por enquanto.

**app/controllers/produtos_controller.rb**:

```
class ProdutosController < ApplicationController

  def index
    @produtos_por_nome = Produto.all.order(:nome).limit 5
    @produtos_por_preco = Produto.all.order(:preco).limit 2
  end

  def new

  end

  def create

  end

  def edit

  end

  def update

  end

  def busca

  end

  def destroy

  end
end

```

Na nossa View chamamos uma váriavel de instância chamada **@produtos_por_nome** e **produtos_por_preco**. O valor delas nada mais é do que uma query de produtos ordenados por nome e outra por preço. Denovo... Como boa prática as variáveis estão sendo criadas em nosso **app/controllers/produtos_controller.rb** onde é nele que devemos focar nossas **ações de negócio**.

## Usando SQLite e Criando o Modelo

Queremos realizar as operações de CRUD em nossos produtos. Isso só é possível usando um banco de dados. Aqui irei implementar o **SQLite** que é o banco padrão do Rails e o mesmo que está em nosso **Gemfile**.

No terminal inserimos `rake db:create` para criação do banco.

Após isso precisamos gerar nossa tabela com o comando `rails generate model produto nome:string descricao:text quantidade:integer preco:decimal`. Com isso criaremos tanto nossa classe de modelo Produto quanto um esquema para gerar nossa tabela no banco. Esse template do banco pode ser encontrado em **db/migrate**.

Arquivo **create_produtos.rb**:
```
class CreateProdutos < ActiveRecord::Migration
    def change
        create_table :produtos do |t|
            t.string :nome
            t.text :descricao
            t.integer :quantidade
            t.decimal :preco

            t.timestamps null: false
        end
    end
end
```

Só precisamos ir ao nosso terminal e usar `rake db:migrate` para migrar o script acima. Para conferirmos a tabela criada entramos em `rails dbconsole` e `.tables`. Resultado:

```
sqlite> .tables
produtos            schema_migrations
```

#### Inserindo no banco

Para teste iremos inserir uma camiseta no banco. `rails console` neles!

No console digito...
```
irb(main):008:0> Produto.create nome: "Camiseta do Haizenbé", descricao: "Camiseta do veio careca do Breaking Bad", quantidade: 50, preco: 55.5
```

Para vermos nosso produto inserido, fazemos:
```
irb(main):009:0> todos = Produto.all    //devolve todos os produtos com todos os dados em forma de array

irb(main):010:0> todos.size    //devolve a quantidade de produtos inputados

irb(main):011:0> todos[0].nome    //devolve o campo "nome" do primeiro produto ([1] para o segundo e assim por diante)
```

A parte legal aqui é essa facilidade de realizar querys chamando métodos de nosso objeto *Produto* sem utilizar querys SQL.

> A título de curiosidade toda classe de modelo herda de **ActiveRecord::Base**. A ActiveRecord é responsável por fazer de nossa classe de modelo um objeto que pode persistir dados no banco quando estamos no console. Igual vimos nos exemplos acima.


## Tabela de produtos dinâmica e o poder do **Partials**

Para deixarmos nossa lista de nosso index.html.erb dinâmica vamos fazer com que o Ruby faça isso pra gente. A tabela inicial terá o trabalho de trazer todas a camisetas inseridas no banco uma a uma.

Existe um recurso que nos permite extrair todos os comportamentos que se repetem, que queremos reaproveitar em outras páginas, para um único arquivo. Ele só terá a parte do código que será copiada para as outras páginas, damos a ele o nome de *partial* e, para identificá-la usamos o símbolo de underline: **_produto.html.erb**. Salvamos dentro do diretório **/views/produtos**.

O uso de *partials* aqui é importante podemos fazer reuso da tabela de produtos na nossa index.html e quando buscarmos um produto.

Arquivo **_produto.html.erb***:
```
<tr>
    <td><%= produto.nome %></td>
    <td><%= produto.descricao %></td>
    <td><%= produto.preco %></td>
    <td><%= button_to "Remover", produto,
                                method: :delete,
                                class: "btn btn-danger",
                                data: { confirm: "Tem certeza que deseja remover o produto \"#{produto.nome}\" ?" } %>
    </td>
    <td><%= link_to "Alterar", edit_produto_path(produto),
                                class: "btn btn-default" %></td>
</tr>
```

Para renderizar essa parte do código em nossas páginas usamos o `<%= render partial: "produto", collection: @produtos_por_nome %>` ou de forma resumida `<%= render @produtos_por_nome %>` igual temos no nosso **index.html.erb**.

Quando usamos o render com partial nesta situação, estamos dizendo ao Rails que após o controller retornar variável de instancia **@produtos_por_nome** com query de produtos ordenados por preço, para cada produto dessa query, nossa partial irá renderizar a linha com nome, descrição, e preço do produto e os botões "Remover" e "Alterar". Mágico, não? :)

## Estilizando com Bootstrap

As propriedades de classe usadas nos elementos, como **class: "btn btn-danger"**, somente fará sentido e irá ser alterada após instalar o bootstrap na aplicação. O Rails disponibiliza um gem que se encarrega de atualizar nossos html's com com o novo estilo.

Para isso no final do arquivo **Gemfile**, adicione a seguinte linha:

`gem 'twitter-bootstrap-rails'`

Execute o comando `bundle install` para instalar as novas gems.

Por enquanto, apenas instalamos a gem. Agora vamos solicitar para que os arquivos sejam gerados dentro do nosso projeto:

`rails generate bootstrap:install static`

Nesse momento, será preciso reiniciar o servidor do Rails. Pare o servidor utilizando **Ctrl + C** caso ele esteja em execução. Inicie novamente utilizando o comando  **rails s**.

## Troubleshooting

No Windows quando fiz o passo a passo desse tutorial o Rails não estava reconhecendo minha tag **<%= csrf_meta_tags %>"** em meu arquivo **app/views/layout/application.html.erb**. Para isso adicionei a `gem 'coffee-script-source', '1.8.0'` no meu arquivo **Gemfile** e rodei o comando `bundle update coffee-script-source` no terminal. Esse compartamento foi inesperado por isso adicionei esse item.

## Conclusão

Vantagens
* Fácil configurar
* Facilidade no hora do crud da conexão de classes de modelo com a tabela do banco
* Convention over configuration

## Referências

* [API Ruby](http://api.rubyonrails.org/)
* [DOC Bootstrap](https://getbootstrap.com/docs/4.0/getting-started/introduction/)
* [Rails Guides](http://guides.rubyonrails.org/)
* [Mal funcionamento do coffe-script no Windows](https://stackoverflow.com/questions/28421547/rails-execjsprogramerror-in-pageshome)
