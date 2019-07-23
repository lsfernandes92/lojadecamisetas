class ProdutosController < ApplicationController

  before_action :set_produto, only: [:edit, :update, :destroy]

  def index
    @produtos_por_nome = Produto.all.order(:nome).limit 5
    @produtos_por_preco = Produto.all.order(:preco).limit 2
  end

  def new
    @produto = Produto.new
    renderiza :new
  end

  def create
    @produto = Produto.new produto_params
    if @produto.save
      flash[:notice] = "Produto salvo com sucesso!"
      redirect_to root_url
    else
      renderiza :new
    end
  end

  def edit
    renderiza :edit
  end

  def update
    if @produto.update produto_params
      flash[:notice] = "Produto atualizado com sucesso"
      redirect_to root_url
    else
      renderiza :edit
    end
  end

  def busca
    nome_a_buscar = "%#{params[:nome]}%"
    @produtos = Produto.where "nome like ?", nome_a_buscar
  end

  def destroy
    @produto.destroy
    redirect_to root_url
  end

  private

  def produto_params
    params.require(:produto).permit(:nome, :preco, :descricao, :quantidade, :departamento_id)
  end

  def renderiza(view)
    @departamentos = Departamento.all
    render view
  end

  def set_produto
    id = params[:id]
    @produto = Produto.find(id)
  end
end
