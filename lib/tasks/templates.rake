namespace :templates do
  desc 'Get MD5 hash of current printing templates'
  task :hashes => :environment do 
    ['invoice', 'packing_slip', 'variable_reference'].each do |tmpl|
      path    = "#{RAILS_ROOT}/db/printing/#{tmpl}.liquid"
      content = File.read(path)
      hash    = Digest::MD5.hexdigest(content)
      puts "#{hash} -> #{tmpl}"
    end
  end
end
