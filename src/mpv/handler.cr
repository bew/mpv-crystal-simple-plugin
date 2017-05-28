require "./libmpv"
require "./event"

enum MPV::Timeout
  Block
  Instant
end

class MPV::Handler
  @mpv : LibMPV::Handler

  def initialize(@mpv)
  end

  def client_name
    String.new LibMPV.client_name(@mpv)
  end

  def wait_event(timeout : LibC::Double | Timeout = Timeout::Block)
    timeout = case timeout
              when Timeout::Block
                -1
              when Timeout::Instant
                0
              else
                timeout
              end

    MPV::Event.new LibMPV.wait_event(@mpv, timeout)
  end

  def to_unsafe
    @mpv
  end
end
