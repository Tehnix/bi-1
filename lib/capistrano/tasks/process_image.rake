namespace :rfplusone do
  desc 'Processes graphic assets'
  task :process_image do
    on roles(:app) do
      run_locally do
        rsync_host = host.to_s

        public_path = "#{Dir.pwd}/public"
        icons_path = "#{public_path}/icons"
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

        execute "rsync -av --delete #{icons_path} #{fetch(:user)}@#{rsync_host}:#{shared_path}/public/"
        execute "rm -rf #{icons_path}"
      end

      execute "rm #{deploy_path}/public/app_icon.svg"
    end
  end

  after :updated, :process_image
end
