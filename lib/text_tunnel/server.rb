gem "sinatra", "~> 1.3.2"
require "sinatra/base"

class Server < Sinatra::Base
  post '/files' do
    watched_file = watched_files.create(params[:name], params[:data])
    spawn_editor(watched_file.local_path)

    logger.info "#{watched_file.id} - new - #{params[:name]} (#{watched_file.data.size} bytes)"

    status 201
    etag watched_file.hash
    headers "Location" => url("/files/#{watched_file.id}")
    nil
  end

  get "/files/:id" do
    logger.debug "#{params[:id]} - poll"

    watched_file = watched_files.find(params[:id])
    watched_file.poll
    etag watched_file.hash
    body watched_file.data
    
    logger.info "#{params[:id]} - sent - #{watched_file.data.size} bytes"
  end

  delete "/files/:id" do
    watched_file = watched_files.find(params[:id])
    watched_files.remove(watched_file)

    logger.info "#{params[:id]} - deleted"

    nil
  end

  def watched_files
    settings.watched_files
  end

  def spawn_editor(local_path)
    settings.editor_spawner.call(local_path)
  end
end
