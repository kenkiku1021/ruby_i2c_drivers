require "i2c"

module I2cDrivers
  class MPL115A2
    def initialize(path, address=0x60)
      @device = I2C.create(path)
      @address = address
    end
    
    def read_atm
      @device.write(@address, 0x12, 0x01)
      sleep 0.003
      data = @device.read(@address, 12, 0x00).bytes.to_a
      
      a0 = convert_coefficient(data[4], data[5], 16, 3, 0)
      b1 = convert_coefficient(data[6], data[7], 16, 13, 0)
      b2 = convert_coefficient(data[8], data[9], 16, 14, 0)
      c12 = convert_coefficient(data[10], data[11], 14, 13, 9)
      
      padc = (data[0] << 8 | data[1]) >> 6
      tadc = (data[2] << 8 | data[3]) >> 6
      
      c12x2 = c12 * tadc
      a1 = b1 + c12x2
      a1x1 = a1 * padc
      y1 = a0 + a1x1
      a2x2 = b2 * tadc
      pcomp = y1 + a2x2
      
      atm = ((pcomp * 65 / 1023) + 50) * 10
    end
    
    private
    def convert_coefficient(msb, lsb, total_bits, fractional_bits, zero_pad)
      data = (msb << 8) | lsb
      period = (1 << (16 - total_bits + fractional_bits + zero_pad)).to_f
      if (msb >> 7) == 0
        (data / period).to_f
      else
        (((data ^ 0xffff) + 1) / period).to_f * -1.0
      end
    end
  end
end
