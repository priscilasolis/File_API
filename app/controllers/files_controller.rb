class FilesController < ApplicationController

  def index_upload
    puts "estoy en index"
    render :file_test
  end

  def upload_file
    puts "estoy en upload"
    conn = Faraday.new('http://localhost:8080') do |f|
      f.request :multipart
      f.request :url_encoded
      f.adapter :net_http # This is what ended up making it work
    end

    file = params["upload"]["datafile"].tempfile
    name = params["upload"]['datafile'].original_filename
    type = get_langid(name.split('.')[1])

    payload = { :codefile => Faraday::UploadIO.new(file, 'application/javascript'), :langid => type }

    conn.post('/compile', payload)

    respond_to do |format|
      format.html { render :file_test }
      format.json { render json: "success" }
    end

  end

  def get_langid(type)
    case type
      when 'js'
        return 0
      when 'java'
        return 1
      when 'rb'
        return 2
    end
  end

end
