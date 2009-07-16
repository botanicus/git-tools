# encoding: utf-8

module GitTools
  class Config
    attr_reader :hash
    def initialize(file = ".git/config")
      @file = file
      @hash = Hash.new
    end

    def parse
      @inner = @hash
      File.foreach(@file) do |line|
        if line.match(/^\[(.+)\]/)
          inner = $1
          if inner.match(/^(\w+) "(.+)"/)
            @inner = (@hash[$1.to_sym] ||= Hash.new)
            @key = $2
          else
            @inner = @hash
            @key = inner.to_sym
          end
        elsif line.match(/\s+=\s+/)
          key, value = line.strip.split(/\s+=\s+/)
          value = true if value == "true"
          value = false if value == "false"
          @inner[@key] ||= Hash.new
          @inner[@key][key.to_sym] = value
        else
          raise "Unexpected line format: #{line}"
        end
      end
      return @hash
    end
  end
end
