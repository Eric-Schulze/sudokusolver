#enums.rb

module GroupType
    BAND = 1
    STACK = 2
    BLOCK = 3
end

module Enums
    def self.enum_to_str(enum, value)
        c = enum.constants.find { |k| enum.const_get(k) == value}
        return c.nil? ? nil : c.to_s
    end
end