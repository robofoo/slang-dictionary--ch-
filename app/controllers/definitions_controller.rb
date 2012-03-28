class DefinitionsController < ApplicationController
  # for cancan
  authorize_resource

  # GET /definitions
  # GET /definitions.json
  def index
    @definitions = Definition.order('created_at desc')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @definitions }
    end
  end

  # GET /definitions/1
  # GET /definitions/1.json
  def show
    @definition = Definition.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @definition }
    end
  end

  # GET /definitions/new
  # GET /definitions/new.json
  def new
    @definition = Definition.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @definition }
    end
  end

  # GET /definitions/1/edit
  def edit
    @definition = Definition.find(params[:id])
  end

  def thanks
  end

  # POST /definitions
  # POST /definitions.json
  def create
    @definition = Definition.new(params[:definition])

    respond_to do |format|
      if @definition.save
        if user_signed_in?
          format.html { redirect_to action: "confirm", :code => @definition.code }
        else
          UserMailer.confirm_definition_email(@definition.email, @definition.word, @definition.code).deliver
          format.html { redirect_to action: "thanks" }
        end
      else
        format.html { render action: "new" }
        format.json { render json: @definition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /definitions/1
  # PUT /definitions/1.json
  def update
    @definition = Definition.find(params[:id])

    respond_to do |format|
      if @definition.update_attributes(params[:definition])
        format.html { redirect_to @definition, notice: 'Definition was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @definition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /definitions/1
  # DELETE /definitions/1.json
  def destroy
    @definition = Definition.find(params[:id])
    @definition.destroy

    respond_to do |format|
      format.html { redirect_to definitions_url }
      format.json { head :no_content }
    end
  end

  # verify definitions match the code submitted by user
  def confirm
    @definition = Definition.where(:code => params[:code]).first

    if @definition
      @definition.status = 'confirmed'
      @definition.save!
    end
  end

  def review
    @definition = Definition.random_unconfirmed(current_user)
  end

  def accept
    if user_signed_in?
      definition = Definition.find(params[:id])
      definition.accept(current_user)
      message = t :'definitions.review.accept-message', :word => definition.word
      redirect_to({ :action => 'review' }, :flash => { success:message })
    else
      redirect_to new_user_session_path, :alert => t(:'definitions.review.signin-message')
    end
  end

  def reject
    if user_signed_in?
      definition = Definition.find(params[:id])
      definition.reject(current_user)
      message = t :'definitions.review.reject-message', :word => definition.word
      redirect_to({ :action => 'review' }, :flash => { error:message })
    else
      redirect_to new_user_session_path, :alert => t(:'definitions.review.signin-message')
    end
  end

  def upvote
    if user_signed_in?
      definition = Definition.find(params[:id])
      definition.upvote(current_user)
      redirect_to :back, params
    else
      redirect_to error_path(:error_code => 1)
    end
  end

  def downvote
    if user_signed_in?
      definition = Definition.find(params[:id])
      definition.downvote(current_user)
      redirect_to :back, params
    else
      redirect_to error_path(:error_code => 1)
    end
  end

end
