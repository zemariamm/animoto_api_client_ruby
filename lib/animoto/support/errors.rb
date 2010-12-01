module Animoto
  # This is the base class that all Animoto-specific errors descend from.
  class Error < StandardError
  end

  # Raised when an abstract method is called.
  class AbstractMethodError < Animoto::Error
  end
end