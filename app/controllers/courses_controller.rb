class CoursesController < ApplicationController
  def index
    @search_api_suffix = "search/course/v1.0/quickSearch?searchterm="
    super
  end

  def printable_representation
    if session[:user_id].nil?
      redirect_to '/users/sign_in'
    else
      @with_annotation = params[:annotated] == 'true' ? true : false
      @user = User.find_by("id" => session[:user_id])
      @favorites_printable = @user.courses.all.sort_by(&:number_semester)
      @annotation = Annotation.where("user_id" => session[:user_id], "annotation_type" => "course")
    end
  end

  def setkw

    old_kws = Keyword.find_by("annot_id" => params[:course_id], "user_id" => session[:user_id], "kw_type" => "course")

    if old_kws
      old_kws.update("keywords" =>
                       (old_kws.keywords.blank? || old_kws.keywords.nil? ?
                          "" : old_kws.keywords + ",") +
                         (params[:keyword] ? params[:keyword].to_s : ""))
    else
      new_kw = Keyword.new("annot_id" => params[:course_id], "user_id" => session[:user_id],
                           "keywords" => params[:keyword].to_s, "kw_type" => "course")
      new_kw.save
    end

    redirect_to "/courses/#{params[:course_id]}", status: :see_other
  end

  def removekw
    @keyword_entry = Keyword.find_by("annot_id" => params[:course_id],
                                     "user_id" => session[:user_id], "kw_type" => "course")

    @keywords = @keyword_entry&.keywords.split(",", -1)
    @keywords.delete_at(params[:ind].to_i)

    @keyword_entry.update("keywords" => @keywords.join(","))

    redirect_to "/courses/#{params[:course_id]}", status: :see_other
  end

  def show
    @is_xml = true
    @show_api_suffix = "course/"
    @annotation = Annotation.find_by("annot_id" => params[:id], "user_id" => session[:user_id], "annotation_type" => "course")
    @keywords = Keyword.find_by("annot_id" => params[:id],
                                "user_id" => session[:user_id], "kw_type" => "course")

    if @keywords
      @keywords = @keywords.keywords.split(",", -1)
    end

    super
  end

  def destroy
    @course = Course.find_by("number_semester" => params[:number_semester])
    @course.destroy

    redirect_to "/courses/favorites", status: :see_other
  end

  def parse_number_semester(details_url)
    number_semester = details_url
    number_semester = number_semester.split('?')[1]
    number_semester[9..14] + '-' + number_semester[25..number_semester.length]
  end
  helper_method :parse_number_semester

  def create
    if session[:user_id].nil?
      redirect_to '/users/sign_in' and return
    end

    @course = Course.find_by("number_semester" => params[:number_semester])
    @user = User.find_by("id" => session[:user_id])

    if @course

      @user.courses.append(@course) unless @user.courses.include?(@course)
      redirect_to "/courses/favorites"

    else
      @course = Course.new("number_semester" => params[:number_semester], "title" => params["title"])

      if @course.save

        @user.courses.append(@course) unless @user.courses.include?(@course)

        redirect_to "/courses/favorites"
      else
        render :new, status: :unprocessable_entity
      end

    end

  end

  def annotate

    new_annotation = Annotation.new("annot_id" => params[:number_semester], "user_id" => session[:user_id],
                                    "annotation" => params[:annotation], "annotation_type" => "course")

    old_annotation = Annotation.find_by("annot_id" => params[:number_semester], "user_id" => session[:user_id], "annotation_type" => "course")

    if old_annotation
      old_annotation.update("annotation" => params[:annotation])
    else
      new_annotation.save
    end

    redirect_to "/courses/#{params[:number_semester]}", status: :see_other
  end

  def favorites
    if session[:user_id].nil?
      redirect_to '/users/sign_in'
    else

      @user = User.find_by("id" => session[:user_id])
      @favorites = @user.courses.all

      if params[:order_by_title] == 'true'
        @favorites = @favorites.sort_by(&:title)
      else
        @favorites = @favorites.sort_by(&:created_at).reverse
      end
    end
  end

end
