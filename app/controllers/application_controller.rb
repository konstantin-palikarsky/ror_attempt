class ApplicationController < ActionController::Base
  require 'net/http'
  require 'json'
  require 'nokogiri'
  require 'open-uri'

  ENDPOINT = "https://tiss.tuwien.ac.at/api/"
  @search_api_suffix = ''
  @show_api_suffix = ''
  @is_xml = false

  def index
    params.require(:search_term)

    # uri = URI("https://tiss.tuwien.ac.at/api/person/v22/psuche?q=#{params[:search_term]}")

    uri = URI("#{ENDPOINT}#{@search_api_suffix}#{params[:search_term]}")

    Net::HTTP.start(uri.host, uri.port,
                    :use_ssl => uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new uri

      @response = http.request request # Net::HTTPResponse object
      @my_hash = JSON.parse(@response.body)
    end

    if defined? @response.body
      puts @response.body
      @search_results = @my_hash["results"]
    end
  end

  def show
    @tuwien_uri = "https://tiss.tuwien.ac.at:443/"

    # uri = URI("https://tiss.tuwien.ac.at/api/person/v22/id/#{params[:id]}")

    uri = URI("#{ENDPOINT}#{@show_api_suffix}#{params[:id]}")


    Net::HTTP.start(uri.host, uri.port,
                    :use_ssl => uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new uri

      @response = http.request request # Net::HTTPResponse object

      if @is_xml
        @response_object = Nokogiri::XML(@response.body)
        @response_object.remove_namespaces!
        puts @response_object
      else
        @response_object = JSON.parse(@response.body)
        puts @response.body
      end

    end
  end


end
