require "i2c"

module I2cDrivers
  class AQM0802A
    CHARS_PER_LINE = 8
    DISPLAY_LINES = 2
    MAX_CHARS = CHARS_PER_LINE * DISPLAY_LINES
    
    def initialize(path, address=0x3e)
      @device = I2C.create(path)
      @address = address
      @position = 0
      @line = 0
      # initialize LCD
      begin
        [0x38, 0x39, 0x14, 0x70, 0x56, 0x6c].each do |byte|
          write_setting(byte)
          sleep(0.01)
        end
        sleep(0.2)
        [0x38, 0x0c, 0x01].each do |byte|
          write_setting(byte)
          sleep(0.01)
        end
        clear
      rescue
        raise "Cannot initialize LCD"
      end
    end
    
    def clear
      @position = 0
      @line = 0
      write_setting(0x01)
      sleep(0.01)
    end
    
    def newline
      if @line == DISPLAY_LINES - 1
        clear
      else
        @line += 1
        @position = CHARS_PER_LINE * @line
        write_setting(0xc0)
        sleep(0.001)
      end
    end
    
    def print(s)
      s.each_char do |c|
        print_ch(c)
      end
    end
    
    def print_ch(c)
      c = check_writable(c)
      if @position == MAX_CHARS
        clear
      elsif @position == CHARS_PER_LINE*(@line+1)
        newline
      end
      write_display(c)
      @position += 1
    end
    
    def check_writable(c)
      c = c.bytes.to_a[0]
      if c >= 0x20 && c <= 0x7d
        c
      else
        " "
      end
    end
    
    private
    def write_setting(data)
      @device.write(@address, 0x00, data)
    end
    
    def write_display(data)
      @device.write(@address, 0x40, data)
    end
  end
end
