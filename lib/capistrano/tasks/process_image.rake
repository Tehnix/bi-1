require 'erb'

namespace :deploy do
  desc 'Processes graphic assets'
  task :process_graphics do
    on roles(:app) do
      rsync_host = host.to_s
      execute "mkdir -p public/images/"

      run_locally do
        public_path = "#{Dir.pwd}/public"
        icons_path = "#{public_path}/icons"
        images_path = "#{public_path}/images"
        execute "mkdir -p #{icons_path}"

        # ['198', '208', '248', '262', '396', '416', '526', '624'].each do |dpi|
        dimensions = {
          apple: ['57x57', '60x60', '72x72', '76x76', '114x114',
                  '120x120', '144x144', '152x152', '180x180'],
          android: ['36x36', '48x48', '72x72', '96x96', '144x144',
                    '192x192'],
          favicon: ['16x16', '32x32', '48x48', '96x96']
        }

        # Apple
        dimensions[:apple].each do |dim|
          width, height = dim.split('x')
          execute "inkscape -z -e #{icons_path}/apple-touch-icon-#{dim}.png "\
                  "-w #{width} -h #{height} -C #{public_path}/app_icon.svg"
        end
        execute "cp #{icons_path}/apple-touch-icon-#{dimensions[:apple][-1]}.png"\
                " #{icons_path}/apple-touch-icon.png"

        # Android
        dimensions[:android].each do |dim|
          width, height = dim.split('x')
          execute "inkscape -z -e #{icons_path}/android-chrome-#{dim}.png "\
                  "-w #{width} -h #{height} -C #{public_path}/app_icon.svg"
        end

        # Favicon
        width, height = dimensions[:favicon][-1].split('x')
        execute "inkscape -z -e "\
                "#{icons_path}/favicon-#{dimensions[:favicon][-1]}.png "\
                "-w #{width} -h #{height} -C #{public_path}/app_icon.svg"
        dimensions[:favicon][0..-2].each do |dim|
          if dim == dimensions[:favicon][-2]
            ext = 'ico'
          else
            ext = 'png'
          end

          execute "convert -size #{dim} "\
                  "#{icons_path}/favicon-#{dimensions[:favicon][-1]}.png "\
                  "#{icons_path}/favicon-#{dim}.#{ext}"
        end

        execute "mv #{icons_path}/favicon-#{dimensions[:favicon][-2]}.ico #{icons_path}/favicon.ico"

        # shortcut icon
        icons = []
        icon_files = Dir["#{icons_path}/*"]
        for icon in icon_files
          icon = File.basename(icon)
          if icon =~ /apple-touch-icon/
            type = 'apple-touch-icon'
          elsif icon =~ /\.ico$/
            type = 'shortcut icon'
          elsif icon =~ /android|favicon-/
            type = 'icon'
          end

          dimensions = /[0-9]{2}x[0-9]{2}/.match(icon) || ''
          unless dimensions.nil?
            dimensions = 'sizes="' << dimensions.to_s << '"'
          end

          icons << { name: icon, dimensions: dimensions, type: type }
        end

        File.open("#{public_path}/index.html", "w+") do |f|
          f.write(ERB.new(File.read("#{public_path}/index.html.erb"),
                          nil, '-')
                     .result(binding))
        end

        execute "inkscape -z -e "\
                "#{images_path}/rfplusone.png "\
                "-w 256 -h 256 -C #{public_path}/app_icon.svg"

        execute "rsync -av --delete #{icons_path}/ #{public_path}/index.html #{fetch(:user)}@#{rsync_host}:#{current_path}/public/"

        execute "rsync -av --delete #{images_path}/rfplusone.png #{fetch(:user)}@#{rsync_host}:#{current_path}/public/images/"

        execute "rm -rf #{icons_path}"
        execute "rm -r #{images_path}/rfplusone.png"
      end

      execute "rm -r #{current_path}/public/app_icon.svg"
    end
  end
end

after "deploy:finishing", "deploy:process_graphics"
