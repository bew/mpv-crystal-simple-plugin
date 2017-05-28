require "../mpv"

module MPV
  @@__mpv_handler : LibMPV::Handler?

  def self.__mpv_handler=(@@__mpv_handler : LibMPV::Handler)
  end

  def self.get_plugin_handler
    Handler.new @@__mpv_handler.not_nil!
  end
end

lib LibCrystalMain
  @[Raises]
  fun __crystal_main(argc : Int32, argv : UInt8**)
end

# :nodoc:
fun mpv_open_cplugin(mpv_handle : LibMPV::Handler) : Int32
  GC.init

  MPV.__mpv_handler = mpv_handle

  puts ">>> Crystal cplugin begin with handler at #{mpv_handle}"

  #argv = MPV.create_argv(mpv_handle)
  begin
    #LibCrystalMain.__crystal_main(2, argv)
    LibCrystalMain.__crystal_main(1, ["foo".to_unsafe])
    status = 0
  rescue ex
    puts ex
    status = -1
  end

  puts "<<< Crystal cplugin end, status is #{status}"
  status
end

#macro define_plugin_main
#  # :nodoc:
#  fun mpv_open_cplugin(mpv_handle : Void*)
#    GC.init
#
#    argv = MPV.create_argv(mpv_handle)
#    begin
#      {{yield LibCrystalMain.__crystal_main(2, argv)}}
#      %status = 0
#    rescue
#      %status = -1
#    end
#
#    %status
#  end
#end
#
#define_plugin_main do |main|
#  {{main}}
#end
