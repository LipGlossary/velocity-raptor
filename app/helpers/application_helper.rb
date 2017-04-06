module ApplicationHelper
  # Returns true if the signal of a regular square wave is on at time t
  # These are all floats, yo (i.e. not Times)
  #   t: a time to test
  #   start: offset t wrt 0, when the signal is first on
  #   duration: number of consecutive t-units the signal is on once it's on
  #   repeat: period of the signal wrt t (not frequency)
  # default example square wave given:
  #   assumes a day of 15-minute increments
  #   begins at 0600h, lasts one hour, and repeats daily
  def square_wave(t: 0.0, start: 24.0, duration: 4.0, repeat: 96.0)
    t = t.to_f

    offset = t - start
    sawtooth = offset % repeat
    step = (sawtooth / duration).floor.to_f
    duty = duration / repeat
    normal = 1.0 - (step * duty)
    signal = normal.floor

    signal.nonzero? ? true : false
  end
end
