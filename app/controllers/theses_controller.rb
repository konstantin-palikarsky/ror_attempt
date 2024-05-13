class ThesesController < ApplicationController
  def index
    @search_api_suffix = "search/thesis/v1.0/quickSearch?searchterm="
    super
  end

  def printable_representation
    if session[:user_id].nil?
      redirect_to '/users/sign_in'
    else
      @with_annotation = params[:annotated] == 'true' ? true : false
      @user = User.find_by("id" => session[:user_id])
      @favorites_printable = @user.theses.all.sort_by(&:thesis_id)
      @annotation = Annotation.where("user_id" => session[:user_id], "annotation_type" => "thesis")
    end
  end

  def setkw

    old_kws = Keyword.find_by("annot_id" => params[:thesis_id], "user_id" => session[:user_id], "kw_type" => "thesis")

    if old_kws
      old_kws.update("keywords" =>
                       (old_kws.keywords.blank? || old_kws.keywords.nil? ?
                          "" : old_kws.keywords + ",") +
                         (params[:keyword] ? params[:keyword].to_s : ""))
    else
      new_kw = Keyword.new("annot_id" => params[:thesis_id], "user_id" => session[:user_id],
                           "keywords" => params[:keyword].to_s, "kw_type" => "thesis")
      new_kw.save
    end

    redirect_to "/theses/#{params[:thesis_id]}", status: :see_other
  end

  def removekw
    @keyword_entry = Keyword.find_by("annot_id" => params[:thesis_id],
                                     "user_id" => session[:user_id], "kw_type" => "thesis")

    @keywords = @keyword_entry&.keywords.split(",", -1)
    @keywords.delete_at(params[:ind].to_i)

    @keyword_entry.update("keywords" => @keywords.join(","))

    redirect_to "/theses/#{params[:thesis_id]}", status: :see_other
  end

  def annotate

    new_annotation = Annotation.new("annot_id" => params[:thesis_id], "user_id" => session[:user_id],
                                    "annotation" => params[:annotation], "annotation_type" => "thesis")

    old_annotation = Annotation.find_by("annot_id" => params[:thesis_id], "user_id" => session[:user_id], "annotation_type" => "thesis")

    if old_annotation
      old_annotation.update("annotation" => params[:annotation])
    else
      new_annotation.save
    end

    redirect_to "/theses/#{params[:thesis_id]}", status: :see_other
  end

  def show
    @annotation = Annotation.find_by("annot_id" => params[:id], "user_id" => session[:user_id], "annotation_type" => "thesis")
    @keywords = Keyword.find_by("annot_id" => params[:id],
                                "user_id" => session[:user_id], "kw_type" => "thesis")

    if @keywords
      @keywords = @keywords.keywords.split(",", -1)
    end

    @is_xml = true
    @show_api_suffix = "thesis/"
    super
  end

  def parse_id(details_url)
    url = details_url
    matches = url.match /thesisId=(\d*)/ # this is a regular expression that you can copy/paste
    id = matches[1]
  end

  helper_method :parse_id

  def destroy
    @thesis = Thesis.find_by("thesis_id" => params[:thesis_id])
    @thesis.destroy

    redirect_to "/theses/favorites", status: :see_other
  end

  def create
    if session[:user_id].nil?
      redirect_to '/users/sign_in' and return
    end

    @thesis = Thesis.find_by("thesis_id" => params[:thesis_id])
    @user = User.find_by("id" => session[:user_id])

    if @thesis

      @user.theses.append(@thesis) unless @user.theses.include?(@thesis)
      redirect_to "/theses/favorites"

    else
      @title = params["title"] ? params["title"] : nil

      @thesis = Thesis.new("thesis_id" => params[:thesis_id], "title" => @title)

      if @thesis.save

        @user.theses.append(@thesis) unless @user.theses.include?(@thesis)

        redirect_to "/theses/favorites"
      else
        render :new, status: :unprocessable_entity
      end

    end

  end

  def favorites
    if session[:user_id].nil?
      redirect_to '/users/sign_in'
    else

      @user = User.find_by("id" => session[:user_id])
      @favorites = @user.theses.all
      if params[:order_by_title] == 'true'
        @favorites = @favorites.sort_by(&:title)
      else
        @favorites = @favorites.sort_by(&:created_at).reverse
      end
    end
  end
end
