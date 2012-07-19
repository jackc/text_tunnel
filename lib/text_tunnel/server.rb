gem "sinatra", "~> 1.3.2"
require "sinatra/base"

class Server < Sinatra::Base
  post '/files' do
    watched_file = watched_files.create(params[:file][:filename], params[:file][:tempfile].read)
    spawn_editor(watched_file.local_path)
    status 201
    etag watched_file.hash
    headers "Location" => url("/files/#{watched_file.id}")
    nil
  end

  get "/files/:id" do
    watched_file = watched_files.find(params[:id])
    watched_file.poll
    etag watched_file.hash
    watched_file.data
  end

  delete "/files/:id" do
    watched_file = watched_files.find(params[:id])
    watched_files.remove(watched_file)
    nil
  end

  def watched_files
    settings.watched_files
  end

  def spawn_editor(local_path)
    settings.editor_spawner.call(local_path)
  end
end
