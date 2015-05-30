require "i2c"

module I2cDrivers
  class ADT7410
    def initialize(path, address=0x48)
      @device = I2C.create(path)
      @address = address
    end
    
    def read_temperature
      word_data = @device.read(@address, 2, "")
      temp_h, temp_l = word_data.bytes.to_a
      data = ((temp_h << 8) | temp_l) >> 3
      if data & 0x1000 == 0
        # positive temperature
        data * 0.0625
      else
        # negative temperature
        ((data & 0x1fff) + 1) * -0.0625
      end
    end
  end
end
