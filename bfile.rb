require 'rubygems'
require 'sinatra'
require 'pdf-reader'
require 'txt2speech'

get '/upload' do
  haml :upload
end

post '/upload/:lang' do
  unless params[:file] && (tmpfile = params[:file][:tempfile]) && (name = params[:file][:filename])
    return haml(:upload)
  end

  reader = PDF::Reader.new(tmpfile)
  pages = reader.pages.map { |page| page.text }.join("\n")

  file_path = File.join(Dir.pwd, 'public/uploads', "#{File.basename(name, ".*" )}.mpg")

  f = Txt2Speech::Speech.new(pages, lang = params[:lang])
  f.save(file_path)

  send_file(file_path, :disposition => 'attachment')
end

__END__

@@upload
%h1 Upload

%form{:action => '/upload/en', :method=> 'post', :enctype => 'multipart/form-data'}
  %input{:type => 'file', :name => 'file', :accept => '.pdf'}
  %input{:type => 'submit', :value => 'Upload'}
