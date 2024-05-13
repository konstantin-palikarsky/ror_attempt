class PeopleController < ApplicationController

  def index
    @search_api_suffix = "person/v22/psuche?q="
    super
  end

  def printable_representation
    if session[:user_id].nil?
      redirect_to '/users/sign_in'
    else
      @with_annotation = params[:annotated] == 'true' ? true : false
      @user = User.find_by("id" => session[:user_id])
      @favorites_printable = @user.people.all.sort_by(&:tiss_id)
      @annotation = Annotation.where("user_id" => session[:user_id], "annotation_type" => "person")
    end
  end

  def setkw

    old_kws = Keyword.find_by("annot_id" => params[:person_id], "user_id" => session[:user_id], "kw_type" => "person")

    if old_kws
      old_kws.update("keywords" =>
                       (old_kws.keywords.blank? || old_kws.keywords.nil? ?
                          "" : old_kws.keywords + ",") +
                         (params[:keyword] ? params[:keyword].to_s : ""))
    else
      new_kw = Keyword.new("annot_id" => params[:person_id], "user_id" => session[:user_id],
                           "keywords" => params[:keyword].to_s, "kw_type" => "person")
      new_kw.save
    end

    redirect_to "/people/#{params[:person_id]}", status: :see_other
  end

  def removekw
    @keyword_entry = Keyword.find_by("annot_id" => params[:person_id],
                                     "user_id" => session[:user_id], "kw_type" => "person")

    @keywords = @keyword_entry&.keywords.split(",", -1)
    @keywords.delete_at(params[:ind].to_i)

    @keyword_entry.update("keywords" => @keywords.join(","))

    redirect_to "/people/#{params[:person_id]}", status: :see_other
  end

  def show
    @is_xml = false
    @show_api_suffix = "person/v22/id/"
    @annotation = Annotation.find_by("annot_id" => params[:id], "user_id" => session[:user_id], "annotation_type" => "person")
    @keywords = Keyword.find_by("annot_id" => params[:id],
                                "user_id" => session[:user_id], "kw_type" => "person")

    if @keywords
      @keywords = @keywords.keywords.split(",", -1)
    end

    super
  end

  def destroy
    @person = Person.find_by("tiss_id" => params[:tiss_id])
    @person.destroy

    redirect_to "/people/favorites", status: :see_other
  end

  def create
    if session[:user_id].nil?
      redirect_to '/users/sign_in' and return
    end

    @person = Person.find_by("tiss_id" => params[:tiss_id])
    @user = User.find_by("id" => session[:user_id])

    if @person

      @user.people.append(@person) unless @user.people.include?(@person)
      redirect_to "/people/favorites"

    else
      @person = Person.new("tiss_id" => params["tiss_id"], "first_name" => params["first_name"], "last_name" => params["last_name"])

      if @person.save

        @user.people.append(@person) unless @user.people.include?(@person)

        redirect_to "/people/favorites"
      else
        render :'people/search', status: :unprocessable_entity
      end

    end

  end

  def annotate
    new_annotation = Annotation.new("annot_id" => params[:person_id], "user_id" => session[:user_id],
                                    "annotation" => params[:annotation], "annotation_type" => "person")
    old_annotation = Annotation.find_by("annot_id" => params[:person_id], "user_id" => session[:user_id], "annotation_type" => "person")

    if old_annotation
      old_annotation.update("annotation" => params[:annotation])
    else
      new_annotation.save
    end

    redirect_to "/people/#{params[:person_id]}", status: :see_other
  end

  def favorites
    if session[:user_id].nil?
      redirect_to '/users/sign_in'
    else

      @user = User.find_by("id" => session[:user_id])
      @favorites = @user.people.all

      if params[:order_by_title] == 'true'
        @favorites = @favorites.sort_by(&:first_name)
      else
        @favorites = @favorites.sort_by(&:created_at).reverse
      end
    end
  end

  def full_person_report
    uri = URI("#{ENDPOINT}person/v22/id/#{params[:id]}")
    @tuwien_uri = "https://tiss.tuwien.ac.at:443/"

    Net::HTTP.start(uri.host, uri.port,
                    :use_ssl => uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new uri
      @response = http.request request # Net::HTTPResponse object
      @person = JSON.parse(@response.body)
    end

    uri = URI("#{ENDPOINT}search/thesis/v1.0/quickSearch?searchterm=#{@person["first_name"]}+#{@person["last_name"]}")

    Net::HTTP.start(uri.host, uri.port,
                    :use_ssl => uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new uri

      @theses_response = http.request request # Net::HTTPResponse object
      @my_theses_hash = JSON.parse(@theses_response.body)
    end

    if defined? @theses_response.body
      puts @theses_response.body
      @theses_search_results = @my_theses_hash["results"]
    end

    uri = URI("#{ENDPOINT}pdb/rest/projectFullSearch/v1.0/projects?searchterm=#{@person["first_name"]}+#{@person["last_name"]}")

    Net::HTTP.start(uri.host, uri.port,
                    :use_ssl => uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new uri

      @projects_response = http.request request # Net::HTTPResponse object
      @my_projects_hash = JSON.parse(@projects_response.body)
    end

    if defined? @projects_response.body
      puts @projects_response.body
      @projects_search_results = @my_projects_hash["results"]
    end

    uri = URI("https://tiss.tuwien.ac.at/api/course/lecturer/#{@person["oid"]}")

    Net::HTTP.start(uri.host, uri.port,
                    :use_ssl => uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new uri

      @courses_response = http.request request # Net::HTTPResponse object
      @courses_response = Nokogiri::XML(@courses_response.body)
      @courses_response.remove_namespaces!
      @courses_nodeset = @courses_response.xpath(".//tuvienna/course")
    end


    @search_key = params[:search_key]


  end




end

