LIB_NAME = "mpv-crystal-simple-plugin.so"

PLUGIN_ENTRY_FILE = "./src/simple-plugin.cr"

task :default do
  invoke! :lib
end

def run(cmd)
  puts "Running: #{cmd}"
  output = `#{cmd}`
  {output, $?}
end

#task :lib, deps: ["./src/simple-plugin.cr"]
task :lib do
  link_command_or_error, status = run("crystal build --cross-compile #{PLUGIN_ENTRY_FILE}")
  unless status.success?
    puts "Error: #{link_command_or_error}"
    exit 1
  end

  run("#{link_command_or_error.chomp} -shared -o #{LIB_NAME}")
end

task :clean do
  `rm -f *.o`
  `rm -f #{LIB_NAME}`
end

task :re do
  invoke! :clean
  invoke! :default
end
