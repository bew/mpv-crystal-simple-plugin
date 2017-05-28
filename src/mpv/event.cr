require "./libmpv"

class MPV::Event
  def initialize(@event : LibMPV::Event*)
  end

  def id
    event.id
  end

  def to_s(io)
    event.to_s io
  end

  def to_unsafe
    @event
  end

  private def event
    @event.value # NOTE: will this make a copy of the C struct?
  end
end
