LIB_NAME = "mpv-crystal-simple-plugin.so"

PLUGIN_ENTRY_FILE = "./src/simple-plugin.cr"

task :default do
  invoke! :lib
end

#task :lib, deps: ["./src/simple-plugin.cr"]
task :lib do
  link_command = `crystal build --cross-compile #{PLUGIN_ENTRY_FILE}`
  unless $? == 0
    exit 1
  end

  `#{link_command} -shared -o #{LIB_NAME}`
end

task :clean do
  `rm -f *.o`
  `rm -f #{LIB_NAME}`
end

task :re do
  invoke! :clean
  invoke! :default
end
