# No link needed
lib LibMPV
  alias Handler = Void*

  struct Event
    # One of mpv_event. Keep in mind that later ABI compatible releases might
    # add new event types. These should be ignored by the API user.
    id : EventType

    # This is mainly used for events that are replies to (asynchronous)
    # requests. It contains a status code, which is >= 0 on success, or < 0
    # on error (a mpv_error value). Usually, this will be set if an
    # asynchronous request fails.
    # Used for:
    #  MPV_EVENT_GET_PROPERTY_REPLY
    #  MPV_EVENT_SET_PROPERTY_REPLY
    #  MPV_EVENT_COMMAND_REPLY
    error : Int32

    # If the event is in reply to a request (made with this API and this
    # API handle), this is set to the reply_userdata parameter of the request
    # call. Otherwise, this field is 0.
    # Used for:
    #  MPV_EVENT_GET_PROPERTY_REPLY
    #  MPV_EVENT_SET_PROPERTY_REPLY
    #  MPV_EVENT_COMMAND_REPLY
    #  MPV_EVENT_PROPERTY_CHANGE
    reply_userdata : UInt64

    # The meaning and contents of the data member depend on the event_id:
    #  MPV_EVENT_GET_PROPERTY_REPLY:     mpv_event_property*
    #  MPV_EVENT_PROPERTY_CHANGE:        mpv_event_property*
    #  MPV_EVENT_LOG_MESSAGE:            mpv_event_log_message*
    #  MPV_EVENT_CLIENT_MESSAGE:         mpv_event_client_message*
    #  MPV_EVENT_END_FILE:               mpv_event_end_file*
    #  other: NULL
    #
    # Note: future enhancements might add new event structs for existing or new
    #       event types.
    data : Void*
  end

  # Return the name of this client handle. Every client has its own unique
  # name, which is mostly used for user interface purposes.
  #
  # @return The client name. The string is read-only and is valid until the
  #         mpv_handle is destroyed.
  fun client_name = mpv_client_name(handler : Handler) : LibC::Char*

  # Wait for the next event, or until the timeout expires, or if another thread
  # makes a call to mpv_wakeup(). Passing 0 as timeout will never wait, and
  # is suitable for polling.
  #
  # The internal event queue has a limited size (per client handle). If you
  # don't empty the event queue quickly enough with mpv_wait_event(), it will
  # overflow and silently discard further events. If this happens, making
  # asynchronous requests will fail as well (with MPV_ERROR_EVENT_QUEUE_FULL).
  #
  # Only one thread is allowed to call this on the same mpv_handle at a time.
  # The API won't complain if more than one thread calls this, but it will cause
  # race conditions in the client when accessing the shared mpv_event struct.
  # Note that most other API functions are not restricted by this, and no API
  # function internally calls mpv_wait_event(). Additionally, concurrent calls
  # to different mpv_handles are always safe.
  #
  # @param timeout Timeout in seconds, after which the function returns even if
  #                no event was received. A MPV_EVENT_NONE is returned on
  #                timeout. A value of 0 will disable waiting. Negative values
  #                will wait with an infinite timeout.
  # @return A struct containing the event ID and other data. The pointer (and
  #         fields in the struct) stay valid until the next mpv_wait_event()
  #         call, or until the mpv_handle is destroyed. You must not write to
  #         the struct, and all memory referenced by it will be automatically
  #         released by the API on the next mpv_wait_event() call, or when the
  #         context is destroyed. The return value is never NULL.
  fun wait_event = mpv_wait_event(handler : Handler, timeout : LibC::Double) : LibMPV::Event*

  # :nodoc: Missing numbers were for depracated events
  enum EventType
    # Nothing happened. Happens on timeouts or sporadic wakeups.
    NONE = 0

    # Happens when the player quits. The player enters a state where it tries
    # to disconnect all clients. Most requests to the player will fail, and
    # mpv_wait_event() will always return instantly (returning new shutdown
    # events if no other events are queued). The client should react to this
    # and quit with mpv_detach_destroy() as soon as possible.
    SHUTDOWN = 1

    # See mpv_request_log_messages().
    LOG_MESSAGE = 2

    # Reply to a mpv_get_property_async() request.
    # See also mpv_event and mpv_event_property.
    GET_PROPERTY_REPLY = 3

    # Reply to a mpv_set_property_async() request.
    # (Unlike MPV_EVENT_GET_PROPERTY, mpv_event_property is not used.)
    SET_PROPERTY_REPLY = 4

    # Reply to a mpv_command_async() request.
    COMMAND_REPLY = 5

    # Notification before playback start of a file (before the file is loaded).
    START_FILE = 6

    # Notification after playback end (after the file was unloaded).
    # See also mpv_event and mpv_event_end_file.
    END_FILE = 7

    # Notification when the file has been loaded (headers were read etc.), and
    # decoding starts.
    FILE_LOADED = 8

    # Idle mode was entered. In this mode, no file is played, and the playback
    # core waits for new commands. (The command line player normally quits
    # instead of entering idle mode, unless --idle was specified. If mpv
    # was started with mpv_create(), idle mode is enabled by default.)
    IDLE = 11

    # Sent every time after a video frame is displayed. Note that currently,
    # this will be sent in lower frequency if there is no video, or playback
    # is paused - but that will be removed in the future, and it will be
    # restricted to video frames only.
    TICK = 14

    # Triggered by the script-message input command. The command uses the
    # first argument of the command as client name (see mpv_client_name()) to
    # dispatch the message, and passes along all arguments starting from the
    # second argument as strings.
    # See also mpv_event and mpv_event_client_message.
    CLIENT_MESSAGE = 16

    # Happens after video changed in some way. This can happen on resolution
    # changes, pixel format changes, or video filter changes. The event is
    # sent after the video filters and the VO are reconfigured. Applications
    # embedding a mpv window should listen to this event in order to resize
    # the window if needed.
    # Note that this event can happen sporadically, and you should check
    # yourself whether the video parameters really changed before doing
    # something expensive.
    VIDEO_RECONFIG = 17

    # Similar to VIDEO_RECONFIG. This is relatively uninteresting,
    # because there is no such thing as audio output embedding.
    AUDIO_RECONFIG = 18

    # Happens when a seek was initiated. Playback stops. Usually it will
    # resume with PLAYBACK_RESTART as soon as the seek is finished.
    SEEK = 20

    # There was a discontinuity of some sort (like a seek), and playback
    # was reinitialized. Usually happens after seeking, or ordered chapter
    # segment switches. The main purpose is allowing the client to detect
    # when a seek request is finished.
    PLAYBACK_RESTART = 21

    # Event sent due to mpv_observe_property().
    # See also mpv_event and mpv_event_property.
    PROPERTY_CHANGE = 22

    # Happens if the internal per-mpv_handle ringbuffer overflows, and at
    # least 1 event had to be dropped. This can happen if the client doesn't
    # read the event queue quickly enough with mpv_wait_event(), or if the
    # client makes a very large number of asynchronous calls at once.
    #
    # Event delivery will continue normally once this event was returned
    # (this forces the client to empty the queue completely).
    QUEUE_OVERFLOW = 24
  end
end
