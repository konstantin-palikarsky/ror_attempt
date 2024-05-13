class ProjectsController < ApplicationController
  def index
    @search_api_suffix = "pdb/rest/projectFullSearch/v1.0/projects?searchterm="
    super
  end

  def printable_representation
    if session[:user_id].nil?
      redirect_to '/users/sign_in'
    else
      @with_annotation = params[:annotated] == 'true' ? true : false
      @user = User.find_by("id" => session[:user_id])
      @favorites_printable = @user.projects.all.sort_by(&:project_id)
      @annotation = Annotation.where("user_id" => session[:user_id], "annotation_type" => "project")
    end
  end

  def setkw

    old_kws = Keyword.find_by("annot_id" => params[:project_id], "user_id" => session[:user_id], "kw_type" => "project")

    if old_kws
      old_kws.update("keywords" =>
                       (old_kws.keywords.blank? || old_kws.keywords.nil? ?
                          "" : old_kws.keywords + ",") +
                         (params[:keyword] ? params[:keyword].to_s : ""))
    else
      new_kw = Keyword.new("annot_id" => params[:project_id], "user_id" => session[:user_id],
                           "keywords" => params[:keyword].to_s, "kw_type" => "project")
      new_kw.save
    end

    redirect_to "/projects/#{params[:project_id]}", status: :see_other
  end

  def removekw
    @keyword_entry = Keyword.find_by("annot_id" => params[:project_id],
                                     "user_id" => session[:user_id], "kw_type" => "project")

    @keywords = @keyword_entry&.keywords.split(",", -1)
    @keywords.delete_at(params[:ind].to_i)

    @keyword_entry.update("keywords" => @keywords.join(","))

    redirect_to "/projects/#{params[:project_id]}", status: :see_other
  end

  def show
    @is_xml = true
    @show_api_suffix = "pdb/rest/project/v3/"
    @annotation = Annotation.find_by("annot_id" => params[:id], "user_id" => session[:user_id], "annotation_type" => "project")
    @keywords = Keyword.find_by("annot_id" => params[:id],
                                "user_id" => session[:user_id], "kw_type" => "project")

    if @keywords
      @keywords = @keywords.keywords.split(",", -1)
    end

    super
  end

  def destroy
    @project = Project.find_by("project_id" => params[:project_id])
    @project.destroy

    redirect_to "/projects/favorites", status: :see_other
  end

  def create
    if session[:user_id].nil?
      redirect_to '/users/sign_in' and return
    end

    @project = Project.find_by("project_id" => params[:project_id])
    @user = User.find_by("id" => session[:user_id])

    if @project

      @user.projects.append(@project) unless @user.projects.include?(@project)
      redirect_to "/projects/favorites"

    else
      @title = params["title"] ? params["title"] : nil

      @project = Project.new("project_id" => params[:project_id], "title" => @title)

      if @project.save

        @user.projects.append(@project) unless @user.projects.include?(@project)

        redirect_to "/projects/favorites"
      else
        render :new, status: :unprocessable_entity
      end

    end

  end

  def annotate

    new_annotation = Annotation.new("annot_id" => params[:project_id], "user_id" => session[:user_id],
                                    "annotation" => params[:annotation], "annotation_type" => "project")

    old_annotation = Annotation.find_by("annot_id" => params[:project_id], "user_id" => session[:user_id], "annotation_type" => "project")

    if old_annotation
      old_annotation.update("annotation" => params[:annotation])
    else
      new_annotation.save
    end

    redirect_to "/projects/#{params[:project_id]}", status: :see_other
  end

  def favorites
    if session[:user_id].nil?
      redirect_to '/users/sign_in'
    else

      @user = User.find_by("id" => session[:user_id])
      @favorites = @user.projects.all

      if params[:order_by_title] == 'true'
        @favorites = @favorites.sort_by(&:title)
      else
        @favorites = @favorites.sort_by(&:created_at).reverse
      end
    end
  end
end
