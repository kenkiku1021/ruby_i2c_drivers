require "i2c"

module I2cDrivers
  class ADXL345
    def initialize(path, address=0x1d)
      @device = I2C.create(path)
      @address = address
      # full range
      @device.write(@address, 0x31, 0x08)
      @acc_coefficient = 4 * 9.81 / 1000 # 4mg
      sleep 0.01
      # start
      @device.write(@address, 0x2d, 0x08)
      sleep 0.01
    end
    
    def read_data(register)
      word_data = @device.read(@address, 2, register)
      data_l, data_h = word_data.bytes.to_a
      #data_l = @device.read(@address, register)
      #data_h = @device.read(@address, register+1)
      data = (data_h << 8) | data_l
      
      if data & 0x8000 == 0
        data = data
      else
        data = ((~data&0xffff) + 1) * -1
      end
      
      return @acc_coefficient * data
    end
    
    def read_acc_x
      read_data 0x32
    end
    
    def read_acc_y
      read_data 0x34
    end
    
    def read_acc_z
      read_data 0x36
    end
  end
end
